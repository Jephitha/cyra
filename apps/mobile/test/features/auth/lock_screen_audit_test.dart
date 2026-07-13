import 'package:cyra/core/providers/security_providers.dart';
import 'package:cyra/features/auth/screens/lock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _RejectingPinAuth extends PinAuthService {
  _RejectingPinAuth()
    : super(SecureStorageService(const FlutterSecureStorage()));

  @override
  Future<bool> verifyPin(String pin) async => false;
}

class _RecordingAudit extends AuditService {
  _RecordingAudit() : super(secureStorage: const FlutterSecureStorage());

  final entries =
      <({AuditAction action, bool success, Map<String, String>? details})>[];

  @override
  Future<void> log({
    required AuditAction action,
    required AuditRecordType recordType,
    required bool success,
    Map<String, String>? details,
  }) async {
    entries.add((action: action, success: success, details: details));
  }
}

void main() {
  testWidgets('failed PIN unlock is recorded without storing the PIN', (
    tester,
  ) async {
    const localAuthChannel = MethodChannel('plugins.flutter.io/local_auth');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(localAuthChannel, (call) async {
      if (call.method == 'getAvailableBiometrics') return <String>[];
      if (call.method == 'isDeviceSupported') return false;
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(localAuthChannel, null),
    );
    final audit = _RecordingAudit();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pinAuthServiceProvider.overrideWithValue(_RejectingPinAuth()),
          auditServiceProvider.overrideWithValue(audit),
        ],
        child: const MaterialApp(home: LockScreen()),
      ),
    );
    await tester.pumpAndSettle();

    for (var index = 0; index < 5; index++) {
      await tester.tap(find.text('1'));
      await tester.pump();
    }
    await tester.pumpAndSettle();

    expect(audit.entries, hasLength(1));
    expect(audit.entries.single.action, AuditAction.login);
    expect(audit.entries.single.success, isFalse);
    expect(audit.entries.single.details?['method'], 'pin');
    expect(audit.entries.single.details.toString(), isNot(contains('11111')));
  });
}
