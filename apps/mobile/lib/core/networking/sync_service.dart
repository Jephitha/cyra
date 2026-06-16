import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/core/database/daos/cycle_dao.dart';
import 'package:cyra/core/networking/supabase_client.dart';
import 'package:cyra/core/networking/network_info.dart';
import 'package:cyra/core/security/encryption_service.dart';

part 'sync_service.g.dart';

enum SyncStatus { idle, syncing, success, error }
enum SyncTable { cycles, cycleDays, bbtRecords, journalEntries }

class SyncProgress {
  final SyncTable table;
  final int completed;
  final int total;
  final String? error;

  const SyncProgress({
    required this.table,
    required this.completed,
    required this.total,
    this.error,
  });

  double get fraction => total > 0 ? completed / total : 1.0;
}

class SyncService {
  final db.AppDatabase _database;
  final CycleDao _cycleDao;
  final BbtDao _bbtDao;
  final SupabaseClientService _supabase;
  final EncryptionService _encryptionService;
  final NetworkInfo _networkInfo;

  final ValueNotifier<SyncStatus> statusNotifier = ValueNotifier<SyncStatus>(SyncStatus.idle);
  final ValueNotifier<SyncProgress?> progressNotifier = ValueNotifier<SyncProgress?>(null);
  final ValueNotifier<DateTime?> lastSyncNotifier = ValueNotifier<DateTime?>(null);

  StreamSubscription<bool>? _connectivitySubscription;
  bool _isSyncing = false;
  static const int _maxRetries = 3;

  SyncService(
    this._database,
    this._cycleDao,
    this._bbtDao,
    this._supabase,
    this._encryptionService,
    this._networkInfo,
  ) {
    _connectivitySubscription = _networkInfo.connectivityStream.listen((isConnected) {
      if (isConnected && statusNotifier.value == SyncStatus.idle) {
        syncAll();
      }
    });
  }

  bool get isSyncing => _isSyncing;

  Future<SyncStatus> syncAll() async {
    if (_isSyncing) return SyncStatus.syncing;
    if (!_networkInfo.isConnected) return SyncStatus.error;

    _isSyncing = true;
    statusNotifier.value = SyncStatus.syncing;

    try {
      await syncTable(SyncTable.cycles);
      await syncTable(SyncTable.cycleDays);
      await syncTable(SyncTable.bbtRecords);
      await syncTable(SyncTable.journalEntries);

      statusNotifier.value = SyncStatus.success;
      lastSyncNotifier.value = DateTime.now();
      return SyncStatus.success;
    } catch (e) {
      statusNotifier.value = SyncStatus.error;
      return SyncStatus.error;
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> syncTable(SyncTable table) async {
    final records = await _getUnsyncedRecords(table);

    if (records.isEmpty) {
      progressNotifier.value = SyncProgress(table: table, completed: 0, total: 0);
      return;
    }

    progressNotifier.value = SyncProgress(table: table, completed: 0, total: records.length);
    int completed = 0;

    for (final record in records) {
      await _syncRecordWithRetry(table, record, _maxRetries);
      completed++;
      progressNotifier.value = SyncProgress(table: table, completed: completed, total: records.length);
    }
  }

  Future<List<Map<String, dynamic>>> _getUnsyncedRecords(SyncTable table) async {
    switch (table) {
      case SyncTable.cycles:
        return _cycleDao.getUnsyncedCycles();
      case SyncTable.cycleDays:
        return [];
      case SyncTable.bbtRecords:
        return _bbtDao.getUnsyncedRecords();
      case SyncTable.journalEntries:
        return [];
    }
  }

  Future<void> _syncRecordWithRetry(SyncTable table, Map<String, dynamic> record, int retriesLeft) async {
    for (int attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        await _syncRecord(table, record);
        await _markAsSynced(table, record);
        return;
      } catch (e) {
        if (attempt < _maxRetries) {
          await Future.delayed(_backoffDuration(attempt));
        } else {
          rethrow;
        }
      }
    }
  }

  Duration _backoffDuration(int attempt) {
    final baseMs = 1000;
    final maxMs = 30000;
    final delay = min(baseMs * pow(2, attempt).toInt(), maxMs);
    final jitter = Random().nextInt(1000);
    return Duration(milliseconds: delay + jitter);
  }

  Future<void> _syncRecord(SyncTable table, Map<String, dynamic> record) async {
    final encryptedRecord = _encryptSensitiveFields(record, table);
    final tableName = _tableName(table);

    final conflictColumn = switch (table) {
      SyncTable.cycles => 'id',
      SyncTable.bbtRecords => 'id',
      _ => null,
    };

    await _supabase.upsert(tableName, encryptedRecord, conflictColumn: conflictColumn);
  }

  Map<String, dynamic> _encryptSensitiveFields(Map<String, dynamic> record, SyncTable table) {
    final encrypted = Map<String, dynamic>.from(record);
    encrypted.remove('localId');

    if (table == SyncTable.journalEntries) {
      if (encrypted['content'] != null) {
        encrypted['content'] = _encryptionService.encryptString(encrypted['content'] as String);
      }
      if (encrypted['title'] != null) {
        encrypted['title'] = _encryptionService.encryptString(encrypted['title'] as String);
      }
    }

    return encrypted;
  }

  Future<void> _markAsSynced(SyncTable table, Map<String, dynamic> record) async {
    final id = record['id'] as String?;
    if (id == null) return;

    switch (table) {
      case SyncTable.cycles:
        await _cycleDao.markAsSynced(id);
      case SyncTable.cycleDays:
        break;
      case SyncTable.bbtRecords:
        await _bbtDao.markAsSynced(id);
      case SyncTable.journalEntries:
        break;
    }
  }

  String _tableName(SyncTable table) {
    return switch (table) {
      SyncTable.cycles => 'cycles',
      SyncTable.cycleDays => 'cycle_days',
      SyncTable.bbtRecords => 'bbt_records',
      SyncTable.journalEntries => 'journal_entries',
    };
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    statusNotifier.dispose();
    progressNotifier.dispose();
    lastSyncNotifier.dispose();
  }
}

@Riverpod(keepAlive: true)
SyncService syncService(SyncServiceRef ref) {
  final database_ = ref.read(db.appDatabaseProvider);
  final cycleDao = ref.read(cycleDaoProvider);
  final bbtDao = ref.read(bbtDaoProvider);
  final supabase = ref.read(supabaseClientServiceProvider);
  final encryption = ref.read(encryptionServiceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return SyncService(database_, cycleDao, bbtDao, supabase, encryption, networkInfo);
}
