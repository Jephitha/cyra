import 'package:cyra/core/database/app_database.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/core/security/secure_storage_service.dart';
import 'package:drift/native.dart';

AppDatabase createInMemoryDatabase() {
  return AppDatabase(executor: NativeDatabase.memory());
}

Future<EncryptionService> createTestEncryptionService() async {
  final service = EncryptionService(InMemorySecureStorage());
  await service.initialize();
  return service;
}

class InMemorySecureStorage implements SecureStorageService {
  final Map<String, String> _values = {};

  @override
  Future<void> clearAll() async => _values.clear();

  @override
  Future<bool> containsKey(String key) async => _values.containsKey(key);

  @override
  Future<void> deleteKey(String key) async => _values.remove(key);

  @override
  Future<Map<String, String>> readAll() async => Map.of(_values);

  @override
  Future<String?> readEncrypted(String key) async => _values['enc_$key'];

  @override
  Future<String?> readString(String key) async => _values[key];

  @override
  Future<void> storeEncrypted(String key, String value) async {
    _values['enc_$key'] = value;
  }

  @override
  Future<void> storeString(String key, String value) async {
    _values[key] = value;
  }
}
