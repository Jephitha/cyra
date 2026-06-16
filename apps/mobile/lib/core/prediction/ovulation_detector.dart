import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/models/opk_test_record.dart';
import 'package:cyra/features/ovulation/models/mucus_observation.dart';

class OvulationDetector {
  static const double _bbtShiftThreshold = 0.2;
  static const double _coverLineOffset = 0.1;
  static const int _baselineCount = 6;
  static const int _shiftCount = 3;
  static const int _minRecordsForDetection = 9;

  OvulationResult detectFromBBT(List<BBTRecord> records) {
    if (records.length < _minRecordsForDetection) {
      return OvulationResult(
        isConfirmed: false,
        confidence: 0.0,
        method: 'bbt_shift',
        explanation:
            'Insufficient BBT data. Need at least $_minRecordsForDetection '
            'temperature readings to detect ovulation.',
      );
    }

    final sorted = List<BBTRecord>.from(records)
      ..sort((a, b) => a.date.compareTo(b.date));

    final uniqueDays = <DateTime>{};
    final deduped = <BBTRecord>[];
    for (final r in sorted) {
      final day = DateTime(r.date.year, r.date.month, r.date.day);
      if (uniqueDays.add(day)) deduped.add(r);
    }

    if (deduped.length < _minRecordsForDetection) {
      return OvulationResult(
        isConfirmed: false,
        confidence: 0.0,
        method: 'bbt_shift',
        explanation:
            'Insufficient unique daily BBT readings. '
            'Need at least $_minRecordsForDetection distinct days.',
      );
    }

    for (int i = _baselineCount; i <= deduped.length - _shiftCount; i++) {
      final baselineTemps =
          deduped.sublist(i - _baselineCount, i).map((r) => r.temperature);
      final baselineAvg =
          baselineTemps.reduce((a, b) => a + b) / _baselineCount;
      final coverLine = baselineAvg + _coverLineOffset;

      final shiftRecords = deduped.sublist(i, i + _shiftCount);
      final allAbove = shiftRecords
          .every((r) => r.temperature > coverLine);
      final shiftAvg =
          shiftRecords.map((r) => r.temperature).reduce((a, b) => a + b) /
              _shiftCount;
      final shiftMagnitude = shiftAvg - baselineAvg;

      if (allAbove && shiftMagnitude >= _bbtShiftThreshold) {
        final shiftStart = shiftRecords.first.date;
        final magnitudeFactor =
            (shiftMagnitude / 0.3).clamp(0.0, 1.0);
        const dataPointFactor = 1.0;
        final patternClarity =
            _calculatePatternClarity(deduped, i, baselineAvg);
        final confidence =
            (magnitudeFactor * 0.4 + dataPointFactor * 0.2 + patternClarity * 0.4)
                .clamp(0.0, 0.95);

        final peakIdx = i - 1;
        final ovulationDate = peakIdx >= 0 ? deduped[peakIdx].date : null;

        return OvulationResult(
          confirmedOvulationDate: ovulationDate,
          estimatedOvulationDate: shiftStart,
          isConfirmed: confidence >= 0.7,
          confidence: confidence,
          method: 'bbt_shift',
          explanation:
              'Sustained temperature shift detected: '
              '$_shiftCount consecutive readings elevated ${shiftMagnitude.toStringAsFixed(2)}°C '
              'above cover line of ${coverLine.toStringAsFixed(2)}°C. '
              'Ovulation estimated ${ovulationDate != null ? 'on ${_formatDate(ovulationDate)}' : 'around ${_formatDate(shiftStart)}'}. '
              'Confidence: ${(confidence * 100).round()}%.',
        );
      }
    }

    return OvulationResult(
      isConfirmed: false,
      confidence: 0.3,
      method: 'bbt_shift',
      explanation:
          'No clear biphasic temperature shift detected. '
          'Consider tracking consistently at the same time each morning '
          'before getting out of bed.',
    );
  }

