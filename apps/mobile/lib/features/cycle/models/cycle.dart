import 'package:freezed_annotation/freezed_annotation.dart';

part 'cycle.freezed.dart';
part 'cycle.g.dart';

enum CyclePhase {
  menstrual,
  follicular,
  ovulation,
  luteal,
}

@freezed
class Cycle with _$Cycle {
  const factory Cycle({
    required String id,
    required DateTime startDate,
    DateTime? endDate,
    @Default(28) int cycleLength,
    @Default(5) int periodLength,
    String? notes,
    @Default([]) List<CycleDay> days,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Cycle;

  factory Cycle.fromJson(Map<String, dynamic> json) => _$CycleFromJson(json);
}

@freezed
class CycleDay with _$CycleDay {
  const factory CycleDay({
    required String id,
    required String cycleId,
    required DateTime date,
    @Default(0) int flowIntensity,
    @Default(false) bool spotting,
    @Default(false) bool clotting,
    String? symptomsJson,
    double? temperature,
    String? cervicalMucus,
    String? cervicalPosition,
    String? opkResult,
    String? notes,
  }) = _CycleDay;

  factory CycleDay.fromJson(Map<String, dynamic> json) =>
      _$CycleDayFromJson(json);
}

@freezed
class CycleSummary with _$CycleSummary {
  const factory CycleSummary({
    required int cycleCount,
    required double averageLength,
    required int minLength,
    required int maxLength,
    required double variabilityScore,
    required double averagePeriodLength,
    required DateTime? lastPeriodStart,
    required DateTime? nextPredictedPeriodStart,
  }) = _CycleSummary;

  factory CycleSummary.fromJson(Map<String, dynamic> json) =>
      _$CycleSummaryFromJson(json);
}

@freezed
class PredictionResult with _$PredictionResult {
  const factory PredictionResult({
    required DateTime predictedDate,
    required double confidenceScore,
    required double variabilityScore,
    required DateTime predictionRangeStart,
    required DateTime predictionRangeEnd,
    required String explanation,
  }) = _PredictionResult;

  factory PredictionResult.fromJson(Map<String, dynamic> json) =>
      _$PredictionResultFromJson(json);
}
