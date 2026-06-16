import 'dart:math';

import 'package:cyra/features/cycle/models/cycle.dart';

class CyclePredictor {
  /// Predicts next period date based on cycle history.
  /// Uses weighted moving average with more recent cycles weighted higher.
  PredictionResult predictNextPeriod({
    required List<Cycle> cycleHistory,
    DateTime? referenceDate,
  }) {
    final refDate = referenceDate ?? DateTime.now();

    final completed = cycleHistory
        .where((c) => c.endDate != null && c.cycleLength > 0)
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    if (completed.length < 3) {
      final fallbackDate = refDate.add(const Duration(days: 28));
      return PredictionResult(
        predictedDate: fallbackDate,
        confidenceScore: 0.0,
        variabilityScore: 0.0,
        predictionRangeStart: fallbackDate.subtract(const Duration(days: 7)),
        predictionRangeEnd: fallbackDate.add(const Duration(days: 7)),
        explanation: completed.isEmpty
            ? 'Track at least 3 cycles to receive a prediction.'
            : 'Track ${3 - completed.length} more cycle(s) for a reliable prediction.',
      );
    }

    final lengths = completed.map((c) => c.cycleLength).toList();
    final n = lengths.length;

    double weightedSum = 0;
    double weightTotal = 0;
    for (int i = 0; i < n; i++) {
      final weight = i >= n - 3 ? 2.0 : 1.0;
      weightedSum += lengths[i] * weight;
      weightTotal += weight;
    }
    final averageLength = weightedSum / weightTotal;

    final mean = lengths.fold<int>(0, (a, b) => a + b) / n;
    final variance =
        lengths.fold<double>(0, (a, b) => a + pow(b - mean, 2)) / n;
    final stdDev = sqrt(variance);
    final variabilityScore = mean > 0 ? stdDev / mean : 0.0;

    final confidence = calculateConfidence(n, variabilityScore);

    final lastPeriodStart = completed.last.startDate;
    final predictedDate = lastPeriodStart
        .add(Duration(days: averageLength.round()));

    final rangeDays = (stdDev * 1.5).round().clamp(1, 14);
    final rangeStart = predictedDate.subtract(Duration(days: rangeDays));
    final rangeEnd = predictedDate.add(Duration(days: rangeDays));

    final explanation = generateExplanation(
      trackedCycles: n,
      averageLength: averageLength,
      variabilityScore: variabilityScore,
      confidence: confidence,
    );

    return PredictionResult(
      predictedDate: predictedDate,
      confidenceScore: confidence,
      variabilityScore: variabilityScore,
      predictionRangeStart: rangeStart,
      predictionRangeEnd: rangeEnd,
      explanation: explanation,
    );
  }

  /// Calculates current cycle phase for a given cycle day.
  CyclePhase getCyclePhase(int cycleDay, int cycleLength) {
    final lutealPhaseDays = 14;
    final ovulationDay = cycleLength - lutealPhaseDays;
    final periodLength = 5;

    if (cycleDay <= periodLength) {
      return CyclePhase.menstrual;
    } else if (cycleDay < ovulationDay - 1) {
      return CyclePhase.follicular;
    } else if (cycleDay >= ovulationDay - 1 && cycleDay <= ovulationDay + 1) {
      return CyclePhase.ovulation;
    } else {
      return CyclePhase.luteal;
    }
  }

  /// Detects if a cycle is irregular based on variability.
  bool isIrregular(double variabilityScore) {
    return variabilityScore > 0.15;
  }

  /// Calculate fertile window for a given cycle.
  /// Uses standard fertility awareness: ovulation ~14 days before next period,
  /// fertile window is 5 days before ovulation + ovulation day.
  (DateTime start, DateTime end) getFertileWindow(
    DateTime periodStart,
    int cycleLength,
  ) {
    final ovulationDay = cycleLength - 14;
    final ovulationDate = periodStart.add(Duration(days: ovulationDay));
    final fertileStart = ovulationDate.subtract(const Duration(days: 5));
    return (fertileStart, ovulationDate);
  }

  /// Generate human-readable explanation for prediction.
  String generateExplanation({
    required int trackedCycles,
    required double averageLength,
    required double variabilityScore,
    required double confidence,
    String? currentPhase,
  }) {
    final avgRounded = averageLength.round();
    final isIrreg = isIrregular(variabilityScore);
    final confidencePercent = (confidence * 100).round();

    final buffer = StringBuffer();
    buffer.write(
      'Based on your last $trackedCycles cycles, '
      'your cycle length averages $avgRounded days.',
    );

    if (isIrreg) {
      buffer.write(
        ' Your cycles show some variation, '
        'which is normal but may affect prediction accuracy.',
      );
    }

    if (currentPhase != null) {
      buffer.write(
        ' Your current symptoms suggest the $currentPhase '
        'phase is progressing normally.',
      );
    }

    buffer.write(' Confidence: $confidencePercent%.');
    return buffer.toString();
  }

  /// Calculate confidence based on number of cycles and variability.
  double calculateConfidence(int cycleCount, double variability) {
    if (cycleCount < 3) return 0.0;

    final countFactor = (cycleCount / 12).clamp(0.0, 1.0);
    final variabilityFactor = (1 - variability).clamp(0.0, 1.0);
    final raw = countFactor * variabilityFactor * 1.2;
    return raw.clamp(0.0, 0.95);
  }
}
