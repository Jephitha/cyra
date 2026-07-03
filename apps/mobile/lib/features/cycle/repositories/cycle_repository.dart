import 'dart:math';

import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/core/prediction/cycle_predictor.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:drift/drift.dart';

class CycleRepository {
  final db.AppDatabase _db;
  final EncryptionService _encryption;

  CycleRepository(this._db, this._encryption);

  // ── CRUD ──────────────────────────────────────────────────────

  Future<Cycle> createCycle(Cycle cycle) async {
    final id = cycle.id;
    final now = DateTime.now();

    await _db.into(_db.cycles).insert(db.CyclesCompanion.insert(
      id: id,
      userId: '',
      startDate: cycle.startDate,
      endDate: Value(cycle.endDate),
      cycleLength: Value(cycle.cycleLength),
      periodLength: Value(cycle.periodLength),
      notes: cycle.notes != null
          ? Value(_encryption.encryptString(cycle.notes!))
          : Value.absent(),
      createdAt: now,
      updatedAt: now,
    ));

    return cycle.copyWith(createdAt: now, updatedAt: now);
  }

  Future<Cycle> updateCycle(Cycle cycle) async {
    final now = DateTime.now();

    await (_db.update(_db.cycles)..where((t) => t.id.equals(cycle.id)))
        .write(db.CyclesCompanion(
      startDate: Value(cycle.startDate),
      endDate: Value(cycle.endDate),
      cycleLength: Value(cycle.cycleLength),
      periodLength: Value(cycle.periodLength),
      notes: cycle.notes != null
          ? Value(_encryption.encryptString(cycle.notes!))
          : Value.absent(),
      updatedAt: Value(now),
    ));

    return cycle.copyWith(updatedAt: now);
  }

