import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';

part 'correlation_engine.freezed.dart';
part 'correlation_engine.g.dart';

class CorrelationEngine {
  double pearsonCorrelation(List<double> x, List<double> y) {
    if (x.length != y.length || x.length < 3) return 0.0;

    final n = x.length;
    final sumX = x.fold<double>(0, (a, b) => a + b);
    final sumY = y.fold<double>(0, (a, b) => a + b);
    final sumXY = _zip(x, y).fold<double>(0, (a, b) => a + b.$1 * b.$2);
    final sumX2 = x.fold<double>(0, (a, b) => a + b * b);
    final sumY2 = y.fold<double>(0, (a, b) => a + b * b);

    final numerator = n * sumXY - sumX * sumY;
    final denomX = n * sumX2 - sumX * sumX;
    final denomY = n * sumY2 - sumY * sumY;
    final denominator = sqrt(denomX * denomY);

    if (denominator == 0) return 0.0;
    return (numerator / denominator).clamp(-1.0, 1.0);
  }

  CorrelationResult symptomPhaseCorrelation({
    required List<CycleDay> cycleDays,
    required String symptomId,
  }) {
    if (cycleDays.length < 6) {
      return CorrelationResult(
        featureA: symptomId,
        featureB: 'cycle_phase',
        correlationCoefficient: 0.0,
        isSignificant: false,
        explanation: 'Not enough data to calculate phase correlation.',
      );
    }

    final cycleStart = _findCycleStart(cycleDays);

    final phaseCounts = <CyclePhase, int>{
      CyclePhase.menstrual: 0,
      CyclePhase.follicular: 0,
      CyclePhase.ovulation: 0,
      CyclePhase.luteal: 0,
    };
    final phaseTotals = <CyclePhase, int>{
      CyclePhase.menstrual: 0,
      CyclePhase.follicular: 0,
      CyclePhase.ovulation: 0,
      CyclePhase.luteal: 0,
    };

    for (final day in cycleDays) {
      final phase = _estimatePhase(day, cycleStart);
      phaseTotals[phase] = (phaseTotals[phase] ?? 0) + 1;

      if (day.symptomsJson != null && day.symptomsJson!.contains(symptomId)) {
        phaseCounts[phase] = (phaseCounts[phase] ?? 0) + 1;
      }
    }

    final totalDays = cycleDays.length;
    final symptomDays =
        phaseCounts.values.fold<int>(0, (a, b) => a + b);

    if (symptomDays < 3) {
      return CorrelationResult(
        featureA: symptomId,
        featureB: 'cycle_phase',
        correlationCoefficient: 0.0,
        isSignificant: false,
        mostCommonPhase: '',
        explanation:
            'Symptom logged only $symptomDays times. Track more to detect phase patterns.',
      );
    }

    var maxPhase = CyclePhase.menstrual;
    var maxCount = 0;
    StringBuffer explanation = StringBuffer();

    for (final entry in phaseCounts.entries) {
      final count = entry.value;
      final total = phaseTotals[entry.key] ?? 1;
      final proportion = count / total;
      final overallProportion = symptomDays / totalDays;
      final expected = overallProportion * total;
      final deviation = expected > 0 ? (count - expected) / expected : 0.0;

      if (count > maxCount) {
        maxCount = count;
        maxPhase = entry.key;
      }

      if (deviation.abs() > 0.3) {
        explanation.write(
          '${_phaseName(entry.key)}: ${(proportion * 100).round()}% occurrence rate. ',
        );
      }
    }

    final expectedValues = <double>[];
    final observedValues = <int>[];
    for (final phase in CyclePhase.values) {
      final total = phaseTotals[phase] ?? 1;
      final expected = (symptomDays / totalDays) * total;
      expectedValues.add(expected);
      observedValues.add(phaseCounts[phase] ?? 0);
    }

    double chiSquare = 0;
    for (int i = 0; i < expectedValues.length; i++) {
      if (expectedValues[i] > 0) {
        chiSquare +=
            pow(observedValues[i] - expectedValues[i], 2) / expectedValues[i];
      }
    }

    final isSignificant = chiSquare > 7.815;
    final correlationStrength = (chiSquare / (chiSquare + totalDays));

    final phaseName = _phaseName(maxPhase);
    final summary = explanation.isNotEmpty
        ? 'You tend to experience this symptom most often during the $phaseName phase. $explanation'
        : 'This symptom appears most frequently during the $phaseName phase, though the pattern is not strongly phase-dependent.';

    return CorrelationResult(
      featureA: symptomId,
      featureB: 'cycle_phase',
      correlationCoefficient: correlationStrength.clamp(0.0, 1.0),
      isSignificant: isSignificant,
      mostCommonPhase: phaseName,
      explanation: summary,
    );
  }

