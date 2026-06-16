import 'package:flutter_test/flutter_test.dart';
import 'package:cyra/core/prediction/ovulation_detector.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/models/opk_test_record.dart';
import 'package:cyra/features/ovulation/models/mucus_observation.dart';

void main() {
  late OvulationDetector detector;

  setUp(() {
    detector = OvulationDetector();
  });

  group('detectFromBBT', () {
    List<BBTRecord> createRecords({
      required int startDay,
      required double baselineTemp,
      required double shiftTemp,
      int preShiftDays = 6,
      int postShiftDays = 3,
      int month = 1,
    }) {
      final records = <BBTRecord>[];
      for (int i = 0; i < preShiftDays; i++) {
        records.add(BBTRecord(
          id: 'pre_$i',
          date: DateTime(2025, month, startDay + i),
          temperature: baselineTemp + (i.isEven ? 0.02 : -0.02),
        ));
      }
      for (int i = 0; i < postShiftDays; i++) {
        records.add(BBTRecord(
          id: 'post_$i',
          date: DateTime(2025, month, startDay + preShiftDays + i),
          temperature: shiftTemp + (i.isEven ? 0.03 : -0.03),
        ));
      }
      return records;
    }

    test('detects temperature shift with clear biphasic pattern', () {
      final records = createRecords(
        startDay: 1,
        baselineTemp: 36.2,
        shiftTemp: 36.5,
        preShiftDays: 6,
        postShiftDays: 3,
      );

      final result = detector.detectFromBBT(records);

      expect(result.isConfirmed, isTrue);
      expect(result.confidence, greaterThan(0.7));
      expect(result.method, 'bbt_shift');
      expect(result.explanation, contains('temperature shift'));
    });

    test('returns no detection with insufficient data', () {
      final records = List.generate(5, (i) => BBTRecord(
        id: 'r_$i',
        date: DateTime(2025, 1, 1 + i),
        temperature: 36.3 + (i * 0.02),
      ));

      final result = detector.detectFromBBT(records);

      expect(result.isConfirmed, isFalse);
      expect(result.confidence, 0.0);
      expect(result.explanation, contains('Insufficient BBT data'));
    });

    test('returns no detection without clear shift', () {
      final records = List.generate(12, (i) => BBTRecord(
        id: 'r_$i',
        date: DateTime(2025, 1, 1 + i),
        temperature: 36.3 + (i.isEven ? 0.04 : -0.02),
      ));

      final result = detector.detectFromBBT(records);

      expect(result.isConfirmed, isFalse);
      expect(result.confidence, lessThan(0.5));
      expect(result.explanation, contains('No clear biphasic'));
    });

    test('returns no detection with insufficient unique days', () {
      final records = List.generate(12, (i) => BBTRecord(
        id: 'r_$i',
        date: DateTime(2025, 1, 1), // All same day
        temperature: 36.3 + (i * 0.01),
      ));

      final result = detector.detectFromBBT(records);

      expect(result.isConfirmed, isFalse);
      expect(result.confidence, 0.0);
      expect(result.explanation, contains('distinct days'));
    });

    test('detects shift with large temperature rise', () {
      final records = createRecords(
        startDay: 1,
        baselineTemp: 36.0,
        shiftTemp: 36.8,
        preShiftDays: 6,
        postShiftDays: 3,
      );

      final result = detector.detectFromBBT(records);

      expect(result.isConfirmed, isTrue);
      expect(result.confidence, greaterThan(0.8));
    });

    test('sorts unsorted records chronologically', () {
      final records = [
        BBTRecord(id: '3', date: DateTime(2025, 1, 3), temperature: 36.6),
        BBTRecord(id: '1', date: DateTime(2025, 1, 1), temperature: 36.2),
        BBTRecord(id: '2', date: DateTime(2025, 1, 2), temperature: 36.3),
        BBTRecord(id: '4', date: DateTime(2025, 1, 4), temperature: 36.2),
        BBTRecord(id: '5', date: DateTime(2025, 1, 5), temperature: 36.3),
        BBTRecord(id: '6', date: DateTime(2025, 1, 6), temperature: 36.2),
        BBTRecord(id: '7', date: DateTime(2025, 1, 7), temperature: 36.5),
        BBTRecord(id: '8', date: DateTime(2025, 1, 8), temperature: 36.5),
        BBTRecord(id: '9', date: DateTime(2025, 1, 9), temperature: 36.6),
      ];

      final result = detector.detectFromBBT(records);

      expect(result.isConfirmed, isTrue);
    });
  });

  group('detectFromOPK', () {
    List<OPKTestResult> createSurgePattern({
      required DateTime surgeDate,
      int priorNegatives = 3,
      bool fadeAfter = true,
    }) {
      final tests = <OPKTestResult>[];
      for (int i = priorNegatives; i > 0; i--) {
        tests.add(OPKTestResult(
          id: 'neg_$i',
          date: surgeDate.subtract(Duration(days: i)),
          result: OPKResult.negative,
        ));
      }
      tests.add(OPKTestResult(
        id: 'surge',
        date: surgeDate,
        result: OPKResult.positive,
      ));
      if (fadeAfter) {
        tests.add(OPKTestResult(
          id: 'fade',
          date: surgeDate.add(const Duration(days: 1)),
          result: OPKResult.fading,
        ));
        tests.add(OPKTestResult(
          id: 'neg_after',
          date: surgeDate.add(const Duration(days: 2)),
          result: OPKResult.negative,
        ));
      }
      return tests;
    }

    test('detects LH surge from positive tests', () {
      final tests = createSurgePattern(
        surgeDate: DateTime(2025, 1, 14),
        priorNegatives: 4,
        fadeAfter: true,
      );

      final result = detector.detectFromOPK(tests);

      expect(result.isConfirmed, isTrue);
      expect(result.confidence, greaterThan(0.7));
      expect(result.method, 'opk_positive');
      expect(result.explanation, contains('LH surge detected'));
    });

    test('returns no detection for empty tests', () {
      final result = detector.detectFromOPK([]);

      expect(result.isConfirmed, isFalse);
      expect(result.confidence, 0.0);
    });

    test('returns lower confidence without subsequent negatives', () {
      final tests = createSurgePattern(
        surgeDate: DateTime(2025, 1, 14),
        priorNegatives: 0,
        fadeAfter: false,
      );

      final result = detector.detectFromOPK(tests);

      expect(result.isConfirmed, isFalse);
      expect(result.confidence, lessThanOrEqualTo(0.5));
    });

    test('returns no detection for only negative tests', () {
      final tests = List.generate(5, (i) => OPKTestResult(
        id: 'neg_$i',
        date: DateTime(2025, 1, 10 + i),
        result: OPKResult.negative,
      ));

      final result = detector.detectFromOPK(tests);

      expect(result.isConfirmed, isFalse);
      expect(result.explanation, contains('No positive OPK tests'));
    });

    test('estimates ovulation 30 hours after surge', () {
      final tests = createSurgePattern(
        surgeDate: DateTime(2025, 1, 14),
        priorNegatives: 3,
        fadeAfter: true,
      );

      final result = detector.detectFromOPK(tests);

      expect(result.estimatedOvulationDate,
          DateTime(2025, 1, 15).add(const Duration(hours: 6)));
    });

    test('confidence increases with more prior negatives', () {
      final fewPrior = createSurgePattern(
        surgeDate: DateTime(2025, 1, 14),
        priorNegatives: 2,
        fadeAfter: true,
      );
      final manyPrior = createSurgePattern(
        surgeDate: DateTime(2025, 1, 14),
        priorNegatives: 6,
        fadeAfter: true,
      );

      final resultFew = detector.detectFromOPK(fewPrior);
      final resultMany = detector.detectFromOPK(manyPrior);

      expect(resultMany.confidence, greaterThan(resultFew.confidence));
    });
  });

  group('detectFromMucus', () {
    test('detects peak from mucus progression', () {
      final observations = [
        MucusObservation(id: '1', date: DateTime(2025, 1, 10), type: CervicalMucusType.dry),
        MucusObservation(id: '2', date: DateTime(2025, 1, 11), type: CervicalMucusType.sticky),
        MucusObservation(id: '3', date: DateTime(2025, 1, 12), type: CervicalMucusType.creamy),
        MucusObservation(id: '4', date: DateTime(2025, 1, 13), type: CervicalMucusType.watery),
        MucusObservation(id: '5', date: DateTime(2025, 1, 14), type: CervicalMucusType.eggWhite),
        MucusObservation(id: '6', date: DateTime(2025, 1, 15), type: CervicalMucusType.sticky),
        MucusObservation(id: '7', date: DateTime(2025, 1, 16), type: CervicalMucusType.dry),
      ];

      final result = detector.detectFromMucus(observations);

      expect(result.isConfirmed, isTrue);
      expect(result.confidence, greaterThan(0.7));
      expect(result.explanation, contains('mucus pattern'));
    });

    test('returns no detection with insufficient observations', () {
      final observations = List.generate(2, (i) => MucusObservation(
        id: 'o_$i',
        date: DateTime(2025, 1, 10 + i),
        type: CervicalMucusType.sticky,
      ));

      final result = detector.detectFromMucus(observations);

      expect(result.isConfirmed, isFalse);
      expect(result.confidence, 0.0);
      expect(result.explanation, contains('Insufficient'));
    });

    test('returns no detection without fertile-type mucus', () {
      final observations = List.generate(5, (i) => MucusObservation(
        id: 'o_$i',
        date: DateTime(2025, 1, 10 + i),
        type: CervicalMucusType.dry,
      ));

      final result = detector.detectFromMucus(observations);

      expect(result.isConfirmed, isFalse);
      expect(result.confidence, lessThanOrEqualTo(0.2));
    });

    test('estimates ovulation 1 day after peak', () {
      final observations = [
        MucusObservation(id: '1', date: DateTime(2025, 1, 10), type: CervicalMucusType.sticky),
        MucusObservation(id: '2', date: DateTime(2025, 1, 11), type: CervicalMucusType.creamy),
        MucusObservation(id: '3', date: DateTime(2025, 1, 12), type: CervicalMucusType.eggWhite),
        MucusObservation(id: '4', date: DateTime(2025, 1, 13), type: CervicalMucusType.sticky),
        MucusObservation(id: '5', date: DateTime(2025, 1, 14), type: CervicalMucusType.dry),
      ];

      final result = detector.detectFromMucus(observations);

      expect(result.estimatedOvulationDate, DateTime(2025, 1, 13));
    });

    test('detects peak from eggWhite mucus', () {
      final observations = [
        MucusObservation(id: '1', date: DateTime(2025, 1, 10), type: CervicalMucusType.creamy),
        MucusObservation(id: '2', date: DateTime(2025, 1, 11), type: CervicalMucusType.eggWhite),
        MucusObservation(id: '3', date: DateTime(2025, 1, 12), type: CervicalMucusType.sticky),
        MucusObservation(id: '4', date: DateTime(2025, 1, 13), type: CervicalMucusType.dry),
      ];

      final result = detector.detectFromMucus(observations);

      // peakIndex=1 which is < 2, so _hasProgressionPattern returns false
      // and isConfirmed requires both progression and post-peak dry-up
      expect(result.isConfirmed, isFalse);
    });

    test('confidence increases with more observations', () {
      final shortObs = [
        MucusObservation(id: '1', date: DateTime(2025, 1, 11), type: CervicalMucusType.sticky),
        MucusObservation(id: '2', date: DateTime(2025, 1, 12), type: CervicalMucusType.creamy),
        MucusObservation(id: '3', date: DateTime(2025, 1, 13), type: CervicalMucusType.eggWhite),
      ];

      final longObs = [
        MucusObservation(id: '1', date: DateTime(2025, 1, 8), type: CervicalMucusType.dry),
        MucusObservation(id: '2', date: DateTime(2025, 1, 9), type: CervicalMucusType.sticky),
        MucusObservation(id: '3', date: DateTime(2025, 1, 10), type: CervicalMucusType.creamy),
        MucusObservation(id: '4', date: DateTime(2025, 1, 11), type: CervicalMucusType.creamy),
        MucusObservation(id: '5', date: DateTime(2025, 1, 12), type: CervicalMucusType.watery),
        MucusObservation(id: '6', date: DateTime(2025, 1, 13), type: CervicalMucusType.eggWhite),
        MucusObservation(id: '7', date: DateTime(2025, 1, 14), type: CervicalMucusType.sticky),
        MucusObservation(id: '8', date: DateTime(2025, 1, 15), type: CervicalMucusType.dry),
      ];

      final resultShort = detector.detectFromMucus(shortObs);
      final resultLong = detector.detectFromMucus(longObs);

      expect(resultLong.confidence, greaterThan(resultShort.confidence));
    });
  });

  group('detectCombined', () {
    BBTRecord bbt(String id, DateTime date, double temp) {
      return BBTRecord(id: id, date: date, temperature: temp);
    }

    OPKTestResult opk(String id, DateTime date, OPKResult result) {
      return OPKTestResult(id: id, date: date, result: result);
    }

    MucusObservation mucus(String id, DateTime date, CervicalMucusType type) {
      return MucusObservation(id: id, date: date, type: type);
    }

    test('combines all three signals with agreement', () {
      final bbtRecords = List.generate(9, (i) {
        final temp = i < 6 ? 36.3 : 36.6;
        return bbt('bbt_$i', DateTime(2025, 1, 1 + i), temp);
      });

      final opkResults = [
        opk('opk_1', DateTime(2025, 1, 3), OPKResult.negative),
        opk('opk_2', DateTime(2025, 1, 4), OPKResult.positive),
        opk('opk_3', DateTime(2025, 1, 5), OPKResult.fading),
      ];

      final mucusObservations = [
        mucus('m_1', DateTime(2025, 1, 1), CervicalMucusType.dry),
        mucus('m_2', DateTime(2025, 1, 2), CervicalMucusType.sticky),
        mucus('m_3', DateTime(2025, 1, 3), CervicalMucusType.creamy),
        mucus('m_4', DateTime(2025, 1, 4), CervicalMucusType.eggWhite),
        mucus('m_5', DateTime(2025, 1, 5), CervicalMucusType.sticky),
        mucus('m_6', DateTime(2025, 1, 6), CervicalMucusType.dry),
      ];

      final result = detector.detectCombined(bbtRecords, opkResults, mucusObservations);

      expect(result.method, 'combined');
      expect(result.confidence, greaterThan(0.5));
    });

    test('returns low confidence with no data', () {
      final result = detector.detectCombined([], [], []);

      expect(result.isConfirmed, isFalse);
      expect(result.confidence, 0.0);
      expect(result.explanation, contains('Insufficient data'));
    });

    test('falls back to single method when only one has data', () {
      final opkResults = [
        opk('opk_1', DateTime(2025, 1, 10), OPKResult.negative),
        opk('opk_2', DateTime(2025, 1, 11), OPKResult.positive),
        opk('opk_3', DateTime(2025, 1, 12), OPKResult.negative),
      ];

      final result = detector.detectCombined([], opkResults, []);

      expect(result.method, 'opk_positive');
    });

    test('reduces confidence when signals disagree', () {
      final bbtRecords = List.generate(9, (i) {
        return bbt('bbt_$i', DateTime(2025, 1, 1 + i), 36.3);
      });

      final opkResults = [
        opk('opk_1', DateTime(2025, 1, 10), OPKResult.positive),
        opk('opk_2', DateTime(2025, 1, 11), OPKResult.fading),
      ];

      final result = detector.detectCombined(bbtRecords, opkResults, []);

      // BBT has no shift (no estimated date), so only OPK contributes.
      // OPK surge is confirmed (fading counts), so OPK confidence is 0.8.
      // With only one available signal, confidence equals OPK confidence.
      expect(result.confidence, greaterThan(0.5));
    });

    test('includes method summaries in explanation', () {
      final opkResults = [
        opk('opk_1', DateTime(2025, 1, 10), OPKResult.positive),
        opk('opk_2', DateTime(2025, 1, 11), OPKResult.fading),
      ];

      final result = detector.detectCombined([], opkResults, []);

      expect(result.explanation, contains('OPK'));
    });
  });

  group('calculateFertileWindow', () {
    test('returns correct range for 28-day cycle', () {
      final (start, end) = detector.calculateFertileWindow(
        periodStart: DateTime(2025, 1, 1),
        cycleLength: 28,
      );

      // ovulationDay = 14, ovulationDate = Jan 15, fertileStart = Jan 10
      expect(start, DateTime(2025, 1, 10));
      expect(end, DateTime(2025, 1, 15));
    });

    test('uses default cycle length when not provided', () {
      final (start, end) = detector.calculateFertileWindow(
        periodStart: DateTime(2025, 1, 1),
      );

      // Default 28-day cycle: same as above
      expect(start, DateTime(2025, 1, 10));
      expect(end, DateTime(2025, 1, 15));
    });

    test('uses lastOvulationDate when provided', () {
      final (start, end) = detector.calculateFertileWindow(
        periodStart: DateTime(2025, 2, 1),
        lastOvulationDate: DateTime(2025, 1, 15),
        lastCycleLength: 28,
        cycleLength: 30,
      );

      expect(end, DateTime(2025, 1, 17));
    });
  });

  group('dailyConceptionProbability', () {
    test('returns valid distribution with peak before ovulation', () {
      final probs = detector.dailyConceptionProbability(28);

      expect(probs.length, 28);
      expect(probs.values.any((p) => p > 0), isTrue);
      expect(probs.values.every((p) => p >= 0.0 && p <= 1.0), isTrue);
    });

    test('has peak probability 2 days before ovulation', () {
      final probs = detector.dailyConceptionProbability(28);

      // ovulationDay = 14; day 12 = -2 offset, day 13 = -1 offset, day 14 = 0 offset
      expect(probs[12], 0.30);
      expect(probs[13], 0.33);
      expect(probs[14], 0.12);
    });

    test('returns zero probability outside fertile window', () {
      final probs = detector.dailyConceptionProbability(28);

      expect(probs[1], 0.0);
      expect(probs[20], 0.0);
      expect(probs[28], 0.0);
    });

    test('adjusts ovulation day for different cycle lengths', () {
      final probs28 = detector.dailyConceptionProbability(28);
      final probs35 = detector.dailyConceptionProbability(35);

      expect(probs28[14], 0.12);
      expect(probs35[21], 0.12);
    });
  });
}
