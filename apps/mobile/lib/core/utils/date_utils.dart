import 'package:intl/intl.dart';
import 'package:cyra/core/constants/cycle_constants.dart';

class CycleDateUtils {
  CycleDateUtils._();

  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayFormat = DateFormat('MMM d, yyyy');
  static final DateFormat _shortFormat = DateFormat('MMM d');

  static String formatDate(DateTime date) => _displayFormat.format(date);
  static String formatShort(DateTime date) => _shortFormat.format(date);
  static String formatIso(DateTime date) => _dateFormat.format(date);

  static DateTime getStartOfCycle(int cycleDay, DateTime periodStart) {
    return periodStart.add(Duration(days: cycleDay - 1));
  }

  static int getCycleDay(DateTime date, DateTime periodStart) {
    final diff = date.startOfDay.difference(periodStart.startOfDay).inDays;
    return diff < 0 ? 0 : diff + 1;
  }

  static DateTime calculateDueDate(DateTime lastPeriodStart, {int cycleLength = 28}) {
    final gestationalAge = cycleLength - CycleConstants.averageCycleLength;
    final adjustedLmp = lastPeriodStart.subtract(Duration(days: gestationalAge));
    return DateTime(
      adjustedLmp.year,
      adjustedLmp.month + 9,
      adjustedLmp.day + 7,
    );
  }

  static DateTime calculateOvulationDate(DateTime lastPeriodStart, {int cycleLength = 28}) {
    final predictedNextPeriod = lastPeriodStart.add(Duration(days: cycleLength));
    return predictedNextPeriod.subtract(const Duration(days: 14));
  }

  static int getTrimester(int week) {
    if (week < 1) return 0;
    if (week <= 13) return 1;
    if (week <= 27) return 2;
    if (week <= 42) return 3;
    return 0;
  }

  static int getWeekOfPregnancy(DateTime dueDate) {
    final now = DateTime.now();
    final daysUntilDue = now.startOfDay.daysUntil(dueDate.startOfDay);
    final totalDays = 280;
    final daysPregnant = totalDays - daysUntilDue;
    if (daysPregnant < 0) return 0;
    return (daysPregnant / 7).floor() + 1;
  }

  static String weekToSizeComparison(int week) {
    const comparisons = <int, String>{
      4: 'Poppy seed',
      5: 'Sesame seed',
      6: 'Lentil',
      7: 'Blueberry',
      8: 'Raspberry',
      9: 'Grape',
      10: 'Kumquat',
      11: 'Fig',
      12: 'Lime',
      13: 'Pea pod',
      14: 'Lemon',
      15: 'Apple',
      16: 'Avocado',
      17: 'Pear',
      18: 'Bell pepper',
      19: 'Mango',
      20: 'Banana',
      21: 'Carrot',
      22: 'Papaya',
      23: 'Grapefruit',
      24: 'Ear of corn',
      25: 'Rutabaga',
      26: 'Zucchini',
      27: 'Cauliflower',
      28: 'Eggplant',
      29: 'Butternut squash',
      30: 'Cabbage',
      31: 'Coconut',
      32: 'Jicama',
      33: 'Pineapple',
      34: 'Cantaloupe',
      35: 'Honeydew',
      36: 'Romaine lettuce',
      37: 'Swiss chard',
      38: 'Rhubarb',
      39: 'Mini watermelon',
      40: 'Watermelon',
    };

    return comparisons[week] ?? 'Unknown';
  }

  static bool isInFertileWindow(int cycleDay, int cycleLength) {
    final ovulationDay = cycleLength - 14;
    final fertileStart = ovulationDay - 5;
    final fertileEnd = ovulationDay + 1;
    return cycleDay >= fertileStart && cycleDay <= fertileEnd;
  }

  static double calculateConfidence(int trackedCycles, double variability) {
    if (trackedCycles < CycleConstants.minCyclesForPrediction) return 0.0;

    final cycleScore = (trackedCycles / CycleConstants.maxTrackedCyclesForPrediction).clamp(0.0, 1.0);
    final variabilityScore = (1.0 - (variability / 14.0)).clamp(0.0, 1.0);
    final confidence = (cycleScore * 0.5) + (variabilityScore * 0.5);

    return (confidence * 100).roundToDouble();
  }

  static double calculateCycleVariability(List<int> cycleLengths) {
    if (cycleLengths.length < 2) return 7.0;

    final mean = cycleLengths.reduce((a, b) => a + b) / cycleLengths.length;
    final variance = cycleLengths.fold<double>(0.0, (sum, len) => sum + (len - mean) * (len - mean)) / cycleLengths.length;

    return variance.isNaN ? 7.0 : variance;
  }

  static double getFertilityProbability(int cycleDay, int cycleLength, {int trackedCycles = 0, double variability = 7.0}) {
    final confidence = calculateConfidence(trackedCycles, variability);
    final inWindow = isInFertileWindow(cycleDay, cycleLength);

    if (!inWindow) return 0.0;

    final ovulationDay = cycleLength - 14;
    final distanceFromOvulation = (cycleDay - ovulationDay).abs();

    final baseProbability = switch (distanceFromOvulation) {
      0 => 0.30,
      1 => 0.25,
      2 => 0.20,
      3 => 0.15,
      4 => 0.10,
      5 => 0.05,
      _ => 0.0,
    };

    return baseProbability * (confidence / 100.0);
  }

  static String describeFertilityProbability(double probability) {
    if (probability >= 0.25) return 'Peak';
    if (probability >= 0.15) return 'High';
    if (probability >= 0.05) return 'Medium';
    if (probability > 0.0) return 'Low';
    return 'Not fertile';
  }
}

extension DateTimeCycle on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  int daysUntil(DateTime other) => other.startOfDay.difference(startOfDay).inDays;

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
