import 'package:freezed_annotation/freezed_annotation.dart';

part 'condition_models.freezed.dart';
part 'condition_models.g.dart';

@freezed
class UserCondition with _$UserCondition {
  const factory UserCondition({
    required String id,
    required String conditionType,
    DateTime? diagnosisDate,
    @Default(true) bool isActive,
    String? notes,
    @Default([]) List<String> trackedSymptoms,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserCondition;

  factory UserCondition.fromJson(Map<String, dynamic> json) =>
      _$UserConditionFromJson(json);
}

@freezed
class ConditionInfo with _$ConditionInfo {
  const factory ConditionInfo({
    required String id,
    required String name,
    required String description,
    required List<String> commonSymptoms,
    required List<String> trackingRecommendations,
    required String managementTips,
    required String whenToSeeDoctor,
    String? prevalenceInfo,
    @Default(false) bool isVisible,
  }) = _ConditionInfo;

  factory ConditionInfo.fromJson(Map<String, dynamic> json) =>
      _$ConditionInfoFromJson(json);
}
