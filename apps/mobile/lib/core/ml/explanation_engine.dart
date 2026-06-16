import 'package:cyra/core/ml/correlation_engine.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';

class ExplanationEngine {
  String explainPeriodPrediction(PredictionResult prediction, CycleSummary summary) {
    final predictedDay = _formatDate(prediction.predictedDate);
    final rangeStart = _formatDate(prediction.predictionRangeStart);
    final rangeEnd = _formatDate(prediction.predictionRangeEnd);
    final confidence = (prediction.confidenceScore * 100).round();
    final avgLength = summary.averageLength.round();

    final buffer = StringBuffer();
    buffer.write(
      'Based on your last ${summary.cycleCount} cycles, '
      'your cycle length averages $avgLength days.',
    );

    if (prediction.confidenceScore >= 0.7) {
      buffer.write(
        ' Your next period is predicted to start around $predictedDay, '
        'likely between $rangeStart and $rangeEnd.',
      );
    } else if (prediction.confidenceScore >= 0.4) {
      buffer.write(
        ' The estimated date for your next period is $predictedDay, '
        'with a range of $rangeStart to $rangeEnd.',
      );
    } else {
      buffer.write(
        ' Based on available data, a rough estimate for your next period '
        'is around $predictedDay, though this may vary.',
      );
    }

    buffer.write(
      ' Confidence: $confidence%. '
      '${_confidenceNote(prediction.confidenceScore)}',
    );
    return buffer.toString();
  }

  String explainSymptomCorrelation(CorrelationResult correlation) {
    final strength = correlation.correlationCoefficient.abs() > 0.7
        ? 'strong'
        : correlation.correlationCoefficient.abs() > 0.4
            ? 'moderate'
            : correlation.correlationCoefficient.abs() > 0.2
                ? 'weak'
                : 'very weak';

    if (correlation.mostCommonPhase.isNotEmpty) {
      return correlation.explanation.isNotEmpty
          ? correlation.explanation
          : 'You tend to experience this most often during the '
              '${correlation.mostCommonPhase} phase. '
              'There is a $strength association with your cycle.';
    }

    return correlation.explanation.isNotEmpty
        ? correlation.explanation
        : 'There is a $strength correlation between these symptoms. '
            '${correlation.isSignificant ? "This pattern is statistically significant and may be meaningful for tracking." : "More data is needed to confirm this pattern."}';
  }

  String explainFertilityStatus(FertileWindow window, int cycleDay) {
    final buffer = StringBuffer();
    final windowStart = _formatDate(window.windowStart);
    final windowEnd = _formatDate(window.windowEnd);

    if (window.isInWindow) {
      buffer.write(
        'You are currently in your fertile window '
        '(cycle days ${_dayOfCycle(window.windowStart)}-${_dayOfCycle(window.windowEnd)}).',
      );
    } else if (cycleDay < _dayOfCycle(window.windowStart)) {
      buffer.write(
        'Your fertile window is approaching — '
        'expected to start around $windowStart.',
      );
    } else {
      buffer.write(
        'Your fertile window has passed for this cycle.',
      );
    }

    if (window.ovulationDate != null) {
      buffer.write(
        ' Ovulation is estimated around ${_formatDate(window.ovulationDate!)}.',
      );
    }

    if (window.explanation != null && window.explanation!.isNotEmpty) {
      buffer.write(' ${window.explanation}');
    }

    return buffer.toString();
  }

  String explainRegularity(CycleRegularityResult regularity) {
    if (regularity.explanation != null && regularity.explanation!.isNotEmpty) {
      return regularity.explanation!;
    }

    final stdDev = regularity.standardDeviation.round();
    final cv = (regularity.coefficientOfVariation * 100).round();

    return switch (regularity.regularity) {
      CycleRegularity.regular =>
        'Your cycles vary by $stdDev days on average (CV: $cv%). '
            'This is considered regular. Variation of up to 7 days is normal.',
      CycleRegularity.slightlyIrregular =>
        'Your cycles vary by $stdDev days on average (CV: $cv%). '
            'This is considered slightly irregular. '
            'Some variation between cycles is common and often related to '
            'stress, sleep changes, or other lifestyle factors.',
      CycleRegularity.irregular =>
        'Your cycles vary by $stdDev days on average (CV: $cv%). '
            'This is considered irregular. '
            'Significant variation may be influenced by stress, diet, exercise, '
            'or underlying conditions. If this pattern persists, consider '
            'discussing it with a healthcare provider.',
    };
  }

