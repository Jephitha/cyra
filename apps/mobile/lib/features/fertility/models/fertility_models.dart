import 'package:freezed_annotation/freezed_annotation.dart';

part 'fertility_models.freezed.dart';
part 'fertility_models.g.dart';

enum FertilityMode { tryingToConceive, avoidPregnancy, notPlanning }

enum FertilityDayType {
  period,
  notFertile,
  transitioning,
  fertile,
  peakFertile,
  ovulation,
  postOvulation,
  unknown,
}

@freezed
class IntercourseLog with _$IntercourseLog {
  const factory IntercourseLog({
    required String id,
    required DateTime date,
    @Default(false) bool unprotected,
    String? notes,
  }) = _IntercourseLog;

  factory IntercourseLog.fromJson(Map<String, dynamic> json) =>
      _$IntercourseLogFromJson(json);
}

@freezed
class FertilityStatus with _$FertilityStatus {
  const factory FertilityStatus({
    required int cycleDay,
    required FertilityDayType dayType,
    @Default(0.0) double conceptionProbability,
    String? recommendation,
    String? explanation,
  }) = _FertilityStatus;

  factory FertilityStatus.fromJson(Map<String, dynamic> json) =>
      _$FertilityStatusFromJson(json);
}
