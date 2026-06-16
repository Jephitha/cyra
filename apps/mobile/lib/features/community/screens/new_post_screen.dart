import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/app_typography.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_button.dart';
import 'package:cyra/features/community/models/community_models.dart';
import 'package:cyra/features/community/providers/community_providers.dart';
import 'package:cyra/features/community/repositories/community_repository.dart';
import 'package:cyra/features/community/screens/community_guidelines_screen.dart';

class NewPostScreen extends ConsumerStatefulWidget {
  final CommunityTopic? topic;

  const NewPostScreen({super.key, this.topic});

  @override
  ConsumerState<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends ConsumerState<NewPostScreen> {
  final _contentController = TextEditingController();
  CommunityTopic? _selectedTopic;
  bool _agreeToGuidelines = false;
  bool _isAnonymous = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedTopic = widget.topic;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _selectedTopic != null &&
      _contentController.text.trim().isNotEmpty &&
      _agreeToGuidelines &&
      !_isSubmitting;

  Future<void> _onSubmit() async {
    if (!_canSubmit) return;

    setState(() => _isSubmitting = true);

    try {
      await ref.read(communityRepositoryProvider).createPost(
        topicId: _selectedTopic!.id,
        content: _contentController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your post has been shared anonymously.'),
            backgroundColor: AppColors.forestGreen,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create post: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final topicsAsync = ref.watch(communityTopicsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Share anonymously with the community',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          if (widget.topic == null)
            _buildTopicSelector(context, topicsAsync, isDark)
          else
            _buildPreSelectedTopic(context, isDark),
          const SizedBox(height: AppSpacing.xxl),
          _buildContentField(context, isDark),
          const SizedBox(height: AppSpacing.xxl),
          _buildAnonymousToggle(context, isDark),
          const SizedBox(height: AppSpacing.xxl),
          _buildGuidelinesAgreement(context, isDark),
          const SizedBox(height: AppSpacing.xxl),
          _buildModerationNotice(context, isDark),
          const SizedBox(height: AppSpacing.xxxl),
          AppButton.primary(
            'Submit Post',
            icon: Icons.send_rounded,
            isDisabled: !_canSubmit,
            isLoading: _isSubmitting,
            onPressed: _onSubmit,
            width: double.infinity,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildTopicSelector(
    BuildContext context,
    AsyncValue<List<CommunityTopic>> topicsAsync,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topic',
          style: AppTypography.light.labelMedium?.copyWith(
            color: AppColors.slate,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        topicsAsync.when(
          data: (topics) => DropdownButtonFormField<CommunityTopic>(
            value: _selectedTopic,
            hint: const Text('Select a topic'),
            items: topics.map((topic) {
              return DropdownMenuItem(
                value: topic,
                child: Text(topic.name),
              );
            }).toList(),
            onChanged: (topic) {
              setState(() => _selectedTopic = topic);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
          ),
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text(
            'Failed to load topics',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ],
    );
  }

  Widget _buildPreSelectedTopic(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.forestGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: AppColors.forestGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.forum_outlined, size: 20, color: AppColors.forestGreen),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Posting in',
                style: AppTypography.light.labelSmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
              Text(
                widget.topic!.name,
                style: AppTypography.light.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentField(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your post',
          style: AppTypography.light.labelMedium?.copyWith(
            color: AppColors.slate,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: _contentController,
          maxLines: 6,
          maxLength: 2000,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Share your thoughts, experiences, or questions...',
            hintStyle: TextStyle(color: AppColors.slate.withValues(alpha: 0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: const BorderSide(color: AppColors.forestGreen),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnonymousToggle(BuildContext context, bool isDark) {
    return Row(
      children: [
        Icon(
          Icons.shield_outlined,
          size: 20,
          color: AppColors.forestGreen,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Post anonymously',
                style: AppTypography.light.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
              Text(
                'Your identity will not be revealed',
                style: AppTypography.light.labelSmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: _isAnonymous,
          onChanged: (v) => setState(() => _isAnonymous = v),
          activeColor: AppColors.forestGreen,
        ),
      ],
    );
  }

  Widget _buildGuidelinesAgreement(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CommunityGuidelinesScreen(),
            ),
          ),
          borderRadius: BorderRadius.circular(AppRadius.xs),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Text(
              'Read Community Guidelines',
              style: AppTypography.light.labelSmall?.copyWith(
                color: AppColors.forestGreen,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _agreeToGuidelines,
                onChanged: (v) => setState(() => _agreeToGuidelines = v ?? false),
                activeColor: AppColors.forestGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'I agree to the community guidelines',
                style: AppTypography.light.bodySmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModerationNotice(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.softGold.withValues(alpha: isDark ? 0.1 : 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: AppColors.softGold.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 16,
            color: AppColors.softGold,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Posts are reviewed for safety. '
              'Harmful content will be removed.',
              style: AppTypography.light.labelSmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
