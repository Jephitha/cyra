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
  final post = await repo.getPost(postId);
  if (post == null) throw Exception('Post not found');
  return post;
}

@riverpod
Future<List<CommunityPost>> myCommunityPosts(MyCommunityPostsRef ref) async {
  final repo = ref.watch(communityRepositoryProvider);
  return repo.getMyPosts();
}

@Riverpod(keepAlive: true)
class JoinedTopics extends _$JoinedTopics {
  @override
  Set<String> build() => <String>{};

  void join(String topicId) => state = {...state, topicId};
  void leave(String topicId) => state = Set<String>.from(state)..remove(topicId);
  bool isJoined(String topicId) => state.contains(topicId);
}
