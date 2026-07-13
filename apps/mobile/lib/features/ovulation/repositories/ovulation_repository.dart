import 'package:drift/drift.dart';

import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/core/prediction/ovulation_detector.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/models/opk_test_record.dart';
import 'package:cyra/features/ovulation/models/mucus_observation.dart';

class OvulationRepository {
  final db.AppDatabase _db;
  final OvulationDetector _detector;

  OvulationRepository(this._db) : _detector = OvulationDetector();

  // ── BBT Records ───────────────────────────────────────────────

  Future<void> saveBBT(BBTRecord record) async {
    final existing = await getBBT(record.date);
    final now = DateTime.now();

    if (existing != null) {
      await (_db.update(
        _db.bbtRecords,
      )..where((t) => t.id.equals(existing.id))).write(
        db.BbtRecordsCompanion(
          temperature: Value(record.temperature),
          measurementMethod: Value(record.method.name),
          timeOfDay: Value(record.timeOfDay ?? existing.timeOfDay ?? ''),
          isEstimated: Value(record.isEstimated),
          notes: Value(record.notes),
        ),
      );
      return;
    }

    await _db
        .into(_db.bbtRecords)
        .insert(
          db.BbtRecordsCompanion.insert(
            id: record.id,
            userId: '',
            date: record.date,
            temperature: record.temperature,
            measurementMethod: record.method.name,
            timeOfDay: record.timeOfDay ?? '',
            isEstimated: Value(record.isEstimated),
            notes: Value(record.notes),
            createdAt: now,
          ),
        );
  }

  Future<BBTRecord?> getBBT(DateTime date) async {
    final result = await (_db.select(
      _db.bbtRecords,
    )..where((t) => t.date.equals(date))).getSingleOrNull();
    if (result == null) return null;
    return _toDomainBBT(result);
  }

  Future<List<BBTRecord>> getBBTRange(DateTime start, DateTime end) async {
    final results =
        await (_db.select(_db.bbtRecords)
              ..where((t) => t.date.isBetween(Variable(start), Variable(end)))
              ..orderBy([(t) => OrderingTerm.asc(t.date)]))
            .get();
    return results.map(_toDomainBBT).toList();
  }

  Future<List<BBTRecord>> getBBTForCycle(String cycleId) async {
    final cycle = await (_db.select(
      _db.cycles,
    )..where((t) => t.id.equals(cycleId))).getSingleOrNull();
    if (cycle == null) return [];

    final end = cycle.endDate ?? DateTime.now();
    return getBBTRange(cycle.startDate, end);
  }

  Future<bool> hasBBTData(String cycleId) async {
    final cycle = await (_db.select(
      _db.cycles,
    )..where((t) => t.id.equals(cycleId))).getSingleOrNull();
    if (cycle == null) return false;

    final count =
        await (_db.select(_db.bbtRecords)..where(
              (t) => t.date.isBetween(
                Variable(cycle.startDate),
                Variable(cycle.endDate ?? DateTime.now()),
              ),
            ))
            .get();
    return count.isNotEmpty;
  }

  // ── OPK Tests ─────────────────────────────────────────────────

  Future<void> saveOPK(OPKTestResult result) async {
    final existing = await getOPK(result.date);
    final now = DateTime.now();

    if (existing != null) {
      await (_db.update(
        _db.ovulationTests,
      )..where((t) => t.id.equals(existing.id))).write(
        db.OvulationTestsCompanion(
          result: Value(result.result.name),
          timeOfDay: Value(result.timeOfDay ?? existing.timeOfDay ?? ''),
          brand: Value(result.brand),
          photoPath: Value(result.photoPath),
        ),
      );
      return;
    }

    await _db
        .into(_db.ovulationTests)
        .insert(
          db.OvulationTestsCompanion.insert(
            id: result.id,
            userId: '',
            date: result.date,
            result: result.result.name,
            timeOfDay: result.timeOfDay ?? '',
            brand: Value(result.brand),
            photoPath: Value(result.photoPath),
            createdAt: now,
          ),
        );
  }

  Future<OPKTestResult?> getOPK(DateTime date) async {
    final result = await (_db.select(
      _db.ovulationTests,
    )..where((t) => t.date.equals(date))).getSingleOrNull();
    if (result == null) return null;
    return _toDomainOPK(result);
  }

  Future<List<OPKTestResult>> getOPKRange(DateTime start, DateTime end) async {
    final results =
        await (_db.select(_db.ovulationTests)
              ..where((t) => t.date.isBetween(Variable(start), Variable(end)))
              ..orderBy([(t) => OrderingTerm.asc(t.date)]))
            .get();
    return results.map(_toDomainOPK).toList();
  }

