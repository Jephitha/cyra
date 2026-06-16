// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArticleImpl _$$ArticleImplFromJson(Map<String, dynamic> json) =>
    _$ArticleImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      summary: json['summary'] as String?,
      isOfflineAvailable: json['isOfflineAvailable'] as bool? ?? false,
      medicalReviewDate: json['medicalReviewDate'] == null
          ? null
          : DateTime.parse(json['medicalReviewDate'] as String),
      reviewAuthor: json['reviewAuthor'] as String?,
      readTimeMinutes: (json['readTimeMinutes'] as num?)?.toInt() ?? 5,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      imageAsset: json['imageAsset'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ArticleImplToJson(_$ArticleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
      'summary': instance.summary,
      'isOfflineAvailable': instance.isOfflineAvailable,
      'medicalReviewDate': instance.medicalReviewDate?.toIso8601String(),
      'reviewAuthor': instance.reviewAuthor,
      'readTimeMinutes': instance.readTimeMinutes,
      'tags': instance.tags,
      'imageAsset': instance.imageAsset,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$ArticleCategoryImpl _$$ArticleCategoryImplFromJson(
  Map<String, dynamic> json,
) => _$ArticleCategoryImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  iconName: json['iconName'] as String,
  articleCount: (json['articleCount'] as num).toInt(),
);

Map<String, dynamic> _$$ArticleCategoryImplToJson(
  _$ArticleCategoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'iconName': instance.iconName,
  'articleCount': instance.articleCount,
};
