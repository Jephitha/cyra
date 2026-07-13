import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';

import 'package:cyra/core/database/app_database.dart';
import 'package:cyra/core/security/audit_service.dart';
import 'package:cyra/core/security/biometric_auth_service.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/core/security/health_data_pdf_renderer.dart';

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
  final HealthDataPdfRenderer _pdfRenderer;
  final Future<Directory> Function()? exportDirectoryCallback;

  /// Callback to retrieve data from the database layer.
  /// Each entry should be a map with at least a 'table' and 'id' field.
  final Future<List<Map<String, dynamic>>> Function()? getAllDataCallback;

  /// Callback to retrieve data filtered by date range.
  final Future<List<Map<String, dynamic>>> Function(
    DateTime start,
    DateTime end,
  )?
  getDataByDateRangeCallback;

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
    HealthDataPdfRenderer? pdfRenderer,
    this.exportDirectoryCallback,
    this.getAllDataCallback,
    this.getDataByDateRangeCallback,
    this.deleteRecordCallback,
    this.deleteDateRangeCallback,
    this.deleteAllDataCallback,
  }) : _pdfRenderer = pdfRenderer ?? HealthDataPdfRenderer();

  Future<File> exportHealthDataPdf(HealthDataPdfRequest request) async {
    try {
      await _requireReVerification('export your health summary');
      if (getDataByDateRangeCallback == null) {
        throw DataExportException('Date range data retrieval not configured');
      }

      final data = await getDataByDateRangeCallback!(
        request.start,
        request.end,
      );
      final includedData = request.includeJournalEntries
          ? data
          : data
                .where((record) => record['table'] != 'journal_entries')
                .toList();
      final bytes = await _pdfRenderer.render(includedData, request);
      final file = await _writeBytesToFile(
        bytes,
        'cyra_health_summary_${_fileDate(request.start)}_${_fileDate(request.end)}',
        'pdf',
      );
      await _auditService.log(
        action: AuditAction.export,
        recordType: AuditRecordType.export,
        success: true,
        details: {
          'scope': 'clinicianPdf',
          'recordCount': includedData.length.toString(),
          'journalsIncluded': request.includeJournalEntries.toString(),
          'fileName': file.path.split('/').last,
        },
      );
      return file;
    } catch (error) {
      await _auditService.log(
        action: AuditAction.export,
        recordType: AuditRecordType.export,
        success: false,
        details: {'scope': 'clinicianPdf', 'error': _truncateError(error)},
      );
      if (error is DataExportException) rethrow;
      throw DataExportException('Failed to export health summary', error);
    }
  }

  Future<File> exportAllDataAsJson() async {
    try {
      await _requireReVerification('Export all data');
      if (getAllDataCallback == null) {
        throw DataExportException('Data retrieval callback not configured');
      }
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
    try {
      await _requireReVerification('Export data by date range');
      if (getDataByDateRangeCallback == null) {
        throw DataExportException('Date range data retrieval not configured');
      }
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
    try {
      await _requireReVerification('Delete record');
      if (deleteRecordCallback == null) {
        throw DataExportException('Delete record callback not configured');
      }
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
        details: {'table': table, 'recordId': id, 'scope': 'single'},
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
    try {
      await _requireReVerification('Delete data by date range');
      if (deleteDateRangeCallback == null) {
        throw DataExportException('Delete date range callback not configured');
      }
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
    try {
      await _requireReVerification('Delete all data');
      if (deleteAllDataCallback == null) {
        throw DataExportException('Delete all data callback not configured');
      }
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
      final copy = Map<String, dynamic>.from(entry);
      final table = copy.remove('table') as String? ?? 'unknown';
      grouped
          .putIfAbsent(table, () => [])
          .add(copy.map((key, value) => MapEntry(key, _jsonSafe(value))));
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
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
    return file;
  }

  Future<File> _writeBytesToFile(
    List<int> bytes,
    String baseName,
    String extension,
  ) async {
    final dir = await _getExportDirectory();
    if (!await dir.exists()) await dir.create(recursive: true);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/${baseName}_$timestamp.$extension');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<Directory> _getExportDirectory() async {
    if (exportDirectoryCallback != null) return exportDirectoryCallback!();
    final appDir = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${appDir.path}/exports');
    return exportDir;
  }

  Future<void> _requireReVerification(String action) async {
    final authenticated = await _authService.authenticateWithBiometricsOrPin(
      reason: 'Re-verify your identity to $action',
    );
    if (!authenticated) {
      throw DataExportException('Authentication required for: $action');
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

  String _fileDate(DateTime date) => date.toIso8601String().split('T').first;

  dynamic _jsonSafe(dynamic value) => switch (value) {
    DateTime date => date.toIso8601String(),
    List<dynamic> values => values.map(_jsonSafe).toList(),
    Map<dynamic, dynamic> values => values.map(
      (key, nested) => MapEntry(key.toString(), _jsonSafe(nested)),
    ),
    _ => value,
  };
}

@Riverpod(keepAlive: true)
DataExportService dataExportService(DataExportServiceRef ref) {
  final database = ref.watch(appDatabaseProvider);
  final encryption = ref.watch(encryptionServiceProvider);
  return DataExportService(
    authService: ref.read(biometricAuthServiceProvider),
    auditService: ref.read(auditServiceProvider),
    getAllDataCallback: () => _collectExportData(database, encryption),
    getDataByDateRangeCallback: (start, end) =>
        _collectExportData(database, encryption, start: start, end: end),
    deleteRecordCallback: (table, id) =>
        _deleteExportRecord(database, table, id),
    deleteDateRangeCallback: (start, end) =>
        _deleteExportDateRange(database, start, end),
    deleteAllDataCallback: () => _deleteAllHealthData(database),
  );
}

Future<void> _deleteExportRecord(
  AppDatabase database,
  String table,
  String id,
) async {
  switch (table) {
    case 'cycles':
      await (database.delete(
        database.cycles,
      )..where((row) => row.id.equals(id))).go();
    case 'cycle_days':
      await (database.delete(
        database.cycleDays,
      )..where((row) => row.id.equals(id))).go();
    case 'symptom_logs':
      await (database.delete(
        database.symptomLogs,
      )..where((row) => row.id.equals(id))).go();
    case 'journal_entries':
      await (database.delete(
        database.journalEntries,
      )..where((row) => row.id.equals(id))).go();
    default:
      throw DataExportException('Unsupported record type: $table');
  }
}

Future<void> _deleteExportDateRange(
  AppDatabase database,
  DateTime start,
  DateTime end,
) async {
  await database.transaction(() async {
    await (database.delete(
      database.journalEntries,
    )..where((row) => row.date.isBetween(Variable(start), Variable(end)))).go();
    await (database.delete(
      database.symptomLogs,
    )..where((row) => row.date.isBetween(Variable(start), Variable(end)))).go();
    await (database.delete(
      database.cycleDays,
    )..where((row) => row.date.isBetween(Variable(start), Variable(end)))).go();
    await (database.delete(database.cycles)..where(
          (row) => row.startDate.isBetween(Variable(start), Variable(end)),
        ))
        .go();
  });
}

Future<void> _deleteAllHealthData(AppDatabase database) async {
  await database.transaction(() async {
    await database.delete(database.healthReports).go();
    await database.delete(database.fetalMeasurements).go();
    await database.delete(database.pregnancies).go();
    await database.delete(database.ovulationTests).go();
    await database.delete(database.cervicalMucusObservations).go();
    await database.delete(database.bbtRecords).go();
    await database.delete(database.journalEntries).go();
    await database.delete(database.symptomLogs).go();
    await database.delete(database.cycleDays).go();
    await database.delete(database.cycles).go();
    await database.delete(database.userConditions).go();
    await database.delete(database.wearableSources).go();
  });
}

Future<List<Map<String, dynamic>>> _collectExportData(
  AppDatabase database,
  EncryptionService encryption, {
  DateTime? start,
  DateTime? end,
}) async {
  final records = <Map<String, dynamic>>[];
  final cyclesQuery = database.select(database.cycles);
  final daysQuery = database.select(database.cycleDays);
  final logsQuery = database.select(database.symptomLogs);
  final journalsQuery = database.select(database.journalEntries);
  if (start != null && end != null) {
    cyclesQuery.where(
      (row) => row.startDate.isBetween(Variable(start), Variable(end)),
    );
    daysQuery.where(
      (row) => row.date.isBetween(Variable(start), Variable(end)),
    );
    logsQuery.where(
      (row) => row.date.isBetween(Variable(start), Variable(end)),
    );
    journalsQuery.where(
      (row) => row.date.isBetween(Variable(start), Variable(end)),
    );
  }
  final cycles = await cyclesQuery.get();
  final days = await daysQuery.get();
  final logs = await logsQuery.get();
  final journals = await journalsQuery.get();
  final symptoms = await database.select(database.symptoms).get();
  final symptomNames = {
    for (final symptom in symptoms) symptom.id: symptom.name,
  };

  records.addAll(
    cycles.map(
      (cycle) => {
        'table': 'cycles',
        'id': cycle.id,
        'startDate': cycle.startDate,
        'endDate': cycle.endDate,
        'cycleLength': cycle.cycleLength,
        'periodLength': cycle.periodLength,
      },
    ),
  );
  records.addAll(
    days.map(
      (day) => {
        'table': 'cycle_days',
        'id': day.id,
        'cycleId': day.cycleId,
        'date': day.date,
        'flowIntensity': day.flowIntensity,
        'spotting': day.spotting,
        'temperature': day.temperature,
      },
    ),
  );
  records.addAll(
    logs.map(
      (log) => {
        'table': 'symptom_logs',
        'id': log.id,
        'date': log.date,
        'symptomId': log.symptomId,
        'symptomName': symptomNames[log.symptomId] ?? 'Other',
        'severity': log.severity,
      },
    ),
  );
  records.addAll(
    journals.map(
      (entry) => {
        'table': 'journal_entries',
        'id': entry.id,
        'date': entry.date,
        'title': _decryptOptional(encryption, entry.title),
        'content': _decryptOptional(encryption, entry.content),
        'moodRating': entry.moodRating,
      },
    ),
  );
  return records;
}

String? _decryptOptional(EncryptionService encryption, String? value) {
  if (value == null) return null;
  try {
    return encryption.decryptString(value);
  } catch (_) {
    return null;
  }
}