  Future<OPKTestResult?> getLatestOPK() async {
    final result =
        await (_db.select(_db.ovulationTests)
              ..orderBy([(t) => OrderingTerm.desc(t.date)])
              ..limit(1))
            .getSingleOrNull();
    if (result == null) return null;
    return _toDomainOPK(result);
  }

  // ── Cervical Mucus ────────────────────────────────────────────

  Future<void> saveMucus(MucusObservation observation) async {
    final existing = await getMucus(observation.date);

    if (existing != null) {
      await (_db.update(
        _db.cervicalMucusObservations,
      )..where((t) => t.id.equals(existing.id))).write(
        db.CervicalMucusObservationsCompanion(
          type: Value(observation.type.name),
          consistency: Value(observation.consistency),
          color: Value(observation.color),
          amount: Value(observation.amount ?? ''),
          createdAt: Value(observation.date),
        ),
      );
      return;
    }

    await _db
        .into(_db.cervicalMucusObservations)
        .insert(
          db.CervicalMucusObservationsCompanion.insert(
            id: observation.id,
            cycleDayId: '',
            type: observation.type.name,
            consistency: Value(observation.consistency),
            color: Value(observation.color),
            amount: observation.amount ?? '',
            // The schema predates a dedicated observation-date column, so
            // createdAt is the persisted domain date for mucus records.
            createdAt: observation.date,
          ),
        );
  }

  Future<MucusObservation?> getMucus(DateTime date) async {
    final results =
        await (_db.select(_db.cervicalMucusObservations)..where(
              (t) => t.createdAt.isBetween(
                Variable(date.subtract(const Duration(days: 1))),
                Variable(date.add(const Duration(days: 1))),
              ),
            ))
            .get();
    if (results.isEmpty) return null;
    return _toDomainMucus(results.first);
  }

  Future<List<MucusObservation>> getMucusRange(
    DateTime start,
    DateTime end,
  ) async {
    final allInRange = await _getAllMucusInRange(start, end);
    return allInRange.map(_toDomainMucus).toList();
  }

  // ── Analysis ──────────────────────────────────────────────────

  Future<OvulationResult> detectOvulation({
    required List<Cycle> cycles,
    required List<BBTRecord> bbtRecords,
    required List<OPKTestResult> opkResults,
    required List<MucusObservation> mucusObservations,
  }) async {
    return _detector.detectCombined(bbtRecords, opkResults, mucusObservations);
  }

  Future<FertileWindow> calculateFertileWindow({
    required DateTime lastPeriodStart,
    int? cycleLength,
    List<BBTRecord>? bbtRecords,
    List<OPKTestResult>? opkResults,
    List<MucusObservation>? mucusObservations,
  }) async {
    final length = cycleLength ?? 28;
    final (fertileStart, fertileEnd) = _detector.calculateFertileWindow(
      periodStart: lastPeriodStart,
      cycleLength: length,
    );

    final now = DateTime.now();
    final isInWindow =
        now.isAfter(fertileStart) &&
        now.isBefore(fertileEnd.add(const Duration(days: 1)));

    final ovulationDate = fertileEnd;
    late final double ovulationProbability;

    if (bbtRecords != null || opkResults != null || mucusObservations != null) {
      final bbt = bbtRecords ?? [];
      final opk = opkResults ?? [];
      final mucus = mucusObservations ?? [];
      final result = _detector.detectCombined(bbt, opk, mucus);
      ovulationProbability = result.confidence;
    } else {
      ovulationProbability = 0.0;
    }

    int? currentDayOfWindow;
    if (isInWindow) {
      final daysSince = now.difference(fertileStart).inDays;
      final windowLength = fertileEnd.difference(fertileStart).inDays;
      currentDayOfWindow = daysSince.clamp(0, windowLength);
    }

    final explanation = StringBuffer();
    if (isInWindow) {
      explanation.write(
        'You are in your fertile window. '
        'Ovulation is estimated around ${_formatDate(fertileEnd)}.',
      );
    } else if (now.isBefore(fertileStart)) {
      final daysUntil = fertileStart.difference(now).inDays;
      explanation.write(
        'Your fertile window starts in $daysUntil day${daysUntil == 1 ? "" : "s"} '
        '(${_formatDate(fertileStart)}).',
      );
    } else {
      explanation.write(
        'Your fertile window ended on ${_formatDate(fertileEnd)}.',
      );
    }

    return FertileWindow(
      windowStart: fertileStart,
      windowEnd: fertileEnd,
      ovulationDate: ovulationDate,
      ovulationProbability: ovulationProbability,
      isInWindow: isInWindow,
      currentDayOfWindow: currentDayOfWindow,
      explanation: explanation.toString(),
    );
  }

