import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cyra/core/security/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_auth_service.g.dart';

class PinAuthException implements Exception {
  final String message;
  final Object? cause;
  PinAuthException(this.message, [this.cause]);

  @override
  String toString() => 'PinAuthException: $message';
}

class PinAuthService {
  final SecureStorageService _secureStorage;
  final Random _random = Random.secure();

  static const String _pinHashKey = 'cyra_pin_hash';
  static const String _pinSaltKey = 'cyra_pin_salt';
  static const String _failedAttemptsKey = 'cyra_pin_failed_attempts';
  static const String _lockoutUntilKey = 'cyra_pin_lockout_until';

  static const int _iterations = 10000;
  static const int _keyLength = 32;
  static const int _saltLength = 32;
  static const int _maxAttempts = 5;
  static const Duration _lockoutDuration = Duration(seconds: 30);
  static const int _pinMinLength = 4;
  static const int _pinMaxLength = 8;

  PinAuthService(this._secureStorage);

  Future<void> setPin(String pin) async {
    if (pin.length < _pinMinLength || pin.length > _pinMaxLength) {
      throw PinAuthException(
        'PIN must be between $_pinMinLength and $_pinMaxLength digits',
      );
    }
    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      throw PinAuthException('PIN must contain only digits');
    }

    final salt = _generateSalt();
    final hash = _deriveKey(pin, salt);

    await _secureStorage.storeString(_pinSaltKey, base64.encode(salt));
    await _secureStorage.storeString(_pinHashKey, base64.encode(hash));
    await _secureStorage.storeString(_failedAttemptsKey, '0');
    await _secureStorage.deleteKey(_lockoutUntilKey);
  }

  Future<bool> verifyPin(String pin) async {
    if (pin.length < _pinMinLength || pin.length > _pinMaxLength) {
      return false;
    }
    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      return false;
    }

    try {
      final lockoutUntil = await _getLockoutUntil();
      if (lockoutUntil != null && DateTime.now().isBefore(lockoutUntil)) {
        return false;
      }

      final storedSalt = await _secureStorage.readString(_pinSaltKey);
      final storedHash = await _secureStorage.readString(_pinHashKey);

      if (storedSalt == null || storedHash == null) {
        return false;
      }

      final salt = base64.decode(storedSalt);
      final expectedHash = base64.decode(storedHash);
      final actualHash = _deriveKey(pin, salt);

      final matches = _constantTimeEqual(actualHash, expectedHash);

      if (matches) {
        await _resetFailedAttempts();
        return true;
      } else {
        await _incrementFailedAttempts();
        return false;
      }
    } catch (e) {
      throw PinAuthException('PIN verification failed', e);
    }
  }

  Future<bool> hasPin() async {
    final hash = await _secureStorage.readString(_pinHashKey);
    return hash != null && hash.isNotEmpty;
  }

  Future<void> clearPin() async {
    await _secureStorage.deleteKey(_pinHashKey);
    await _secureStorage.deleteKey(_pinSaltKey);
    await _secureStorage.deleteKey(_failedAttemptsKey);
    await _secureStorage.deleteKey(_lockoutUntilKey);
  }

  Future<int> getFailedAttempts() async {
    final value = await _secureStorage.readString(_failedAttemptsKey);
    if (value == null) return 0;
    return int.tryParse(value) ?? 0;
  }

  Future<void> resetFailedAttempts() async {
    await _resetFailedAttempts();
  }

  Future<DateTime?> getLockoutUntil() async {
    return _getLockoutUntil();
  }

  Future<bool> isLocked() async {
    final lockoutUntil = await _getLockoutUntil();
    if (lockoutUntil == null) return false;
    return DateTime.now().isBefore(lockoutUntil);
  }

  Future<int> getRemainingAttempts() async {
    if (await isLocked()) return 0;
    final attempts = await getFailedAttempts();
    return _maxAttempts - attempts;
  }

  Future<Duration> getLockoutRemaining() async {
    final lockoutUntil = await _getLockoutUntil();
    if (lockoutUntil == null) return Duration.zero;
    final remaining = lockoutUntil.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Future<bool> verifyInteractively() async {
    if (await isLocked()) return false;
    return hasPin();
  }

  List<int> _generateSalt() {
    return List<int>.generate(_saltLength, (_) => _random.nextInt(256));
  }

  Uint8List _deriveKey(String pin, List<int> salt) {
    final derivator = pc.PBKDF2KeyDerivator(
      pc.HMac(pc.SHA256Digest(), 64),
    );
    derivator.init(pc.Pbkdf2Parameters(
      Uint8List.fromList(salt),
      _iterations,
      _keyLength,
    ));
    return derivator.process(Uint8List.fromList(utf8.encode(pin)));
  }

  bool _constantTimeEqual(List<int> a, List<int> b) {
    if (a.length != b.length) {
      int result = a.length ^ b.length;
      for (var i = 0; i < min(a.length, b.length); i++) {
        result |= a[i] ^ b[i];
      }
      return false;
    }

    int result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }

  Future<void> _incrementFailedAttempts() async {
    final attempts = await getFailedAttempts();
    final newAttempts = attempts + 1;

    if (newAttempts >= _maxAttempts) {
      final lockoutUntil = DateTime.now().add(_lockoutDuration);
      await _secureStorage.storeString(
        _lockoutUntilKey,
        lockoutUntil.toIso8601String(),
      );
    }

    await _secureStorage.storeString(
      _failedAttemptsKey,
      newAttempts.toString(),
    );
  }

  Future<void> _resetFailedAttempts() async {
    await _secureStorage.storeString(_failedAttemptsKey, '0');
    await _secureStorage.deleteKey(_lockoutUntilKey);
  }

  Future<DateTime?> _getLockoutUntil() async {
    final value = await _secureStorage.readString(_lockoutUntilKey);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}

@Riverpod(keepAlive: true)
PinAuthService pinAuthService(PinAuthServiceRef ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return PinAuthService(secureStorage);
}
