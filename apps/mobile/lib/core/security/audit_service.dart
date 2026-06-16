import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audit_service.g.dart';

class AuditException implements Exception {
  final String message;
  final Object? cause;
  AuditException(this.message, [this.cause]);

  @override
  String toString() => 'AuditException: $message';
}

enum AuditAction {
  read,
  write,
  delete,
  export,
  login,
  logout,
  settingsChange,
  emergencyLock,
  keyRotation,
}

enum AuditRecordType {
  cycle,
  symptom,
  journal,
  note,
  healthData,
  settings,
  auth,
  export,
  account,
}

class AuditEntry {
  final String id;
  final DateTime timestamp;
  final AuditAction action;
  final AuditRecordType recordType;
  final bool success;
  final Map<String, String>? details;

  AuditEntry({
    required this.id,
    required this.timestamp,
    required this.action,
    required this.recordType,
    required this.success,
    this.details,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'action': action.name,
        'recordType': recordType.name,
        'success': success,
        if (details != null) 'details': details,
      };

  factory AuditEntry.fromJson(Map<String, dynamic> json) => AuditEntry(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        action: AuditAction.values.byName(json['action'] as String),
        recordType: AuditRecordType.values.byName(json['recordType'] as String),
        success: json['success'] as bool,
        details: json['details'] != null
            ? Map<String, String>.from(json['details'] as Map)
            : null,
      );
}

class AuditService {
  final FlutterSecureStorage _secureStorage;
  final Random _random = Random.secure();

  static const String _auditLogPrefix = 'cyra_audit_';
  static const String _auditIndexKey = 'cyra_audit_index';
  static const int _defaultRetentionDays = 90;
  static const int _maxEntries = 10000;

  int _retentionDays;

  AuditService({
    required FlutterSecureStorage secureStorage,
    int retentionDays = _defaultRetentionDays,
  })  : _secureStorage = secureStorage,
        _retentionDays = retentionDays;

  int get retentionDays => _retentionDays;

  Future<void> setRetentionDays(int days) async {
    if (days < 1 || days > 365) {
      throw AuditException('Retention days must be between 1 and 365');
    }
    _retentionDays = days;
    await _pruneExpiredEntries();
  }

  Future<void> log({
    required AuditAction action,
    required AuditRecordType recordType,
    required bool success,
    Map<String, String>? details,
  }) async {
    try {
      if (details != null) {
        _validateDetails(details);
      }

      final entry = AuditEntry(
        id: _generateId(),
        timestamp: DateTime.now(),
        action: action,
        recordType: recordType,
        success: success,
        details: details,
      );

      final index = await _getIndex();
      index.add(entry.id);
      await _trimIndex(index);

      await _secureStorage.write(
        key: '$_auditLogPrefix${entry.id}',
        value: base64.encode(
          utf8.encode(json.encode(entry.toJson())),
        ),
      );
      await _secureStorage.write(
        key: _auditIndexKey,
        value: json.encode(index),
      );

      await _pruneExpiredEntries();
    } catch (e) {
      throw AuditException('Failed to log audit entry', e);
    }
  }

  Future<List<AuditEntry>> getAuditLog({
    DateTime? from,
    DateTime? to,
    int? limit,
  }) async {
    try {
      final allEntries = await _getAllEntries();

      var filtered = allEntries;

      if (from != null) {
        filtered = filtered.where((e) => e.timestamp.isAfter(from)).toList();
      }
      if (to != null) {
        filtered = filtered.where((e) => e.timestamp.isBefore(to)).toList();
      }

      filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      if (limit != null && limit > 0) {
        filtered = filtered.take(limit).toList();
      }

      return filtered;
    } catch (e) {
      throw AuditException('Failed to retrieve audit log', e);
    }
  }

  Future<List<AuditEntry>> getAuditLogByAction(AuditAction action) async {
    try {
      final entries = (await _getAllEntries())
          .where((e) => e.action == action)
          .toList();
      entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return entries;
    } catch (e) {
      throw AuditException('Failed to retrieve audit log by action', e);
    }
  }

  Future<List<AuditEntry>> getAuditLogByRecordType(
    AuditRecordType recordType,
  ) async {
    try {
      final entries = (await _getAllEntries())
          .where((e) => e.recordType == recordType)
          .toList();
      entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return entries;
    } catch (e) {
      throw AuditException('Failed to retrieve audit log by record type', e);
    }
  }

