import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cyra/core/ml/correlation_engine.dart';
import 'package:cyra/core/ml/explanation_engine.dart';
import 'package:cyra/core/prediction/cycle_predictor.dart';
import 'package:cyra/core/prediction/ovulation_detector.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/models/ovulation_models.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/wearables/models/wearable_models.dart';

part 'health_insights_engine.freezed.dart';
part 'health_insights_engine.g.dart';

class HealthInsightsEngine {
  final CorrelationEngine _correlation;
  final ExplanationEngine _explanation;
  final CyclePredictor _predictor;
  final OvulationDetector _ovulationDetector;

  HealthInsightsEngine(
    this._correlation,
    this._explanation,
    this._predictor,
    this._ovulationDetector,
  );

  Future<DashboardInsights> generateDashboardInsights({
    required List<Cycle> cycles,
    required List<CycleDay> recentDays,
    required List<BBTRecord> bbtRecords,
    required List<SymptomEntry> symptoms,
    WearableDataSummary? wearableSummary,
    DateTime? currentDate,
  }) async {
    final now = currentDate ?? DateTime.now();
    final activeCycle = cycles.isNotEmpty ? cycles.last : null;
    final cycleDay = activeCycle != null
        ? now.difference(activeCycle.startDate).inDays + 1
        : 0;
    final cycleLength = activeCycle?.cycleLength ?? 28;

    final prediction = _predictor.predictNextPeriod(
      cycleHistory: cycles,
      referenceDate: now,
    );

    final currentPhase = cycleDay > 0
        ? _predictor.getCyclePhase(cycleDay, cycleLength)
        : CyclePhase.follicular;

    final regularity = _correlation.analyzeRegularity(cycles);

    final cycleVMsymptoms = _recentSymptoms(symptoms);
    final topSymptoms =
        _correlation.getMostImpactfulSymptoms(cycles, 3);

    FertileWindow? fertileWindow;
    if (activeCycle != null) {
      final window = _ovulationDetector.calculateFertileWindow(
        periodStart: activeCycle.startDate,
        cycleLength: cycleLength,
      );
      fertileWindow = FertileWindow(
        windowStart: window.$1,
        windowEnd: window.$2,
        isInWindow: now.isAfter(window.$1) && now.isBefore(window.$2.add(const Duration(days: 1))),
      );
    }

    final cycleDayForSummary = cycleDay > 0 ? cycleDay : 1;
    final weeklySummary = _explanation.generateWeeklySummary(
      symptoms: cycleVMsymptoms,
      cycleDay: cycleDayForSummary,
      ovulationStatus: fertileWindow?.isInWindow == true ? 'fertile window' : null,
    );

    final healthTips = <String>[];
    if (topSymptoms.isNotEmpty) {
      healthTips.add(
        _explanation.generateHealthTip(
          topSymptoms: topSymptoms,
          currentPhase: currentPhase,
        ),
      );
    }
    if (wearableSummary != null && wearableSummary.dataPointCount > 0) {
      if (wearableSummary.averageSleepHours > 0) {
        healthTips.add(
          'Your synced sleep averaged '
          '${wearableSummary.averageSleepHours.toStringAsFixed(1)} hours. '
          'Sleep context can help explain day-to-day temperature changes.',
        );
      }
      if (wearableSummary.averageHrv > 0) {
        healthTips.add(
          'HRV is being tracked as personal context. Focus on changes from '
          'your own baseline rather than comparing a single value with others.',
        );
      }
    }

    return DashboardInsights(
      weeklySummary: weeklySummary,
      nextPeriod: prediction,
      currentPhase: currentPhase,
      regularity: regularity,
      topSymptoms: topSymptoms,
      fertileWindow: fertileWindow,
      healthTips: healthTips.isNotEmpty ? healthTips : null,
    );
  }

  Future<TopicInsight> explainTopic({
    required InsightTopic topic,
    required Map<String, dynamic> contextData,
  }) async {
    return switch (topic) {
      InsightTopic.periodPrediction => _periodPredictionInsight(topic, contextData),
      InsightTopic.ovulationDetection => _ovulationInsight(topic, contextData),
      InsightTopic.symptomCorrelation => _symptomInsight(topic, contextData),
      InsightTopic.cycleRegularity => _regularityInsight(topic, contextData),
      InsightTopic.fertilityWindow => _fertilityInsight(topic, contextData),
      InsightTopic.conceptionTips => _conceptionInsight(topic, contextData),
      InsightTopic.pregnancyMilestone => _pregnancyInsight(topic, contextData),
    };
  }

