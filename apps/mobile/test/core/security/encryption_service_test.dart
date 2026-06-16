import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/core/security/secure_storage_service.dart';

/// A simple in-memory mock for SecureStorageService.
class MockSecureStorage implements SecureStorageService {
  final Map<String, String> _store = {};

  @override
  Future<String?> readString(String key) async => _store[key];

  @override
  Future<void> storeString(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<void> deleteKey(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clearAll() async {
    _store.clear();
  }

  @override
  Future<bool> containsKey(String key) async => _store.containsKey(key);

  @override
  Future<Map<String, String>> readAll() async => Map<String, String>.of(_store);

  @override
  Future<void> storeEncrypted(String key, String value) async {
    _store['enc_$key'] = value;
  }

  @override
  Future<String?> readEncrypted(String key) async => _store['enc_$key'];
}

void main() {
  group('EncryptionService', () {
    late MockSecureStorage mockStorage;
    late EncryptionService service;

    setUp(() async {
      mockStorage = MockSecureStorage();
      service = EncryptionService(mockStorage);
      await service.initialize();
    });

    test('encrypt and decrypt are inverses', () {
      const plaintext = 'Sensitive health data for encryption test';
      final ciphertext = service.encryptString(plaintext);
      final decrypted = service.decryptString(ciphertext);

      expect(decrypted, equals(plaintext));
    });

    test('throws EncryptionException when not initialized', () {
      final uninitialized = EncryptionService(mockStorage);

      expect(
        () => uninitialized.encryptString('test'),
        throwsA(isA<EncryptionException>()),
      );
    });

    test('different keys produce different ciphertext', () async {
      const plaintext = 'Same plaintext';
      final ciphertext1 = service.encryptString(plaintext);

      final mockStorage2 = MockSecureStorage();
      final service2 = EncryptionService(mockStorage2);
      await service2.initialize();

      final ciphertext2 = service2.encryptString(plaintext);
      expect(ciphertext1, isNot(equals(ciphertext2)));
    });

    test('IV is different for each encryption call', () {
      const plaintext = 'Same data encrypted twice';
      final ciphertext1 = service.encryptString(plaintext);
      final ciphertext2 = service.encryptString(plaintext);
      expect(ciphertext1, isNot(equals(ciphertext2)));
    });

    test('decrypt with wrong key fails', () async {
      const plaintext = 'Secret message';
      final ciphertext = service.encryptString(plaintext);

      final mockStorage2 = MockSecureStorage();
      final service2 = EncryptionService(mockStorage2);
      await service2.initialize();

      expect(
        () => service2.decryptString(ciphertext),
        throwsA(isA<EncryptionException>()),
      );
    });

    test('encrypt null-like strings works', () {
      expect(service.encryptString(''), isNotEmpty);
      expect(service.encryptString(' '), isNotEmpty);
      expect(service.encryptString('a'), isNotEmpty);
    });

    test('decrypt throws on invalid ciphertext', () {
      expect(
        () => service.decryptString('invalid-base64!'),
        throwsA(isA<EncryptionException>()),
      );
    });

    test('decrypt throws on too-short ciphertext', () {
      final shortB64 = service.encryptString('test').substring(0, 10);
      expect(
        () => service.decryptString(shortB64),
        throwsA(isA<EncryptionException>()),
      );
    });

    test('encryptFile and decryptFile work correctly', () async {
      final tempDir = await Directory.systemTemp.createTemp('cyra_test_');
      try {
        final inputFile = File('${tempDir.path}/input.txt');
        final encryptedFile = File('${tempDir.path}/encrypted.bin');
        final decryptedFile = File('${tempDir.path}/decrypted.txt');

        const originalContent = 'File encryption test content with sensitive data.';
        await inputFile.writeAsString(originalContent);

        await service.encryptFile(inputFile, encryptedFile);
        await service.decryptFile(encryptedFile, decryptedFile);

        final decryptedContent = await decryptedFile.readAsString();
        expect(decryptedContent, equals(originalContent));
        expect(encryptedFile.lengthSync(), isNot(equals(inputFile.lengthSync())));
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('encryptFile throws on non-existent input', () async {
      final fakeInput = File('/nonexistent/path/input.txt');
      final fakeOutput = File('/tmp/output.bin');

      await expectLater(
        () => service.encryptFile(fakeInput, fakeOutput),
        throwsA(isA<EncryptionException>()),
      );
    });

    test('decryptFile throws on invalid encrypted file', () async {
      final tempDir = await Directory.systemTemp.createTemp('cyra_test_');
      try {
        final badFile = File('${tempDir.path}/bad.bin');
        await badFile.writeAsString('not encrypted');

        final output = File('${tempDir.path}/output.txt');

        await expectLater(
          () => service.decryptFile(badFile, output),
          throwsA(isA<EncryptionException>()),
        );
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('encrypt handles very long text', () {
      final longText = 'A' * 10000;
      final ciphertext = service.encryptString(longText);
      final decrypted = service.decryptString(ciphertext);
      expect(decrypted, equals(longText));
    });

    test('isInitialized returns correct state', () {
      expect(service.isInitialized, isTrue);

      final uninit = EncryptionService(mockStorage);
      expect(uninit.isInitialized, isFalse);
    });
  });
}
