import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:cyra/core/database/app_database.dart';
import 'package:cyra/core/prediction/ovulation_detector.dart';
import 'package:cyra/features/fertility/models/fertility_models.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/models/opk_test_record.dart';
import 'package:cyra/features/ovulation/models/mucus_observation.dart';

class FertilityRepository {
  final AppDatabase _db;
  final OvulationDetector _detector;

  static const String _intercourseKey = 'intercourse_logs';
  static const String _modeKey = 'fertility_mode';

  FertilityRepository(this._db) : _detector = OvulationDetector();

  // ── Fertility Mode ────────────────────────────────────────────

  Future<FertilityMode> getFertilityMode() async {
    final setting = await (_db.select(_db.appSettings)
          ..where((t) => t.key.equals(_modeKey)))
        .getSingleOrNull();
    if (setting == null) return FertilityMode.notPlanning;
    return FertilityMode.values.firstWhere(
      (m) => m.name == setting.value,
      orElse: () => FertilityMode.notPlanning,
    );
  }

  Future<void> setFertilityMode(FertilityMode mode) async {
    final existing = await (_db.select(_db.appSettings)
          ..where((t) => t.key.equals(_modeKey)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.appSettings)
            ..where((t) => t.key.equals(_modeKey)))
          .write(AppSettingsCompanion(
        value: Value(mode.name),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      await _db.into(_db.appSettings).insert(AppSettingsCompanion.insert(
        id: _modeKey,
        key: _modeKey,
        value: mode.name,
        updatedAt: DateTime.now(),
      ));
    }
  }

  // ── Intercourse Log ───────────────────────────────────────────

  Future<List<IntercourseLog>> getIntercourseLogs({
    int limit = 50,
    int offset = 0,
  }) async {
    final logs = await _loadIntercourseLogs();
    logs.sort((a, b) => b.date.compareTo(a.date));
    return logs.skip(offset).take(limit).toList();
  }

  Future<List<IntercourseLog>> getIntercourseLogsInRange(
    DateTime start,
    DateTime end,
  ) async {
    final logs = await _loadIntercourseLogs();
    return logs
        .where((l) =>
            l.date.isAfter(start.subtract(const Duration(days: 1))) &&
            l.date.isBefore(end.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<IntercourseLog?> getLatestIntercourseLog() async {
    final logs = await _loadIntercourseLogs();
    if (logs.isEmpty) return null;
    logs.sort((a, b) => b.date.compareTo(a.date));
    return logs.first;
  }

  Future<IntercourseLog> logIntercourse(IntercourseLog log) async {
    final logs = await _loadIntercourseLogs();
    final existingIdx = logs.indexWhere((l) => l.id == log.id);
    if (existingIdx >= 0) {
      logs[existingIdx] = log;
    } else {
      logs.add(log);
    }
    await _saveIntercourseLogs(logs);
    return log;
  }

  Future<void> deleteIntercourseLog(String id) async {
    final logs = await _loadIntercourseLogs();
    logs.removeWhere((l) => l.id == id);
    await _saveIntercourseLogs(logs);
  }

  Future<List<IntercourseLog>> _loadIntercourseLogs() async {
    final setting = await (_db.select(_db.appSettings)
          ..where((t) => t.key.equals(_intercourseKey)))
        .getSingleOrNull();
    if (setting == null || setting.value.isEmpty) return [];

    try {
      final list = jsonDecode(setting.value) as List;
      return list
          .map((e) => IntercourseLog.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveIntercourseLogs(List<IntercourseLog> logs) async {
    final json = jsonEncode(logs.map((l) => l.toJson()).toList());
    final existing = await (_db.select(_db.appSettings)
          ..where((t) => t.key.equals(_intercourseKey)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.appSettings)
            ..where((t) => t.key.equals(_intercourseKey)))
          .write(AppSettingsCompanion(
        value: Value(json),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      await _db.into(_db.appSettings).insert(AppSettingsCompanion.insert(
        id: _intercourseKey,
        key: _intercourseKey,
        value: json,
        updatedAt: DateTime.now(),
      ));
    }
  }

  // ── Fertility Status ──────────────────────────────────────────

  Future<FertilityStatus> getDailyFertilityStatus({
    required int cycleDay,
    required int cycleLength,
    List<BBTRecord>? bbtRecords,
    List<OPKTestResult>? opkResults,
    List<MucusObservation>? mucusObservations,
    DateTime? lastIntercourseDate,
  }) async {
    final probabilities =
        _detector.dailyConceptionProbability(cycleLength);
    final conceptionProb = probabilities[cycleDay] ?? 0.0;

    final ovulationDay = cycleLength - 14;
    final dayType = _determineDayType(
      cycleDay: cycleDay,
      cycleLength: cycleLength,
      ovulationDay: ovulationDay,
      bbtRecords: bbtRecords,
      opkResults: opkResults,
      mucusObservations: mucusObservations,
    );

    final recommendation = _generateRecommendation(
      dayType: dayType,
      conceptionProb: conceptionProb,
      cycleDay: cycleDay,
      ovulationDay: ovulationDay,
      lastIntercourseDate: lastIntercourseDate,
    );

    final explanation = _generateExplanation(
      dayType: dayType,
      cycleDay: cycleDay,
      cycleLength: cycleLength,
      ovulationDay: ovulationDay,
      conceptionProb: conceptionProb,
    );

    return FertilityStatus(
      cycleDay: cycleDay,
      dayType: dayType,
      conceptionProbability: conceptionProb,
      recommendation: recommendation,
      explanation: explanation,
    );
  }

  FertilityDayType _determineDayType({
    required int cycleDay,
    required int cycleLength,
    required int ovulationDay,
    List<BBTRecord>? bbtRecords,
    List<OPKTestResult>? opkResults,
    List<MucusObservation>? mucusObservations,
  }) {
    final periodLength = 5;

    if (cycleDay <= periodLength) {
      return FertilityDayType.period;
    }

    if (bbtRecords != null && bbtRecords.isNotEmpty) {
      final bbtResult = _detector.detectFromBBT(bbtRecords);
      if (bbtResult.isConfirmed &&
          bbtResult.confirmedOvulationDate != null) {
        final temp = bbtResult.confirmedOvulationDate!;
        final confirmedDay =
            temp.difference(DateTime(temp.year, temp.month, 1)).inDays + 1;
        if (cycleDay > confirmedDay + 1) {
          return FertilityDayType.postOvulation;
        }
      }
    }

    if (opkResults != null && opkResults.isNotEmpty) {
      final opkResult = _detector.detectFromOPK(opkResults);
      if (opkResult.isConfirmed &&
          opkResult.estimatedOvulationDate != null) {
        final surgeDay = opkResult.estimatedOvulationDate!
            .difference(
                DateTime(opkResult.estimatedOvulationDate!.year,
                    opkResult.estimatedOvulationDate!.month, 1))
            .inDays + 1;
        if (cycleDay > surgeDay + 2) {
          return FertilityDayType.postOvulation;
        }
        if (cycleDay == surgeDay || cycleDay == surgeDay + 1) {
          return FertilityDayType.ovulation;
        }
      }
    }

    if (mucusObservations != null && mucusObservations.isNotEmpty) {
      final mucusResult = _detector.detectFromMucus(mucusObservations);
      if (mucusResult.isConfirmed &&
          mucusResult.confirmedOvulationDate != null) {
        final peakDay = mucusResult.confirmedOvulationDate!
            .difference(
                DateTime(mucusResult.confirmedOvulationDate!.year,
                    mucusResult.confirmedOvulationDate!.month, 1))
            .inDays + 1;
        if (cycleDay > peakDay + 2) {
          return FertilityDayType.postOvulation;
        }
      }
    }

    if (cycleDay >= ovulationDay - 5 && cycleDay < ovulationDay - 2) {
      return FertilityDayType.transitioning;
    }
    if (cycleDay >= ovulationDay - 2 && cycleDay < ovulationDay - 1) {
      return FertilityDayType.fertile;
    }
    if (cycleDay == ovulationDay - 1) {
      return FertilityDayType.peakFertile;
    }
    if (cycleDay == ovulationDay) {
      return FertilityDayType.ovulation;
    }
    if (cycleDay > ovulationDay && cycleDay <= ovulationDay + 2) {
      return FertilityDayType.postOvulation;
    }
    if (cycleDay > ovulationDay + 2) {
      return FertilityDayType.notFertile;
    }

    return FertilityDayType.unknown;
  }

  String? _generateRecommendation({
    required FertilityDayType dayType,
    required double conceptionProb,
    required int cycleDay,
    required int ovulationDay,
    DateTime? lastIntercourseDate,
  }) {
    final cycleLength = ovulationDay + 14;
    return switch (dayType) {
      FertilityDayType.period => 'Rest and track flow intensity.',
      FertilityDayType.notFertile =>
        'Low conception probability. Focus on general wellness.',
      FertilityDayType.transitioning =>
        'Your fertile window is approaching. Consider starting OPK testing.',
      FertilityDayType.fertile =>
        'You are in your fertile window. Intercourse every 1-2 days '
        'is recommended for TTC.',
      FertilityDayType.peakFertile =>
        'Peak fertility today! This is your best chance for conception. '
        'Continue tracking BBT and mucus.',
      FertilityDayType.ovulation =>
        'Ovulation day. Have intercourse today for optimal chances. '
        'Record BBT to confirm ovulation.',
      FertilityDayType.postOvulation =>
        'Ovulation has passed. Take time to rest and reflect. '
        'Expect your period in ${cycleLength - cycleDay} days.',
      FertilityDayType.unknown =>
        'Track more symptoms to improve fertility predictions.',
    };
  }

  String _generateExplanation({
    required FertilityDayType dayType,
    required int cycleDay,
    required int cycleLength,
    required int ovulationDay,
    required double conceptionProb,
  }) {
    final phase = switch (dayType) {
      FertilityDayType.period => 'menstrual phase',
      FertilityDayType.notFertile => 'luteal phase (non-fertile)',
      FertilityDayType.transitioning => 'follicular phase (transitioning)',
      FertilityDayType.fertile => 'fertile window',
      FertilityDayType.peakFertile => 'peak fertile phase',
      FertilityDayType.ovulation => 'ovulation phase',
      FertilityDayType.postOvulation => 'post-ovulation phase (luteal)',
      FertilityDayType.unknown => 'uncertain phase',
    };

    return
        'Day $cycleDay of $cycleLength — $phase. '
        'Conception probability: ${(conceptionProb * 100).round()}%.';
  }
}