  CorrelationResult symptomSymptomCorrelation({
    required List<CycleDay> cycleDays,
    required String symptomA,
    required String symptomB,
  }) {
    if (cycleDays.length < 6) {
      return CorrelationResult(
        featureA: symptomA,
        featureB: symptomB,
        correlationCoefficient: 0.0,
        isSignificant: false,
        explanation: 'Not enough data to analyze symptom relationships.',
      );
    }

    int bothPresent = 0;
    int aPresent = 0;
    int bPresent = 0;

    for (final day in cycleDays) {
      final hasA = day.symptomsJson?.contains(symptomA) ?? false;
      final hasB = day.symptomsJson?.contains(symptomB) ?? false;

      if (hasA && hasB) {
        bothPresent++;
      } else if (hasA) {
        aPresent++;
      } else if (hasB) {
        bPresent++;
      }
    }

    if (aPresent + bothPresent < 3 || bPresent + bothPresent < 3) {
      return CorrelationResult(
        featureA: symptomA,
        featureB: symptomB,
        correlationCoefficient: 0.0,
        isSignificant: false,
        explanation:
            'Insufficient co-occurrence data. Log both symptoms more frequently.',
      );
    }

    final totalDays = cycleDays.length;

    final pA = (aPresent + bothPresent) / totalDays;
    final pB = (bPresent + bothPresent) / totalDays;
    final pAB = bothPresent / totalDays;
    final pABgivenA =
        (aPresent + bothPresent) > 0 ? bothPresent / (aPresent + bothPresent) : 0.0;

    final lift = pA > 0 ? (pAB / (pA * pB)) : 1.0;
    final correlationCoefficient = (lift - 1.0) / (lift + 1.0);

    final cooccurrenceRate = (pABgivenA * 100).round();
    final isSignificant = lift > 1.3 && cooccurrenceRate > 15;

    final strength = correlationCoefficient.abs() > 0.5
        ? 'strong'
        : correlationCoefficient.abs() > 0.25
            ? 'moderate'
            : 'weak';

    final explanation = isSignificant
        ? 'When you experience this symptom, the other occurs $cooccurrenceRate% of the time — a $strength association. '
            'They may share an underlying cause or trigger.'
        : 'These symptoms do not show a statistically significant relationship. '
            'Their occurrence appears independent of each other.';

    return CorrelationResult(
      featureA: symptomA,
      featureB: symptomB,
      correlationCoefficient: correlationCoefficient.clamp(-1.0, 1.0),
      isSignificant: isSignificant,
      explanation: explanation,
    );
  }

  double detectTemperatureShift(List<BBTRecord> records) {
    if (records.length < 9) return 0.0;

    final sorted = List<BBTRecord>.from(records)
      ..sort((a, b) => a.date.compareTo(b.date));

    final baseline = sorted.take(6).map((r) => r.temperature).toList();
    final recent = sorted.skip(sorted.length - 3).map((r) => r.temperature).toList();

    final baselineMean = baseline.reduce((a, b) => a + b) / baseline.length;
    final recentMean = recent.reduce((a, b) => a + b) / recent.length;

    return (recentMean - baselineMean).clamp(0.0, 2.0);
  }

