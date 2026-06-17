import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/features/community/models/community_models.dart';
import 'package:cyra/features/community/providers/community_providers.dart';
import 'package:cyra/features/community/repositories/community_repository.dart';
import 'package:cyra/features/community/screens/new_post_screen.dart';
import 'package:cyra/features/community/screens/post_detail_screen.dart';
import 'package:cyra/features/community/screens/community_guidelines_screen.dart';

class TopicScreen extends ConsumerStatefulWidget {
  final CommunityTopic topic;

  const TopicScreen({super.key, required this.topic});

  @override
  ConsumerState<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends ConsumerState<TopicScreen> {
  final ScrollController _scrollController = ScrollController();
  int _page = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  final List<CommunityPost> _allPosts = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);

    try {
      final newPosts = await ref.read(
        topicPostsProvider(widget.topic.id, page: _page + 1).future,
      );
      if (newPosts.isEmpty) {
        _hasMore = false;
      } else {
        setState(() {
          _page++;
          _allPosts.addAll(newPosts);
        });
      }
    } catch (_) {}

    if (mounted) setState(() => _isLoadingMore = false);
  }

  Future<void> _onRefresh() async {
    setState(() {
      _page = 0;
      _hasMore = true;
      _allPosts.clear();
    });
    final posts = await ref.refresh(topicPostsProvider(widget.topic.id).future);
    if (mounted) setState(() => _allPosts.addAll(posts));
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(topicPostsProvider(widget.topic.id));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.topic.name,
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => NewPostScreen(topic: widget.topic),
          ),
        ).then((_) => _onRefresh()),
        backgroundColor: AppColors.forestGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_rounded),
        label: const Text('New Post'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.forestGreen,
        child: postsAsync.when(
          data: (posts) {
            if (_page == 0 && _allPosts.isEmpty) {
              _allPosts.addAll(posts);
            }
            return _buildPostList(context, _allPosts, isDark);
          },
          loading: () => _allPosts.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _buildPostList(context, _allPosts, isDark),
          error: (e, _) => _allPosts.isEmpty
              ? _buildError(context, e.toString(), isDark)
              : _buildPostList(context, _allPosts, isDark),
        ),
      ),
    );
  }

  Widget _buildPostList(
    BuildContext context,
    List<CommunityPost> posts,
    bool isDark,
  ) {
    if (posts.isEmpty) {
      return _buildEmptyState(context, isDark);
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.huge,
      ),
      children: [
        _buildTopicHeader(context, isDark),
        const SizedBox(height: AppSpacing.md),
        _buildGuidelinesReminder(context, isDark),
        const SizedBox(height: AppSpacing.lg),
        ...posts.map((post) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _buildPostCard(context, post, isDark),
        )),
        if (_isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildTopicHeader(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.topic.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          widget.topic.description,
          style: AppTypography.light.bodySmall?.copyWith(
            color: AppColors.slate,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Icon(Icons.people_outline_rounded, size: 14, color: AppColors.slate),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              '${widget.topic.memberCount} members',
              style: AppTypography.light.labelSmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Icon(Icons.chat_bubble_outline_rounded, size: 14, color: AppColors.slate),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              '${widget.topic.postCount} posts',
              style: AppTypography.light.labelSmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuidelinesReminder(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const CommunityGuidelinesScreen(),
        ),
      ),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.sage.withValues(alpha: isDark ? 0.1 : 0.08),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: AppColors.sage.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 16, color: AppColors.sage),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Remember to follow community guidelines. Be kind and supportive.',
                style: AppTypography.light.labelSmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    CommunityPost post,
    bool isDark,
  ) {
    final truncated = post.content.length > 150;
    final displayContent =
        truncated ? '${post.content.substring(0, 150)}...' : post.content;

    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.forestGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 16,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Anonymous \u00b7 ${post.anonymousUserId.length >= 12 ? post.anonymousUserId.substring(0, 8) : post.anonymousUserId}',
                style: AppTypography.light.labelSmall?.copyWith(
                  color: AppColors.slate,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PostDetailScreen(post: post),
              ),
            ),
            child: Text(
              displayContent,
              style: AppTypography.light.bodySmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                height: 1.5,
              ),
            ),
          ),
          if (truncated) ...[
            const SizedBox(height: AppSpacing.xs),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PostDetailScreen(post: post),
                ),
              ),
              child: Text(
                'Read more',
                style: AppTypography.light.labelSmall?.copyWith(
                  color: AppColors.forestGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.favorite_border_rounded,
                size: 16,
                color: AppColors.slate,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${post.likeCount}',
                style: AppTypography.light.labelSmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 16,
                color: AppColors.slate,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${post.replyCount}',
                style: AppTypography.light.labelSmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onLongPress: () => _showReportOption(context, post.id),
                child: Icon(
                  Icons.more_horiz_rounded,
                  size: 18,
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SizedBox(height: AppSpacing.xxxxl),
        _buildTopicHeader(context, isDark),
        const SizedBox(height: AppSpacing.md),
        _buildGuidelinesReminder(context, isDark),
        const SizedBox(height: AppSpacing.xxxxl),
        Center(
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.forestGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 32,
                  color: AppColors.forestGreen,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'No posts yet',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Be the first to start a conversation!',
                style: AppTypography.light.bodySmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.slate),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Unable to load posts',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.light.bodySmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportOption(BuildContext context, String postId) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('Report this post'),
              onTap: () {
                Navigator.of(ctx).pop();
                _showReportReasonDialog(context, postId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.content_copy_outlined),
              title: const Text('Copy content'),
              onTap: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReportReasonDialog(BuildContext context, String postId) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Why are you reporting this post? '
              'All reports are reviewed anonymously.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Describe your concern...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final reason = controller.text.trim();
              if (reason.isEmpty) return;
              Navigator.of(ctx).pop();
              try {
                await ref.read(communityRepositoryProvider).reportContent(
                  contentType: 'post',
                  contentId: postId,
                  reason: reason,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report submitted. Thank you.'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to submit report: $e')),
                  );
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
