import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/conditions/data/condition_data.dart';
import 'package:cyra/features/conditions/models/condition_models.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:drift/drift.dart';

class ConditionRepository {
  final db.AppDatabase _db;
  final EncryptionService _encryption;

  ConditionRepository(this._db, this._encryption);

  Future<UserCondition> createCondition(UserCondition condition) async {
    final now = DateTime.now();

    await _db.into(_db.userConditions).insert(db.UserConditionsCompanion.insert(
      id: condition.id,
      userId: '',
      conditionType: condition.conditionType,
      diagnosisDate: Value(condition.diagnosisDate),
      isActive: Value(condition.isActive),
      notes: condition.notes != null
          ? Value(_encryption.encryptString(condition.notes!))
          : Value.absent(),
      createdAt: now,
      updatedAt: now,
    ));

    return condition.copyWith(createdAt: now, updatedAt: now);
  }

  Future<UserCondition> updateCondition(UserCondition condition) async {
    final now = DateTime.now();

    await (_db.update(_db.userConditions)
          ..where((t) => t.id.equals(condition.id)))
        .write(db.UserConditionsCompanion(
      conditionType: Value(condition.conditionType),
      diagnosisDate: Value(condition.diagnosisDate),
      isActive: Value(condition.isActive),
      notes: condition.notes != null
          ? Value(_encryption.encryptString(condition.notes!))
          : Value.absent(),
      updatedAt: Value(now),
    ));

    return condition.copyWith(updatedAt: now);
  }