  Future<void> deleteCycle(String id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.cycleDays)
            ..where((t) => t.cycleId.equals(id)))
          .go();
      await (_db.delete(_db.cycles)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<Cycle?> getCycle(String id) async {
    final result = await (_db.select(_db.cycles)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (result == null) return null;
    return _toDomainCycle(result);
  }

  // ── Queries ───────────────────────────────────────────────────

  Future<List<Cycle>> getAllCycles({int limit = 12}) async {
    final results = await (_db.select(_db.cycles)
          ..orderBy([
            (t) => OrderingTerm.desc(t.startDate)
          ])
          ..limit(limit))
        .get();
    return results.map(_toDomainCycle).toList();
  }

  Future<Cycle?> getLatestCycle() async {
    final result = await (_db.select(_db.cycles)
          ..orderBy([
            (t) => OrderingTerm.desc(t.startDate)
          ])
          ..limit(1))
        .getSingleOrNull();
    if (result == null) return null;
    return _toDomainCycle(result);
  }

  Future<Cycle?> getActiveCycle() async {
    final result = await (_db.select(_db.cycles)
          ..where((t) => t.endDate.isNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.startDate)
          ])
          ..limit(1))
        .getSingleOrNull();
    if (result == null) return null;
    return _toDomainCycle(result);
  }

  Future<CycleSummary> getCycleSummary() async {
    final cycles = await (_db.select(_db.cycles)
          ..where((t) => t.endDate.isNotNull())
          ..orderBy([
            (t) => OrderingTerm.desc(t.startDate)
          ]))
        .get();

    if (cycles.isEmpty) {
      return const CycleSummary(
        cycleCount: 0,
        averageLength: 0,
        minLength: 0,
        maxLength: 0,
        variabilityScore: 0,
        averagePeriodLength: 0,
        lastPeriodStart: null,
        nextPredictedPeriodStart: null,
      );
    }

    final lengths = cycles.map((c) => c.cycleLength ?? 28).toList();
    final periodLengths = cycles.map((c) => c.periodLength ?? 5).toList();

    final mean = lengths.fold<int>(0, (a, b) => a + b) / lengths.length;
    final variance =
        lengths.fold<double>(0, (a, b) => a + pow(b - mean, 2)) / lengths.length;
    final variability = sqrt(variance) / mean;

    final domainCycles = cycles.map(_toDomainCycle).toList();
    final predictor = CyclePredictor();
    final prediction = predictor.predictNextPeriod(cycleHistory: domainCycles);

    return CycleSummary(
      cycleCount: cycles.length,
      averageLength: mean,
      minLength: lengths.reduce(min),
      maxLength: lengths.reduce(max),
      variabilityScore: variability,
      averagePeriodLength:
          periodLengths.fold<int>(0, (a, b) => a + b) / periodLengths.length,
      lastPeriodStart: cycles.first.startDate,
      nextPredictedPeriodStart: prediction.predictedDate,
    );
  }

  Future<List<Cycle>> getCyclesInRange(DateTime start, DateTime end) async {
    final results = await (_db.select(_db.cycles)
          ..where((t) => t.startDate.isBetween(Variable(start), Variable(end)))
          ..orderBy([
            (t) => OrderingTerm.desc(t.startDate)
          ]))
        .get();
    return results.map(_toDomainCycle).toList();
  }

  // ── Cycle days ────────────────────────────────────────────────

  Future<CycleDay> saveCycleDay(CycleDay day) async {
    final now = DateTime.now();
    final existing = await getCycleDayForCycle(day.cycleId, day.date);

    if (existing != null) {
      await (_db.update(_db.cycleDays)
            ..where((t) => t.cycleId.equals(day.cycleId) & t.date.equals(day.date)))
          .write(db.CycleDaysCompanion(
        flowIntensity: day.flowIntensity > 0
            ? Value(day.flowIntensity)
            : Value.absent(),
        spotting: Value(day.spotting),
        clotting: Value(day.clotting),
        symptomsJson: Value(day.symptomsJson),
        temperature: Value(day.temperature),
        cervicalMucus: Value(day.cervicalMucus),
        cervicalPosition: Value(day.cervicalPosition),
        opkResult: Value(day.opkResult),
        notes: day.notes != null
            ? Value(_encryption.encryptString(day.notes!))
            : Value.absent(),
        updatedAt: Value(now),
      ));
      return day;
    }

    await _db.into(_db.cycleDays).insert(db.CycleDaysCompanion.insert(
      id: day.id,
      cycleId: day.cycleId,
      date: day.date,
      flowIntensity: day.flowIntensity > 0
          ? Value(day.flowIntensity)
          : Value.absent(),
      spotting: Value(day.spotting),
      clotting: Value(day.clotting),
      symptomsJson: Value(day.symptomsJson),
      temperature: Value(day.temperature),
      cervicalMucus: Value(day.cervicalMucus),
      cervicalPosition: Value(day.cervicalPosition),
      opkResult: Value(day.opkResult),
      notes: day.notes != null
          ? Value(_encryption.encryptString(day.notes!))
          : Value.absent(),
      createdAt: now,
      updatedAt: now,
    ));

    return day;
  }

  Future<CycleDay?> getCycleDayForCycle(String cycleId, DateTime date) async {
    final result = await (_db.select(_db.cycleDays)
          ..where((t) => t.cycleId.equals(cycleId) & t.date.equals(date)))
        .getSingleOrNull();
    if (result == null) return null;
    return _toDomainCycleDay(result);
  }

  Future<CycleDay?> getCycleDay(DateTime date) async {
    final results = await (_db.select(_db.cycleDays)
          ..where((t) => t.date.equals(date))
          ..limit(1))
        .get();
    if (results.isEmpty) return null;
    return _toDomainCycleDay(results.first);
  }

  Future<List<CycleDay>> getCycleDays(String cycleId) async {
    final results = await (_db.select(_db.cycleDays)
          ..where((t) => t.cycleId.equals(cycleId))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
    return results.map(_toDomainCycleDay).toList();
  }

  Future<void> deleteCycleDay(String id) async {
    await (_db.delete(_db.cycleDays)..where((t) => t.id.equals(id))).go();
  }

  // ── Analysis ──────────────────────────────────────────────────

  Future<PredictionResult> predictNextPeriod() async {
    final history = await getAllCycles(limit: 12);
    final predictor = CyclePredictor();
    return predictor.predictNextPeriod(cycleHistory: history);
  }

  // ── Flow logging shortcuts ────────────────────────────────────

  Future<void> logPeriodStart(DateTime date, {int? flowIntensity}) async {
    final active = await getActiveCycle();

    if (active != null) {
      // If the date is within a reasonable window of the active cycle's start,
      // treat it as part of the same cycle.
      final daysSinceCycleStart = date.difference(active.startDate).inDays;
      if (daysSinceCycleStart >= 0 && daysSinceCycleStart <= 10) {
        final cycleDays = await getCycleDays(active.id);
        final hasFlow = cycleDays.any((d) => d.flowIntensity > 0 || d.spotting);
        if (!hasFlow) {
          final dayId = '${active.id}_${date.toIso8601String()}';
          await saveCycleDay(CycleDay(
            id: dayId,
            cycleId: active.id,
            date: date,
            flowIntensity: flowIntensity ?? 1,
          ));
        }
        return;
      }
      // Date is too far from the active cycle: close the old one and start fresh.
      await logPeriodEnd(date);
    }

    final newId = DateTime.now().microsecondsSinceEpoch.toString();
    final now = DateTime.now();

    await _db.into(_db.cycles).insert(db.CyclesCompanion.insert(
      id: newId,
      userId: '',
      startDate: date,
      createdAt: now,
      updatedAt: now,
    ));

    if (flowIntensity != null && flowIntensity > 0) {
      final dayId = '${newId}_${date.toIso8601String()}';
      await _db.into(_db.cycleDays).insert(db.CycleDaysCompanion.insert(
        id: dayId,
        cycleId: newId,
        date: date,
        flowIntensity: Value(flowIntensity),
        createdAt: now,
        updatedAt: now,
      ));
    }
  }

  Future<void> logPeriodEnd(DateTime date) async {
    final active = await getActiveCycle();
    if (active == null) return;

    final days = await getCycleDays(active.id);
    final periodDays = days.where((d) => d.flowIntensity > 0).toList();
    if (periodDays.isEmpty) return;

    final periodLength = date.difference(periodDays.first.date).inDays + 1;
    final cycleLength = date.difference(active.startDate).inDays + 1;

    await (_db.update(_db.cycles)..where((t) => t.id.equals(active.id)))
        .write(db.CyclesCompanion(
      endDate: Value(date),
      periodLength: Value(periodLength),
      cycleLength: Value(cycleLength),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // ── Mapping helpers ───────────────────────────────────────────

  Cycle _toDomainCycle(db.Cycle entity) {
    return Cycle(
      id: entity.id,
      startDate: entity.startDate,
      endDate: entity.endDate,
      cycleLength: entity.cycleLength ?? 28,
      periodLength: entity.periodLength ?? 5,
      notes: entity.notes != null
          ? _encryption.decryptString(entity.notes!)
          : null,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  CycleDay _toDomainCycleDay(db.CycleDay entity) {
    return CycleDay(
      id: entity.id,
      cycleId: entity.cycleId.toString(),
      date: entity.date,
      flowIntensity: entity.flowIntensity ?? 0,
      spotting: entity.spotting,
      clotting: entity.clotting,
      symptomsJson: entity.symptomsJson,
      temperature: entity.temperature,
      cervicalMucus: entity.cervicalMucus,
      cervicalPosition: entity.cervicalPosition,
      opkResult: entity.opkResult,
      notes: entity.notes != null
          ? _encryption.decryptString(entity.notes!)
          : null,
    );
  }
}