  CycleRegularityResult analyzeRegularity(List<Cycle> cycles) {
    final completed = cycles
        .where((c) => c.endDate != null && c.cycleLength > 0)
        .toList();

    if (completed.length < 3) {
      return CycleRegularityResult(
        regularity: CycleRegularity.regular,
        coefficientOfVariation: 0.0,
        standardDeviation: 0.0,
        trend: null,
        explanation:
            'Track at least 3 complete cycles to analyze regularity.',
      );
    }

    final lengths = completed.map((c) => c.cycleLength.toDouble()).toList();
    final n = lengths.length;
    final mean = lengths.reduce((a, b) => a + b) / n;
    final variance =
        lengths.map((l) => pow(l - mean, 2)).reduce((a, b) => a + b) / n;
    final stdDev = sqrt(variance);
    final cv = mean > 0 ? stdDev / mean : 0.0;

    CycleRegularity regularity;
    if (cv <= 0.07) {
      regularity = CycleRegularity.regular;
    } else if (cv <= 0.15) {
      regularity = CycleRegularity.slightlyIrregular;
    } else {
      regularity = CycleRegularity.irregular;
    }

    final sorted = List<double>.from(lengths)..sort();
    final firstHalf = sorted.take(n ~/ 2).toList();
    final secondHalf = sorted.skip(n ~/ 2).toList();
    final firstMean = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final secondMean = secondHalf.reduce((a, b) => a + b) / secondHalf.length;

    String? trend;
    final diff = secondMean - firstMean;
    if (diff.abs() > 1.0) {
      trend = diff > 0 ? 'lengthening' : 'shortening';
    } else {
      trend = 'stable';
    }

    StringBuffer explanation = StringBuffer();
    explanation.write(
      'Your cycles vary by ${stdDev.round()} days on average (CV: ${(cv * 100).round()}%). '
      'This is considered ${regularity == CycleRegularity.regular ? 'regular' : regularity == CycleRegularity.slightlyIrregular ? 'slightly irregular' : 'irregular'}.',
    );

    if (regularity == CycleRegularity.regular) {
      explanation.write(
        ' Variation of up to 7 days is normal and not a cause for concern.',
      );
    } else if (regularity == CycleRegularity.slightlyIrregular) {
      explanation.write(
        ' Some variation between cycles is common, especially during times of '
        'stress, illness, or lifestyle changes.',
      );
    } else {
      explanation.write(
        ' Significant variation may be influenced by stress, diet, exercise, '
        'or underlying conditions. Consider discussing with a healthcare provider '
        'if this persists.',
      );
    }

    if (trend == 'lengthening') {
      explanation.write(
        ' Your cycles appear to be lengthening over time, with recent cycles '
        'averaging ${diff.round()} more days than earlier ones.',
      );
    } else if (trend == 'shortening') {
      explanation.write(
        ' Your cycles appear to be shortening over time, with recent cycles '
        'averaging ${diff.abs().round()} fewer days than earlier ones.',
      );
    }

    return CycleRegularityResult(
      regularity: regularity,
      coefficientOfVariation: cv,
      standardDeviation: stdDev,
      trend: trend,
      explanation: explanation.toString(),
    );
  }

  SeverityTrend getSymptomSeverityTrend(List<SymptomEntry> entries) {
    if (entries.length < 4) {
      return SeverityTrend(
        direction: TrendDirection.stable,
        slope: 0.0,
      );
    }

    final sorted = List<SymptomEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    final n = sorted.length;
    final xValues = List.generate(n, (i) => i.toDouble());
    final yValues = sorted.map((e) => e.severity.toDouble()).toList();

    final sumX = xValues.fold<double>(0, (a, b) => a + b);
    final sumY = yValues.fold<double>(0, (a, b) => a + b);
    final sumXY =
        _zip(xValues, yValues).fold<double>(0, (a, b) => a + b.$1 * b.$2);
    final sumX2 = xValues.fold<double>(0, (a, b) => a + b * b);

    final slope =
        (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);

    TrendDirection direction;
    if (slope.abs() < 0.05) {
      direction = TrendDirection.stable;
    } else if (slope < 0) {
      direction = TrendDirection.improving;
    } else {
      direction = TrendDirection.worsening;
    }

    return SeverityTrend(
      direction: direction,
      slope: slope,
    );
  }