  Future<void> deleteCondition(String id) async {
    await (_db.delete(_db.userConditions)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<UserCondition?> getCondition(String id) async {
    final result = await (_db.select(_db.userConditions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (result == null) return null;
    return _toDomain(result);
  }

  Future<List<UserCondition>> getAllConditions() async {
    final results = await _db.select(_db.userConditions).get();
    return results.map(_toDomain).toList();
  }

  Future<List<UserCondition>> getActiveConditions() async {
    final results = await (_db.select(_db.userConditions)
          ..where((t) => t.isActive.equals(true)))
        .get();
    return results.map(_toDomain).toList();
  }

  Future<UserCondition> toggleCondition(String id, bool isActive) async {
    final now = DateTime.now();

    await (_db.update(_db.userConditions)
          ..where((t) => t.id.equals(id)))
        .write(db.UserConditionsCompanion(
      isActive: Value(isActive),
      updatedAt: Value(now),
    ));

    final updated = await getCondition(id);
    return updated!;
  }

  List<String> getTrackingRecommendations(String conditionType) {
    final info = ConditionData.conditions[conditionType];
    return info?.trackingRecommendations ?? [];
  }

  Future<Map<String, dynamic>> detectPatterns(String conditionType) async {
    final now = DateTime.now();
    final ninetyDaysAgo = now.subtract(const Duration(days: 90));

    final logs = await (_db.select(_db.symptomLogs)
          ..where((t) => t.date.isBetween(Variable(ninetyDaysAgo), Variable(now))))
        .get();

    final cycleDays = await _db.select(_db.cycleDays).get();
    final cycleDayMap = <DateTime, int>{};
    for (final d in cycleDays) {
      cycleDayMap[d.date.startOfDay] = d.date.day;
    }

    switch (conditionType) {
      case 'pcos':
        return _detectPcosPatterns(logs, cycleDayMap);
      case 'endometriosis':
        return _detectEndometriosisPatterns(logs, cycleDayMap);
      case 'pmdd':
        return _detectPmddPatterns(logs, cycleDayMap);
      case 'adenomyosis':
        return _detectAdenomyosisPatterns(logs);
      case 'fibroids':
        return _detectFibroidPatterns(logs);
      case 'thyroid':
        return _detectThyroidPatterns(logs);
      default:
        return {'patterns': <String>[], 'insights': <String>[]};
    }
  }

  Map<String, dynamic> _detectPcosPatterns(
    List<db.SymptomLog> logs,
    Map<DateTime, int> cycleDayMap,
  ) {
    final insights = <String>[];

    final cycleLogs = _filterBySymptomIds(logs, ['irregular_periods', 'missed_period']);
    if (cycleLogs.length >= 3) {
      insights.add('You\'ve logged irregular or missed periods ${
          cycleLogs.length} times in the last 90 days. Consider tracking cycle regularity.');
    }

    final weightLogs = _filterBySymptomIds(logs, ['weight_gain']);
    if (weightLogs.isNotEmpty) {
      insights.add('Weight changes have been logged. Maintaining a healthy weight can help manage PCOS symptoms.');
    }

    final acneLogs = _filterBySymptomIds(logs, ['acne']);
    if (acneLogs.isNotEmpty) {
      insights.add('Acne has been logged ${acneLogs.length} times. Hormonal acne is common with PCOS.');
    }

    return {
      'condition': 'pcos',
      'insights': insights,
      'hasData': insights.isNotEmpty,
    };
  }

  Map<String, dynamic> _detectEndometriosisPatterns(
    List<db.SymptomLog> logs,
    Map<DateTime, int> cycleDayMap,
  ) {
    final insights = <String>[];

    final painLogs = _filterBySymptomIds(logs, ['cramps', 'pelvic_pain', 'back_pain']);
    if (painLogs.length >= 5) {
      final avgSeverity = painLogs.fold<int>(0, (a, b) => a + b.severity) / painLogs.length;
      insights.add('You\'ve logged pain ${
          painLogs.length} times with an average severity of ${avgSeverity.toStringAsFixed(1)}/10.');

      final severeDays = painLogs.where((l) => l.severity >= 7).length;
      if (severeDays > 0) {
        insights.add('$severeDays episodes of severe pain (7+) were recorded. Discuss pain management with your provider.');
      }
    }

    final severeCramps = _filterBySymptomIds(logs, ['cramps']).where((l) => l.severity >= 5).length;
    if (severeCramps >= 3) {
      insights.add('Severe cramping has been reported $severeCramps times. This aligns with common endometriosis symptoms.');
    }

    return {
      'condition': 'endometriosis',
      'insights': insights,
      'hasData': insights.isNotEmpty,
    };
  }

  Map<String, dynamic> _detectPmddPatterns(
    List<db.SymptomLog> logs,
    Map<DateTime, int> cycleDayMap,
  ) {
    final insights = <String>[];

    final moodLogs = logs.where((l) =>
        l.symptomId == 'mood' || l.symptomId == 'mood_swings' || l.symptomId == 'irritability').toList();
    if (moodLogs.length >= 5) {
      final lutealMoods = moodLogs.where((l) {
        final dayNum = cycleDayMap[l.date.startOfDay];
        return dayNum != null && dayNum >= 21;
      }).length;

      if (lutealMoods > 0) {
        insights.add('$lutealMoods mood entries occurred during the luteal phase, consistent with PMDD patterns.');
      }
    }

    final fatigueLogs = _filterBySymptomIds(logs, ['fatigue']);
    if (fatigueLogs.length >= 3) {
      insights.add('Fatigue has been logged ${fatigueLogs.length} times. Energy tracking can help identify cyclical patterns.');
    }

    return {
      'condition': 'pmdd',
      'insights': insights,
      'hasData': insights.isNotEmpty,
    };
  }

  Map<String, dynamic> _detectAdenomyosisPatterns(List<db.SymptomLog> logs) {
    final insights = <String>[];

    final heavyBleeding = _filterBySymptomIds(logs, ['heavy_bleeding']);
    if (heavyBleeding.isNotEmpty) {
      insights.add('Heavy bleeding has been reported ${heavyBleeding.length} times.');
    }

    final painLogs = _filterBySymptomIds(logs, ['cramps', 'pelvic_pain']);
    if (painLogs.length >= 4) {
      insights.add('Pelvic pain or cramping was logged ${painLogs.length} times. Consistent tracking helps your provider assess your condition.');
    }

    return {
      'condition': 'adenomyosis',
      'insights': insights,
      'hasData': insights.isNotEmpty,
    };
  }

  Map<String, dynamic> _detectFibroidPatterns(List<db.SymptomLog> logs) {
    final insights = <String>[];

    final heavyBleeding = _filterBySymptomIds(logs, ['heavy_bleeding']);
    if (heavyBleeding.length >= 3) {
      insights.add('Heavy bleeding has been logged ${
          heavyBleeding.length} times. Tracking flow intensity helps monitor fibroid symptoms.');
    }

    final pressureLogs = _filterBySymptomIds(logs, ['pelvic_pressure', 'bloating']);
    if (pressureLogs.isNotEmpty) {
      insights.add('Pelvic pressure or bloating reported ${pressureLogs.length} times.');
    }

    return {
      'condition': 'fibroids',
      'insights': insights,
      'hasData': insights.isNotEmpty,
    };
  }

  Map<String, dynamic> _detectThyroidPatterns(List<db.SymptomLog> logs) {
    final insights = <String>[];

    final fatigueLogs = _filterBySymptomIds(logs, ['fatigue']);
    if (fatigueLogs.length >= 4) {
      insights.add('Fatigue was logged ${fatigueLogs.length} times. Persistent fatigue may be related to thyroid function.');
    }

    final weightLogs = _filterBySymptomIds(logs, ['weight_gain', 'weight_loss']);
    if (weightLogs.isNotEmpty) {
      insights.add('Weight changes have been noted. Thyroid disorders commonly affect metabolism.');
    }

    final moodLogs = _filterBySymptomIds(logs, ['mood_swings', 'anxiety']);
    if (moodLogs.isNotEmpty) {
      insights.add('Mood changes were logged ${moodLogs.length} times. Both hypothyroidism and hyperthyroidism can affect mood.');
    }

    return {
      'condition': 'thyroid',
      'insights': insights,
      'hasData': insights.isNotEmpty,
    };
  }

  List<db.SymptomLog> _filterBySymptomIds(List<db.SymptomLog> logs, List<String> ids) {
    return logs.where((l) => ids.contains(l.symptomId)).toList();
  }

  Future<List<SymptomEntry>> getConditionSymptomsInRange(
    List<String> trackedSymptomIds,
    DateTime start,
    DateTime end,
  ) async {
    if (trackedSymptomIds.isEmpty) return [];

    final results = await (_db.select(_db.symptomLogs)
          ..where((t) =>
              t.symptomId.isIn(trackedSymptomIds) &
              t.date.isBetween(Variable(start), Variable(end)))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();

    return results.map((r) => SymptomEntry(
      id: r.id,
      date: r.date,
      symptomId: r.symptomId,
      symptomName: '',
      severity: r.severity,
      notes: r.notes != null ? _encryption.decryptString(r.notes!) : null,
      createdAt: r.createdAt,
    )).toList();
  }

  Future<Map<String, int>> getSymptomFrequency(
    List<String> symptomIds,
    DateTime start,
    DateTime end,
  ) async {
    if (symptomIds.isEmpty) return {};

    final results = await (_db.select(_db.symptomLogs)
          ..where((t) =>
              t.symptomId.isIn(symptomIds) &
              t.date.isBetween(Variable(start), Variable(end))))
        .get();

    final frequency = <String, int>{};
    for (final r in results) {
      frequency.update(r.symptomId, (v) => v + 1, ifAbsent: () => 1);
    }

    return frequency;
  }

  UserCondition _toDomain(db.UserCondition row) {
    return UserCondition(
      id: row.id,
      conditionType: row.conditionType,
      diagnosisDate: row.diagnosisDate,
      isActive: row.isActive,
      notes: row.notes != null ? _encryption.decryptString(row.notes!) : null,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