  TopicInsight _periodPredictionInsight(InsightTopic topic, Map<String, dynamic> data) {
    final prediction = data['prediction'] as PredictionResult?;
    final summary = data['summary'] as CycleSummary?;

    final title = 'Period Prediction';
    final summaryText = prediction != null && summary != null
        ? _explanation.explainPeriodPrediction(prediction, summary)
        : 'Start tracking your cycles to receive period predictions.';

    final detailed = StringBuffer();
    detailed.writeln(summaryText);
    if (prediction != null) {
      detailed.writeln();
      detailed.writeln(
        'How predictions work: Cyra analyzes your past cycle lengths using '
        'a weighted moving average. More recent cycles are given slightly '
        'higher weight to account for gradual changes.',
      );
      detailed.writeln(
        'The prediction range reflects natural variability — even with '
        'regular cycles, period arrival can vary by a few days.',
      );
      final confidence = (prediction.confidenceScore * 100).round();
      detailed.writeln(
        'Your prediction confidence of $confidence% is based on '
        '${summary?.cycleCount ?? 0} tracked cycles and your '
        '${summary != null ? summary.averageLength.round() : "average"} day cycle length.',
      );
    }
    detailed.writeln();
    detailed.writeln(
      'Tips: Track at least 6 cycles for more accurate predictions. '
      'Log your period start date as soon as it arrives.',
    );

    return TopicInsight(
      topic: topic,
      title: title,
      summary: summaryText,
      detailedExplanation: detailed.toString(),
      confidence: prediction?.confidenceScore ?? 0.0,
      requiresDisclaimer: true,
    );
  }

  TopicInsight _ovulationInsight(InsightTopic topic, Map<String, dynamic> data) {
    final bbtRecords = data['bbtRecords'] as List<BBTRecord>? ?? [];
    final result = _ovulationDetector.detectFromBBT(bbtRecords);

    return TopicInsight(
      topic: topic,
      title: 'Ovulation Detection',
      summary: result.explanation ?? 'No ovulation data available.',
      detailedExplanation: [
        result.explanation ?? '',
        '',
        'Ovulation detection uses sustained temperature shifts: '
            'a rise of at least 0.2°C for 3 consecutive days following '
            'a lower baseline typically indicates ovulation has occurred.',
        '',
        'For best accuracy, take your temperature at the same time each '
            'morning before getting out of bed, after at least 3 hours of sleep.',
        '',
        'Combine BBT tracking with OPK tests and cervical mucus observations '
            'for the most reliable ovulation detection.',
      ].join('\n'),
      confidence: result.confidence,
      relatedTopics: [
        InsightTopic.fertilityWindow,
        InsightTopic.conceptionTips,
      ].map((t) => t.name).toList(),
      requiresDisclaimer: true,
    );
  }

  TopicInsight _symptomInsight(InsightTopic topic, Map<String, dynamic> data) {
    final symptomId = data['symptomId'] as String? ?? '';
    final cycleDays = data['cycleDays'] as List<CycleDay>? ?? [];

    final phaseCorrelation = _correlation.symptomPhaseCorrelation(
      cycleDays: cycleDays,
      symptomId: symptomId,
    );
    final explanation = _explanation.explainSymptomCorrelation(phaseCorrelation);

    return TopicInsight(
      topic: topic,
      title: 'Symptom & Cycle Correlation',
      summary: explanation,
      detailedExplanation: [
        explanation,
        '',
        'This analysis checks whether your symptom follows a pattern '
            'across your cycle phases: menstrual, follicular, ovulation, and luteal.',
        '',
        'A statistically significant correlation means the symptom appears '
            'more often in one phase than expected by chance.',
        '',
        'Correlation does not imply causation — symptom patterns are '
            'informational and may be influenced by many factors including '
            'stress, diet, sleep, and environment.',
      ].join('\n'),
      confidence: phaseCorrelation.correlationCoefficient,
      relatedTopics: [
        InsightTopic.cycleRegularity,
      ].map((t) => t.name).toList(),
      requiresDisclaimer: true,
    );
  }

  TopicInsight _regularityInsight(InsightTopic topic, Map<String, dynamic> data) {
    final cycles = data['cycles'] as List<Cycle>? ?? [];
    final result = _correlation.analyzeRegularity(cycles);
    final explanation = _explanation.explainRegularity(result);

    return TopicInsight(
      topic: topic,
      title: 'Cycle Regularity',
      summary: explanation,
      detailedExplanation: [
        explanation,
        '',
        'Cycle regularity is measured using the coefficient of variation (CV), '
            'which compares the standard deviation of your cycle lengths to the mean.',
        '',
        'Regular: CV up to 7%. '
            'Slightly irregular: CV 7-15%. '
            'Irregular: CV over 15%.',
        '',
        'Normal cycle length ranges from 21 to 35 days. '
            'Occasional variations are common and can be caused by stress, '
            'illness, travel, significant weight changes, or hormonal shifts.',
        '',
        'If your cycles are consistently irregular or you experience sudden '
            'changes, consider consulting a healthcare provider.',
      ].join('\n'),
      confidence: (1.0 - result.coefficientOfVariation).clamp(0.0, 1.0),
      relatedTopics: [
        InsightTopic.periodPrediction,
      ].map((t) => t.name).toList(),
      requiresDisclaimer: true,
    );
  }

