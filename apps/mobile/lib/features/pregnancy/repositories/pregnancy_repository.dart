import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/core/utils/date_utils.dart';
import 'package:cyra/features/pregnancy/models/pregnancy_models.dart';

class PregnancyRepository {
  final db.AppDatabase _db;

  static const String _kickLogsKey = 'kick_logs';

  PregnancyRepository(this._db);

  // ── Pregnancy CRUD ─────────────────────────────────────────────

  Future<Pregnancy> createPregnancy(
    DateTime dueDate, {
    DateTime? conceptionDate,
  }) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final now = DateTime.now();
    final weeks = _calculateWeeksFromDueDate(dueDate);
    final trimester = CycleDateUtils.getTrimester(weeks);

    await _db
        .into(_db.pregnancies)
        .insert(
          db.PregnanciesCompanion.insert(
            id: id,
            userId: '',
            conceptionDate: conceptionDate != null
                ? Value(conceptionDate)
                : Value.absent(),
            dueDate: dueDate,
            currentWeek: weeks,
            currentTrimester: trimester,
            notes: Value.absent(),
            isActive: const Value(true),
            isSynced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ),
        );

    return Pregnancy(
      id: id,
      conceptionDate: conceptionDate,
      dueDate: dueDate,
      currentWeek: weeks,
      currentTrimester: trimester,
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<Pregnancy?> getCurrentPregnancy() async {
    final results =
        await (_db.select(_db.pregnancies)
              ..where((t) => t.isActive.equals(true))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
              ..limit(1))
            .get();

    if (results.isEmpty) return null;
    return _toDomainPregnancy(results.first);
  }

  Future<Pregnancy?> getPregnancy(String id) async {
    final result = await (_db.select(
      _db.pregnancies,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (result == null) return null;
    return _toDomainPregnancy(result);
  }

  Future<List<Pregnancy>> getAllPregnancies() async {
    final results = await (_db.select(
      _db.pregnancies,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
    return results.map(_toDomainPregnancy).toList();
  }

  Future<Pregnancy> updatePregnancy(Pregnancy pregnancy) async {
    final now = DateTime.now();
    final weeks = _calculateWeeksFromDueDate(pregnancy.dueDate);
    final trimester = CycleDateUtils.getTrimester(weeks);

    await (_db.update(
      _db.pregnancies,
    )..where((t) => t.id.equals(pregnancy.id))).write(
      db.PregnanciesCompanion(
        conceptionDate: pregnancy.conceptionDate != null
            ? Value(pregnancy.conceptionDate!)
            : Value.absent(),
        dueDate: Value(pregnancy.dueDate),
        currentWeek: Value(weeks),
        currentTrimester: Value(trimester),
        notes: pregnancy.notes != null
            ? Value(pregnancy.notes!)
            : Value.absent(),
        isActive: Value(pregnancy.isActive),
        updatedAt: Value(now),
      ),
    );

    return pregnancy.copyWith(
      currentWeek: weeks,
      currentTrimester: trimester,
      updatedAt: now,
    );
  }

  Future<void> endPregnancy(String id) async {
    await (_db.update(_db.pregnancies)..where((t) => t.id.equals(id))).write(
      db.PregnanciesCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ── Fetal Measurements ─────────────────────────────────────────

  Future<FetalMeasurement> saveMeasurement(FetalMeasurement m) async {
    final now = DateTime.now();
    final existing = await _getMeasurementEntity(m.id);

    if (existing != null) {
      await (_db.update(
        _db.fetalMeasurements,
      )..where((t) => t.id.equals(m.id))).write(
        db.FetalMeasurementsCompanion(
          weight: m.weight != null ? Value(m.weight!) : Value.absent(),
          bloodPressureSystolic: m.bloodPressureSystolic != null
              ? Value(m.bloodPressureSystolic!)
              : Value.absent(),
          bloodPressureDiastolic: m.bloodPressureDiastolic != null
              ? Value(m.bloodPressureDiastolic!)
              : Value.absent(),
          glucoseLevel: m.glucoseLevel != null
              ? Value(m.glucoseLevel!)
              : Value.absent(),
          kicksCount: m.kicksCount != null
              ? Value(m.kicksCount!)
              : Value.absent(),
          contractionsJson: m.contractionsJson != null
              ? Value(m.contractionsJson!)
              : Value.absent(),
        ),
      );
      return m;
    }

    await _db
        .into(_db.fetalMeasurements)
        .insert(
          db.FetalMeasurementsCompanion.insert(
            id: m.id,
            pregnancyId: m.pregnancyId,
            date: m.date,
            weight: m.weight != null ? Value(m.weight!) : Value.absent(),
            bloodPressureSystolic: m.bloodPressureSystolic != null
                ? Value(m.bloodPressureSystolic!)
                : Value.absent(),
            bloodPressureDiastolic: m.bloodPressureDiastolic != null
                ? Value(m.bloodPressureDiastolic!)
                : Value.absent(),
            glucoseLevel: m.glucoseLevel != null
                ? Value(m.glucoseLevel!)
                : Value.absent(),
            kicksCount: m.kicksCount != null
                ? Value(m.kicksCount!)
                : Value.absent(),
            contractionsJson: m.contractionsJson != null
                ? Value(m.contractionsJson!)
                : Value.absent(),
            createdAt: now,
          ),
        );

    return m;
  }

  Future<List<FetalMeasurement>> getMeasurements(String pregnancyId) async {
    final results =
        await (_db.select(_db.fetalMeasurements)
              ..where((t) => t.pregnancyId.equals(pregnancyId))
              ..orderBy([(t) => OrderingTerm.asc(t.date)]))
            .get();
    return results.map(_toDomainMeasurement).toList();
  }

  Future<FetalMeasurement?> getLatestMeasurement(String pregnancyId) async {
    final results =
        await (_db.select(_db.fetalMeasurements)
              ..where((t) => t.pregnancyId.equals(pregnancyId))
              ..orderBy([(t) => OrderingTerm.desc(t.date)])
              ..limit(1))
            .get();
    if (results.isEmpty) return null;
    return _toDomainMeasurement(results.first);
  }

  Future<void> deleteMeasurement(String id) async {
    await (_db.delete(
      _db.fetalMeasurements,
    )..where((t) => t.id.equals(id))).go();
  }

  // ── Kick Logs ─────────────────────────────────────────────────

  Future<KickLog> saveKickLog(KickLog log) async {
    final logs = await _loadKickLogs();
    final existingIdx = logs.indexWhere((l) => l.id == log.id);

    final normal = log.kickCount >= 10 ? true : false;
    final updated = log.copyWith(isNormal: normal);

    if (existingIdx >= 0) {
      logs[existingIdx] = updated;
    } else {
      logs.add(updated);
    }

    await _saveKickLogs(logs);
    return updated;
  }

  Future<List<KickLog>> getKickLogs(
    String pregnancyId, {
    DateTime? from,
    DateTime? to,
  }) async {
    final logs = await _loadKickLogs();
    var filtered = logs.where((l) => l.pregnancyId == pregnancyId);

    if (from != null) {
      filtered = filtered.where(
        (l) => l.date.isAfter(from.subtract(const Duration(days: 1))),
      );
    }
    if (to != null) {
      filtered = filtered.where(
        (l) => l.date.isBefore(to.add(const Duration(days: 1))),
      );
    }

    return filtered.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<KickLog?> getLatestKickLog(String pregnancyId) async {
    final logs = await getKickLogs(pregnancyId);
    if (logs.isEmpty) return null;
    return logs.first;
  }

  Future<void> deleteKickLog(String id) async {
    final logs = await _loadKickLogs();
    logs.removeWhere((l) => l.id == id);
    await _saveKickLogs(logs);
  }

  // ── Due Date Calculation ──────────────────────────────────────

  DateTime calculateDueDate(DateTime lastPeriodStart, {int cycleLength = 28}) {
    return CycleDateUtils.calculateDueDate(
      lastPeriodStart,
      cycleLength: cycleLength,
    );
  }

  DateTime estimateConceptionDate(DateTime dueDate) {
    return dueDate.subtract(const Duration(days: 266));
  }

  int calculateCurrentWeek(DateTime dueDate) {
    return CycleDateUtils.getWeekOfPregnancy(dueDate);
  }

  DateTime? estimateLastPeriodStart(DateTime dueDate, {int cycleLength = 28}) {
    final gestationalAge = cycleLength - 28;
    return dueDate.subtract(Duration(days: 280 - gestationalAge));
  }

  // ── Week Advancement ──────────────────────────────────────────

  Future<Pregnancy> advanceWeek(Pregnancy pregnancy) async {
    final weeks = _calculateWeeksFromDueDate(pregnancy.dueDate);
    final trimester = CycleDateUtils.getTrimester(weeks);

    if (weeks == pregnancy.currentWeek &&
        trimester == pregnancy.currentTrimester) {
      return pregnancy;
    }

    final updated = pregnancy.copyWith(
      currentWeek: weeks,
      currentTrimester: trimester,
      updatedAt: DateTime.now(),
    );

    await _updatePregnancyWeek(pregnancy.id, weeks, trimester);
    return updated;
  }

  Future<Pregnancy> recalculateWeeks(String id) async {
    final pregnancy = await getPregnancy(id);
    if (pregnancy == null) {
      throw Exception('Pregnancy not found');
    }
    return advanceWeek(pregnancy);
  }

  // ── Statistics ────────────────────────────────────────────────

  Future<Map<String, double>> getWeightTrend(String pregnancyId) async {
    final measurements = await getMeasurements(pregnancyId);
    final trend = <String, double>{};

    for (final m in measurements) {
      if (m.weight != null) {
        trend[CycleDateUtils.formatDate(m.date)] = m.weight!;
      }
    }

    return trend;
  }

  Future<List<FetalMeasurement>> getBloodPressureReadings(
    String pregnancyId,
  ) async {
    final measurements = await getMeasurements(pregnancyId);
    return measurements
        .where(
          (m) =>
              m.bloodPressureSystolic != null &&
              m.bloodPressureDiastolic != null,
        )
        .toList();
  }

  // ── Private ───────────────────────────────────────────────────

  int _calculateWeeksFromDueDate(DateTime dueDate) {
    final weeks = CycleDateUtils.getWeekOfPregnancy(dueDate);
    return weeks.clamp(0, 42);
  }

  Future<void> _updatePregnancyWeek(String id, int week, int trimester) async {
    await (_db.update(_db.pregnancies)..where((t) => t.id.equals(id))).write(
      db.PregnanciesCompanion(
        currentWeek: Value(week),
        currentTrimester: Value(trimester),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<db.FetalMeasurement?> _getMeasurementEntity(String id) async {
    final result = await (_db.select(
      _db.fetalMeasurements,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return result;
  }

  Future<List<KickLog>> _loadKickLogs() async {
    final setting = await (_db.select(
      _db.appSettings,
    )..where((t) => t.key.equals(_kickLogsKey))).getSingleOrNull();
    if (setting == null || setting.value.isEmpty) return [];

    try {
      final list = jsonDecode(setting.value) as List;
      return list
          .map((e) => KickLog.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveKickLogs(List<KickLog> logs) async {
    final json = jsonEncode(logs.map((l) => l.toJson()).toList());
    final existing = await (_db.select(
      _db.appSettings,
    )..where((t) => t.key.equals(_kickLogsKey))).getSingleOrNull();

    if (existing != null) {
      await (_db.update(
        _db.appSettings,
      )..where((t) => t.key.equals(_kickLogsKey))).write(
        db.AppSettingsCompanion(
          value: Value(json),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await _db
          .into(_db.appSettings)
          .insert(
            db.AppSettingsCompanion.insert(
              id: _kickLogsKey,
              key: _kickLogsKey,
              value: json,
              updatedAt: DateTime.now(),
            ),
          );
    }
  }

  Pregnancy _toDomainPregnancy(db.Pregnancy entity) {
    return Pregnancy(
      id: entity.id,
      conceptionDate: entity.conceptionDate,
      dueDate: entity.dueDate,
      currentWeek: entity.currentWeek,
      currentTrimester: entity.currentTrimester,
      isActive: entity.isActive,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  FetalMeasurement _toDomainMeasurement(db.FetalMeasurement entity) {
    return FetalMeasurement(
      id: entity.id,
      pregnancyId: entity.pregnancyId,
      date: entity.date,
      weight: entity.weight,
      bloodPressureSystolic: entity.bloodPressureSystolic,
      bloodPressureDiastolic: entity.bloodPressureDiastolic,
      glucoseLevel: entity.glucoseLevel,
      kicksCount: entity.kicksCount,
      contractionsJson: entity.contractionsJson,
    );
  }
}
