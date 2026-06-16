import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/database/app_database.dart';

part 'cycle_dao.g.dart';

// ============================================================
// CycleDao
// ============================================================

class CycleDao {
  final AppDatabase _db;
  CycleDao(this._db);

  Future<Cycle> createCycle(Cycle cycle) async {
    await _db.into(_db.cycles).insert(cycle);
    return cycle;
  }

  Future<Cycle?> getCycleById(String id) =>
      (_db.select(_db.cycles)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<Cycle>> getCyclesByUserId(String userId) =>
      (_db.select(_db.cycles)..where((t) => t.userId.equals(userId))).get();

  Future<List<Cycle>> getCyclesByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) =>
      (_db.select(_db.cycles)
            ..where((t) =>
                t.userId.equals(userId) & t.startDate.isBetween(Variable(start), Variable(end))))
          .get();

  Future<Cycle?> getLatestCycle(String userId) =>
      (_db.select(_db.cycles)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)])
            ..limit(1))
          .getSingleOrNull();

  Future<bool> updateCycle(Cycle cycle) =>
      _db.update(_db.cycles).replace(cycle);

  Future<int> deleteCycle(String id) =>
      (_db.delete(_db.cycles)..where((t) => t.id.equals(id))).go();

  Future<List<Cycle>> getCycleHistorySummary(String userId) =>
      (_db.select(_db.cycles)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();

  Future<List<Map<String, dynamic>>> getUnsyncedCycles() async {
    final cycles = await (_db.select(_db.cycles)
          ..where((t) => t.isSynced.equals(false)))
        .get();
    return cycles
        .map((c) => {
              'id': c.id,
              'user_id': c.userId,
              'start_date': c.startDate.toIso8601String(),
              'end_date': c.endDate?.toIso8601String(),
              'is_synced': c.isSynced,
            })
        .toList();
  }

  Future<void> markAsSynced(String id) async {
    await (_db.update(_db.cycles)..where((t) => t.id.equals(id))).write(
      CyclesCompanion(
        isSynced: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

@riverpod
CycleDao cycleDao(CycleDaoRef ref) {
  return CycleDao(ref.watch(appDatabaseProvider));
}

// ============================================================
// SymptomDao
// ============================================================

class SymptomDao {
  final AppDatabase _db;
  SymptomDao(this._db);

  // -- Symptoms catalog --

  Future<Symptom> createSymptom(Symptom symptom) async {
    await _db.into(_db.symptoms).insert(symptom);
    return symptom;
  }

  Future<Symptom?> getSymptomById(String id) =>
      (_db.select(_db.symptoms)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<Symptom>> getAllSymptoms() =>
      (_db.select(_db.symptoms)..where((t) => t.isActive.equals(true))).get();

  Future<List<Symptom>> getSymptomsByCategory(String category) =>
      (_db.select(_db.symptoms)
            ..where((t) =>
                t.isActive.equals(true) & t.category.equals(category)))
          .get();

  Future<bool> updateSymptom(Symptom symptom) =>
      _db.update(_db.symptoms).replace(symptom);

  Future<int> deleteSymptom(String id) =>
      (_db.delete(_db.symptoms)..where((t) => t.id.equals(id))).go();

  // -- Symptom logs --

  Future<SymptomLog> logSymptom(SymptomLog log) async {
    await _db.into(_db.symptomLogs).insert(log);
    return log;
  }

  Future<List<SymptomLog>> getSymptomLogsByDate(DateTime date) =>
      (_db.select(_db.symptomLogs)..where((t) => t.date.equals(date))).get();

  Future<List<SymptomLog>> getSymptomLogsByDateRange(
    DateTime start,
    DateTime end,
  ) =>
      (_db.select(_db.symptomLogs)
            ..where((t) => t.date.isBetween(Variable(start), Variable(end))))
          .get();

  Future<List<SymptomLog>> getSymptomLogsByCycleDay(String cycleDayId) =>
      (_db.select(_db.symptomLogs)
            ..where((t) => t.cycleDayId.equals(cycleDayId)))
          .get();

  Future<int> deleteSymptomLog(String id) =>
      (_db.delete(_db.symptomLogs)..where((t) => t.id.equals(id))).go();

  Future<List<Map<String, dynamic>>> getSymptomFrequencyAnalysis(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final logs = await (_db.select(_db.symptomLogs)
          ..where((t) => t.date.isBetween(Variable(start), Variable(end))))
        .get();

    final symptomIds = logs.map((l) => l.symptomId).toSet().toList();
    final symptoms = <String, Symptom>{};
    for (final id in symptomIds) {
      final s = await getSymptomById(id);
      if (s != null) symptoms[s.id] = s;
    }

    final counts = <String, int>{};
    for (final log in logs) {
      final name = symptoms[log.symptomId]?.name ?? log.symptomId;
      counts[name] = (counts[name] ?? 0) + 1;
    }

    return counts.entries
        .map((e) => {'name': e.key, 'count': e.value})
        .toList()
      ..sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
  }
}

@riverpod
SymptomDao symptomDao(SymptomDaoRef ref) {
  return SymptomDao(ref.watch(appDatabaseProvider));
}

// ============================================================
// BbtDao
// ============================================================

class BbtDao {
  final AppDatabase _db;
  BbtDao(this._db);

  Future<BbtRecord> createBbtRecord(BbtRecord record) async {
    await _db.into(_db.bbtRecords).insert(record);
    return record;
  }

  Future<BbtRecord?> getBbtRecordById(String id) =>
      (_db.select(_db.bbtRecords)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<BbtRecord>> getBbtRecordsByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) =>
      (_db.select(_db.bbtRecords)
            ..where((t) =>
                t.userId.equals(userId) & t.date.isBetween(Variable(start), Variable(end)))
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  Future<BbtRecord?> getBbtRecordByDate(String userId, DateTime date) =>
      (_db.select(_db.bbtRecords)
            ..where((t) => t.userId.equals(userId) & t.date.equals(date)))
          .getSingleOrNull();

  Future<double?> getTemperatureRangeByCycle(
    String userId,
    DateTime cycleStart,
    DateTime cycleEnd,
  ) async {
    final records = await getBbtRecordsByDateRange(userId, cycleStart, cycleEnd);
    if (records.isEmpty) return null;
    final temps = records.map((r) => r.temperature).toList();
    return temps.reduce((a, b) => a > b ? a : b) -
        temps.reduce((a, b) => a < b ? a : b);
  }

  Future<bool> updateBbtRecord(BbtRecord record) =>
      _db.update(_db.bbtRecords).replace(record);

  Future<int> deleteBbtRecord(String id) =>
      (_db.delete(_db.bbtRecords)..where((t) => t.id.equals(id))).go();

  /// Detects a potential ovulation temperature shift.
  /// Returns the date of the first sustained temperature rise if found.
  Future<DateTime?> detectOvulationTemperatureShift(
    String userId,
    DateTime cycleStart,
    DateTime cycleEnd,
  ) async {
    final records = await getBbtRecordsByDateRange(userId, cycleStart, cycleEnd);
    if (records.length < 9) return null;

    records.sort((a, b) => a.date.compareTo(b.date));

    for (int i = 6; i < records.length - 2; i++) {
      final baseline = records.sublist(i - 6, i);
      final baselineAvg =
          baseline.map((r) => r.temperature).reduce((a, b) => a + b) / 6;

      final shift = records.sublist(i, i + 3);
      final shiftAvg =
          shift.map((r) => r.temperature).reduce((a, b) => a + b) / 3;

      if (shiftAvg > baselineAvg + 0.17) {
        return shift.first.date;
      }
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getUnsyncedRecords() async {
    final records = await (_db.select(_db.bbtRecords)
          ..where((t) => t.isSynced.equals(false)))
        .get();
    return records
        .map((r) => {
              'id': r.id,
              'user_id': r.userId,
              'date': r.date.toIso8601String(),
              'temperature': r.temperature,
              'is_synced': r.isSynced,
            })
        .toList();
  }

  Future<void> markAsSynced(String id) async {
    await (_db.update(_db.bbtRecords)..where((t) => t.id.equals(id))).write(
      BbtRecordsCompanion(isSynced: const Value(true)),
    );
  }
}

@riverpod
BbtDao bbtDao(BbtDaoRef ref) {
  return BbtDao(ref.watch(appDatabaseProvider));
}

// ============================================================
// OvulationTestDao
// ============================================================

class OvulationTestDao {
  final AppDatabase _db;
  OvulationTestDao(this._db);

  Future<OvulationTest> createOvulationTest(OvulationTest test) async {
    await _db.into(_db.ovulationTests).insert(test);
    return test;
  }

  Future<OvulationTest?> getOvulationTestById(String id) =>
      (_db.select(_db.ovulationTests)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<OvulationTest>> getOvulationTestsByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) =>
      (_db.select(_db.ovulationTests)
            ..where((t) =>
                t.userId.equals(userId) & t.date.isBetween(Variable(start), Variable(end)))
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  Future<OvulationTest?> getLatestOvulationTest(String userId) =>
      (_db.select(_db.ovulationTests)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)])
            ..limit(1))
          .getSingleOrNull();

  Future<int> deleteOvulationTest(String id) =>
      (_db.delete(_db.ovulationTests)..where((t) => t.id.equals(id))).go();
}

@riverpod
OvulationTestDao ovulationTestDao(OvulationTestDaoRef ref) {
  return OvulationTestDao(ref.watch(appDatabaseProvider));
}

// ============================================================
// MucusDao
// ============================================================

class MucusDao {
  final AppDatabase _db;
  MucusDao(this._db);

  Future<CervicalMucusObservation> createObservation(
          CervicalMucusObservation observation) async {
    await _db.into(_db.cervicalMucusObservations).insert(observation);
    return observation;
  }

  Future<List<CervicalMucusObservation>> getObservationsByCycleDay(
          String cycleDayId) =>
      (_db.select(_db.cervicalMucusObservations)
            ..where((t) => t.cycleDayId.equals(cycleDayId)))
          .get();

  Future<List<CervicalMucusObservation>> getObservationsByCycleDays(
    List<String> cycleDayIds,
  ) =>
      (_db.select(_db.cervicalMucusObservations)
            ..where((t) => t.cycleDayId.isIn(cycleDayIds)))
          .get();

  Future<int> deleteObservation(String id) =>
      (_db.delete(_db.cervicalMucusObservations)
            ..where((t) => t.id.equals(id)))
          .go();
}

@riverpod
MucusDao mucusDao(MucusDaoRef ref) {
  return MucusDao(ref.watch(appDatabaseProvider));
}

// ============================================================
// PregnancyDao
// ============================================================

class PregnancyDao {
  final AppDatabase _db;
  PregnancyDao(this._db);

  Future<Pregnancy> createPregnancy(Pregnancy pregnancy) async {
    await _db.into(_db.pregnancies).insert(pregnancy);
    return pregnancy;
  }

  Future<Pregnancy?> getPregnancyById(String id) =>
      (_db.select(_db.pregnancies)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<Pregnancy?> getCurrentPregnancy(String userId) =>
      (_db.select(_db.pregnancies)
            ..where((t) => t.userId.equals(userId) & t.isActive.equals(true)))
          .getSingleOrNull();

  Future<List<Pregnancy>> getPregnancyHistory(String userId) =>
      (_db.select(_db.pregnancies)..where((t) => t.userId.equals(userId)))
          .get();

  Future<bool> updatePregnancy(Pregnancy pregnancy) =>
      _db.update(_db.pregnancies).replace(pregnancy);

  Future<int> deletePregnancy(String id) =>
      (_db.delete(_db.pregnancies)..where((t) => t.id.equals(id))).go();

  // -- Fetal measurements --

  Future<FetalMeasurement> addFetalMeasurement(
          FetalMeasurement measurement) async {
    await _db.into(_db.fetalMeasurements).insert(measurement);
    return measurement;
  }

  Future<List<FetalMeasurement>> getFetalMeasurements(String pregnancyId) =>
      (_db.select(_db.fetalMeasurements)
            ..where((t) => t.pregnancyId.equals(pregnancyId))
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  Future<int> deleteFetalMeasurement(String id) =>
      (_db.delete(_db.fetalMeasurements)..where((t) => t.id.equals(id))).go();
}

@riverpod
PregnancyDao pregnancyDao(PregnancyDaoRef ref) {
  return PregnancyDao(ref.watch(appDatabaseProvider));
}

// ============================================================
// JournalDao
// ============================================================

class JournalDao {
  final AppDatabase _db;
  JournalDao(this._db);

  Future<JournalEntry> createEntry(JournalEntry entry) async {
    await _db.into(_db.journalEntries).insert(entry);
    return entry;
  }

  Future<JournalEntry?> getEntryById(String id) =>
      (_db.select(_db.journalEntries)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<JournalEntry>> getEntriesByCycleDay(String cycleDayId) =>
      (_db.select(_db.journalEntries)
            ..where((t) => t.cycleDayId.equals(cycleDayId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<JournalEntry>> getEntriesByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final cycles = await (_db.select(_db.cycles)
          ..where((t) =>
              t.userId.equals(userId) & t.startDate.isBetween(Variable(start), Variable(end))))
        .get();
    final cycleDayIds = <String>[];
    for (final cycle in cycles) {
      final days = await (_db.select(_db.cycleDays)
            ..where((t) => t.cycleId.equals(cycle.id)))
          .get();
      cycleDayIds.addAll(days.map((d) => d.id));
    }

    if (cycleDayIds.isEmpty) return [];

    return (_db.select(_db.journalEntries)
          ..where((t) => t.cycleDayId.isIn(cycleDayIds))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<JournalEntry?> getLatestEntry(String userId) async {
    final cycles = await (_db.select(_db.cycles)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.startDate)])
          ..limit(1))
        .get();
    if (cycles.isEmpty) return null;
    final days = await (_db.select(_db.cycleDays)
          ..where((t) => t.cycleId.equals(cycles.first.id))
          ..limit(1))
        .get();
    if (days.isEmpty) return null;
    return (_db.select(_db.journalEntries)
          ..where((t) => t.cycleDayId.equals(days.first.id))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<bool> updateEntry(JournalEntry entry) =>
      _db.update(_db.journalEntries).replace(entry);

  Future<int> deleteEntry(String id) =>
      (_db.delete(_db.journalEntries)..where((t) => t.id.equals(id))).go();
}

@riverpod
JournalDao journalDao(JournalDaoRef ref) {
  return JournalDao(ref.watch(appDatabaseProvider));
}

// ============================================================
// SettingsDao
// ============================================================

class SettingsDao {
  final AppDatabase _db;
  SettingsDao(this._db);

  Future<AppSetting> setSetting(
      String key, String value, String? userId) async {
    final existing = await getSetting(key, userId: userId);
    if (existing != null) {
      await (_db.update(_db.appSettings)
            ..where((t) => t.id.equals(existing.id)))
          .write(AppSetting(
        id: existing.id,
        userId: userId,
        key: key,
        value: value,
        updatedAt: DateTime.now(),
      ));
      return (await getSetting(key, userId: userId))!;
    }
    await _db.into(_db.appSettings).insert(AppSetting(
          id: key,
          userId: userId,
          key: key,
          value: value,
          updatedAt: DateTime.now(),
        ));
    return (await getSetting(key, userId: userId))!;
  }

  Future<AppSetting?> getSetting(String key, {String? userId}) =>
      (_db.select(_db.appSettings)
            ..where((t) =>
                t.key.equals(key) &
                (userId != null ? t.userId.equals(userId) : t.userId.isNull())))
          .getSingleOrNull();

  Future<List<AppSetting>> getAllSettings({String? userId}) =>
      (_db.select(_db.appSettings)
            ..where((t) => userId != null
                ? t.userId.equals(userId)
                : t.userId.isNull()))
          .get();

  Future<int> deleteSetting(String id) =>
      (_db.delete(_db.appSettings)..where((t) => t.id.equals(id))).go();

  Future<void> setValue(String key, String value) =>
      setSetting(key, value, null);

  Future<String?> getValue(String key) async =>
      (await getSetting(key))?.value;

  Future<void> deleteKey(String key) async {
    final existing = await getSetting(key);
    if (existing != null) {
      await deleteSetting(existing.id);
    }
  }
}

@riverpod
SettingsDao settingsDao(SettingsDaoRef ref) {
  return SettingsDao(ref.watch(appDatabaseProvider));
}

// ============================================================
// ConditionDao
// ============================================================

class ConditionDao {
  final AppDatabase _db;
  ConditionDao(this._db);

  Future<UserCondition> createCondition(UserCondition condition) async {
    await _db.into(_db.userConditions).insert(condition);
    return condition;
  }

  Future<UserCondition?> getConditionById(String id) =>
      (_db.select(_db.userConditions)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<UserCondition>> getActiveConditions(String userId) =>
      (_db.select(_db.userConditions)
            ..where((t) => t.userId.equals(userId) & t.isActive.equals(true)))
          .get();

  Future<List<UserCondition>> getConditionsByType(
          String userId, String conditionType) =>
      (_db.select(_db.userConditions)
            ..where((t) =>
                t.userId.equals(userId) & t.conditionType.equals(conditionType)))
          .get();

  Future<bool> updateCondition(UserCondition condition) =>
      _db.update(_db.userConditions).replace(condition);

  Future<int> deleteCondition(String id) =>
      (_db.delete(_db.userConditions)..where((t) => t.id.equals(id))).go();
}

@riverpod
ConditionDao conditionDao(ConditionDaoRef ref) {
  return ConditionDao(ref.watch(appDatabaseProvider));
}
