// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pregnancy_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PregnancyImpl _$$PregnancyImplFromJson(Map<String, dynamic> json) =>
    _$PregnancyImpl(
      id: json['id'] as String,
      conceptionDate: json['conceptionDate'] == null
          ? null
          : DateTime.parse(json['conceptionDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      currentWeek: (json['currentWeek'] as num).toInt(),
      currentTrimester: (json['currentTrimester'] as num).toInt(),
      isActive: json['isActive'] as bool? ?? true,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PregnancyImplToJson(_$PregnancyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conceptionDate': instance.conceptionDate?.toIso8601String(),
      'dueDate': instance.dueDate.toIso8601String(),
      'currentWeek': instance.currentWeek,
      'currentTrimester': instance.currentTrimester,
      'isActive': instance.isActive,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$FetalMeasurementImpl _$$FetalMeasurementImplFromJson(
  Map<String, dynamic> json,
) => _$FetalMeasurementImpl(
  id: json['id'] as String,
  pregnancyId: json['pregnancyId'] as String,
  date: DateTime.parse(json['date'] as String),
  weight: (json['weight'] as num?)?.toDouble(),
  weightPercentile: (json['weightPercentile'] as num?)?.toDouble(),
  bloodPressureSystolic: (json['bloodPressureSystolic'] as num?)?.toInt(),
  bloodPressureDiastolic: (json['bloodPressureDiastolic'] as num?)?.toInt(),
  glucoseLevel: (json['glucoseLevel'] as num?)?.toDouble(),
  kicksCount: (json['kicksCount'] as num?)?.toInt(),
  kicksDurationMinutes: (json['kicksDurationMinutes'] as num?)?.toInt(),
  contractionsJson: json['contractionsJson'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$FetalMeasurementImplToJson(
  _$FetalMeasurementImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'pregnancyId': instance.pregnancyId,
  'date': instance.date.toIso8601String(),
  'weight': instance.weight,
  'weightPercentile': instance.weightPercentile,
  'bloodPressureSystolic': instance.bloodPressureSystolic,
  'bloodPressureDiastolic': instance.bloodPressureDiastolic,
  'glucoseLevel': instance.glucoseLevel,
  'kicksCount': instance.kicksCount,
  'kicksDurationMinutes': instance.kicksDurationMinutes,
  'contractionsJson': instance.contractionsJson,
  'notes': instance.notes,
};

_$ContractionImpl _$$ContractionImplFromJson(Map<String, dynamic> json) =>
    _$ContractionImpl(
      startTime: DateTime.parse(json['startTime'] as String),
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      intensity: (json['intensity'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$ContractionImplToJson(_$ContractionImpl instance) =>
    <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'duration': instance.duration.inMicroseconds,
      'intensity': instance.intensity,
    };

_$KickLogImpl _$$KickLogImplFromJson(Map<String, dynamic> json) =>
    _$KickLogImpl(
      id: json['id'] as String,
      pregnancyId: json['pregnancyId'] as String,
      date: DateTime.parse(json['date'] as String),
      kickCount: (json['kickCount'] as num).toInt(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      isNormal: json['isNormal'] as bool?,
    );

Map<String, dynamic> _$$KickLogImplToJson(_$KickLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pregnancyId': instance.pregnancyId,
      'date': instance.date.toIso8601String(),
      'kickCount': instance.kickCount,
      'durationMinutes': instance.durationMinutes,
      'isNormal': instance.isNormal,
    };
