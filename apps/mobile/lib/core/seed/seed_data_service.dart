import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cyra/core/database/app_database.dart' as db;
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/cycle/repositories/cycle_repository.dart';
import 'package:cyra/features/journal/models/journal_models.dart';
import 'package:cyra/features/journal/repositories/journal_repository.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/models/opk_test_record.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/ovulation/repositories/ovulation_repository.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/symptoms/repositories/symptom_repository.dart';
import 'package:cyra/core/database/daos/cycle_dao.dart';

class SeedDataService {
  final CycleRepository _cycleRepo;
  final OvulationRepository _ovulationRepo;
  final SymptomRepository _symptomRepo;
  final JournalRepository _journalRepo;
  final SymptomDao _symptomDao;
  final Random _random;
  int _idCounter = 0;

  static const _symptomDefs = [
    ('cramps', 'Cramps', 'physical', 'cramps'),
    ('bloating', 'Bloating', 'physical', 'bloating'),
    ('headache', 'Headache', 'physical', 'headache'),
    ('fatigue', 'Fatigue', 'physical', 'fatigue'),
    ('back_pain', 'Back Pain', 'physical', 'back_pain'),
    ('breast_tenderness', 'Breast Tenderness', 'physical', 'breast_tenderness'),
    ('mood_swings', 'Mood Swings', 'emotional', 'mood_swings'),
    ('anxiety', 'Anxiety', 'emotional', 'anxiety'),
    ('acne', 'Acne', 'skin', 'acne'),
    ('cravings', 'Food Cravings', 'lifestyle', 'cravings'),
    ('insomnia', 'Insomnia', 'lifestyle', 'insomnia'),
    ('increased_energy', 'Increased Energy', 'lifestyle', 'high_energy'),
    ('low_energy', 'Low Energy', 'lifestyle', 'low_energy'),
  ];

  SeedDataService(
    this._cycleRepo,
    this._ovulationRepo,
    this._symptomRepo,
    this._journalRepo,
    this._symptomDao,
  ) : _random = Random(42);

  Future<void> loadIfNeeded() async {
    if (!kDebugMode) return;
    final existing = await _cycleRepo.getAllCycles();
    if (existing.isNotEmpty) return;
    await _generateAll();
    debugPrint('Seed data loaded: 7 cycles over 6+ months');
  }

  String _nextId() {
    _idCounter++;
    return 'seed_${_idCounter}_${DateTime.now().microsecondsSinceEpoch}';
  }

