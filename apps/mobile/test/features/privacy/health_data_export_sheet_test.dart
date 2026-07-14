import 'dart:io';

import 'package:cyra/core/security/audit_service.dart';
import 'package:cyra/core/security/biometric_auth_service.dart';
import 'package:cyra/core/security/data_export_service.dart';
import 'package:cyra/core/security/health_data_pdf_renderer.dart';
import 'package:cyra/core/security/pin_auth_service.dart';
import 'package:cyra/core/security/secure_storage_service.dart';
import 'package:cyra/features/privacy/screens/privacy_controls_screen.dart';
import 'package:cyra/features/privacy/widgets/health_data_export_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';

class _Auth extends BiometricAuthService {
  _Auth()
    : super(
        localAuth: LocalAuthentication(),
        secureStorage: const FlutterSecureStorage(),
        pinAuthService: PinAuthService(
          SecureStorageService(const FlutterSecureStorage()),
        ),
      );
}

class _Audit extends AuditService {
  _Audit() : super(secureStorage: const FlutterSecureStorage());
}

class _ExportService extends DataExportService {
  _ExportService() : super(authService: _Auth(), auditService: _Audit());

  HealthDataPdfRequest? request;

  @override
  Future<File> exportHealthDataPdf(HealthDataPdfRequest request) async {
    this.request = request;
    return File('/tmp/cyra-health-summary.pdf');
  }
}

void main() {
  testWidgets('privacy settings makes PDF primary and hides raw JSON export', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: PrivacyControlsScreen())),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Export my data'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Export my data'), findsOneWidget);
    expect(find.text('Advanced exports'), findsNothing);
    expect(find.text('Export all data as JSON'), findsNothing);
  });

  testWidgets('PDF flow excludes journals by default and offers share/save', (
    tester,
  ) async {
    final service = _ExportService();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dataExportServiceProvider.overrideWithValue(service)],
        child: const MaterialApp(home: Scaffold(body: HealthDataExportSheet())),
      ),
    );

    expect(find.text('Export my data'), findsOneWidget);
    expect(find.text('Generate PDF'), findsOneWidget);
    final journals = tester.widget<CheckboxListTile>(
      find.widgetWithText(CheckboxListTile, 'Include journal entries'),
    );
    expect(journals.value, isFalse);

    await tester.ensureVisible(find.text('Generate PDF'));
    await tester.tap(find.text('Generate PDF'));
    await tester.pumpAndSettle();

    expect(service.request, isNotNull);
    expect(service.request!.includeJournalEntries, isFalse);
    expect(service.request!.includeDailyLog, isTrue);
    expect(find.text('Share'), findsOneWidget);
    expect(find.text('Save to device'), findsOneWidget);
  });
}
