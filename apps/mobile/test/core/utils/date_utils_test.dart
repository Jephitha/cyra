import 'package:flutter_test/flutter_test.dart';
import 'package:cyra/core/utils/date_utils.dart';

void main() {
  group('CycleDateUtils', () {
    group('getCycleDay', () {
      test('returns 1 for the period start date', () {
        final periodStart = DateTime(2025, 1, 1);
        expect(CycleDateUtils.getCycleDay(DateTime(2025, 1, 1), periodStart), 1);
      });

      test('returns correct day for dates after period start', () {
        final periodStart = DateTime(2025, 1, 1);
        expect(CycleDateUtils.getCycleDay(DateTime(2025, 1, 10), periodStart), 10);
        expect(CycleDateUtils.getCycleDay(DateTime(2025, 1, 28), periodStart), 28);
      });

      test('returns 0 for dates before period start', () {
        final periodStart = DateTime(2025, 1, 15);
        expect(CycleDateUtils.getCycleDay(DateTime(2025, 1, 10), periodStart), 0);
        expect(CycleDateUtils.getCycleDay(DateTime(2025, 1, 1), periodStart), 0);
      });

      test('handles cross-month cycles', () {
        final periodStart = DateTime(2025, 1, 28);
        expect(CycleDateUtils.getCycleDay(DateTime(2025, 2, 1), periodStart), 5);
        expect(CycleDateUtils.getCycleDay(DateTime(2025, 2, 10), periodStart), 14);
      });
    });

    group('calculateDueDate', () {
      test('returns correct due date for 28-day cycle (Naegele\'s rule)', () {
        final lmp = DateTime(2025, 1, 1);
        final dueDate = CycleDateUtils.calculateDueDate(lmp);

        expect(dueDate.year, 2025);
        expect(dueDate.month, 10);
        expect(dueDate.day, 8);
      });

      test('adjusts for shorter cycles', () {
        final lmp = DateTime(2025, 1, 1);
        final dueDate = CycleDateUtils.calculateDueDate(lmp, cycleLength: 21);

        final daysDiff = dueDate.difference(DateTime(2025, 10, 8)).inDays;
        expect(daysDiff, 7);
      });

      test('adjusts for longer cycles', () {
        final lmp = DateTime(2025, 1, 1);
        final dueDate = CycleDateUtils.calculateDueDate(lmp, cycleLength: 35);

        // gestationalAge = 35 - 28 = 7, adjustedLmp = Dec 25 2024
        // dueDate = DateTime(2024, 21, 32) → Oct 2, 2025
        // Oct 2 - Oct 8 = -6 days
        final daysDiff = dueDate.difference(DateTime(2025, 10, 8)).inDays;
        expect(daysDiff, -6);
      });
    });

    group('calculateOvulationDate', () {
      test('returns correct date for 28-day cycle', () {
        final lmp = DateTime(2025, 1, 1);
        final ovulation = CycleDateUtils.calculateOvulationDate(lmp);

        expect(ovulation, DateTime(2025, 1, 15));
      });

      test('returns correct date for 35-day cycle', () {
        final lmp = DateTime(2025, 1, 1);
        final ovulation = CycleDateUtils.calculateOvulationDate(lmp, cycleLength: 35);

        expect(ovulation, DateTime(2025, 1, 22));
      });

      test('returns correct date for 21-day cycle', () {
        final lmp = DateTime(2025, 1, 1);
        final ovulation = CycleDateUtils.calculateOvulationDate(lmp, cycleLength: 21);

        expect(ovulation, DateTime(2025, 1, 8));
      });
    });

    group('getTrimester', () {
      test('returns 0 for invalid weeks', () {
        expect(CycleDateUtils.getTrimester(0), 0);
        expect(CycleDateUtils.getTrimester(-1), 0);
        expect(CycleDateUtils.getTrimester(43), 0);
      });

      test('returns 1 for weeks 1-13', () {
        expect(CycleDateUtils.getTrimester(1), 1);
        expect(CycleDateUtils.getTrimester(13), 1);
        expect(CycleDateUtils.getTrimester(7), 1);
      });

      test('returns 2 for weeks 14-27', () {
        expect(CycleDateUtils.getTrimester(14), 2);
        expect(CycleDateUtils.getTrimester(27), 2);
        expect(CycleDateUtils.getTrimester(20), 2);
      });

      test('returns 3 for weeks 28-42', () {
        expect(CycleDateUtils.getTrimester(28), 3);
        expect(CycleDateUtils.getTrimester(42), 3);
        expect(CycleDateUtils.getTrimester(35), 3);
      });
    });

    group('isInFertileWindow', () {
      test('returns true for days 9-15 in a 28-day cycle', () {
        expect(CycleDateUtils.isInFertileWindow(9, 28), isTrue);
        expect(CycleDateUtils.isInFertileWindow(12, 28), isTrue);
        expect(CycleDateUtils.isInFertileWindow(15, 28), isTrue);
      });

      test('returns false for days outside fertile window', () {
        expect(CycleDateUtils.isInFertileWindow(1, 28), isFalse);
        expect(CycleDateUtils.isInFertileWindow(8, 28), isFalse);
        expect(CycleDateUtils.isInFertileWindow(16, 28), isFalse);
        expect(CycleDateUtils.isInFertileWindow(28, 28), isFalse);
      });

      test('adjusts for different cycle lengths', () {
        expect(CycleDateUtils.isInFertileWindow(16, 35), isTrue);
        expect(CycleDateUtils.isInFertileWindow(22, 35), isTrue);
        expect(CycleDateUtils.isInFertileWindow(15, 35), isFalse);
        expect(CycleDateUtils.isInFertileWindow(23, 35), isFalse);
      });

      test('adjusts for short cycle', () {
        expect(CycleDateUtils.isInFertileWindow(2, 21), isTrue);
        expect(CycleDateUtils.isInFertileWindow(8, 21), isTrue);
        expect(CycleDateUtils.isInFertileWindow(1, 21), isFalse);
        expect(CycleDateUtils.isInFertileWindow(9, 21), isFalse);
      });
    });

    group('calculateConfidence', () {
      test('returns 0 when fewer than min cycles', () {
        final result = CycleDateUtils.calculateConfidence(2, 3.0);
        expect(result, 0.0);
      });

      test('returns higher confidence with more cycles', () {
        final low = CycleDateUtils.calculateConfidence(3, 3.0);
        final high = CycleDateUtils.calculateConfidence(12, 3.0);
        expect(high, greaterThan(low));
      });

      test('returns higher confidence with lower variability', () {
        final highVar = CycleDateUtils.calculateConfidence(6, 14.0);
        final lowVar = CycleDateUtils.calculateConfidence(6, 1.0);
        expect(lowVar, greaterThan(highVar));
      });

      test('returns a percentage between 0 and 100', () {
        final result = CycleDateUtils.calculateConfidence(6, 3.0);
        expect(result, greaterThan(0));
        expect(result, lessThanOrEqualTo(100));
      });
    });

    group('calculateCycleVariability', () {
      test('returns 7.0 for fewer than 2 cycles', () {
        expect(CycleDateUtils.calculateCycleVariability([28]), 7.0);
        expect(CycleDateUtils.calculateCycleVariability([]), 7.0);
      });

      test('returns 0 for identical cycle lengths', () {
        expect(CycleDateUtils.calculateCycleVariability([28, 28, 28]), 0.0);
      });

      test('returns positive for varying lengths', () {
        final variance = CycleDateUtils.calculateCycleVariability([25, 28, 31]);
        expect(variance, greaterThan(0));
      });
    });

    group('getFertilityProbability', () {
      test('returns 0 outside fertile window', () {
        final prob = CycleDateUtils.getFertilityProbability(1, 28);
        expect(prob, 0.0);
      });

      test('returns positive probability inside fertile window', () {
        final prob = CycleDateUtils.getFertilityProbability(14, 28, trackedCycles: 6, variability: 3.0);
        expect(prob, greaterThan(0));
      });

      test('probability decreases further from ovulation', () {
        final atOvulation = CycleDateUtils.getFertilityProbability(14, 28, trackedCycles: 12, variability: 1.0);
        final farFromOvulation = CycleDateUtils.getFertilityProbability(9, 28, trackedCycles: 12, variability: 1.0);
        expect(atOvulation, greaterThan(farFromOvulation));
      });

      test('probability scales with confidence', () {
        final lowConfidence = CycleDateUtils.getFertilityProbability(14, 28, trackedCycles: 3, variability: 10.0);
        final highConfidence = CycleDateUtils.getFertilityProbability(14, 28, trackedCycles: 12, variability: 1.0);
        expect(highConfidence, greaterThan(lowConfidence));
      });
    });

    group('describeFertilityProbability', () {
      test('returns Peak for probability >= 0.25', () {
        expect(CycleDateUtils.describeFertilityProbability(0.30), 'Peak');
        expect(CycleDateUtils.describeFertilityProbability(0.25), 'Peak');
      });

      test('returns High for probability >= 0.15', () {
        expect(CycleDateUtils.describeFertilityProbability(0.20), 'High');
        expect(CycleDateUtils.describeFertilityProbability(0.15), 'High');
      });

      test('returns Medium for probability >= 0.05', () {
        expect(CycleDateUtils.describeFertilityProbability(0.10), 'Medium');
        expect(CycleDateUtils.describeFertilityProbability(0.05), 'Medium');
      });

      test('returns Low for probability > 0.0', () {
        expect(CycleDateUtils.describeFertilityProbability(0.01), 'Low');
        expect(CycleDateUtils.describeFertilityProbability(0.04), 'Low');
      });

      test('returns Not fertile for 0.0', () {
        expect(CycleDateUtils.describeFertilityProbability(0.0), 'Not fertile');
      });
    });

    group('formatDate', () {
      test('formats date correctly', () {
        final date = DateTime(2025, 6, 15);
        expect(CycleDateUtils.formatDate(date), 'Jun 15, 2025');
      });
    });

    group('formatShort', () {
      test('formats short date correctly', () {
        final date = DateTime(2025, 6, 15);
        expect(CycleDateUtils.formatShort(date), 'Jun 15');
      });
    });

    group('formatIso', () {
      test('formats ISO date correctly', () {
        final date = DateTime(2025, 6, 15);
        expect(CycleDateUtils.formatIso(date), '2025-06-15');
      });
    });

    group('getStartOfCycle', () {
      test('returns correct date for cycle day', () {
        final start = CycleDateUtils.getStartOfCycle(10, DateTime(2025, 1, 1));
        expect(start, DateTime(2025, 1, 10));
      });
    });

    group('getWeekOfPregnancy', () {
      test('returns large week number for past due date', () {
        // Due date far in the past means daysPregnant is very large
        // (280 minus a large negative daysUntilDue).
        // The algorithm does not cap at 0 for past-due dates.
        final dueDate = DateTime(2024, 1, 1);
        final week = CycleDateUtils.getWeekOfPregnancy(dueDate);
        expect(week, greaterThan(40));
      });
    });

    group('weekToSizeComparison', () {
      test('returns correct size for known weeks', () {
        expect(CycleDateUtils.weekToSizeComparison(4), 'Poppy seed');
        expect(CycleDateUtils.weekToSizeComparison(20), 'Banana');
        expect(CycleDateUtils.weekToSizeComparison(40), 'Watermelon');
      });

      test('returns Unknown for invalid week', () {
        expect(CycleDateUtils.weekToSizeComparison(50), 'Unknown');
      });
    });
  });
}