  Future<void> _generateAll() async {
    await _ensureSymptomsExist();

    final now = DateTime.now();
    var currentDate = now.subtract(const Duration(days: 190));
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

    const cycleDefs = [
      (length: 28, period: 5),
      (length: 27, period: 4),
      (length: 30, period: 5),
      (length: 26, period: 4),
      (length: 29, period: 6),
      (length: 28, period: 5),
      (length: 28, period: 5),
    ];

    for (int i = 0; i < cycleDefs.length && currentDate.isBefore(now); i++) {
      final def = cycleDefs[i];
      final cycleLength = def.length;
      final periodLength = def.period;
      final cycleId = 'seed_cycle_$i';
      final cycleEnd = currentDate.add(Duration(days: cycleLength - 1));
      final isLast = i == cycleDefs.length - 1;

      await _cycleRepo.createCycle(Cycle(
        id: cycleId,
        startDate: currentDate,
        endDate: isLast ? null : (cycleEnd.isBefore(now) ? cycleEnd : null),
        cycleLength: cycleLength,
        periodLength: periodLength,
      ));

      final ovulationDay = cycleLength - 14;
      final daysToGenerate = min(cycleLength, now.difference(currentDate).inDays + 1);

      for (int d = 0; d < daysToGenerate; d++) {
        final date = currentDate.add(Duration(days: d));
        final dayOfCycle = d + 1;
        final isPeriodDay = dayOfCycle <= periodLength;
        final isFertile = dayOfCycle >= 10 && dayOfCycle <= 17;

        final dayId = '${cycleId}_day_$d';

        final symptoms = <String>[];
        int flowIntensity = 0;
        if (isPeriodDay) {
          flowIntensity = _random.nextInt(3) + 1;
          if (dayOfCycle <= 2) flowIntensity = _random.nextInt(2) + 2;
          if (dayOfCycle == periodLength) flowIntensity = 1;
          symptoms.add('cramps');
          if (dayOfCycle <= 2) symptoms.add('fatigue');
          if (dayOfCycle == 1) symptoms.add('headache');
          if (dayOfCycle <= 2 && _random.nextDouble() < 0.6) symptoms.add('back_pain');
          if (_random.nextDouble() < 0.4) symptoms.add('bloating');
        } else if (dayOfCycle >= ovulationDay - 2 && dayOfCycle <= ovulationDay + 1) {
          symptoms.add('increased_energy');
          if (_random.nextDouble() < 0.3) symptoms.add('bloating');
        } else if (dayOfCycle > ovulationDay + 1) {
          if (_random.nextDouble() < 0.5) symptoms.add('bloating');
          if (_random.nextDouble() < 0.45) symptoms.add('mood_swings');
          if (_random.nextDouble() < 0.4) {
            symptoms.add('cravings');
            symptoms.add('fatigue');
          }
          if (dayOfCycle > cycleLength - 5 && _random.nextDouble() < 0.4) symptoms.add('insomnia');
          if (_random.nextDouble() < 0.3) symptoms.add('breast_tenderness');
          if (_random.nextDouble() < 0.25) symptoms.add('acne');
          if (_random.nextDouble() < 0.15) symptoms.add('anxiety');
        } else {
          if (_random.nextDouble() < 0.25) symptoms.add('increased_energy');
        }

        final temp = _generateBBT(dayOfCycle, periodLength, ovulationDay, cycleLength);
        String? mucus;
        if (isFertile && !isPeriodDay) {
          mucus = 'egg_white';
        } else if (dayOfCycle > ovulationDay + 1 && dayOfCycle < cycleLength - 2) {
          if (_random.nextDouble() < 0.3) mucus = 'creamy';
        }

        final symptomsJson = symptoms.isNotEmpty
            ? symptoms.map((s) => '{symptomId:$s,severity:${2 + _random.nextInt(2)}}').join(',')
            : null;
        if (symptomsJson != null) {
          final wrapped = '[$symptomsJson]';
          await _cycleRepo.saveCycleDay(CycleDay(
            id: dayId,
            cycleId: cycleId,
            date: date,
            flowIntensity: flowIntensity,
            spotting: isPeriodDay && _random.nextDouble() < 0.15,
            clotting: flowIntensity >= 3 && _random.nextDouble() < 0.3,
            symptomsJson: wrapped,
            temperature: temp,
            cervicalMucus: mucus,
          ));
        } else {
          await _cycleRepo.saveCycleDay(CycleDay(
            id: dayId,
            cycleId: cycleId,
            date: date,
            flowIntensity: flowIntensity,
            spotting: isPeriodDay && _random.nextDouble() < 0.15,
            clotting: flowIntensity >= 3 && _random.nextDouble() < 0.3,
            temperature: temp,
            cervicalMucus: mucus,
          ));
        }

        if (temp != null) {
          await _ovulationRepo.saveBBT(BBTRecord(
            id: '${dayId}_bbt',
            date: date,
            temperature: temp,
            method: BBTMeasurementMethod.oral,
            timeOfDay: '07:00',
            isEstimated: _random.nextDouble() < 0.1,
          ));
        }

        if (symptoms.isNotEmpty) {
          for (final sym in symptoms) {
            await _symptomRepo.createSymptomEntry(SymptomEntry(
              id: '${dayId}_sym_$sym',
              date: date,
              symptomId: sym,
              symptomName: _symptomDefs.firstWhere((s) => s.$1 == sym).$2,
              severity: 2 + _random.nextInt(2),
              category: _symptomDefs.firstWhere((s) => s.$1 == sym).$3,
            ));
          }
        }

        if (_random.nextDouble() < 0.6) {
          final moodRating = _generateMood(dayOfCycle, periodLength, ovulationDay, cycleLength);
          await _symptomRepo.createMoodEntry(MoodEntry(
            id: '${dayId}_mood',
            date: date,
            moodRating: moodRating,
          ));
        }
      }

      if (!isLast && currentDate.add(Duration(days: cycleLength)).isBefore(now)) {
        await _generateOPKs(currentDate, cycleLength, periodLength, ovulationDay);
        await _generateJournalEntries(currentDate, cycleLength, periodLength, cycleId, ovulationDay);
      }

      currentDate = currentDate.add(Duration(days: cycleLength));
    }
  }

