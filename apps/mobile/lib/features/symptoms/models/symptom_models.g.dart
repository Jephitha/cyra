// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SymptomEntryImpl _$$SymptomEntryImplFromJson(Map<String, dynamic> json) =>
    _$SymptomEntryImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      symptomId: json['symptomId'] as String,
      symptomName: json['symptomName'] as String,
      severity: (json['severity'] as num?)?.toInt() ?? 1,
      notes: json['notes'] as String?,
      category: json['category'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SymptomEntryImplToJson(_$SymptomEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'symptomId': instance.symptomId,
      'symptomName': instance.symptomName,
      'severity': instance.severity,
      'notes': instance.notes,
      'category': instance.category,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$SymptomPatternImpl _$$SymptomPatternImplFromJson(Map<String, dynamic> json) =>
    _$SymptomPatternImpl(
      symptomId: json['symptomId'] as String,
      symptomName: json['symptomName'] as String,
      frequency: (json['frequency'] as num?)?.toInt() ?? 0,
      averageSeverity: (json['averageSeverity'] as num?)?.toDouble() ?? 0.0,
      commonCycleDays:
          (json['commonCycleDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      correlation: json['correlation'] as String?,
    );

Map<String, dynamic> _$$SymptomPatternImplToJson(
  _$SymptomPatternImpl instance,
) => <String, dynamic>{
  'symptomId': instance.symptomId,
  'symptomName': instance.symptomName,
  'frequency': instance.frequency,
  'averageSeverity': instance.averageSeverity,
  'commonCycleDays': instance.commonCycleDays,
  'correlation': instance.correlation,
};

_$MoodEntryImpl _$$MoodEntryImplFromJson(Map<String, dynamic> json) =>
    _$MoodEntryImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      moodRating: (json['moodRating'] as num?)?.toInt() ?? 3,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MoodEntryImplToJson(_$MoodEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'moodRating': instance.moodRating,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
