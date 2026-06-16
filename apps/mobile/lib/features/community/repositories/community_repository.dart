import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/core/networking/supabase_client.dart';
import 'package:cyra/core/security/secure_storage_service.dart';
import 'package:cyra/features/community/models/community_models.dart';

part 'community_repository.g.dart';

class AnonymousUser {
  final String id;
  final String displayName;

  const AnonymousUser({required this.id, required this.displayName});
}

@Riverpod(keepAlive: true)
class AnonymousUserNotifier extends _$AnonymousUserNotifier {
  static const _storageKey = 'cyra_anonymous_user_id';

  @override
  Future<AnonymousUser> build() async {
    final storage = ref.read(secureStorageServiceProvider);
    final existing = await storage.readString(_storageKey);

    if (existing != null && existing.isNotEmpty) {
      final parts = existing.split('|');
      if (parts.length == 2) {
        return AnonymousUser(id: parts[0], displayName: parts[1]);
      }
    }

    final random = Random.secure();
    final id = List.generate(
      16,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    final number = random.nextInt(90000) + 10000;
    final displayName = 'Cygnet #$number';

    await storage.storeString(_storageKey, '$id|$displayName');

    return AnonymousUser(id: id, displayName: displayName);
  }
}

class CommunityRepositoryException implements Exception {
  final String message;
  final Object? cause;
  CommunityRepositoryException(this.message, [this.cause]);

  @override
  String toString() => 'CommunityRepositoryException: $message';
}

class CommunityRepository {
  final SupabaseClientService _supabase;
  final Ref _ref;

  CommunityRepository(this._supabase, this._ref);

  Future<String> get _anonymousUserId async {
    final user = await _ref.read(anonymousUserNotifierProvider.future);
    return user.id;
  }

  Future<List<CommunityTopic>> getTopics() async {
    try {
      final data = await _supabase.fetch(
        'community_topics',
        orderBy: 'post_count',
      );
      return data.map((json) => CommunityTopic.fromJson(json)).toList();
    } catch (e) {
      throw CommunityRepositoryException('Failed to load topics', e);
    }
  }

  Future<List<CommunityPost>> getPostsForTopic(
    String topicId, {
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final from = page * pageSize;
      final to = from + pageSize - 1;

      final response = await _supabase.client
          .from('community_posts')
          .select('*, replies:community_replies(*)')
          .eq('topic_id', topicId)
          .order('created_at', ascending: false)
          .range(from, to);

      final data = response as List<dynamic>;
      return data.map((json) => CommunityPost.fromJson(
          json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw CommunityRepositoryException('Failed to load posts', e);
    }
  }

  Future<CommunityPost> createPost({
    required String topicId,
    required String content,
  }) async {
    try {
      final userId = await _anonymousUserId;
      final now = DateTime.now();
      final id = 'post_${now.millisecondsSinceEpoch}_${userId.substring(0, 8)}';

      final data = {
        'id': id,
        'topic_id': topicId,
        'content': content,
        'anonymous_user_id': userId,
        'is_anonymous': true,
        'like_count': 0,
        'reply_count': 0,
        'is_moderated': false,
        'created_at': now.toIso8601String(),
      };

      await _supabase.insert('community_posts', data);

      return CommunityPost(
        id: id,
        topicId: topicId,
        content: content,
        anonymousUserId: userId,
        createdAt: now,
      );
    } catch (e) {
      throw CommunityRepositoryException('Failed to create post', e);
    }
  }

  Future<CommunityReply> replyToPost({
    required String postId,
    required String content,
  }) async {
    try {
      final userId = await _anonymousUserId;
      final now = DateTime.now();
      final id = 'reply_${now.millisecondsSinceEpoch}_${userId.substring(0, 8)}';

      final data = {
        'id': id,
        'post_id': postId,
        'content': content,
        'anonymous_user_id': userId,
        'is_anonymous': true,
        'like_count': 0,
        'is_moderated': false,
        'created_at': now.toIso8601String(),
      };

      await _supabase.insert('community_replies', data);

      await _supabase.client.rpc('increment_reply_count', params: {
        'post_id': postId,
      });

      return CommunityReply(
        id: id,
        postId: postId,
        content: content,
        anonymousUserId: userId,
        createdAt: now,
      );
    } catch (e) {
      throw CommunityRepositoryException('Failed to reply to post', e);
    }
  }

  Future<void> likePost(String postId) async {
    try {
      final userId = await _anonymousUserId;
      final existing = await _supabase.fetchWithFilter(
        'community_likes',
        column: 'post_id',
        value: postId,
      );

      final alreadyLiked = existing.any(
        (like) => like['anonymous_user_id'] == userId,
      );

      if (alreadyLiked) {
        await _supabase.client
            .from('community_likes')
            .delete()
            .eq('post_id', postId)
            .eq('anonymous_user_id', userId);

        await _supabase.client.rpc('decrement_like_count', params: {
          'post_id': postId,
        });
      } else {
        await _supabase.insert('community_likes', {
          'post_id': postId,
          'anonymous_user_id': userId,
          'created_at': DateTime.now().toIso8601String(),
        });

        await _supabase.client.rpc('increment_like_count', params: {
          'post_id': postId,
        });
      }
    } catch (e) {
      throw CommunityRepositoryException('Failed to toggle like', e);
    }
  }

  Future<bool> hasUserLikedPost(String postId) async {
    try {
      final userId = await _anonymousUserId;
      final existing = await _supabase.fetchWithFilter(
        'community_likes',
        column: 'post_id',
        value: postId,
      );

      return existing.any((like) => like['anonymous_user_id'] == userId);
    } catch (e) {
      return false;
    }
  }

  Future<void> reportContent({
    required String contentType,
    required String contentId,
    required String reason,
  }) async {
    try {
      final userId = await _anonymousUserId;

      await _supabase.insert('community_reports', {
        'content_type': contentType,
        'content_id': contentId,
        'reported_by': userId,
        'reason': reason,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw CommunityRepositoryException('Failed to report content', e);
    }
  }

  Future<List<CommunityPost>> getMyPosts() async {
    try {
      final userId = await _anonymousUserId;

      final response = await _supabase.client
          .from('community_posts')
          .select()
          .eq('anonymous_user_id', userId)
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data.map((json) => CommunityPost.fromJson(
          json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw CommunityRepositoryException('Failed to load your posts', e);
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      final userId = await _anonymousUserId;

      final post = await _supabase.fetchById('community_posts', postId);
      if (post == null) {
        throw CommunityRepositoryException('Post not found');
      }
      if (post['anonymous_user_id'] != userId) {
        throw CommunityRepositoryException('You can only delete your own posts');
      }

      await _supabase.delete('community_posts', postId);
    } catch (e) {
      if (e is CommunityRepositoryException) rethrow;
      throw CommunityRepositoryException('Failed to delete post', e);
    }
  }
}

@Riverpod(keepAlive: true)
CommunityRepository communityRepository(CommunityRepositoryRef ref) {
  final supabase = ref.read(supabaseClientServiceProvider);
  return CommunityRepository(supabase, ref);
}
