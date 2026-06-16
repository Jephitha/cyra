// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserConditionImpl _$$UserConditionImplFromJson(Map<String, dynamic> json) =>
    _$UserConditionImpl(
      id: json['id'] as String,
      conditionType: json['conditionType'] as String,
      diagnosisDate: json['diagnosisDate'] == null
          ? null
          : DateTime.parse(json['diagnosisDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      notes: json['notes'] as String?,
      trackedSymptoms:
          (json['trackedSymptoms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserConditionImplToJson(_$UserConditionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conditionType': instance.conditionType,
      'diagnosisDate': instance.diagnosisDate?.toIso8601String(),
      'isActive': instance.isActive,
      'notes': instance.notes,
      'trackedSymptoms': instance.trackedSymptoms,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ConditionInfoImpl _$$ConditionInfoImplFromJson(Map<String, dynamic> json) =>
    _$ConditionInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      commonSymptoms: (json['commonSymptoms'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      trackingRecommendations:
          (json['trackingRecommendations'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      managementTips: json['managementTips'] as String,
      whenToSeeDoctor: json['whenToSeeDoctor'] as String,
      prevalenceInfo: json['prevalenceInfo'] as String?,
      isVisible: json['isVisible'] as bool? ?? false,
    );

Map<String, dynamic> _$$ConditionInfoImplToJson(_$ConditionInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'commonSymptoms': instance.commonSymptoms,
      'trackingRecommendations': instance.trackingRecommendations,
      'managementTips': instance.managementTips,
      'whenToSeeDoctor': instance.whenToSeeDoctor,
      'prevalenceInfo': instance.prevalenceInfo,
      'isVisible': instance.isVisible,
    };
