import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/security/audit_service.dart';
import 'package:cyra/core/security/biometric_auth_service.dart';

part 'data_export_service.g.dart';

class DataExportException implements Exception {
  final String message;
  final Object? cause;
  DataExportException(this.message, [this.cause]);

  @override
  String toString() => 'DataExportException: $message';
}

class DataExportService {
  final BiometricAuthService _authService;
  final AuditService _auditService;

  /// Callback to retrieve data from the database layer.
  /// Each entry should be a map with at least a 'table' and 'id' field.
  final Future<List<Map<String, dynamic>>> Function()? getAllDataCallback;

  /// Callback to retrieve data filtered by date range.
  final Future<List<Map<String, dynamic>>> Function(
    DateTime start,
    DateTime end,
  )? getDataByDateRangeCallback;

  /// Callback to delete a single record.
  final Future<void> Function(String table, String id)? deleteRecordCallback;

  /// Callback to delete records by date range.
  final Future<void> Function(DateTime start, DateTime end)?
      deleteDateRangeCallback;

  /// Callback to delete all user data (account deletion).
  final Future<void> Function()? deleteAllDataCallback;

  DataExportService({
    required this._authService,
    required this._auditService,
    this.getAllDataCallback,
    this.getDataByDateRangeCallback,
    this.deleteRecordCallback,
    this.deleteDateRangeCallback,
    this.deleteAllDataCallback,
  });

  Future<File> exportAllDataAsJson() async {
    await _requireReVerification('Export all data');

    if (getAllDataCallback == null) {
      throw DataExportException('Data retrieval callback not configured');
    }

    try {
      final data = await getAllDataCallback!();
      final exportData = _buildExportJson(data);
      final file = await _writeJsonToFile(exportData, 'cyra_export_all');

      await _auditService.log(
        action: AuditAction.export,
        recordType: AuditRecordType.export,
        success: true,
        details: {
          'scope': 'all',
          'recordCount': data.length.toString(),
          'fileName': file.path.split('/').last,
        },
      );

      return file;
    } catch (e) {
      await _auditService.log(
        action: AuditAction.export,
        recordType: AuditRecordType.export,
        success: false,
        details: {'scope': 'all', 'error': _truncateError(e)},
      );
      throw DataExportException('Failed to export all data', e);
    }
  }

  Future<File> exportDateRange(DateTime start, DateTime end) async {
    await _requireReVerification('Export data by date range');

    if (getDataByDateRangeCallback == null) {
      throw DataExportException('Date range data retrieval not configured');
    }

    try {
      final data = await getDataByDateRangeCallback!(start, end);
      final exportData = _buildExportJson(data);
      final file = await _writeJsonToFile(
        exportData,
        'cyra_export_${start.toIso8601String().split('T').first}'
            '_${end.toIso8601String().split('T').first}',
      );

      await _auditService.log(
        action: AuditAction.export,
        recordType: AuditRecordType.export,
        success: true,
        details: {
          'scope': 'dateRange',
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
          'recordCount': data.length.toString(),
        },
      );

      return file;
    } catch (e) {
      await _auditService.log(
        action: AuditAction.export,
        recordType: AuditRecordType.export,
        success: false,
        details: {
          'scope': 'dateRange',
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
          'error': _truncateError(e),
        },
      );
      throw DataExportException('Failed to export data by date range', e);
    }
  }

  Future<void> deleteSingleRecord(String table, String id) async {
    await _requireReVerification('Delete record');

    if (deleteRecordCallback == null) {
      throw DataExportException('Delete record callback not configured');
    }

    try {
      await deleteRecordCallback!(table, id);

      AuditRecordType recordType;
      switch (table) {
        case 'cycles':
          recordType = AuditRecordType.cycle;
          break;
        case 'symptoms':
          recordType = AuditRecordType.symptom;
          break;
        case 'journal_entries':
          recordType = AuditRecordType.journal;
          break;
        case 'notes':
          recordType = AuditRecordType.note;
          break;
        default:
          recordType = AuditRecordType.healthData;
      }

      await _auditService.log(
        action: AuditAction.delete,
        recordType: recordType,
        success: true,
        details: {
          'table': table,
          'recordId': id,
          'scope': 'single',
        },
      );
    } catch (e) {
      await _auditService.log(
        action: AuditAction.delete,
        recordType: _recordTypeFromTable(table),
        success: false,
        details: {
          'table': table,
          'recordId': id,
          'scope': 'single',
          'error': _truncateError(e),
        },
      );
      throw DataExportException('Failed to delete record', e);
    }
  }

