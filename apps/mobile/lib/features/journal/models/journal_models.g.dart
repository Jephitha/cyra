// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JournalEntryImpl _$$JournalEntryImplFromJson(Map<String, dynamic> json) =>
    _$JournalEntryImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String?,
      content: json['content'] as String?,
      photoPaths:
          (json['photoPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      voiceNotePaths:
          (json['voiceNotePaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      moodRating: (json['moodRating'] as num?)?.toInt() ?? 0,
      cycleDayId: json['cycleDayId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$JournalEntryImplToJson(_$JournalEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'title': instance.title,
      'content': instance.content,
      'photoPaths': instance.photoPaths,
      'voiceNotePaths': instance.voiceNotePaths,
      'moodRating': instance.moodRating,
      'cycleDayId': instance.cycleDayId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
