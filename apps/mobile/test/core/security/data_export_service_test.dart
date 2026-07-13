import 'dart:io';
import 'dart:typed_data';

import 'package:cyra/core/security/audit_service.dart';
import 'package:cyra/core/security/biometric_auth_service.dart';
import 'package:cyra/core/security/data_export_service.dart';
import 'package:cyra/core/security/health_data_pdf_renderer.dart';
import 'package:cyra/core/security/pin_auth_service.dart';
import 'package:cyra/core/security/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';

class _Authentication extends BiometricAuthService {
  _Authentication(this.allowed)
    : super(
        localAuth: LocalAuthentication(),
        secureStorage: const FlutterSecureStorage(),
        pinAuthService: PinAuthService(
          SecureStorageService(const FlutterSecureStorage()),
        ),
      );

  final bool allowed;
  int attempts = 0;

  @override
  Future<bool> authenticateWithBiometricsOrPin({required String reason}) async {
    attempts++;
    return allowed;
  }
}

class _AuditLog extends AuditService {
  _AuditLog() : super(secureStorage: const FlutterSecureStorage());

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

class _RecordingRenderer extends HealthDataPdfRenderer {
  List<Map<String, dynamic>>? records;

  @override
  Future<Uint8List> render(
    List<Map<String, dynamic>> records,
    HealthDataPdfRequest request,
  ) async {
    this.records = records;
    return super.render(records, request);
  }
}

void main() {
  test(
    'PDF export authenticates, writes a readable file, and audits success',
    () async {
      final directory = await Directory.systemTemp.createTemp('cyra-pdf-test');
      addTearDown(() => directory.delete(recursive: true));
      final authentication = _Authentication(true);
      final audit = _AuditLog();
      final renderer = _RecordingRenderer();
      var callbackCalls = 0;
      final service = DataExportService(
        authService: authentication,
        auditService: audit,
        pdfRenderer: renderer,
        exportDirectoryCallback: () async => directory,
        getDataByDateRangeCallback: (start, end) async {
          callbackCalls++;
          return [
            {
              'table': 'cycles',
              'id': 'cycle-1',
              'startDate': DateTime(2026, 6, 1),
              'endDate': DateTime(2026, 6, 28),
              'cycleLength': 28,
              'periodLength': 5,
            },
            {
              'table': 'journal_entries',
              'id': 'journal-1',
              'date': DateTime(2026, 6, 2),
              'content': 'Private journal content',
            },
          ];
        },
      );

      final file = await service.exportHealthDataPdf(
        HealthDataPdfRequest(
          start: DateTime(2026, 6, 1),
          end: DateTime(2026, 6, 30),
          includeJournalEntries: false,
          generatedAt: DateTime(2026, 7, 13),
        ),
      );

      expect(authentication.attempts, 1);
      expect(callbackCalls, 1);
      expect(await file.exists(), isTrue);
      expect(String.fromCharCodes((await file.readAsBytes()).take(5)), '%PDF-');
      expect(audit.entries, hasLength(1));
      expect(audit.entries.single.action, AuditAction.export);
      expect(audit.entries.single.success, isTrue);
      expect(audit.entries.single.details?['journalsIncluded'], 'false');
      expect(
        renderer.records!.where(
          (record) => record['table'] == 'journal_entries',
        ),
        isEmpty,
      );
    },
  );

  test(
    'failed fresh authentication prevents data access and audits failure',
    () async {
      final authentication = _Authentication(false);
      final audit = _AuditLog();
      var callbackCalls = 0;
      final service = DataExportService(
        authService: authentication,
        auditService: audit,
        getDataByDateRangeCallback: (start, end) async {
          callbackCalls++;
          return [];
        },
      );

      await expectLater(
        service.exportHealthDataPdf(
          HealthDataPdfRequest(
            start: DateTime(2026, 6, 1),
            end: DateTime(2026, 6, 30),
          ),
        ),
        throwsA(isA<DataExportException>()),
      );

      expect(callbackCalls, 0);
      expect(audit.entries, hasLength(1));
      expect(audit.entries.single.success, isFalse);
    },
  );

  test(
    'delete callback runs only after fresh auth and records the event',
    () async {
      final authentication = _Authentication(true);
      final audit = _AuditLog();
      DateTime? deletedStart;
      DateTime? deletedEnd;
      final service = DataExportService(
        authService: authentication,
        auditService: audit,
        deleteDateRangeCallback: (start, end) async {
          deletedStart = start;
          deletedEnd = end;
        },
      );
      final start = DateTime(2026, 1, 1);
      final end = DateTime(2026, 2, 1);

      await service.deleteDateRange(start, end);

      expect(deletedStart, start);
      expect(deletedEnd, end);
      expect(authentication.attempts, 1);
      expect(audit.entries.single.action, AuditAction.delete);
      expect(audit.entries.single.success, isTrue);
    },
  );
}
