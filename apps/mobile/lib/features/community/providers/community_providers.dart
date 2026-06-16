import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/features/community/models/community_models.dart';
import 'package:cyra/features/community/repositories/community_repository.dart';

part 'community_providers.g.dart';

@riverpod
Future<List<CommunityTopic>> communityTopics(CommunityTopicsRef ref) async {
  final repo = ref.watch(communityRepositoryProvider);
  return repo.getTopics();
}

@riverpod
Future<List<CommunityPost>> topicPosts(
  TopicPostsRef ref,
  String topicId, {
  int page = 0,
}) async {
  final repo = ref.watch(communityRepositoryProvider);
  return repo.getPostsForTopic(topicId, page: page);
}

@riverpod
Future<CommunityPost> postDetail(PostDetailRef ref, String postId) async {
  final repo = ref.watch(communityRepositoryProvider);
  final posts = await repo.getPostsForTopic('', page: 0);
  return posts.firstWhere((p) => p.id == postId);
}

@riverpod
Future<List<CommunityPost>> myCommunityPosts(MyCommunityPostsRef ref) async {
  final repo = ref.watch(communityRepositoryProvider);
  return repo.getMyPosts();
}
