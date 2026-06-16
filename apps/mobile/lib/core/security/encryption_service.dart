import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cyra/core/security/secure_storage_service.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encryption_service.g.dart';

class EncryptionException implements Exception {
  final String message;
  final Object? cause;
  EncryptionException(this.message, [this.cause]);

  @override
  String toString() => 'EncryptionException: $message';
}

class EncryptionService {
  static const String _keyStorageKey = 'cyra_encryption_key';
  static const int _keyLength = 32;
  static const int _nonceLength = 12;

  final SecureStorageService _secureStorage;
  encrypt.Key? _key;
  final Random _random = Random.secure();

  EncryptionService(this._secureStorage);

  Future<void> initialize() async {
    await getOrCreateKey();
  }

  Future<encrypt.Key> getOrCreateKey() async {
    if (_key != null) return _key!;

    final storedKey = await _secureStorage.readString(_keyStorageKey);
    if (storedKey != null && storedKey.isNotEmpty) {
      _key = encrypt.Key.fromBase64(storedKey);
      return _key!;
    }

    _key = encrypt.Key.fromSecureRandom(_keyLength);
    await _secureStorage.storeString(_keyStorageKey, _key!.base64);
    return _key!;
  }

  Uint8List _generateNonce() {
    return Uint8List.fromList(
      List<int>.generate(_nonceLength, (_) => _random.nextInt(256)),
    );
  }

  encrypt.Encrypter _encrypter() {
    return encrypt.Encrypter(
      encrypt.AES(_key!, mode: encrypt.AESMode.gcm),
    );
  }

  String encryptString(String plaintext) {
    _ensureInitialized();
    try {
      final nonce = _generateNonce();
      final iv = encrypt.IV(nonce);
      final encrypted = _encrypter().encrypt(plaintext, iv: iv);
      final combined = Uint8List(_nonceLength + encrypted.bytes.length);
      combined.setRange(0, _nonceLength, nonce);
      combined.setRange(_nonceLength, combined.length, encrypted.bytes);
      return base64.encode(combined);
    } catch (e) {
      throw EncryptionException('Encryption failed', e);
    }
  }

  String decryptString(String ciphertext) {
    _ensureInitialized();
    try {
      final combined = base64.decode(ciphertext);
      if (combined.length < _nonceLength) {
        throw EncryptionException('Invalid ciphertext: too short');
      }
      final nonce = Uint8List.sublistView(combined, 0, _nonceLength);
      final cipherBytes = Uint8List.sublistView(combined, _nonceLength);
      final iv = encrypt.IV(nonce);
      final encrypted = encrypt.Encrypted(cipherBytes);
      return _encrypter().decrypt(encrypted, iv: iv);
    } on EncryptionException {
      rethrow;
    } catch (e) {
      throw EncryptionException('Decryption failed', e);
    }
  }

  Future<void> encryptFile(File inputFile, File outputFile) async {
    _ensureInitialized();
    try {
      final fileBytes = await inputFile.readAsBytes();
      final nonce = _generateNonce();
      final iv = encrypt.IV(nonce);
      final encrypted = _encrypter().encryptBytes(fileBytes, iv: iv);
      final combined = Uint8List(_nonceLength + encrypted.bytes.length);
      combined.setRange(0, _nonceLength, nonce);
      combined.setRange(_nonceLength, combined.length, encrypted.bytes);
      await outputFile.writeAsBytes(combined);
    } catch (e) {
      throw EncryptionException('File encryption failed', e);
    }
  }

  Future<void> decryptFile(File inputFile, File outputFile) async {
    _ensureInitialized();
    try {
      final combined = await inputFile.readAsBytes();
      if (combined.length < _nonceLength) {
        throw EncryptionException('Invalid encrypted file: too short');
      }
      final nonce = Uint8List.sublistView(combined, 0, _nonceLength);
      final cipherBytes = Uint8List.sublistView(combined, _nonceLength);
      final iv = encrypt.IV(nonce);
      final encrypted = encrypt.Encrypted(cipherBytes);
      final decrypted = _encrypter().decryptBytes(encrypted, iv: iv);
      await outputFile.writeAsBytes(decrypted);
    } catch (e) {
      throw EncryptionException('File decryption failed', e);
    }
  }

  Future<void> rotateKey() async {
    _ensureInitialized();
    final oldKey = _key!;
    final newKey = encrypt.Key.fromSecureRandom(_keyLength);

    _key = newKey;
    await _secureStorage.storeString(_keyStorageKey, newKey.base64);

    try {
      await _reEncryptAll(oldKey, newKey);
    } catch (e) {
      _key = oldKey;
      await _secureStorage.storeString(_keyStorageKey, oldKey.base64);
      throw EncryptionException('Key rotation failed during re-encryption', e);
    }
  }

  Future<void> _reEncryptAll(encrypt.Key oldKey, encrypt.Key newKey) async {
    final dir = Directory.systemTemp;
    final files = await dir.list().where(
      (entity) =>
          entity is File &&
          entity.path.endsWith('.encrypted'),
    ).toList();

    for (final entity in files) {
      final file = entity as File;
      try {
        final combined = await file.readAsBytes();
        if (combined.length <= _nonceLength) continue;

        final nonce = Uint8List.sublistView(combined, 0, _nonceLength);
        final cipherBytes = Uint8List.sublistView(combined, _nonceLength);
        final oldIv = encrypt.IV(nonce);
        final oldEnc = encrypt.Encrypted(cipherBytes);
        final oldEncrypter = encrypt.Encrypter(
          encrypt.AES(oldKey, mode: encrypt.AESMode.gcm),
        );
        final plaintext = oldEncrypter.decryptBytes(oldEnc, iv: oldIv);

        final newNonce = _generateNonce();
        final newIv = encrypt.IV(newNonce);
        final newEncrypter = encrypt.Encrypter(
          encrypt.AES(newKey, mode: encrypt.AESMode.gcm),
        );
        final newEncrypted = newEncrypter.encryptBytes(plaintext, iv: newIv);
        final newCombined = Uint8List(_nonceLength + newEncrypted.bytes.length);
        newCombined.setRange(0, _nonceLength, newNonce);
        newCombined.setRange(
          _nonceLength,
          newCombined.length,
          newEncrypted.bytes,
        );
        await file.writeAsBytes(newCombined);
      } catch (_) {}
    }
  }

  Future<void> setKeyFromBase64(String base64Key) async {
    _key = encrypt.Key.fromBase64(base64Key);
    await _secureStorage.storeString(_keyStorageKey, base64Key);
  }

  bool get isInitialized => _key != null;

  void _ensureInitialized() {
    if (!isInitialized) {
      throw EncryptionException(
        'Service not initialized. Call initialize() first.',
      );
    }
  }
}

@Riverpod(keepAlive: true)
EncryptionService encryptionService(EncryptionServiceRef ref) {
  final secureStorage = ref.read(secureStorageServiceProvider);
  return EncryptionService(secureStorage);
}
