import 'package:cyra/core/security/audit_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _UnavailableAuditStore extends AuditService {
  _UnavailableAuditStore() : super(secureStorage: const FlutterSecureStorage());

  @override
  Future<void> log({
    required AuditAction action,
    required AuditRecordType recordType,
    required bool success,
    Map<String, String>? details,
  }) async {
    throw AuditException('Audit store unavailable');
  }
}

void main() {
  test('safe logging never blocks the security action', () async {
    final audit = _UnavailableAuditStore();

    await expectLater(
      audit.logSafely(
        action: AuditAction.login,
        recordType: AuditRecordType.auth,
        success: true,
      ),
      completes,
    );
  });
}
