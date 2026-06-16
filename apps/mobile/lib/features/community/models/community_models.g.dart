// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityTopicImpl _$$CommunityTopicImplFromJson(Map<String, dynamic> json) =>
    _$CommunityTopicImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      postCount: (json['postCount'] as num).toInt(),
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      iconAsset: json['iconAsset'] as String?,
      isJoined: json['isJoined'] as bool? ?? false,
      isModerated: json['isModerated'] as bool? ?? false,
    );

Map<String, dynamic> _$$CommunityTopicImplToJson(
  _$CommunityTopicImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'postCount': instance.postCount,
  'memberCount': instance.memberCount,
  'iconAsset': instance.iconAsset,
  'isJoined': instance.isJoined,
  'isModerated': instance.isModerated,
};

_$CommunityPostImpl _$$CommunityPostImplFromJson(Map<String, dynamic> json) =>
    _$CommunityPostImpl(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      content: json['content'] as String,
      anonymousUserId: json['anonymousUserId'] as String,
      isAnonymous: json['isAnonymous'] as bool? ?? true,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
      isModerated: json['isModerated'] as bool? ?? false,
      moderationAction: json['moderationAction'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => CommunityReply.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CommunityPostImplToJson(_$CommunityPostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topicId': instance.topicId,
      'content': instance.content,
      'anonymousUserId': instance.anonymousUserId,
      'isAnonymous': instance.isAnonymous,
      'likeCount': instance.likeCount,
      'replyCount': instance.replyCount,
      'isModerated': instance.isModerated,
      'moderationAction': instance.moderationAction,
      'createdAt': instance.createdAt?.toIso8601String(),
      'replies': instance.replies,
    };

_$CommunityReplyImpl _$$CommunityReplyImplFromJson(Map<String, dynamic> json) =>
    _$CommunityReplyImpl(
      id: json['id'] as String,
      postId: json['postId'] as String,
      content: json['content'] as String,
      anonymousUserId: json['anonymousUserId'] as String,
      isAnonymous: json['isAnonymous'] as bool? ?? true,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      isModerated: json['isModerated'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CommunityReplyImplToJson(
  _$CommunityReplyImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'postId': instance.postId,
  'content': instance.content,
  'anonymousUserId': instance.anonymousUserId,
  'isAnonymous': instance.isAnonymous,
  'likeCount': instance.likeCount,
  'isModerated': instance.isModerated,
  'createdAt': instance.createdAt?.toIso8601String(),
};