  double? _generateBBT(int dayOfCycle, int periodLength, int ovulationDay, int cycleLength) {
    if (_random.nextDouble() < 0.15) return null;
    if (dayOfCycle <= periodLength) {
      return double.parse((36.3 + _random.nextDouble() * 0.15).toStringAsFixed(1));
    } else if (dayOfCycle < ovulationDay) {
      return double.parse((36.2 + _random.nextDouble() * 0.2).toStringAsFixed(1));
    } else if (dayOfCycle == ovulationDay) {
      return double.parse((36.1 + _random.nextDouble() * 0.15).toStringAsFixed(1));
    } else if (dayOfCycle <= ovulationDay + 3) {
      return double.parse((36.5 + _random.nextDouble() * 0.2).toStringAsFixed(1));
    } else if (dayOfCycle <= cycleLength - 3) {
      return double.parse((36.6 + _random.nextDouble() * 0.2).toStringAsFixed(1));
    } else {
      return double.parse((36.4 + _random.nextDouble() * 0.2).toStringAsFixed(1));
    }
  }

  int _generateMood(int dayOfCycle, int periodLength, int ovulationDay, int cycleLength) {
    if (dayOfCycle <= periodLength) return _random.nextInt(2) + 2;
    if (dayOfCycle <= ovulationDay - 1) return _random.nextInt(2) + 3;
    if (dayOfCycle >= ovulationDay - 1 && dayOfCycle <= ovulationDay + 1) return _random.nextInt(2) + 4;
    if (dayOfCycle >= ovulationDay + 2 && dayOfCycle <= cycleLength - 5) return _random.nextInt(2) + 2;
    return _random.nextInt(2) + 2;
  }

  Future<void> _ensureSymptomsExist() async {
    final dao = _symptomDao;
    final existing = await dao.getAllSymptoms();
    if (existing.length >= _symptomDefs.length) return;

    final now = DateTime.now();
    for (final def in _symptomDefs) {
      try {
        await dao.createSymptom(db.Symptom(
          id: def.$1,
          name: def.$2,
          category: def.$3,
          iconName: def.$4,
          colorHex: '',
          predefinedOptions: '',
          isActive: true,
          createdAt: now,
        ));
      } catch (_) {}
    }
  }

  Future<void> _generateOPKs(
    DateTime cycleStart,
    int cycleLength,
    int periodLength,
    int ovulationDay,
  ) async {
    for (int d = ovulationDay - 3; d <= ovulationDay + 2; d++) {
      if (d < 1 || d > cycleLength) continue;
      final date = cycleStart.add(Duration(days: d - 1));
      if (d <= ovulationDay - 2) {
        await _ovulationRepo.saveOPK(OPKTestResult(
          id: _nextId(),
          date: date,
          result: OPKResult.negative,
          timeOfDay: '14:00',
          brand: 'Easy@Home',
        ));
      } else if (d == ovulationDay - 1) {
        await _ovulationRepo.saveOPK(OPKTestResult(
          id: _nextId(),
          date: date,
          result: OPKResult.positive,
          timeOfDay: '16:00',
          brand: 'Easy@Home',
        ));
      } else if (d == ovulationDay) {
        await _ovulationRepo.saveOPK(OPKTestResult(
          id: _nextId(),
          date: date,
          result: OPKResult.positive,
          timeOfDay: '12:00',
          brand: 'Easy@Home',
        ));
      } else {
        await _ovulationRepo.saveOPK(OPKTestResult(
          id: _nextId(),
          date: date,
          result: OPKResult.negative,
          timeOfDay: '14:00',
          brand: 'Easy@Home',
        ));
      }
    }
  }

  Future<void> _generateJournalEntries(
    DateTime cycleStart,
    int cycleLength,
    int periodLength,
    String cycleId,
    int ovulationDay,
  ) async {
    final entries = <(int, String, String, int)>[];

    entries.add((
      1,
      'Period started',
      'My period started today. Cramps are manageable with a heating pad. '
          'Taking it easy this evening.',
      2,
    ));

    entries.add((
      min(periodLength + 2, cycleLength),
      'Period is over',
      'Feeling much better now that my period is winding down. '
          'Energy levels are starting to come back up.',
      4,
    ));

    entries.add((
      ovulationDay,
      'Ovulation day',
      'Feeling great! Lots of energy and in a positive mood. '
          'Noticed egg-white cervical mucus today.',
      5,
    ));

    entries.add((
      cycleLength - 5,
      'PMS symptoms',
      'Feeling bloated and irritable today. Really craving chocolate. '
          'Trying to stay hydrated and get some rest.',
      2,
    ));

    for (final entry in entries) {
      final dayIndex = entry.$1 - 1;
      final date = cycleStart.add(Duration(days: dayIndex));
      await _journalRepo.createEntry(JournalEntry(
        id: '${cycleId}_journal_${entry.$1}',
        date: date,
        title: entry.$2,
        content: entry.$3,
        moodRating: entry.$4,
        cycleDayId: '${cycleId}_day_$dayIndex',
      ));
    }
  }
}