  List<ImpactfulSymptom> getMostImpactfulSymptoms(
      List<Cycle> cycles, int limit) {
    final symptomMap = <String, _SymptomAggregate>{};
    int totalDays = 0;

    for (final cycle in cycles) {
      final cycleDays = cycle.days;
      if (cycleDays.isEmpty) continue;
      final cycleStart = _findCycleStart(cycleDays);

      for (final day in cycleDays) {
        totalDays++;
        if (day.symptomsJson == null || day.symptomsJson!.isEmpty) continue;

        final symptoms = _parseSymptomsJson(day.symptomsJson!);
        final phase = _estimatePhase(day, cycleStart);

        for (final s in symptoms) {
          final agg = symptomMap.putIfAbsent(
            s.id,
            () => _SymptomAggregate(),
          );
          agg.frequency++;
          agg.totalSeverity += s.severity;
          agg.phaseCounts[phase] = (agg.phaseCounts[phase] ?? 0) + 1;
        }
      }
    }

    if (symptomMap.isEmpty) return [];

    final maxFreq =
        symptomMap.values.map((v) => v.frequency).reduce(max).toDouble();

    final results = symptomMap.entries.map((e) {
      final agg = e.value;
      final avgSeverity =
          agg.frequency > 0 ? agg.totalSeverity / agg.frequency : 0.0;

      final maxPhaseCount =
          agg.phaseCounts.values.fold<int>(0, (a, b) => a > b ? a : b);
      final phaseSpecificity = agg.frequency > 0
          ? maxPhaseCount / agg.frequency
          : 0.0;

      final normFreq = maxFreq > 0 ? agg.frequency / maxFreq : 0.0;
      final normSeverity = avgSeverity / 5.0;
      final impactScore =
          (normFreq * 0.4 + normSeverity * 0.35 + phaseSpecificity * 0.25)
              .clamp(0.0, 1.0);

      return ImpactfulSymptom(
        symptomId: e.key,
        symptomName: e.key,
        impactScore: impactScore,
        frequency: agg.frequency,
        averageSeverity: avgSeverity,
        insight: _generateSymptomInsight(
          averageSeverity: avgSeverity,
          frequency: agg.frequency,
          totalDays: totalDays,
          phaseSpecificity: phaseSpecificity,
        ),
      );
    }).toList();

    results.sort((a, b) => b.impactScore.compareTo(a.impactScore));
    return results.take(limit).toList();
  }

  CyclePhase _estimatePhase(CycleDay day, DateTime cycleStart) {
    final dayNumber = day.date.difference(cycleStart).inDays + 1;
    if (dayNumber <= 5) return CyclePhase.menstrual;
    if (dayNumber <= 13) return CyclePhase.follicular;
    if (dayNumber <= 16) return CyclePhase.ovulation;
    return CyclePhase.luteal;
  }

  DateTime _findCycleStart(List<CycleDay> days) {
    final withFlow = days
        .where((d) => d.flowIntensity > 0)
        .map((d) => d.date)
        .toList()
      ..sort();
    if (withFlow.isNotEmpty) {
      return DateTime(withFlow.first.year, withFlow.first.month, withFlow.first.day);
    }
    final allDates = days.map((d) => d.date).toList()..sort();
    return DateTime(allDates.first.year, allDates.first.month, allDates.first.day);
  }

  String _phaseName(CyclePhase phase) {
    return switch (phase) {
      CyclePhase.menstrual => 'menstrual',
      CyclePhase.follicular => 'follicular',
      CyclePhase.ovulation => 'ovulation',
      CyclePhase.luteal => 'luteal',
    };
  }

