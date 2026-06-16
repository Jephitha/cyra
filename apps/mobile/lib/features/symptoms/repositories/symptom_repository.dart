import 'dart:math';

import 'package:cyra/core/database/app_database.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/core/utils/extensions.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:drift/drift.dart';

class SymptomRepository {
  final AppDatabase _db;
  final EncryptionService _encryption;

  SymptomRepository(this._db, this._encryption);

  // ── Symptom catalog ───────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getSymptomCatalog() async {
    final rows = await _db.select(_db.symptoms).get();
    return rows.map((r) => r.toJson()).toList();
  }

  // ── Symptom Entry CRUD ────────────────────────────────────────────

  Future<SymptomEntry> createSymptomEntry(SymptomEntry entry) async {
    final now = DateTime.now();

    await _db.into(_db.symptomLogs).insert(SymptomLogsCompanion.insert(
          id: entry.id,
          date: entry.date,
          symptomId: entry.symptomId,
          severity: entry.severity,
          timestamp: now,
          notes: entry.notes != null
              ? Value(_encryption.encryptString(entry.notes!))
              : Value.absent(),
          createdAt: now,
        ));

    return entry.copyWith(createdAt: now);
  }

  Future<SymptomEntry> updateSymptomEntry(SymptomEntry entry) async {
    final now = DateTime.now();

    await (_db.update(_db.symptomLogs)
          ..where((t) => t.id.equals(entry.id)))
        .write(SymptomLogsCompanion(
          date: Value(entry.date),
          symptomId: Value(entry.symptomId),
          severity: Value(entry.severity),
          notes: entry.notes != null
              ? Value(_encryption.encryptString(entry.notes!))
              : Value.absent(),
        ));

    return entry;
  }

  Future<void> deleteSymptomEntry(String id) async {
    await (_db.delete(_db.symptomLogs)..where((t) => t.id.equals(id))).go();
  }

  Future<SymptomEntry?> getSymptomEntry(String id) async {
    final result = await (_db.select(_db.symptomLogs)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (result == null) return null;
    return _toDomainSymptomEntry(result);
  }

  // ── Query symptoms by date / range ────────────────────────────────

  Future<List<SymptomEntry>> getSymptomsForDate(DateTime date) async {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final results = await (_db.select(_db.symptomLogs)
          ..where((t) => t.date.isBetween(Variable(dayStart), Variable(dayEnd))))
        .get();

    return results.map(_toDomainSymptomEntry).toList();
  }

  Future<List<SymptomEntry>> getSymptomsInRange(
      DateTime start, DateTime end) async {
    final results = await (_db.select(_db.symptomLogs)
          ..where((t) => t.date.isBetween(Variable(start), Variable(end)))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();

    return results.map(_toDomainSymptomEntry).toList();
  }

  Future<List<SymptomEntry>> getSymptomsForCycleDay(String cycleDayId) async {
    final results = await (_db.select(_db.symptomLogs)
          ..where((t) => t.cycleDayId.equals(cycleDayId)))
        .get();

    return results.map(_toDomainSymptomEntry).toList();
  }

  // ── Symptom patterns ──────────────────────────────────────────────

  Future<List<SymptomPattern>> getSymptomPatterns(
      {DateTime? start, DateTime? end}) async {
    final rangeStart = start ?? DateTime.now().subtract(const Duration(days: 90));
    final rangeEnd = end ?? DateTime.now();

    final logs = await (_db.select(_db.symptomLogs)
          ..where((t) => t.date.isBetween(Variable(rangeStart), Variable(rangeEnd))))
        .get();

    final cycleDays = await _db.select(_db.cycleDays).get();

    final grouped = <String, List<SymptomLog>>{};
    for (final log in logs) {
      grouped.putIfAbsent(log.symptomId, () => []).add(log);
    }

    final patterns = <SymptomPattern>[];
    for (final entry in grouped.entries) {
      final logs = entry.value;
      final symptom = await _getSymptomName(entry.key);

      final frequency = logs.length;
      final avgSeverity = logs.fold<int>(0, (a, b) => a + b.severity) / frequency;

      final sortedDays = <int>[];

      String? correlation;

      patterns.add(SymptomPattern(
        symptomId: entry.key,
        symptomName: symptom,
        frequency: frequency,
        averageSeverity: avgSeverity,
        commonCycleDays: sortedDays,
        correlation: correlation,
      ));
    }

    patterns.sort((a, b) => b.frequency.compareTo(a.frequency));
    return patterns;
  }

  Future<List<SymptomEntry>> getCommonSymptomsForCycleDay(int cycleDay) async {
    return [];
  }

  // ── Mood Entry CRUD (stored in symptom_logs with symptomId='mood') ─

  static const String _moodSymptomId = 'mood';

  Future<MoodEntry> createMoodEntry(MoodEntry entry) async {
    final now = DateTime.now();

    await _db.into(_db.symptomLogs).insert(SymptomLogsCompanion.insert(
          id: entry.id,
          date: entry.date,
          symptomId: _moodSymptomId,
          severity: entry.moodRating,
          timestamp: now,
          notes: entry.notes != null
              ? Value(_encryption.encryptString(entry.notes!))
              : Value.absent(),
          createdAt: now,
        ));

    return entry.copyWith(createdAt: now);
  }

  Future<MoodEntry> updateMoodEntry(MoodEntry entry) async {
    await (_db.update(_db.symptomLogs)
          ..where((t) =>
              t.id.equals(entry.id) & t.symptomId.equals(_moodSymptomId)))
        .write(SymptomLogsCompanion(
          severity: Value(entry.moodRating),
          notes: entry.notes != null
              ? Value(_encryption.encryptString(entry.notes!))
              : Value.absent(),
        ));

    return entry;
  }

  Future<void> deleteMoodEntry(String id) async {
    await (_db.delete(_db.symptomLogs)
          ..where(
              (t) => t.id.equals(id) & t.symptomId.equals(_moodSymptomId)))
        .go();
  }

  Future<MoodEntry?> getMoodEntry(String id) async {
    final result = await (_db.select(_db.symptomLogs)
          ..where(
              (t) => t.id.equals(id) & t.symptomId.equals(_moodSymptomId)))
        .getSingleOrNull();
    if (result == null) return null;
    return _toDomainMoodEntry(result);
  }

  Future<MoodEntry?> getMoodForDate(DateTime date) async {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final result = await (_db.select(_db.symptomLogs)
          ..where((t) =>
              t.symptomId.equals(_moodSymptomId) &
              t.date.isBetween(Variable(dayStart), Variable(dayEnd))))
        .getSingleOrNull();
    if (result == null) return null;
    return _toDomainMoodEntry(result);
  }

  Future<List<MoodEntry>> getMoodsInRange(DateTime start, DateTime end) async {
    final results = await (_db.select(_db.symptomLogs)
          ..where((t) =>
              t.symptomId.equals(_moodSymptomId) &
              t.date.isBetween(Variable(start), Variable(end)))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();

    return results.map(_toDomainMoodEntry).toList();
  }

  // ── Correlation analysis ──────────────────────────────────────────

  Future<Map<String, dynamic>> getSymptomCycleCorrelation(
      String symptomId) async {
    final logs = await (_db.select(_db.symptomLogs)
          ..where((t) => t.symptomId.equals(symptomId)))
        .get();

    if (logs.isEmpty) return {'correlation': 0.0, 'insight': null};

    final cycleDays = await _db.select(_db.cycleDays).get();
    final cycleDayMap = <DateTime, int>{};
    for (final d in cycleDays) {
      cycleDayMap[d.date.startOfDay] = d.date.day;
    }

    final paired = <double, double>{};
    for (final log in logs) {
      final dayNum = cycleDayMap[log.date.startOfDay];
      if (dayNum != null) {
        paired[dayNum.toDouble()] = log.severity.toDouble();
      }
    }

    final xVals = paired.keys.toList();
    final yVals = paired.values.toList();

    double r = 0.0;
    if (xVals.length >= 3) {
      r = _pearsonCorrelation(xVals, yVals);
    }

    String? insight;
    if (r.abs() > 0.3) {
      final direction = r > 0 ? 'increase' : 'decrease';
      insight =
          'This symptom tends to $direction in severity as your cycle progresses';
    }

    return {'correlation': r, 'insight': insight};
  }

  Future<Map<String, dynamic>> getMoodCycleCorrelation() async {
    final moods = await (_db.select(_db.symptomLogs)
          ..where((t) => t.symptomId.equals(_moodSymptomId)))
        .get();

    if (moods.isEmpty) return {'correlation': 0.0, 'insight': null};

    final cycleDays = await _db.select(_db.cycleDays).get();
    final cycleDayMap = <DateTime, int>{};
    for (final d in cycleDays) {
      cycleDayMap[d.date.startOfDay] = d.date.day;
    }

    final phaseScores = <int, List<int>>{};
    for (final mood in moods) {
      final dayNum = cycleDayMap[mood.date.startOfDay];
      if (dayNum != null) {
        final phase = _cyclePhaseForDay(dayNum);
        phaseScores.putIfAbsent(phase, () => []).add(mood.severity);
      }
    }

    String? insight;
    if (phaseScores.isNotEmpty) {
      String? lowestPhase;
      double? lowestAvg;
      for (final entry in phaseScores.entries) {
        final avg = entry.value.fold<int>(0, (a, b) => a + b) / entry.value.length;
        if (lowestAvg == null || avg < lowestAvg) {
          lowestAvg = avg;
          lowestPhase = _phaseLabel(entry.key);
        }
      }

      if (lowestPhase != null && lowestAvg != null && lowestAvg < 3.0) {
        insight =
            'Your mood tends to be lower during the $lowestPhase phase';
      }
    }

    return {'correlation': 0.0, 'insight': insight};
  }

  // ── Streak ────────────────────────────────────────────────────────

  Future<List<DateTime>> getDistinctLogDates() async {
    final logs = await _db.select(_db.symptomLogs).get();
    final dates = logs.map((l) => l.date.startOfDay).toSet().toList();
    dates.sort((a, b) => b.compareTo(a));
    return dates;
  }

  Future<int> getSymptomStreak() async {
    final dates = await getDistinctLogDates();
    if (dates.isEmpty) return 0;

    int streak = 1;
    for (int i = 0; i < dates.length - 1; i++) {
      if (dates[i].difference(dates[i + 1]).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  // ── Helpers ───────────────────────────────────────────────────────

  Future<String> _getSymptomName(String symptomId) async {
    if (symptomId == _moodSymptomId) return 'Mood';
    final result = await (_db.select(_db.symptoms)
          ..where((t) => t.id.equals(symptomId)))
        .getSingleOrNull();
    return result?.name ?? symptomId;
  }

  SymptomEntry _toDomainSymptomEntry(SymptomLog entity) {
    return SymptomEntry(
      id: entity.id,
      date: entity.date,
      symptomId: entity.symptomId,
      symptomName: '', // populated externally if needed
      severity: entity.severity,
      notes: entity.notes != null
          ? _encryption.decryptString(entity.notes!)
          : null,
      createdAt: entity.createdAt,
    );
  }

  MoodEntry _toDomainMoodEntry(SymptomLog entity) {
    return MoodEntry(
      id: entity.id,
      date: entity.date,
      moodRating: entity.severity,
      notes: entity.notes != null
          ? _encryption.decryptString(entity.notes!)
          : null,
      createdAt: entity.createdAt,
    );
  }

  double _pearsonCorrelation(List<double> x, List<double> y) {
    final n = x.length;
    final sumX = x.fold<double>(0, (a, b) => a + b);
    final sumY = y.fold<double>(0, (a, b) => a + b);
    final sumXY = _zipWith(x, y, (a, b) => a * b).fold<double>(0, (a, b) => a + b);
    final sumX2 = x.fold<double>(0, (a, b) => a + b * b);
    final sumY2 = y.fold<double>(0, (a, b) => a + b * b);

    final num = n * sumXY - sumX * sumY;
    final den = sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));

    if (den == 0) return 0;
    final r = num / den;
    return r.clamp(-1.0, 1.0);
  }

  List<double> _zipWith(
      List<double> a, List<double> b, double Function(double, double) fn) {
    final len = min(a.length, b.length);
    return List.generate(len, (i) => fn(a[i], b[i]));
  }

  int _cyclePhaseForDay(int dayNum) {
    if (dayNum <= 5) return 0;
    if (dayNum <= 14) return 1;
    if (dayNum <= 17) return 2;
    return 3;
  }

  String _phaseLabel(int phase) {
    switch (phase) {
      case 0:
        return 'menstrual';
      case 1:
        return 'follicular';
      case 2:
        return 'ovulatory';
      case 3:
        return 'luteal';
      default:
        return 'menstrual';
    }
  }

  String _buildDayRanges(List<int> days) {
    if (days.isEmpty) return '';
    if (days.length == 1) return days.first.toString();

    final ranges = <String>[];
    int start = days.first;
    int prev = start;

    for (int i = 1; i < days.length; i++) {
      if (days[i] == prev + 1) {
        prev = days[i];
      } else {
        ranges.add(start == prev ? '$start' : '$start-$prev');
        start = days[i];
        prev = start;
      }
    }
    ranges.add(start == prev ? '$start' : '$start-$prev');

    return ranges.join(', ');
  }
}
