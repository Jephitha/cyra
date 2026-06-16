import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cyra/core/ml/health_insights_engine.dart';

part 'insight_models.freezed.dart';
part 'insight_models.g.dart';

@freezed
class AIInsightCard with _$AIInsightCard {
  const factory AIInsightCard({
    required String title,
    required String summary,
    required String iconName,
    required int colorValue,
    required InsightTopic topic,
    @Default(0.0) double confidence,
    String? disclaimer,
    @Default(false) bool isLoading,
  }) = _AIInsightCard;

  factory AIInsightCard.fromJson(Map<String, dynamic> json) =>
      _$AIInsightCardFromJson(json);
}

@freezed
class WeeklySummary with _$WeeklySummary {
  const factory WeeklySummary({
    required DateTime weekStart,
    required DateTime weekEnd,
    required int symptomCount,
    required double moodAverage,
    @Default([]) List<String> highlights,
    required String keyInsight,
    String? tip,
  }) = _WeeklySummary;

  factory WeeklySummary.fromJson(Map<String, dynamic> json) =>
      _$WeeklySummaryFromJson(json);
}