  List<({String id, int severity})> _parseSymptomsJson(String json) {
    try {
      final List<dynamic> items = _parseSimpleJson(json);
      return items.map((item) {
        if (item is Map) {
          return (
            id: item['symptomId']?.toString() ?? item['id']?.toString() ?? '',
            severity:
                int.tryParse(item['severity']?.toString() ?? '') ?? 1,
          );
        }
        return (id: item.toString(), severity: 1);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  List<dynamic> _parseSimpleJson(String json) {
    final trimmed = json.trim();
    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      final inner = trimmed.substring(1, trimmed.length - 1);
      if (inner.trim().isEmpty) return [];
      try {
        return inner
            .split('},{')
            .map((s) {
              var clean = s.trim();
              if (!clean.startsWith('{')) clean = '{$clean';
              if (!clean.endsWith('}')) clean = '$clean}';
              final parts = clean
                  .replaceAll(RegExp(r'[{}"]'), '')
                  .split(',')
                  .where((p) => p.contains(':'));
              final map = <String, String>{};
              for (final part in parts) {
                final kv = part.split(':');
                if (kv.length == 2) {
                  map[kv[0].trim()] = kv[1].trim();
                }
              }
              return map;
            })
            .toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  List<(T1, T2)> _zip<T1, T2>(List<T1> a, List<T2> b) {
    final length = a.length < b.length ? a.length : b.length;
    return List.generate(length, (i) => (a[i], b[i]));
  }
}

class _SymptomAggregate {
  int frequency = 0;
  double totalSeverity = 0;
  Map<CyclePhase, int> phaseCounts = {};
}

@freezed
class CorrelationResult with _$CorrelationResult {
  const factory CorrelationResult({
    required String featureA,
    required String featureB,
    required double correlationCoefficient,
    required bool isSignificant,
    @Default('') String mostCommonPhase,
    @Default('') String explanation,
  }) = _CorrelationResult;
  factory CorrelationResult.fromJson(Map<String, dynamic> json) =>
      _$CorrelationResultFromJson(json);
}

@freezed
class CycleRegularityResult with _$CycleRegularityResult {
  const factory CycleRegularityResult({
    required CycleRegularity regularity,
    required double coefficientOfVariation,
    required double standardDeviation,
    String? trend,
    String? explanation,
  }) = _CycleRegularityResult;
  factory CycleRegularityResult.fromJson(Map<String, dynamic> json) =>
      _$CycleRegularityResultFromJson(json);
}

enum CycleRegularity { regular, slightlyIrregular, irregular }

@freezed
class SeverityTrend with _$SeverityTrend {
  const factory SeverityTrend({
    required TrendDirection direction,
    required double slope,
  }) = _SeverityTrend;
  factory SeverityTrend.fromJson(Map<String, dynamic> json) =>
      _$SeverityTrendFromJson(json);
}

enum TrendDirection { improving, worsening, stable }

@freezed
class ImpactfulSymptom with _$ImpactfulSymptom {
  const factory ImpactfulSymptom({
    required String symptomId,
    required String symptomName,
    required double impactScore,
    required int frequency,
    required double averageSeverity,
    @Default('') String insight,
  }) = _ImpactfulSymptom;
  factory ImpactfulSymptom.fromJson(Map<String, dynamic> json) =>
      _$ImpactfulSymptomFromJson(json);
}

String _generateSymptomInsight({
  required double averageSeverity,
  required int frequency,
  required int totalDays,
  required double phaseSpecificity,
}) {
  final severityLabel = averageSeverity >= 4
      ? 'high severity'
      : averageSeverity >= 2.5
          ? 'moderate severity'
          : 'mild';
  final occurrenceRate = totalDays > 0
      ? ((frequency / totalDays) * 100).round()
      : 0;

  final specificityNote = phaseSpecificity > 0.6
      ? 'Strongly linked to a specific cycle phase.'
      : phaseSpecificity > 0.35
          ? 'Moderately phase-dependent.'
          : 'Occurs across multiple phases.';

  return 'Logged $occurrenceRate% of days ($severityLabel). $specificityNote';
}
