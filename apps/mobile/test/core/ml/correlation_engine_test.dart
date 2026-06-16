import 'package:flutter_test/flutter_test.dart';
import 'package:cyra/core/ml/correlation_engine.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';

CycleDay _day({
  required int dayOfMonth,
  required int flow,
  String? symptoms,
  int month = 1,
}) {
  return CycleDay(
    id: 'd_$dayOfMonth',
    cycleId: 'c1',
    date: DateTime(2025, month, dayOfMonth),
    flowIntensity: flow,
    symptomsJson: symptoms,
  );
}

Cycle _cycle({
  required String id,
  required int startDay,
  int endDay = 28,
  int cycleLength = 28,
  int periodLength = 5,
  int month = 1,
  List<CycleDay>? days,
}) {
  return Cycle(
    id: id,
    startDate: DateTime(2025, month, startDay),
    endDate: DateTime(2025, month, endDay),
    cycleLength: cycleLength,
    periodLength: periodLength,
    days: days ?? [],
  );
}

void main() {
  late CorrelationEngine engine;

  setUp(() {
    engine = CorrelationEngine();
  });

  group('pearsonCorrelation', () {
    test('returns 1.0 for perfectly correlated data', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [2.0, 4.0, 6.0, 8.0, 10.0];

      final result = engine.pearsonCorrelation(x, y);

      expect(result, closeTo(1.0, 0.001));
    });

    test('returns -1.0 for perfectly negatively correlated data', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [10.0, 8.0, 6.0, 4.0, 2.0];

      final result = engine.pearsonCorrelation(x, y);

      expect(result, closeTo(-1.0, 0.001));
    });

    test('returns near 0.0 for uncorrelated data', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [3.0, 3.0, 3.0, 3.0, 3.0];

      final result = engine.pearsonCorrelation(x, y);

      expect(result, closeTo(0.0, 0.001));
    });

    test('returns 0.0 for fewer than 3 data points', () {
      expect(engine.pearsonCorrelation([1.0], [2.0]), 0.0);
      expect(engine.pearsonCorrelation([1.0, 2.0], [2.0, 4.0]), 0.0);
    });

    test('returns 0.0 for mismatched lengths', () {
      final result = engine.pearsonCorrelation([1.0, 2.0, 3.0], [1.0, 2.0]);

      expect(result, 0.0);
    });

    test('handles constant values gracefully', () {
      final x = [5.0, 5.0, 5.0];
      final y = [1.0, 2.0, 3.0];

      final result = engine.pearsonCorrelation(x, y);

      expect(result, 0.0);
    });

    test('computes moderate correlation correctly', () {
      final x = [1.0, 2.0, 3.0, 4.0, 5.0];
      final y = [1.0, 3.0, 2.0, 5.0, 4.0];

      final result = engine.pearsonCorrelation(x, y);

      expect(result, greaterThan(0.8));
      expect(result, lessThan(1.0));
    });
  });

  group('symptomPhaseCorrelation', () {
    test('detects phase-specific symptoms', () {
      final days = <CycleDay>[
        _day(dayOfMonth: 1, flow: 3, symptoms: 'cramps'),
        _day(dayOfMonth: 2, flow: 2, symptoms: 'cramps'),
        _day(dayOfMonth: 3, flow: 1, symptoms: 'cramps,headache'),
        _day(dayOfMonth: 4, flow: 1, symptoms: 'cramps'),
        _day(dayOfMonth: 5, flow: 0, symptoms: 'cramps'),
        _day(dayOfMonth: 6, flow: 0, symptoms: 'headache'),
        _day(dayOfMonth: 10, flow: 0),
        _day(dayOfMonth: 14, flow: 0, symptoms: 'headache'),
        _day(dayOfMonth: 15, flow: 0, symptoms: 'bloating'),
        _day(dayOfMonth: 16, flow: 0, symptoms: 'bloating'),
        _day(dayOfMonth: 20, flow: 0),
        _day(dayOfMonth: 25, flow: 0, symptoms: 'bloating'),
      ];

      final result = engine.symptomPhaseCorrelation(
        cycleDays: days,
        symptomId: 'cramps',
      );

      expect(result.isSignificant, isTrue);
      expect(result.mostCommonPhase, 'menstrual');
      expect(result.correlationCoefficient, greaterThan(0.0));
    });

    test('returns low significance with insufficient data', () {
      final days = <CycleDay>[
        _day(dayOfMonth: 1, flow: 3, symptoms: 'cramps'),
        _day(dayOfMonth: 2, flow: 2),
        _day(dayOfMonth: 3, flow: 1),
      ];

      final result = engine.symptomPhaseCorrelation(
        cycleDays: days,
        symptomId: 'cramps',
      );

      expect(result.isSignificant, isFalse);
      expect(result.explanation, contains('Not enough data'));
    });

    test('returns no correlation if symptom logged fewer than 3 times', () {
      final days = <CycleDay>[
        _day(dayOfMonth: 1, flow: 3, symptoms: 'cramps'),
        _day(dayOfMonth: 8, flow: 0, symptoms: 'headache'),
        _day(dayOfMonth: 10, flow: 0, symptoms: 'headache'),
        _day(dayOfMonth: 14, flow: 0, symptoms: 'headache'),
        _day(dayOfMonth: 15, flow: 0, symptoms: 'headache'),
        _day(dayOfMonth: 16, flow: 0, symptoms: 'headache'),
        _day(dayOfMonth: 20, flow: 0),
      ];

      final result = engine.symptomPhaseCorrelation(
        cycleDays: days,
        symptomId: 'cramps',
      );

      expect(result.isSignificant, isFalse);
      expect(result.correlationCoefficient, 0.0);
    });
  });

  group('symptomSymptomCorrelation', () {
    test('detects co-occurrence of related symptoms', () {
      final days = List.generate(20, (i) {
        final day = i + 1;
        String? symptoms;
        if (day >= 1 && day <= 5) {
          symptoms = 'cramps,bloating';
        } else if (day >= 6 && day <= 7) {
          symptoms = 'cramps';
        } else if (day >= 10 && day <= 12) {
          symptoms = 'bloating';
        }
        return _day(dayOfMonth: day, flow: day <= 5 ? 2 : 0, symptoms: symptoms);
      });

      final result = engine.symptomSymptomCorrelation(
        cycleDays: days,
        symptomA: 'cramps',
        symptomB: 'bloating',
      );

      expect(result.isSignificant, isTrue);
      expect(result.correlationCoefficient, greaterThan(0.0));
    });

    test('returns no correlation for unrelated symptoms', () {
      final days = List.generate(20, (i) {
        final day = i + 1;
        return _day(
          dayOfMonth: day,
          flow: 0,
          symptoms: day == 3 ? 'cramps' : (day == 15 ? 'nausea' : null),
        );
      });

      final result = engine.symptomSymptomCorrelation(
        cycleDays: days,
        symptomA: 'cramps',
        symptomB: 'nausea',
      );

      expect(result.isSignificant, isFalse);
    });

    test('returns no correlation with insufficient data', () {
      final days = <CycleDay>[
        _day(dayOfMonth: 1, flow: 3, symptoms: 'cramps'),
        _day(dayOfMonth: 2, flow: 2),
      ];

      final result = engine.symptomSymptomCorrelation(
        cycleDays: days,
        symptomA: 'cramps',
        symptomB: 'headache',
      );

      expect(result.isSignificant, isFalse);
      expect(result.explanation, contains('Not enough data'));
    });

    test('handles one symptom never logged', () {
      final days = List.generate(15, (i) {
        return _day(
          dayOfMonth: i + 1,
          flow: i < 5 ? 2 : 0,
          symptoms: i < 5 ? 'cramps' : null,
        );
      });

      final result = engine.symptomSymptomCorrelation(
        cycleDays: days,
        symptomA: 'cramps',
        symptomB: 'never_logged',
      );

      expect(result.isSignificant, isFalse);
    });
  });

  group('analyzeRegularity', () {
    test('classifies regular cycles correctly', () {
      final cycles = List.generate(6, (i) => _cycle(
        id: 'c$i',
        startDay: 1 + (i * 28),
        endDay: 29 + (i * 28),
        cycleLength: 28,
      ));

      final result = engine.analyzeRegularity(cycles);

      expect(result.regularity, CycleRegularity.regular);
      expect(result.coefficientOfVariation, lessThanOrEqualTo(0.07));
    });

    test('classifies irregular cycles correctly', () {
      final cycles = [
        _cycle(id: 'c1', startDay: 1, endDay: 25, cycleLength: 24),
        _cycle(id: 'c2', startDay: 25, endDay: 61, cycleLength: 36),
        _cycle(id: 'c3', startDay: 61, endDay: 82, cycleLength: 21),
        _cycle(id: 'c4', startDay: 82, endDay: 118, cycleLength: 36),
        _cycle(id: 'c5', startDay: 118, endDay: 148, cycleLength: 30),
      ];

      final result = engine.analyzeRegularity(cycles);

      expect(result.regularity, CycleRegularity.irregular);
      expect(result.coefficientOfVariation, greaterThan(0.15));
    });

    test('returns regular for fewer than 3 cycles', () {
      final cycles = [
        _cycle(id: 'c1', startDay: 1, endDay: 25, cycleLength: 24),
        _cycle(id: 'c2', startDay: 25, endDay: 51, cycleLength: 26),
      ];

      final result = engine.analyzeRegularity(cycles);

      expect(result.regularity, CycleRegularity.regular);
      expect(result.explanation, contains('Track at least 3'));
    });

    test('detects lengthening trend', () {
      final cycles = [
        _cycle(id: 'c1', startDay: 1, endDay: 26, cycleLength: 25),
        _cycle(id: 'c2', startDay: 26, endDay: 54, cycleLength: 28),
        _cycle(id: 'c3', startDay: 54, endDay: 86, cycleLength: 32),
        _cycle(id: 'c4', startDay: 86, endDay: 121, cycleLength: 35),
      ];

      final result = engine.analyzeRegularity(cycles);

      expect(result.trend, 'lengthening');
    });

    test('detects shortening trend', () {
      final cycles = [
        _cycle(id: 'c1', startDay: 1, endDay: 33, cycleLength: 32),
        _cycle(id: 'c2', startDay: 33, endDay: 62, cycleLength: 29),
        _cycle(id: 'c3', startDay: 62, endDay: 88, cycleLength: 26),
        _cycle(id: 'c4', startDay: 88, endDay: 111, cycleLength: 23),
      ];

      final result = engine.analyzeRegularity(cycles);

      expect(result.trend, 'shortening');
    });

    test('filters incomplete cycles', () {
      final cycles = [
        _cycle(id: 'c1', startDay: 1, endDay: 28, cycleLength: 28),
        Cycle(id: 'c2', startDate: DateTime(2025, 1, 29), endDate: null, cycleLength: 0, periodLength: 5),
        _cycle(id: 'c3', startDay: 60, endDay: 88, cycleLength: 28),
      ];

      final result = engine.analyzeRegularity(cycles);

      expect(result.regularity, CycleRegularity.regular);
      expect(result.explanation, contains('2 cycles'));
    });
  });

  group('getMostImpactfulSymptoms', () {
    test('returns symptoms sorted by weighted score', () {
      final days = List.generate(30, (i) {
        final day = i + 1;
        String? symptoms;
        if (day >= 1 && day <= 5) {
          symptoms = '[{"symptomId":"cramps","severity":4},{"symptomId":"bloating","severity":3}]';
        } else if (day >= 10 && day <= 12) {
          symptoms = '[{"symptomId":"headache","severity":2}]';
        } else if (day >= 14 && day <= 16) {
          symptoms = '[{"symptomId":"bloating","severity":1}]';
        }
        return _day(dayOfMonth: day, flow: day <= 5 ? 2 : 0, symptoms: symptoms);
      });

      final cycles = [
        _cycle(id: 'c1', startDay: 1, endDay: 30, days: days),
      ];

      final results = engine.getMostImpactfulSymptoms(cycles, 5);

      expect(results, isNotEmpty);
      expect(results.length, lessThanOrEqualTo(5));
      expect(results[0].impactScore, greaterThanOrEqualTo(results.last.impactScore));
    });

    test('returns empty list for no symptoms', () {
      final days = List.generate(10, (i) => _day(
        dayOfMonth: i + 1,
        flow: 0,
      ));

      final cycles = [
        _cycle(id: 'c1', startDay: 1, endDay: 10, days: days),
      ];

      final results = engine.getMostImpactfulSymptoms(cycles, 5);

      expect(results, isEmpty);
    });

    test('respects limit parameter', () {
      final days = List.generate(15, (i) {
        return _day(
          dayOfMonth: i + 1,
          flow: i < 5 ? 2 : 0,
          symptoms: i < 5
              ? '[{"symptomId":"cramps","severity":3},{"symptomId":"bloating","severity":2}]'
              : null,
        );
      });

      final cycles = [
        _cycle(id: 'c1', startDay: 1, endDay: 15, days: days),
      ];

      final results = engine.getMostImpactfulSymptoms(cycles, 1);

      expect(results.length, 1);
    });

    test('computes average severity from logged values', () {
      final days = List.generate(10, (i) {
        final day = i + 1;
        const highSeverity = '[{"symptomId":"pain","severity":5}]';
        const lowSeverity = '[{"symptomId":"pain","severity":1}]';
        return _day(
          dayOfMonth: day,
          flow: day <= 5 ? 2 : 0,
          symptoms: day <= 5 ? highSeverity : lowSeverity,
        );
      });

      final cycles = [
        _cycle(id: 'c1', startDay: 1, endDay: 10, days: days),
      ];

      final results = engine.getMostImpactfulSymptoms(cycles, 5);

      expect(results.first.averageSeverity, greaterThan(0));
    });
  });

  group('detectTemperatureShift', () {
    test('returns positive shift when recent temps are higher', () {
      final records = List.generate(12, (i) {
        final temp = i < 6 ? 36.3 : 36.6;
        return BBTRecord(
          id: 'r_$i',
          date: DateTime(2025, 1, 1 + i),
          temperature: temp,
        );
      });

      final result = engine.detectTemperatureShift(records);

      expect(result, greaterThan(0.2));
    });

    test('returns 0.0 for fewer than 9 records', () {
      final records = List.generate(8, (i) => BBTRecord(
        id: 'r_$i',
        date: DateTime(2025, 1, 1 + i),
        temperature: 36.5,
      ));

      expect(engine.detectTemperatureShift(records), 0.0);
    });

    test('returns near 0 when temps are stable', () {
      final records = List.generate(12, (i) => BBTRecord(
        id: 'r_$i',
        date: DateTime(2025, 1, 1 + i),
        temperature: 36.5,
      ));

      final result = engine.detectTemperatureShift(records);

      expect(result, lessThan(0.1));
    });
  });

  group('getSymptomSeverityTrend', () {
    test('detects worsening trend', () {
      final entries = [
        SymptomEntry(id: '1', date: DateTime(2025, 1, 1), symptomId: 'pain', symptomName: 'Pain', severity: 1),
        SymptomEntry(id: '2', date: DateTime(2025, 1, 3), symptomId: 'pain', symptomName: 'Pain', severity: 2),
        SymptomEntry(id: '3', date: DateTime(2025, 1, 5), symptomId: 'pain', symptomName: 'Pain', severity: 3),
        SymptomEntry(id: '4', date: DateTime(2025, 1, 7), symptomId: 'pain', symptomName: 'Pain', severity: 4),
        SymptomEntry(id: '5', date: DateTime(2025, 1, 9), symptomId: 'pain', symptomName: 'Pain', severity: 5),
      ];

      final trend = engine.getSymptomSeverityTrend(entries);

      expect(trend.direction, TrendDirection.worsening);
      expect(trend.slope, greaterThan(0));
    });

    test('detects improving trend', () {
      final entries = [
        SymptomEntry(id: '1', date: DateTime(2025, 1, 1), symptomId: 'pain', symptomName: 'Pain', severity: 5),
        SymptomEntry(id: '2', date: DateTime(2025, 1, 3), symptomId: 'pain', symptomName: 'Pain', severity: 4),
        SymptomEntry(id: '3', date: DateTime(2025, 1, 5), symptomId: 'pain', symptomName: 'Pain', severity: 3),
        SymptomEntry(id: '4', date: DateTime(2025, 1, 7), symptomId: 'pain', symptomName: 'Pain', severity: 2),
      ];

      final trend = engine.getSymptomSeverityTrend(entries);

      expect(trend.direction, TrendDirection.improving);
      expect(trend.slope, lessThan(0));
    });

    test('returns stable for fewer than 4 entries', () {
      final entries = List.generate(3, (i) => SymptomEntry(
        id: '$i',
        date: DateTime(2025, 1, 1 + i),
        symptomId: 'pain',
        symptomName: 'Pain',
        severity: 3,
      ));

      final trend = engine.getSymptomSeverityTrend(entries);

      expect(trend.direction, TrendDirection.stable);
      expect(trend.slope, 0.0);
    });
  });
}
