import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/ml/health_insights_engine.dart';
import 'package:cyra/core/ml/insight_service.dart';
import 'package:cyra/features/cycle/models/cycle.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/insights/models/insight_models.dart';
import 'package:cyra/features/ovulation/models/bbt_record.dart';
import 'package:cyra/features/ovulation/providers/ovulation_providers.dart';
import 'package:cyra/features/pregnancy/providers/pregnancy_providers.dart';
import 'package:cyra/features/symptoms/models/symptom_models.dart';
import 'package:cyra/features/symptoms/providers/symptom_providers.dart';

part 'insight_providers.g.dart';

@riverpod
Future<DashboardInsights> dashboardInsights(DashboardInsightsRef ref) async {
  final engine = ref.watch(healthInsightsEngineProvider);
  final cycles = await ref.watch(allCyclesProvider.future);
  final activeCycle = await ref.watch(activeCycleProvider.future);

  final recentDays = <CycleDay>[];
  if (activeCycle != null) {
    final days = await ref.watch(cycleDaysProvider(activeCycle.id).future);
    recentDays.addAll(days);
  }

  final now = DateTime.now();
  final monthAgo = now.subtract(const Duration(days: 30));

  final bbtRepo = ref.watch(ovulationRepositoryProvider);
  List<BBTRecord> bbtRecords = [];
  try {
    bbtRecords = await bbtRepo.getBBTRange(monthAgo, now);
  } catch (_) {}

  final symptoms = await ref.watch(
    symptomsInRangeProvider(monthAgo, now).future,
  );

  return engine.generateDashboardInsights(
    cycles: cycles,
    recentDays: recentDays,
    bbtRecords: bbtRecords,
    symptoms: symptoms,
    currentDate: now,
  );
}

@riverpod
Future<TopicInsight> topicInsight(
  TopicInsightRef ref,
  InsightTopic topic,
) async {
  final engine = ref.watch(healthInsightsEngineProvider);
  final activeCycle = await ref.watch(activeCycleProvider.future);
  final contextData = <String, dynamic>{};

  if (activeCycle != null) {
    contextData['cycleLength'] = activeCycle.cycleLength;
    contextData['periodStart'] = activeCycle.startDate;
    contextData['cycles'] = await ref.watch(allCyclesProvider.future);

    final days = await ref.watch(cycleDaysProvider(activeCycle.id).future);
    contextData['cycleDays'] = days;

    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 30));

    try {
      final bbtRepo = ref.watch(ovulationRepositoryProvider);
      contextData['bbtRecords'] =
          await bbtRepo.getBBTRange(monthAgo, now);
    } catch (_) {}
  }

  final prediction = await ref.watch(nextPeriodPredictionProvider.future);
  contextData['prediction'] = prediction;

  final summary = await ref.watch(cycleSummaryProvider.future);
  contextData['summary'] = summary;

  try {
    final pregnancy = await ref.watch(currentPregnancyProvider.future);
    contextData['pregnancyWeek'] = pregnancy?.currentWeek;
  } catch (_) {}

  return engine.explainTopic(topic: topic, contextData: contextData);
}

@riverpod
Future<WeeklySummary> weeklySummary(WeeklySummaryRef ref) async {
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7));

  final symptoms = await ref.watch(
    symptomsInRangeProvider(weekAgo, now).future,
  );

  final activeCycle = await ref.watch(activeCycleProvider.future);
  final cycleDay = activeCycle != null
      ? now.difference(activeCycle.startDate).inDays + 1
      : 1;

  final moods = await ref.watch(
    moodsInRangeProvider(weekAgo, now).future,
  );

  final moodAverage = moods.isNotEmpty
      ? moods.fold<int>(0, (a, b) => a + b.moodRating) / moods.length
      : 0.0;

  final highlights = <String>[];
  if (activeCycle != null) {
    highlights.add('Cycle day $cycleDay');
  }
  if (symptoms.isNotEmpty) {
    final unique = symptoms.map((s) => s.symptomName).toSet();
    highlights.add('${unique.length} symptom types logged');
  }
  if (moodAverage > 0) {
    highlights.add('Average mood ${moodAverage.toStringAsFixed(1)}/5');
  }

  final engine = ref.watch(healthInsightsEngineProvider);
  final weeklyInsight = await engine.generateDashboardInsights(
    cycles: await ref.watch(allCyclesProvider.future),
    recentDays: activeCycle != null
        ? await ref.watch(cycleDaysProvider(activeCycle.id).future)
        : [],
    bbtRecords: [],
    symptoms: symptoms,
    currentDate: now,
  );

  return WeeklySummary(
    weekStart: weekAgo,
    weekEnd: now,
    symptomCount: symptoms.length,
    moodAverage: moodAverage,
    highlights: highlights,
    keyInsight: weeklyInsight.weeklySummary,
    tip: weeklyInsight.healthTips?.isNotEmpty == true
        ? weeklyInsight.healthTips!.first
        : null,
  );
}

@riverpod
Future<String> healthTip(HealthTipRef ref) async {
  final cycles = await ref.watch(allCyclesProvider.future);
  final activeCycle = await ref.watch(activeCycleProvider.future);

  final cycleDay = activeCycle != null
      ? DateTime.now().difference(activeCycle.startDate).inDays + 1
      : 1;
  final cycleLength = activeCycle?.cycleLength ?? 28;

  final predictor = ref.watch(cyclePredictorProvider);
  final currentPhase = cycleDay > 0
      ? predictor.getCyclePhase(cycleDay, cycleLength)
      : CyclePhase.follicular;

  final topSymptoms =
      ref.watch(correlationEngineProvider).getMostImpactfulSymptoms(cycles, 3);

  return ref.watch(explanationEngineProvider).generateHealthTip(
    topSymptoms: topSymptoms,
    currentPhase: currentPhase,
  );
}