  Future<int> getEntryCount() async {
    try {
      final index = await _getIndex();
      return index.length;
    } catch (e) {
      return 0;
    }
  }

  Future<void> clearAuditLog() async {
    try {
      final index = await _getIndex();
      for (final id in index) {
        await _secureStorage.delete(key: '$_auditLogPrefix$id');
      }
      await _secureStorage.delete(key: _auditIndexKey);
    } catch (e) {
      throw AuditException('Failed to clear audit log', e);
    }
  }

  Future<List<int>> getAuditLogStats() async {
    final entries = await _getAllEntries();
    final now = DateTime.now();
    final last24h = entries.where(
      (e) => e.timestamp.isAfter(now.subtract(const Duration(hours: 24))),
    ).length;
    final last7d = entries.where(
      (e) => e.timestamp.isAfter(now.subtract(const Duration(days: 7))),
    ).length;
    final last30d = entries.where(
      (e) => e.timestamp.isAfter(now.subtract(const Duration(days: 30))),
    ).length;
    return [last24h, last7d, last30d, entries.length];
  }

  // --- Private Helpers ---

  Future<List<String>> _getIndex() async {
    final value = await _secureStorage.read(key: _auditIndexKey);
    if (value == null) return [];
    final decoded = json.decode(value) as List;
    return decoded.cast<String>();
  }

  Future<void> _trimIndex(List<String> index) async {
    if (index.length > _maxEntries) {
      final toRemove = index.sublist(0, index.length - _maxEntries);
      for (final id in toRemove) {
        await _secureStorage.delete(key: '$_auditLogPrefix$id');
      }
      index.removeRange(0, index.length - _maxEntries);
    }
  }

  Future<List<AuditEntry>> _getAllEntries() async {
    final index = await _getIndex();
    final entries = <AuditEntry>[];

    for (final id in index.reversed) {
      final value = await _secureStorage.read(key: '$_auditLogPrefix$id');
      if (value != null) {
        try {
          final decoded = json.decode(utf8.decode(base64.decode(value)));
          entries.add(AuditEntry.fromJson(decoded as Map<String, dynamic>));
        } catch (_) {}
      }
    }

    return entries;
  }

  Future<void> _pruneExpiredEntries() async {
    final cutoff = DateTime.now().subtract(Duration(days: _retentionDays));
    final index = await _getIndex();
    final toRemove = <String>[];
    final remaining = <String>[];

    for (final id in index) {
      final value = await _secureStorage.read(key: '$_auditLogPrefix$id');
      if (value != null) {
        try {
          final decoded = json.decode(utf8.decode(base64.decode(value)));
          final entry = AuditEntry.fromJson(
            decoded as Map<String, dynamic>,
          );
          if (entry.timestamp.isBefore(cutoff)) {
            toRemove.add(id);
          } else {
            remaining.add(id);
          }
        } catch (_) {
          toRemove.add(id);
        }
      } else {
        toRemove.add(id);
      }
    }

    for (final id in toRemove) {
      await _secureStorage.delete(key: '$_auditLogPrefix$id');
    }

    if (toRemove.isNotEmpty) {
      await _secureStorage.write(
        key: _auditIndexKey,
        value: json.encode(remaining),
      );
    }
  }

  String _generateId() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  void _validateDetails(Map<String, String> details) {
    const sensitiveKeys = [
      'password',
      'pin',
      'token',
      'secret',
      'key',
      'auth',
      'credential',
    ];
    final lowerDetails = details.map((k, v) => MapEntry(k.toLowerCase(), v));
    for (final key in sensitiveKeys) {
      if (lowerDetails.containsKey(key)) {
        throw AuditException(
          'Audit log must not contain sensitive data (found key: $key)',
        );
      }
    }

    final totalLength = details.values.fold<int>(
      0,
      (sum, v) => sum + v.length,
    );
    if (totalLength > 512) {
      throw AuditException('Audit log details exceed maximum length (512 chars)');
    }
  }
}

extension _ListExtension<T> on List<T> {
  List<T> sorted(int Function(T, T) compare) {
    final copy = [...this];
    copy.sort(compare);
    return copy;
  }
}

@Riverpod(keepAlive: true)
AuditService auditService(AuditServiceRef ref) {
  return AuditService(
    secureStorage: const FlutterSecureStorage(),
  );
}
