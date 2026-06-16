import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_service.g.dart';

class SecureStorageException implements Exception {
  final String message;
  final Object? cause;
  SecureStorageException(this.message, [this.cause]);

  @override
  String toString() => 'SecureStorageException: $message';
}

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  Future<void> storeString(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw SecureStorageException('Failed to store value for key: $key', e);
    }
  }

  Future<String?> readString(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw SecureStorageException('Failed to read value for key: $key', e);
    }
  }

  Future<void> deleteKey(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw SecureStorageException('Failed to delete key: $key', e);
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw SecureStorageException('Failed to clear all stored data', e);
    }
  }

  Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      throw SecureStorageException('Failed to read all stored data', e);
    }
  }

  Future<void> storeEncrypted(String key, String value) async {
    try {
      final encoded = base64.encode(utf8.encode(value));
      await _storage.write(key: _encryptedKey(key), value: encoded);
    } catch (e) {
      throw SecureStorageException(
        'Failed to store encrypted value for key: $key',
        e,
      );
    }
  }

  Future<String?> readEncrypted(String key) async {
    try {
      final encoded = await _storage.read(key: _encryptedKey(key));
      if (encoded == null) return null;
      return utf8.decode(base64.decode(encoded));
    } catch (e) {
      throw SecureStorageException(
        'Failed to read encrypted value for key: $key',
        e,
      );
    }
  }

  String _encryptedKey(String key) => 'enc_$key';
}

@Riverpod(keepAlive: true)
SecureStorageService secureStorageService(SecureStorageServiceRef ref) {
  return SecureStorageService(const FlutterSecureStorage());
}
