import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/features/community/models/community_models.dart';
import 'package:cyra/features/community/repositories/community_repository.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final CommunityPost post;

  const PostDetailScreen({super.key, required this.post});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _replyController = TextEditingController();
  bool _isLiked = false;
  int _likeCount = 0;
  List<CommunityReply> _replies = [];
  bool _isSendingReply = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likeCount;
    _replies = widget.post.replies;
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _toggleLike() async {
    try {
      await ref.read(communityRepositoryProvider).likePost(widget.post.id);
      setState(() {
        _isLiked = !_isLiked;
        _likeCount += _isLiked ? 1 : -1;
      });
    } catch (_) {}
  }

  Future<void> _sendReply() async {
    final content = _replyController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSendingReply = true);

    try {
      final reply = await ref.read(communityRepositoryProvider).replyToPost(
        postId: widget.post.id,
        content: content,
      );

      setState(() {
        _replies = [reply, ..._replies];
        _replyController.clear();
        _isSendingReply = false;
      });
    } catch (e) {
      setState(() => _isSendingReply = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send reply: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showReportOption(BuildContext context, String id, String type) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Report $type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Why are you reporting this content?',
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
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report submitted. Thank you.'),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.flag_outlined,
              color: AppColors.slate,
            ),
            onPressed: () => _showReportOption(
              context,
              widget.post.id,
              'post',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0,
              ),
              children: [
                _buildPostContent(context, isDark),
                if (widget.post.isModerated) ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildModerationNotice(context, isDark),
                ],
                const SizedBox(height: AppSpacing.lg),
                _buildLikeButton(context, isDark),
                const Divider(height: AppSpacing.xxl),
                Text(
                  '${_replies.length} ${_replies.length == 1 ? 'Reply' : 'Replies'}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (_replies.isEmpty)
                  _buildEmptyReplies(context, isDark)
                else
                  ..._replies.map((reply) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _buildReplyCard(context, reply, isDark),
                  )),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
          _buildReplyInput(context, isDark),
        ],
      ),
    );
  }

  Widget _buildPostContent(BuildContext context, bool isDark) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.forestGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 18,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anonymous \u00b7 ${widget.post.anonymousUserId.length >= 12 ? widget.post.anonymousUserId.substring(0, 8) : widget.post.anonymousUserId}',
                    style: AppTypography.light.labelSmall?.copyWith(
                      color: AppColors.slate,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.post.createdAt != null)
                    Text(
                      _formatDate(widget.post.createdAt!),
                      style: AppTypography.light.labelSmall?.copyWith(
                        color: AppColors.slate.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            widget.post.content,
            style: AppTypography.light.bodyMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModerationNotice(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              widget.post.moderationAction != null
                  ? 'This post has been moderated: ${widget.post.moderationAction}'
                  : 'This post has been flagged for moderation.',
              style: AppTypography.light.labelSmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeButton(BuildContext context, bool isDark) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: _isLiked ? AppColors.error : AppColors.slate,
          ),
          onPressed: _toggleLike,
        ),
        Text(
          '$_likeCount',
          style: AppTypography.light.bodySmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(width: AppSpacing.xxl),
        Icon(
          Icons.chat_bubble_outline_rounded,
          size: 18,
          color: AppColors.slate,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          '${_replies.length}',
          style: AppTypography.light.bodySmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
      ],
    );
  }

  Widget _buildReplyCard(
    BuildContext context,
    CommunityReply reply,
    bool isDark,
  ) {
    return AppCard.standard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.sage.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person_outline_rounded,
                    size: 14,
                    color: AppColors.sage,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Anonymous \u00b7 ${reply.anonymousUserId.length >= 12 ? reply.anonymousUserId.substring(0, 8) : reply.anonymousUserId}',
                style: AppTypography.light.labelSmall?.copyWith(
                  color: AppColors.slate,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (reply.createdAt != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _formatDate(reply.createdAt!),
                  style: AppTypography.light.labelSmall?.copyWith(
                    color: AppColors.slate.withValues(alpha: 0.6),
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            reply.content,
            style: AppTypography.light.bodySmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.favorite_border_rounded,
                size: 14,
                color: AppColors.slate,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${reply.likeCount}',
                style: AppTypography.light.labelSmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _showReportOption(
                  context,
                  reply.id,
                  'reply',
                ),
                child: Text(
                  'Report',
                  style: AppTypography.light.labelSmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyReplies(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 36,
              color: AppColors.slate.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No replies yet. Start the conversation.',
              style: AppTypography.light.bodySmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyInput(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.sm,
        MediaQuery.of(context).padding.bottom + AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _replyController,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Write a reply...',
                hintStyle: TextStyle(
                  color: AppColors.slate.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendReply(),
            ),
          ),
          IconButton(
            icon: _isSendingReply
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.forestGreen,
                    ),
                  )
                : Icon(
                    Icons.send_rounded,
                    color: _replyController.text.trim().isEmpty
                        ? AppColors.slate.withValues(alpha: 0.3)
                        : AppColors.forestGreen,
                  ),
            onPressed: _replyController.text.trim().isEmpty ? null : _sendReply,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
