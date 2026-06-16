import 'package:flutter_test/flutter_test.dart';
import 'package:cyra/core/prediction/cycle_predictor.dart';
import 'package:cyra/features/cycle/models/cycle.dart';

void main() {
  group('CyclePredictor', () {
    late CyclePredictor predictor;

    setUp(() {
      predictor = CyclePredictor();
    });

    group('predictNextPeriod', () {
      test('returns prediction for regular cycles with high confidence', () {
        final cycles = List.generate(6, (i) => Cycle(
          id: 'cycle_$i',
          startDate: DateTime(2025, 1, 1 + (i * 28)),
          endDate: DateTime(2025, 1, 29 + (i * 28)),
          cycleLength: 28,
          periodLength: 5,
        ));

        final result = predictor.predictNextPeriod(cycleHistory: cycles);

        expect(result.predictedDate, isNotNull);
        expect(result.confidenceScore, greaterThan(0.5));
        expect(result.explanation, contains('6 cycles'));
        expect(result.explanation, contains('28 days'));
      });

      test('returns low confidence for fewer than 3 cycles', () {
        final cycles = List.generate(2, (i) => Cycle(
          id: 'cycle_$i',
          startDate: DateTime(2025, 1, 1 + (i * 28)),
          endDate: DateTime(2025, 1, 29 + (i * 28)),
          cycleLength: 28,
          periodLength: 5,
        ));

        final result = predictor.predictNextPeriod(cycleHistory: cycles);

        expect(result.confidenceScore, lessThan(0.5));
        expect(result.explanation, contains('1 more cycle'));
      });

      test('returns fallback prediction for no cycles', () {
        final result = predictor.predictNextPeriod(cycleHistory: []);

        expect(result.confidenceScore, 0.0);
        expect(result.explanation, contains('Track at least 3 cycles'));
      });

      test('returns wide range for high variability', () {
        final cycles = [
          Cycle(id: '1', startDate: DateTime(2025, 1, 1), endDate: DateTime(2025, 1, 29), cycleLength: 28, periodLength: 5),
          Cycle(id: '2', startDate: DateTime(2025, 1, 29), endDate: DateTime(2025, 3, 5), cycleLength: 35, periodLength: 5),
          Cycle(id: '3', startDate: DateTime(2025, 3, 5), endDate: DateTime(2025, 3, 30), cycleLength: 25, periodLength: 5),
          Cycle(id: '4', startDate: DateTime(2025, 3, 30), endDate: DateTime(2025, 4, 28), cycleLength: 29, periodLength: 5),
          Cycle(id: '5', startDate: DateTime(2025, 4, 28), endDate: DateTime(2025, 6, 1), cycleLength: 34, periodLength: 5),
        ];

        final result = predictor.predictNextPeriod(cycleHistory: cycles);

        expect(
          result.predictionRangeEnd.difference(result.predictionRangeStart).inDays,
          greaterThan(3),
        );
        expect(result.confidenceScore, lessThan(0.8));
      });

      test('uses weighted average favoring recent cycles', () {
        final recent28 = Cycle(id: '1', startDate: DateTime(2025, 5, 1), endDate: DateTime(2025, 5, 29), cycleLength: 28, periodLength: 5);
        final recent35 = Cycle(id: '2', startDate: DateTime(2025, 5, 29), endDate: DateTime(2025, 7, 3), cycleLength: 35, periodLength: 5);
        final recent25 = Cycle(id: '3', startDate: DateTime(2025, 7, 3), endDate: DateTime(2025, 7, 28), cycleLength: 25, periodLength: 5);
        final recent30 = Cycle(id: '4', startDate: DateTime(2025, 7, 28), endDate: DateTime(2025, 8, 27), cycleLength: 30, periodLength: 5);
        final recent32 = Cycle(id: '5', startDate: DateTime(2025, 8, 27), endDate: DateTime(2025, 9, 28), cycleLength: 32, periodLength: 5);
        final recent28b = Cycle(id: '6', startDate: DateTime(2025, 9, 28), endDate: DateTime(2025, 10, 26), cycleLength: 28, periodLength: 5);

        final cycles = [recent28, recent35, recent25, recent30, recent32, recent28b];

        final result = predictor.predictNextPeriod(cycleHistory: cycles);

        expect(result.predictedDate, isNotNull);
        expect(result.confidenceScore, greaterThan(0));
      });

      test('uses reference date when provided', () {
        final cycles = List.generate(3, (i) => Cycle(
          id: 'cycle_$i',
          startDate: DateTime(2025, 1, 1 + (i * 28)),
          endDate: DateTime(2025, 1, 29 + (i * 28)),
          cycleLength: 28,
          periodLength: 5,
        ));

        final refDate = DateTime(2025, 6, 1);
        final result = predictor.predictNextPeriod(
          cycleHistory: cycles,
          referenceDate: refDate,
        );

        expect(result.predictedDate, isNotNull);
      });

      test('filters incomplete cycles', () {
        final cycles = [
          Cycle(id: '1', startDate: DateTime(2025, 1, 1), endDate: DateTime(2025, 1, 29), cycleLength: 28, periodLength: 5),
          Cycle(id: '2', startDate: DateTime(2025, 1, 29), endDate: null, cycleLength: 0, periodLength: 5),
          Cycle(id: '3', startDate: DateTime(2025, 3, 5), endDate: DateTime(2025, 4, 2), cycleLength: 28, periodLength: 5),
        ];

        final result = predictor.predictNextPeriod(cycleHistory: cycles);

        // Only 2 completed cycles (cycle with null endDate is filtered out),
        // so confidence is 0.0 and explanation asks for more cycles.
        expect(result.confidenceScore, 0.0);
        expect(result.explanation, contains('1 more cycle'));
      });
    });

    group('getCyclePhase', () {
      test('returns correct phase for each day of a 28-day cycle', () {
        // ovulationDay = 28 - 14 = 14; ovulation window = [13, 15]
        expect(predictor.getCyclePhase(1, 28), CyclePhase.menstrual);
        expect(predictor.getCyclePhase(3, 28), CyclePhase.menstrual);
        expect(predictor.getCyclePhase(5, 28), CyclePhase.menstrual);
        expect(predictor.getCyclePhase(6, 28), CyclePhase.follicular);
        expect(predictor.getCyclePhase(12, 28), CyclePhase.follicular);
        expect(predictor.getCyclePhase(13, 28), CyclePhase.ovulation);
        expect(predictor.getCyclePhase(14, 28), CyclePhase.ovulation);
        expect(predictor.getCyclePhase(16, 28), CyclePhase.luteal);
        expect(predictor.getCyclePhase(28, 28), CyclePhase.luteal);
      });

      test('returns correct phases for a short cycle', () {
        // ovulationDay = 21 - 14 = 7; ovulation window = [6, 8]
        expect(predictor.getCyclePhase(1, 21), CyclePhase.menstrual);
        expect(predictor.getCyclePhase(5, 21), CyclePhase.menstrual);
        expect(predictor.getCyclePhase(6, 21), CyclePhase.ovulation);
        expect(predictor.getCyclePhase(7, 21), CyclePhase.ovulation);
        expect(predictor.getCyclePhase(9, 21), CyclePhase.luteal);
        expect(predictor.getCyclePhase(21, 21), CyclePhase.luteal);
      });

      test('returns correct phases for a long cycle', () {
        expect(predictor.getCyclePhase(1, 35), CyclePhase.menstrual);
        expect(predictor.getCyclePhase(6, 35), CyclePhase.follicular);
        expect(predictor.getCyclePhase(21, 35), CyclePhase.ovulation);
        expect(predictor.getCyclePhase(23, 35), CyclePhase.luteal);
        expect(predictor.getCyclePhase(35, 35), CyclePhase.luteal);
      });
    });

    group('isIrregular', () {
      test('returns false for low variability', () {
        expect(predictor.isIrregular(0.05), isFalse);
        expect(predictor.isIrregular(0.10), isFalse);
      });

      test('returns true for high variability', () {
        expect(predictor.isIrregular(0.16), isTrue);
        expect(predictor.isIrregular(0.30), isTrue);
        expect(predictor.isIrregular(0.50), isTrue);
      });

      test('returns false at exactly the threshold boundary', () {
        expect(predictor.isIrregular(0.15), isFalse);
      });
    });

    group('calculateConfidence', () {
      test('increases with more cycles', () {
        // calculateConfidence(n, v) = ((n/12) * (1-v) * 1.2).clamp(0, 0.95)
        // 3 cycles: (0.25 * 0.95 * 1.2) = 0.285
        // 6 cycles: (0.50 * 0.95 * 1.2) = 0.57
        // 12 cycles: (1.0 * 0.95 * 1.2) = 0.95 (clamped)
        expect(predictor.calculateConfidence(3, 0.05), greaterThan(0.2));
        expect(predictor.calculateConfidence(6, 0.05), greaterThan(0.5));
        expect(predictor.calculateConfidence(12, 0.05), greaterThan(0.9));
      });

      test('returns zero for fewer than 3 cycles', () {
        expect(predictor.calculateConfidence(2, 0.05), 0.0);
        expect(predictor.calculateConfidence(1, 0.05), 0.0);
        expect(predictor.calculateConfidence(0, 0.05), 0.0);
      });

      test('decreases with higher variability', () {
        final lowVar = predictor.calculateConfidence(6, 0.05);
        final highVar = predictor.calculateConfidence(6, 0.30);
        expect(lowVar, greaterThan(highVar));
      });

      test('caps at 0.95 maximum', () {
        final confidence = predictor.calculateConfidence(24, 0.01);
        expect(confidence, lessThanOrEqualTo(0.95));
      });
    });

    group('getFertileWindow', () {
      test('returns correct window for a 28-day cycle', () {
        final (start, end) = predictor.getFertileWindow(
          DateTime(2025, 1, 1),
          28,
        );

        // ovulationDay = 14, ovulationDate = Jan 15, fertileStart = Jan 10
        expect(start, DateTime(2025, 1, 10));
        expect(end, DateTime(2025, 1, 15));
      });

      test('returns correct window for a 35-day cycle', () {
        final (start, end) = predictor.getFertileWindow(
          DateTime(2025, 1, 1),
          35,
        );

        // ovulationDay = 21, ovulationDate = Jan 22, fertileStart = Jan 17
        expect(start, DateTime(2025, 1, 17));
        expect(end, DateTime(2025, 1, 22));
      });

      test('returns correct window for a 21-day cycle', () {
        final (start, end) = predictor.getFertileWindow(
          DateTime(2025, 1, 1),
          21,
        );

        // ovulationDay = 7, ovulationDate = Jan 8, fertileStart = Jan 3
        expect(start, DateTime(2025, 1, 3));
        expect(end, DateTime(2025, 1, 8));
      });
    });

    group('generateExplanation', () {
      test('includes cycle count and average length', () {
        final text = predictor.generateExplanation(
          trackedCycles: 6,
          averageLength: 28,
          variabilityScore: 0.05,
          confidence: 0.85,
        );

        expect(text, contains('6 cycles'));
        expect(text, contains('28 days'));
        expect(text, contains('85%'));
      });

      test('includes variability note for irregular cycles', () {
        final text = predictor.generateExplanation(
          trackedCycles: 6,
          averageLength: 29,
          variabilityScore: 0.20,
          confidence: 0.5,
        );

        expect(text, contains('variation'));
      });

      test('includes current phase when provided', () {
        final text = predictor.generateExplanation(
          trackedCycles: 6,
          averageLength: 28,
          variabilityScore: 0.05,
          confidence: 0.85,
          currentPhase: 'luteal',
        );

        expect(text, contains('luteal'));
      });

      test('omits variation note for regular cycles', () {
        final text = predictor.generateExplanation(
          trackedCycles: 6,
          averageLength: 28,
          variabilityScore: 0.05,
          confidence: 0.85,
        );

        expect(text, isNot(contains('variation')));
        expect(text, isNot(contains('variability')));
      });
    });
  });
}