  double _calculatePatternClarity(
    List<BBTRecord> records,
    int shiftStartIdx,
    double baselineAvg,
  ) {
    final preShift = records.sublist(0, shiftStartIdx);
    final postShift =
        records.sublist(shiftStartIdx);

    if (preShift.isEmpty || postShift.isEmpty) return 0.5;

    final preVariance = _variance(preShift.map((r) => r.temperature));
    final postVariance = _variance(postShift.map((r) => r.temperature));
    final avgPost = postShift
            .map((r) => r.temperature)
            .reduce((a, b) => a + b) /
        postShift.length;

    final lowVariation = preVariance < 0.05 && postVariance < 0.05 ? 0.3 : 0.0;
    final clearSeparation =
        (avgPost - baselineAvg) > 0.25 ? 0.4 : 0.0;
    final sustained = postShift.length >= _shiftCount ? 0.3 : 0.0;

    return (lowVariation + clearSeparation + sustained).clamp(0.0, 1.0);
  }

  double _variance(Iterable<double> values) {
    final list = values.toList();
    if (list.length < 2) return 0;
    final mean = list.reduce((a, b) => a + b) / list.length;
    return list.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
        (list.length - 1);
  }

  OvulationResult detectFromOPK(List<OPKTestResult> tests) {
    if (tests.isEmpty) {
      return OvulationResult(
        isConfirmed: false,
        confidence: 0.0,
        method: 'opk_positive',
        explanation:
            'No OPK test data available. '
            'Start testing ~3 days before your expected fertile window.',
      );
    }

    final sorted = List<OPKTestResult>.from(tests)
      ..sort((a, b) => a.date.compareTo(b.date));

    final firstPositive = sorted.cast<OPKTestResult?>().firstWhere(
          (t) => t!.result == OPKResult.positive,
          orElse: () => null,
        );

    if (firstPositive == null) {
      return OvulationResult(
        isConfirmed: false,
        confidence: 0.2,
        method: 'opk_positive',
        explanation:
            'No positive OPK tests detected. '
            'LH surge may have been missed — test twice daily '
            'during your estimated fertile window.',
      );
    }

    final surgeDate = firstPositive.date;
    final ovulationEstimate =
        surgeDate.add(const Duration(hours: 30));

    final hasSubsequentNegative = sorted.any(
      (t) =>
          t.date.isAfter(surgeDate) &&
          t.result == OPKResult.negative,
    );
    final hasFading = sorted.any(
      (t) =>
          t.date.isAfter(surgeDate) &&
          t.result == OPKResult.fading,
    );
    final surgeConfirmed = hasSubsequentNegative || hasFading;

    final priorNegatives =
        sorted.where((t) => t.date.isBefore(surgeDate)).length;
    double confidence = 0.5;
    if (surgeConfirmed) confidence += 0.3;
    if (priorNegatives >= 3) confidence += 0.1;
    if (priorNegatives >= 5) confidence += 0.1;
    confidence = confidence.clamp(0.0, 0.95);

    return OvulationResult(
      estimatedOvulationDate: ovulationEstimate,
      isConfirmed: surgeConfirmed,
      confidence: confidence,
      method: 'opk_positive',
      explanation: surgeConfirmed
          ? 'LH surge detected on ${_formatDate(surgeDate)} '
              'with subsequent surge resolution confirming the peak. '
              'Ovulation expected within 24-36 hours (${
                _formatDate(ovulationEstimate)}). '
              'Confidence: ${(confidence * 100).round()}%.'
          : 'LH surge detected on ${_formatDate(surgeDate)}. '
              'Continue testing to confirm surge resolution. '
              'Ovulation expected within 24-36 hours. '
              'Confidence: ${(confidence * 100).round()}%.',
    );
  }

  OvulationResult detectFromMucus(List<MucusObservation> observations) {
    if (observations.length < 3) {
      return OvulationResult(
        isConfirmed: false,
        confidence: 0.0,
        method: 'mucus_peak',
        explanation:
            'Insufficient cervical mucus observations. '
            'Track at least 3 consecutive days to detect patterns.',
      );
    }

    final sorted = List<MucusObservation>.from(observations)
      ..sort((a, b) => a.date.compareTo(b.date));

    final fertileTypes = {
      CervicalMucusType.eggWhite,
      CervicalMucusType.watery,
    };

    int? peakIndex;
    for (int i = sorted.length - 1; i >= 0; i--) {
      if (fertileTypes.contains(sorted[i].type)) {
        peakIndex = i;
        break;
      }
    }

    if (peakIndex == null) {
      return OvulationResult(
        isConfirmed: false,
        confidence: 0.2,
        method: 'mucus_peak',
        explanation:
            'No peak fertile-type mucus (egg white or watery) detected. '
            'The fertile window may have passed or you may have missed '
            'the peak day.',
      );
    }

    final peakDate = sorted[peakIndex].date;
    final ovulationEstimate =
        peakDate.add(const Duration(days: 1));

    final hasProgression = _hasProgressionPattern(sorted, peakIndex);
    final hasPostPeakDryUp =
        sorted.length > peakIndex + 1 &&
        sorted
            .skip(peakIndex + 1)
            .every((o) => o.type == CervicalMucusType.dry ||
                o.type == CervicalMucusType.sticky);

    double confidence = 0.4;
    if (hasProgression) confidence += 0.25;
    if (hasPostPeakDryUp) confidence += 0.2;
    if (observations.length >= 7) confidence += 0.1;
    confidence = confidence.clamp(0.0, 0.95);

    return OvulationResult(
      estimatedOvulationDate: ovulationEstimate,
      confirmedOvulationDate: hasPostPeakDryUp ? peakDate : null,
      isConfirmed: hasProgression && hasPostPeakDryUp,
      confidence: confidence,
      method: hasProgression && hasPostPeakDryUp
          ? 'mucus_peak'
          : 'mucus_partial',
      explanation: hasProgression
          ? 'Clear mucus pattern detected: progressed to '
              'peak fertile-type mucus on ${_formatDate(peakDate)}. '
              'Ovulation expected within 1-2 days after peak. '
              'Confidence: ${(confidence * 100).round()}%.'
          : 'Peak fertile-type mucus detected on '
              '${_formatDate(peakDate)}. Track more days to confirm '
              'the complete pattern. '
              'Confidence: ${(confidence * 100).round()}%.',
    );
  }

  bool _hasProgressionPattern(
    List<MucusObservation> observations,
    int peakIndex,
  ) {
    if (peakIndex < 2) return false;

    final fertileIndices = <int>[];
    for (int i = peakIndex; i >= 0; i--) {
      if (fertileIndices.isEmpty &&
          (observations[i].type == CervicalMucusType.eggWhite ||
              observations[i].type == CervicalMucusType.watery)) {
        fertileIndices.add(i);
      } else if ((observations[i].type == CervicalMucusType.creamy ||
          observations[i].type == CervicalMucusType.sticky)) {
        fertileIndices.add(i);
      } else if (observations[i].type == CervicalMucusType.dry) {
        fertileIndices.add(i);
        break;
      }
    }

    return fertileIndices.length >= 3;
  }

  OvulationResult detectCombined(
    List<BBTRecord> bbtRecords,
    List<OPKTestResult> opkResults,
    List<MucusObservation> mucusObservations,
  ) {
    final bbtResult = detectFromBBT(bbtRecords);
    final opkResult = detectFromOPK(opkResults);
    final mucusResult = detectFromMucus(mucusObservations);

    final estimates = <DateTime?>[
      bbtResult.confirmedOvulationDate ?? bbtResult.estimatedOvulationDate,
      opkResult.estimatedOvulationDate,
      mucusResult.estimatedOvulationDate,
    ];

    final confidences = [
      bbtResult.confidence,
      opkResult.confidence,
      mucusResult.confidence,
    ];

    final available = <int>[];
    for (int i = 0; i < 3; i++) {
      if (estimates[i] != null && confidences[i] > 0) {
        available.add(i);
      }
    }

    if (available.isEmpty) {
      return OvulationResult(
        isConfirmed: false,
        confidence: 0.0,
        method: 'combined',
        explanation:
            'Insufficient data across all tracking methods. '
            'Track BBT, OPK, and cervical mucus for best accuracy.',
      );
    }

    const weights = [0.50, 0.30, 0.20];

    int agreements = 0;
    for (int i = 0; i < available.length; i++) {
      for (int j = i + 1; j < available.length; j++) {
        final daysDiff = (estimates[available[i]]!
                .difference(estimates[available[j]]!)
                .inDays)
            .abs();
        if (daysDiff <= 2) agreements++;
      }
    }

    final maxPossibleAgreements =
        (available.length * (available.length - 1)) ~/ 2;
    final agreementRatio =
        maxPossibleAgreements > 0 ? agreements / maxPossibleAgreements : 0.0;

    double weightedConfidence = 0;
    double weightSum = 0;
    for (final i in available) {
      weightedConfidence += confidences[i] * weights[i];
      weightSum += weights[i];
    }
    final baseConfidence =
        weightSum > 0 ? weightedConfidence / weightSum : 0.0;

    double confidence = baseConfidence;
    if (agreementRatio >= 1.0 && available.length >= 2) {
      confidence = (baseConfidence + 0.2).clamp(0.0, 0.98);
    } else if (agreementRatio <= 0 && available.length >= 2) {
      confidence = (baseConfidence * 0.5).clamp(0.0, 0.3);
    }

    DateTime? finalDate;
    if (available.length >= 2 && agreementRatio > 0) {
      final dateGroups = <DateTime, int>{};
      for (final i in available) {
        final d = estimates[i]!;
        final key = DateTime(d.year, d.month, d.day);
        dateGroups[key] = (dateGroups[key] ?? 0) + confidences[i].round();
      }
      finalDate = dateGroups.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    } else if (available.isNotEmpty) {
      final bestIdx = available
          .reduce((a, b) => confidences[a] > confidences[b] ? a : b);
      finalDate = estimates[bestIdx];
    }

    String method;
    if (available.length == 3) {
      method = 'combined';
    } else if (available.length == 2) {
      method = 'combined_partial';
    } else {
      method = switch (available.first) {
        0 => 'bbt_shift',
        1 => 'opk_positive',
        _ => 'mucus_peak',
      };
    }

    final buffer = StringBuffer();
    if (bbtResult.confidence > 0) {
      buffer.writeln(
        '• BBT: ${bbtResult.isConfirmed ? "Ovulation confirmed" : "No clear shift"} '
        '(${(bbtResult.confidence * 100).round()}%)');
    }
    if (opkResult.confidence > 0) {
      buffer.writeln(
        '• OPK: ${opkResult.isConfirmed ? "Surge confirmed" : "No surge detected"} '
        '(${(opkResult.confidence * 100).round()}%)');
    }
    if (mucusResult.confidence > 0) {
      buffer.writeln(
        '• Mucus: ${mucusResult.isConfirmed ? "Peak confirmed" : "No peak detected"} '
        '(${(mucusResult.confidence * 100).round()}%)');
    }

    if (agreementRatio >= 1.0 && available.length >= 2) {
      buffer.write(
        'All available signals agree, indicating high confidence in '
        'ovulation timing.');
    } else if (available.length >= 2) {
      buffer.write(
        'Some signals disagree — BBT is weighted highest (50%), '
        'followed by OPK (30%) and mucus (20%).');
    }

    return OvulationResult(
      confirmedOvulationDate: bbtResult.confirmedOvulationDate,
      estimatedOvulationDate: finalDate,
      isConfirmed: confidence >= 0.7,
      confidence: confidence,
      method: method,
      explanation: buffer.toString().trim(),
    );
  }

  (DateTime start, DateTime end) calculateFertileWindow({
    required DateTime periodStart,
    int? cycleLength,
    DateTime? lastOvulationDate,
    int? lastCycleLength,
  }) {
    final length = cycleLength ?? lastCycleLength ?? 28;
    final ovulationDay = length - 14;
    DateTime ovulationDate;

    if (lastOvulationDate != null && lastCycleLength != null) {
      ovulationDate = lastOvulationDate.add(
        Duration(days: length - lastCycleLength),
      );
    } else {
      ovulationDate = periodStart.add(Duration(days: ovulationDay));
    }

    final fertileStart = ovulationDate.subtract(const Duration(days: 5));
    final fertileEnd = ovulationDate;

    return (fertileStart, fertileEnd);
  }

  Map<int, double> dailyConceptionProbability(int cycleLength) {
    final ovulationDay = cycleLength - 14;
    final probabilities = <int, double>{};

    const clinicalProbabilities = {
      -6: 0.03,
      -5: 0.08,
      -4: 0.15,
      -3: 0.22,
      -2: 0.30,
      -1: 0.33,
      0: 0.12,
      1: 0.01,
    };

    for (int day = 1; day <= cycleLength; day++) {
      final daysFromOvulation = day - ovulationDay;
      if (clinicalProbabilities.containsKey(daysFromOvulation)) {
        probabilities[day] = clinicalProbabilities[daysFromOvulation]!;
      } else if (daysFromOvulation < -6) {
        probabilities[day] = 0.0;
      } else {
        probabilities[day] = 0.0;
      }
    }

    return probabilities;
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