  TopicInsight _fertilityInsight(InsightTopic topic, Map<String, dynamic> data) {
    final periodStart = data['periodStart'] as DateTime?;
    final cycleLength = data['cycleLength'] as int? ?? 28;

    final window = periodStart != null
        ? _ovulationDetector.calculateFertileWindow(
            periodStart: periodStart,
            cycleLength: cycleLength,
          )
        : null;

    final explanation = window != null
        ? 'Your fertile window is estimated from '
            '${_formatDate(window.$1)} to ${_formatDate(window.$2)}, '
            'with ovulation around ${_formatDate(window.$2)}.'
        : 'Track your period start dates to receive fertile window estimates.';

    return TopicInsight(
      topic: topic,
      title: 'Fertile Window',
      summary: explanation,
      detailedExplanation: [
        explanation,
        '',
        'The fertile window spans approximately 6 days: the 5 days leading '
            'up to ovulation plus ovulation day itself. Sperm can survive in '
            'the reproductive tract for up to 5 days.',
        '',
        'For fertility awareness, combine calendar-based estimates with '
            'cervical mucus observations and OPK testing for greater accuracy.',
        '',
        'If avoiding pregnancy: No app-based method is 100% effective. '
            'Consult a healthcare provider for reliable contraception.',
        '',
        'If trying to conceive: Regular intercourse every 1-2 days during '
            'the fertile window maximizes chances of conception.',
      ].join('\n'),
      confidence: 0.6,
      relatedTopics: [
        InsightTopic.ovulationDetection,
        InsightTopic.conceptionTips,
      ].map((t) => t.name).toList(),
      requiresDisclaimer: true,
    );
  }

  TopicInsight _conceptionInsight(InsightTopic topic, Map<String, dynamic> data) {
    return TopicInsight(
      topic: topic,
      title: 'Conception Tips',
      summary: 'Understanding your fertile window and timing intercourse '
          'during the 6 most fertile days maximizes your chances of conception.',
      detailedExplanation: [
        'The probability of conception varies significantly across your cycle:',
        '',
        '• Peak fertility (30-33%): 1-2 days before ovulation',
        '• High fertility (15-30%): 3-5 days before ovulation',
        '• Moderate fertility (8-15%): Day of ovulation',
        '• Low fertility (1-8%): 6+ days before ovulation, day after',
        '• Near zero: After ovulation has passed',
        '',
        'For best chances: Have intercourse every 1-2 days during your '
            'fertile window. Daily intercourse does not significantly '
            'increase chances over every-other-day.',
        '',
        'After intercourse, sperm can survive for up to 5 days in fertile '
            'cervical mucus, which is why the fertile window starts before ovulation.',
        '',
        'If you have been trying to conceive for over 12 months '
            '(or 6 months if over 35), consult a fertility specialist.',
      ].join('\n'),
      confidence: 0.8,
      relatedTopics: [
        InsightTopic.fertilityWindow,
        InsightTopic.ovulationDetection,
      ].map((t) => t.name).toList(),
      requiresDisclaimer: true,
    );
  }

  TopicInsight _pregnancyInsight(InsightTopic topic, Map<String, dynamic> data) {
    final week = data['pregnancyWeek'] as int?;
    final weekLabel = week != null ? 'week $week' : 'your current stage';

    return TopicInsight(
      topic: topic,
      title: 'Pregnancy Milestone',
      summary: 'Information about $weekLabel of pregnancy.',
      detailedExplanation: [
        'Pregnancy milestones are based on standard gestational development '
            'timelines and may vary for each individual.',
        week != null
            ? 'You are in week $week of pregnancy.'
            : 'Track your pregnancy to receive week-by-week insights.',
        '',
        'This information is for educational purposes. Every pregnancy is unique. '
            'Always follow the guidance of your healthcare provider.',
        '',
        'Common topics to discuss with your provider: prenatal vitamins, '
            'nutrition, exercise during pregnancy, screening tests, '
            'and warning signs that require medical attention.',
      ].join('\n'),
      confidence: 0.9,
      relatedTopics: [
        InsightTopic.periodPrediction,
      ].map((t) => t.name).toList(),
      requiresDisclaimer: true,
    );
  }

  List<SymptomEntry> _recentSymptoms(List<SymptomEntry> symptoms) {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return symptoms.where((s) => s.date.isAfter(weekAgo)).toList();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

@freezed
class DashboardInsights with _$DashboardInsights {
  const factory DashboardInsights({
    required String weeklySummary,
    required PredictionResult nextPeriod,
    required CyclePhase currentPhase,
    required CycleRegularityResult regularity,
    required List<ImpactfulSymptom> topSymptoms,
    FertileWindow? fertileWindow,
    List<String>? healthTips,
  }) = _DashboardInsights;
  factory DashboardInsights.fromJson(Map<String, dynamic> json) =>
      _$DashboardInsightsFromJson(json);
}

@freezed
class TopicInsight with _$TopicInsight {
  const factory TopicInsight({
    required InsightTopic topic,
    required String title,
    required String summary,
    required String detailedExplanation,
    required double confidence,
    List<String>? relatedTopics,
    @Default(false) bool requiresDisclaimer,
  }) = _TopicInsight;
  factory TopicInsight.fromJson(Map<String, dynamic> json) =>
      _$TopicInsightFromJson(json);
}

enum InsightTopic {
  periodPrediction,
  ovulationDetection,
  symptomCorrelation,
  cycleRegularity,
  fertilityWindow,
  conceptionTips,
  pregnancyMilestone,
}