  Future<ConceptionLikelihood> calculateConceptionLikelihood({
    required int cycleDay,
    required int cycleLength,
    bool? ovulationConfirmed,
    DateTime? lastIntercourseDate,
  }) async {
    final probabilities = _detector.dailyConceptionProbability(cycleLength);
    final likelihood = probabilities[cycleDay] ?? 0.0;

    final recommendations = <String>[];
    if (ovulationConfirmed == true) {
      recommendations.add(
        'Ovulation has been confirmed for this cycle. '
        'Track next fertile window for optimized timing.',
      );
      return ConceptionLikelihood(
        likelihood: likelihood,
        explanation:
            'Ovulation confirmed. Conception probability for today is '
            '${(likelihood * 100).round()}%.',
        recommendations: recommendations,
      );
    }

    final ovulationDay = cycleLength - 14;
    final daysUntilOvulation = ovulationDay - cycleDay;

    if (likelihood > 0) {
      if (likelihood >= 0.3) {
        recommendations.add(
          'Peak fertility — consider intercourse today for '
          'maximum conception probability.',
        );
        recommendations.add(
          'Continue tracking LH surge and cervical mucus '
          'to confirm ovulation.',
        );
      } else if (likelihood >= 0.15) {
        recommendations.add(
          'High fertility — intercourse every 1-2 days is recommended '
          'during this window.',
        );
      } else {
        recommendations.add(
          'Fertile window approaching — consider preparing '
          'for optimal timing.',
        );
      }
    }

    if (lastIntercourseDate != null) {
      final daysSince = DateTime.now().difference(lastIntercourseDate).inDays;
      if (daysSince > 2 && likelihood > 0) {
        recommendations.add(
          'Last intercourse was $daysSince day${daysSince == 1 ? "" : "s"} ago. '
          'For TTC, aim for intercourse every 1-2 days during the fertile window.',
        );
      }
    }

    if (daysUntilOvulation > 0 && daysUntilOvulation <= 5 && likelihood == 0) {
      recommendations.add(
        'Your fertile window begins in $daysUntilOvulation day${daysUntilOvulation == 1 ? "" : "s"}. '
        'Prepare to track BBT, OPK, and cervical mucus.',
      );
    }

    return ConceptionLikelihood(
      likelihood: likelihood,
      explanation:
          'Cycle day $cycleDay of $cycleLength. '
          'Daily conception probability: ${(likelihood * 100).round()}%. '
          'Ovulation predicted around day $ovulationDay.',
      recommendations: recommendations,
    );
  }

  // ── Mapping helpers ───────────────────────────────────────────

  BBTRecord _toDomainBBT(db.BbtRecord entity) {
    return BBTRecord(
      id: entity.id,
      date: entity.date,
      temperature: entity.temperature,
      method: BBTMeasurementMethod.values.firstWhere(
        (m) => m.name == entity.measurementMethod,
        orElse: () => BBTMeasurementMethod.oral,
      ),
      timeOfDay: entity.timeOfDay.isNotEmpty ? entity.timeOfDay : null,
      isEstimated: entity.isEstimated,
      notes: entity.notes,
    );
  }

  OPKTestResult _toDomainOPK(db.OvulationTest entity) {
    return OPKTestResult(
      id: entity.id,
      date: entity.date,
      result: OPKResult.values.firstWhere(
        (r) => r.name == entity.result,
        orElse: () => OPKResult.negative,
      ),
      timeOfDay: entity.timeOfDay.isNotEmpty ? entity.timeOfDay : null,
      brand: entity.brand,
      photoPath: entity.photoPath,
    );
  }

  MucusObservation _toDomainMucus(db.CervicalMucusObservation entity) {
    return MucusObservation(
      id: entity.id,
      date: entity.createdAt,
      type: CervicalMucusType.values.firstWhere(
        (t) => t.name == entity.type,
        orElse: () => CervicalMucusType.dry,
      ),
      consistency: entity.consistency,
      color: entity.color,
      amount: entity.amount.isNotEmpty ? entity.amount : null,
    );
  }

  Future<List<db.CervicalMucusObservation>> _getAllMucusInRange(
    DateTime start,
    DateTime end,
  ) async {
    return (_db.select(_db.cervicalMucusObservations)
          ..where((t) => t.createdAt.isBetween(Variable(start), Variable(end))))
        .get();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