  String generateWeeklySummary({
    required List<SymptomEntry> symptoms,
    required int cycleDay,
    String? ovulationStatus,
    String? pregnancyWeek,
  }) {
    final buffer = StringBuffer();

    if (pregnancyWeek != null) {
      buffer.write('You are in pregnancy week $pregnancyWeek. ');
    }

    if (cycleDay > 0) {
      final phase = _phaseForCycleDay(cycleDay);
      buffer.write('You are on cycle day $cycleDay ($phase phase). ');
    }

    if (symptoms.isNotEmpty) {
      final uniqueSymptoms = <String>{
        for (final s in symptoms) s.symptomName,
      };
      buffer.write(
        'This week you logged ${symptoms.length} symptom entries '
        '(${uniqueSymptoms.length} unique types). ',
      );

      final entriesByCategory = <String, List<SymptomEntry>>{};
      for (final s in symptoms) {
        final cat = s.category ?? 'other';
        entriesByCategory.putIfAbsent(cat, () => []).add(s);
      }

      if (entriesByCategory.containsKey('mood')) {
        final moods = entriesByCategory['mood']!;
        final avgMood = moods.fold<int>(0, (a, b) => a + b.severity) / moods.length;
        buffer.write(
          'Your average mood rating was ${avgMood.toStringAsFixed(1)}/5. ',
        );
      }

      if (entriesByCategory.containsKey('pain') ||
          entriesByCategory.containsKey('physical')) {
        final physical = [
          ...?entriesByCategory['pain'],
          ...?entriesByCategory['physical'],
        ];
        final avgPhysical =
            physical.fold<int>(0, (a, b) => a + b.severity) / physical.length;
        buffer.write(
          'Average physical symptom severity: ${avgPhysical.toStringAsFixed(1)}/5. ',
        );
      }
    } else {
      buffer.write('No symptoms were logged this week. ');
    }

    if (ovulationStatus != null) {
      buffer.write('Ovulation status: $ovulationStatus. ');
    }

    buffer.write(
      'Tracking consistently helps identify patterns in your health.',
    );

    return buffer.toString();
  }

  String generateHealthTip({
    required List<ImpactfulSymptom> topSymptoms,
    required CyclePhase currentPhase,
  }) {
    final phaseName = _phaseDisplayName(currentPhase);

    if (topSymptoms.isEmpty) {
      return _generalHealthTip(currentPhase);
    }

    final top = topSymptoms.first;
    return _contextualTip(top, currentPhase, phaseName);
  }

  String _generalHealthTip(CyclePhase phase) {
    return switch (phase) {
      CyclePhase.menstrual =>
        'During your period, staying hydrated and getting adequate rest '
            'can help manage discomfort. Gentle movement like walking or yoga '
            'may also ease cramps.',
      CyclePhase.follicular =>
        'The follicular phase often brings increased energy. '
            'This is a great time for exercise, social activities, and '
            'tackling projects that require focus.',
      CyclePhase.ovulation =>
        'During ovulation, many women notice increased energy and libido. '
            'Pay attention to cervical mucus changes — egg-white consistency '
            'indicates peak fertility.',
      CyclePhase.luteal =>
        'In the luteal phase, your body may benefit from extra rest and '
            'nutrient-rich foods. Some women find magnesium and B vitamins '
            'helpful for mood and bloating.',
    };
  }

  String _contextualTip(ImpactfulSymptom symptom, CyclePhase phase, String phaseName) {
    final name = symptom.symptomName;
    final severity = symptom.averageSeverity;

    return switch (phase) {
      CyclePhase.menstrual =>
        'Many women experience $name during the $phaseName phase. '
            '${_severitySuggestion(name, severity)} '
            'Warm compresses, hydration, and over-the-counter options '
            'may provide relief — consult a pharmacist for guidance.',
      CyclePhase.follicular =>
        'You tend to track $name during your $phaseName phase. '
            'This phase is associated with rising estrogen, which can affect '
            'mood and energy. Maintaining a consistent routine may help.',
      CyclePhase.ovulation =>
        'Some women notice $name around ovulation, when hormone levels peak. '
            '${_severitySuggestion(name, severity)} '
            'Tracking alongside other ovulation signs can provide useful context.',
      CyclePhase.luteal =>
        '$name is commonly reported during the $phaseName phase. '
            '${_severitySuggestion(name, severity)} '
            'This information is based on your logged patterns — '
            'it is not a medical diagnosis.',
    };
  }

  String _severitySuggestion(String symptom, double severity) {
    if (severity >= 4) {
      return 'Since you rate this as high severity, '
          'consider discussing it with a healthcare provider.';
    } else if (severity >= 2.5) {
      return 'Tracking patterns can help you anticipate and prepare '
          'for these symptoms.';
    }
    return 'Mild symptoms like this are common and typically manageable '
        'with rest and self-care.';
  }

  String _confidenceNote(double confidence) {
    if (confidence >= 0.7) return 'Reliable prediction based on consistent cycle data.';
    if (confidence >= 0.4) return 'Moderate confidence — more cycles will improve accuracy.';
    return 'Lower confidence due to limited or variable data.';
  }

  String _phaseForCycleDay(int cycleDay) {
    if (cycleDay <= 5) return 'menstrual';
    if (cycleDay <= 13) return 'follicular';
    if (cycleDay <= 16) return 'ovulation';
    return 'luteal';
  }

  String _phaseDisplayName(CyclePhase phase) {
    return switch (phase) {
      CyclePhase.menstrual => 'menstrual',
      CyclePhase.follicular => 'follicular',
      CyclePhase.ovulation => 'ovulation',
      CyclePhase.luteal => 'luteal',
    };
  }

  int _dayOfCycle(DateTime date) {
    return date.day;
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
