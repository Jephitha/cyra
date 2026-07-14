import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/features/community/models/community_models.dart';
import 'package:cyra/features/community/providers/community_providers.dart';
import 'package:cyra/features/community/repositories/community_repository.dart';
import 'package:cyra/features/community/screens/topic_screen.dart';
import 'package:cyra/features/community/screens/community_guidelines_screen.dart';

class CommunityHubScreen extends ConsumerWidget {
  const CommunityHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicsAsync = ref.watch(communityTopicsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(communityTopicsProvider.future),
        color: AppColors.forestGreen,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xxxxl,
            AppSpacing.lg,
            AppSpacing.xxxl,
          ),
          children: [
            _buildWelcomeBanner(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildPrivacyNotice(context, isDark),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionHeader(context, 'Topic Groups', isDark),
            const SizedBox(height: AppSpacing.sm),
            topicsAsync.when(
              data: (topics) => topics.isEmpty
                  ? _buildEmptyState(context, isDark)
                  : _buildTopicGrid(context, topics, isDark, ref),
              loading: () => _buildTopicGridShimmer(isDark),
              error: (e, _) => _buildErrorState(context, e.toString(), isDark),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionHeader(context, 'My Activity', isDark),
            const SizedBox(height: AppSpacing.sm),
            _buildMyActivity(context, isDark),
            const SizedBox(height: AppSpacing.xxl),
            _buildLinks(context, ref, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.forestGreen, AppColors.forestGreenLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cyra Community',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.onBrand,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Connect anonymously with others on similar journeys',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onBrand.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.onBrand.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                Icons.favorite_outline_rounded,
                color: AppColors.onBrand,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyNotice(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.sage.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.sage.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, size: 20, color: AppColors.sage),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Your identity is protected. No personal information is shared.',
                  style: AppTypography.light.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.charcoal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: () => context.go('/sign-in'),
            icon: Icon(
              Icons.login_rounded,
              size: 16,
              color: AppColors.forestGreen,
            ),
            label: Text(
              'Sign in to sync your activity',
              style: AppTypography.light.labelSmall?.copyWith(
                color: AppColors.forestGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isDark) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTopicGrid(
    BuildContext context,
    List<CommunityTopic> topics,
    bool isDark,
    WidgetRef ref,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.25,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: topics.length,
      itemBuilder: (context, index) =>
          _buildTopicCard(context, topics[index], isDark, ref),
    );
  }

  Widget _buildTopicCard(
    BuildContext context,
    CommunityTopic topic,
    bool isDark,
    WidgetRef ref,
  ) {
    final iconMap = {
      'Trying to Conceive': Icons.favorite_outline_rounded,
      'Pregnancy': Icons.child_care_outlined,
      'PCOS Support': Icons.healing_outlined,
      'Endometriosis Support': Icons.healing_outlined,
      'PMDD Support': Icons.mood_bad_outlined,
      'New to Tracking': Icons.track_changes_rounded,
      'General Discussion': Icons.forum_outlined,
    };

    final icon = iconMap[topic.name] ?? Icons.forum_outlined;
    final joinedTopics = ref.watch(joinedTopicsProvider);
    final isJoined = joinedTopics.contains(topic.id);

    return AppCard.interactive(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => TopicScreen(topic: topic)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 20, color: AppColors.forestGreen),
          ),
          const Spacer(),
          Text(
            topic.name,
            style: AppTypography.light.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(
                Icons.people_outline_rounded,
                size: 12,
                color: AppColors.slate,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${topic.memberCount}',
                style: AppTypography.light.labelSmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 12,
                color: AppColors.slate,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${topic.postCount}',
                style: AppTypography.light.labelSmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                if (isJoined) {
                  ref.read(joinedTopicsProvider.notifier).leave(topic.id);
                  ref.read(communityRepositoryProvider).leaveTopic(topic.id);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Left topic')));
                } else {
                  ref.read(joinedTopicsProvider.notifier).join(topic.id);
                  ref.read(communityRepositoryProvider).joinTopic(topic.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Joined topic! You can now participate.'),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isJoined ? AppColors.forestGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.forestGreen),
                ),
                child: Text(
                  isJoined ? 'Joined' : 'Join',
                  style: TextStyle(
                    fontSize: 12,
                    color: isJoined ? AppColors.onBrand : AppColors.forestGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicGridShimmer(bool isDark) {
    final baseColor = isDark
        ? AppColors.charcoal.withValues(alpha: 0.3)
        : AppColors.borderLight;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.25,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
        child: Column(
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.slate),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Unable to load community',
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

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.charcoal.withValues(alpha: 0.2)
            : AppColors.warmIvory.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
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
              Icons.forum_outlined,
              size: 32,
              color: AppColors.forestGreen,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Welcome to the Cyra Community',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'A safe space to connect anonymously',
            textAlign: TextAlign.center,
            style: AppTypography.light.bodySmall?.copyWith(
              color: AppColors.slate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyActivity(BuildContext context, bool isDark) {
    return AppCard.interactive(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const MyActivityScreen()),
        );
      },
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              Icons.person_outline_rounded,
              size: 20,
              color: AppColors.forestGreen,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Activity',
                  style: AppTypography.light.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'View your posts and replies',
                  style: AppTypography.light.labelSmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.slate),
        ],
      ),
    );
  }

  Widget _buildLinks(BuildContext context, WidgetRef ref, bool isDark) {
    return Column(
      children: [
        _buildLinkRow(
          context,
          icon: Icons.article_outlined,
          label: 'Community Guidelines',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const CommunityGuidelinesScreen(),
            ),
          ),
          isDark: isDark,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildLinkRow(
          context,
          icon: Icons.flag_outlined,
          label: 'Report a Concern',
          onTap: () => _showReportDialog(context, ref),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildLinkRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return AppCard.interactive(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.sage),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: AppTypography.light.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
            ),
          ),
          const Spacer(),
          Icon(Icons.chevron_right_rounded, color: AppColors.slate),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context, WidgetRef ref) {
    final reasonController = TextEditingController();
    String selectedType = 'general';

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Report a Concern'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'If you see something that violates our community guidelines, '
                  'please describe what happened. All reports are reviewed '
                  'anonymously and kept confidential.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                const Text(
                  'What would you like to report?',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  items: const [
                    DropdownMenuItem(
                      value: 'general',
                      child: Text('General Concern'),
                    ),
                    DropdownMenuItem(
                      value: 'post',
                      child: Text('A Specific Post'),
                    ),
                    DropdownMenuItem(
                      value: 'reply',
                      child: Text('A Specific Reply'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) setDialogState(() => selectedType = v);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
                if (selectedType == 'post' || selectedType == 'reply') ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Text(
                      'To report a specific post or reply, please navigate to that content and use the report option there.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Describe your concern',
                    border: OutlineInputBorder(),
                    hintText: 'Please provide details...',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please describe your concern'),
                    ),
                  );
                  return;
                }
                Navigator.of(ctx).pop();
                try {
                  await ref
                      .read(communityRepositoryProvider)
                      .reportContent(
                        contentType: selectedType,
                        contentId: '',
                        reason: reason,
                      );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Your report has been submitted. Thank you.',
                        ),
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
              child: const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyActivityScreen extends ConsumerWidget {
  const MyActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPostsAsync = ref.watch(myCommunityPostsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Activity'),
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
      ),
      body: myPostsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.forum_outlined,
                      size: 48,
                      color: AppColors.slate,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'No activity yet',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Your posts and replies will appear here',
                      style: AppTypography.light.bodySmall?.copyWith(
                        color: AppColors.slate,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final post = posts[index];
              return AppCard.standard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.light.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_border_rounded,
                          size: 14,
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
                          size: 14,
                          color: AppColors.slate,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(
                          '${post.replyCount}',
                          style: AppTypography.light.labelSmall?.copyWith(
                            color: AppColors.slate,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
