import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_models.freezed.dart';
part 'community_models.g.dart';

@freezed
class CommunityTopic with _$CommunityTopic {
  const factory CommunityTopic({
    required String id,
    required String name,
    required String description,
    required int postCount,
    @Default(0) int memberCount,
    String? iconAsset,
    @Default(false) bool isJoined,
    @Default(false) bool isModerated,
  }) = _CommunityTopic;

  factory CommunityTopic.fromJson(Map<String, dynamic> json) =>
      _$CommunityTopicFromJson(json);
}

@freezed
class CommunityPost with _$CommunityPost {
  const factory CommunityPost({
    required String id,
    required String topicId,
    required String content,
    required String anonymousUserId,
    @Default(true) bool isAnonymous,
    @Default(0) int likeCount,
    @Default(0) int replyCount,
    @Default(false) bool isModerated,
    String? moderationAction,
    DateTime? createdAt,
    @Default([]) List<CommunityReply> replies,
  }) = _CommunityPost;

  factory CommunityPost.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostFromJson(json);
}

@freezed
class CommunityReply with _$CommunityReply {
  const factory CommunityReply({
    required String id,
    required String postId,
    required String content,
    required String anonymousUserId,
    @Default(true) bool isAnonymous,
    @Default(0) int likeCount,
    @Default(false) bool isModerated,
    DateTime? createdAt,
  }) = _CommunityReply;

  factory CommunityReply.fromJson(Map<String, dynamic> json) =>
      _$CommunityReplyFromJson(json);
}