  Future<void> deleteDateRange(DateTime start, DateTime end) async {
    await _requireReVerification('Delete data by date range');

    if (deleteDateRangeCallback == null) {
      throw DataExportException(
        'Delete date range callback not configured',
      );
    }

    try {
      await deleteDateRangeCallback!(start, end);

      await _auditService.log(
        action: AuditAction.delete,
        recordType: AuditRecordType.healthData,
        success: true,
        details: {
          'scope': 'dateRange',
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
        },
      );
    } catch (e) {
      await _auditService.log(
        action: AuditAction.delete,
        recordType: AuditRecordType.healthData,
        success: false,
        details: {
          'scope': 'dateRange',
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
          'error': _truncateError(e),
        },
      );
      throw DataExportException('Failed to delete data by date range', e);
    }
  }

  Future<void> deleteAllData() async {
    await _requireReVerification('Delete all data');

    if (deleteAllDataCallback == null) {
      throw DataExportException('Delete all data callback not configured');
    }

    try {
      await deleteAllDataCallback!();

      await _auditService.log(
        action: AuditAction.delete,
        recordType: AuditRecordType.account,
        success: true,
        details: {'scope': 'all'},
      );
    } catch (e) {
      await _auditService.log(
        action: AuditAction.delete,
        recordType: AuditRecordType.account,
        success: false,
        details: {'scope': 'all', 'error': _truncateError(e)},
      );
      throw DataExportException('Failed to delete all data', e);
    }
  }

  /// Get list of available export files.
  Future<List<FileSystemEntity>> getExportFiles() async {
    final dir = await _getExportDirectory();
    if (!await dir.exists()) return [];
    return dir.list().toList();
  }

  /// Delete an export file by path.
  Future<void> deleteExportFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // --- Private Helpers ---

  Map<String, dynamic> _buildExportJson(List<Map<String, dynamic>> data) {
    final grouped = <String, List<Map<String, dynamic>>>{};

    for (final entry in data) {
      final table = entry.remove('table') as String? ?? 'unknown';
      grouped.putIfAbsent(table, () => []).add(entry);
    }

    return {
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'appVersion': '1.0.0',
      'dataFormat': 'cyra_export_v1',
      'recordCount': data.length,
      'groupedRecords': grouped,
    };
  }

  Future<File> _writeJsonToFile(
    Map<String, dynamic> data,
    String baseName,
  ) async {
    final dir = await _getExportDirectory();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/${baseName}_$timestamp.json');
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(data),
    );
    return file;
  }

  Future<Directory> _getExportDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${appDir.path}/exports');
    return exportDir;
  }

  Future<void> _requireReVerification(String action) async {
    final authenticated = await _authService.authenticateWithBiometricsOrPin(
      reason: 'Re-verify your identity to $action',
    );
    if (!authenticated) {
      throw DataExportException(
        'Authentication required for: $action',
      );
    }
  }

  AuditRecordType _recordTypeFromTable(String table) {
    switch (table) {
      case 'cycles':
        return AuditRecordType.cycle;
      case 'symptoms':
        return AuditRecordType.symptom;
      case 'journal_entries':
        return AuditRecordType.journal;
      case 'notes':
        return AuditRecordType.note;
      default:
        return AuditRecordType.healthData;
    }
  }

  String _truncateError(Object error) {
    final msg = error.toString();
    return msg.length > 100 ? '${msg.substring(0, 97)}...' : msg;
  }
}

@Riverpod(keepAlive: true)
DataExportService dataExportService(DataExportServiceRef ref) {
  return DataExportService(
    authService: ref.read(biometricAuthServiceProvider),
    auditService: ref.read(auditServiceProvider),
  );
}
