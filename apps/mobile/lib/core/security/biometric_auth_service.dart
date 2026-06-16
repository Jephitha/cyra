import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cyra/core/security/pin_auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_auth_service.g.dart';

class BiometricAuthException implements Exception {
  final String message;
  final Object? cause;
  BiometricAuthException(this.message, [this.cause]);

  @override
  String toString() => 'BiometricAuthException: $message';
}

class BiometricAuthService {
  final LocalAuthentication _localAuth;
  final FlutterSecureStorage _secureStorage;
  final PinAuthService _pinAuthService;

  static const _biometricEnabledKey = 'cyra_biometric_enabled';

  BiometricAuthService({
    required this._localAuth,
    required this._secureStorage,
    required this._pinAuthService,
  });

  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics({
    required String reason,
    bool sticky = true,
    bool useErrorDialogs = true,
  }) async {
    try {
      final available = await isBiometricAvailable();
      if (!available) return false;

      final result = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: sticky,
          useErrorDialogs: useErrorDialogs,
          biometricOnly: true,
        ),
      );

      if (result) {
        await _pinAuthService.resetFailedAttempts();
      }

      return result;
    } catch (e) {
      throw BiometricAuthException('Biometric authentication failed', e);
    }
  }

  Future<bool> authenticateWithBiometricsOrPin({
    required String reason,
  }) async {
    try {
      final biometricAvailable = await isBiometricAvailable();
      if (biometricAvailable) {
        final success = await authenticateWithBiometrics(reason: reason);
        if (success) return true;
      }
      return await _pinAuthService.verifyInteractively();
    } catch (e) {
      throw BiometricAuthException(
        'Biometric or PIN authentication failed',
        e,
      );
    }
  }

  Future<void> setPinCode(String pin) async {
    if (pin.length < 4 || pin.length > 8) {
      throw BiometricAuthException('PIN must be 4-8 digits');
    }
    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      throw BiometricAuthException('PIN must contain only digits');
    }
    await _pinAuthService.setPin(pin);
  }

  Future<bool> verifyPinCode(String pin) async {
    return await _pinAuthService.verifyPin(pin);
  }

  Future<bool> hasPinCode() async {
    return await _pinAuthService.hasPin();
  }

  Future<void> clearPinCode() async {
    await _pinAuthService.clearPin();
  }

  Future<bool> isDeviceSecure() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _secureStorage.read(key: _biometricEnabledKey);
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
      key: _biometricEnabledKey,
      value: enabled ? 'true' : 'false',
    );
  }
}

@Riverpod(keepAlive: true)
BiometricAuthService biometricAuthService(BiometricAuthServiceRef ref) {
  return BiometricAuthService(
    localAuth: LocalAuthentication(),
    secureStorage: const FlutterSecureStorage(),
    pinAuthService: ref.read(pinAuthServiceProvider),
  );
}
