import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/features/education/models/education_models.dart';
import 'package:cyra/features/education/providers/education_providers.dart';

final _fontSizeProvider = StateProvider<double>((ref) => 16.0);

class ArticleReaderScreen extends ConsumerStatefulWidget {
  final String articleId;

  const ArticleReaderScreen({super.key, required this.articleId});

  @override
  ConsumerState<ArticleReaderScreen> createState() => _ArticleReaderScreenState();
}

class _ArticleReaderScreenState extends ConsumerState<ArticleReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(articleActionsProvider.notifier).markAsRead(widget.articleId);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final progress = maxScroll > 0 ? currentScroll / maxScroll : 0;
    if ((progress - _scrollProgress).abs() > 0.01) {
      setState(() => _scrollProgress = progress.clamp(0.0, 1.0) as double);
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = ref.watch(articleByIdProvider(widget.articleId));
    if (article == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Article not found')),
      );
    }

    final isOffline =
        ref.read(articleActionsProvider.notifier).isOffline(article.id);
    final isBookmarked =
        ref.read(articleActionsProvider.notifier).isBookmarked(article.id);
    final fontSize = ref.watch(_fontSizeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasReview = article.medicalReviewDate != null;
    final categoryColor = _categoryColor(article.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Article',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.slate,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              color: isBookmarked ? AppColors.softGold : null,
            ),
            onPressed: () => ref.read(articleActionsProvider.notifier).toggleBookmark(article.id),
            tooltip: 'Bookmark',
          ),
          IconButton(
            icon: Icon(
              isOffline ? Icons.download_done_rounded : Icons.download_outlined,
              color: isOffline ? AppColors.forestGreen : null,
            ),
            onPressed: () => ref.read(articleActionsProvider.notifier).toggleOffline(article.id),
            tooltip: 'Save offline',
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => Share.share(
              '${article.title}\n\nRead more in Cyra',
            ),
            tooltip: 'Share',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_scrollProgress > 0)
            LinearProgressIndicator(
              value: _scrollProgress,
              backgroundColor: AppColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.forestGreen),
            ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxxl,
              ),
              children: [
                _ArticleHeader(
                  article: article,
                  categoryColor: categoryColor,
                  isDark: isDark,
                  hasReview: hasReview,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (hasReview)
                  _MedicalReviewBadge(
                    article: article,
                    isDark: isDark,
                  ),
                if (hasReview) const SizedBox(height: AppSpacing.lg),
                _FontSizeAdjuster(
                  currentSize: fontSize,
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.lg),
                _ArticleContent(
                  content: _parseContent(article.content),
                  fontSize: fontSize,
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.xxl),
                _RelatedArticlesSection(
                  article: article,
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.xxl),
                _DisclaimerFooter(isDark: isDark),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_ContentBlock> _parseContent(String content) {
    final blocks = <_ContentBlock>[];
    final lines = content.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('**') && trimmed.endsWith('**') && trimmed.length > 4) {
        blocks.add(_ContentBlock(type: _BlockType.heading, text: trimmed.replaceAll('**', '')));
      } else if (trimmed.startsWith('- ')) {
        blocks.add(_ContentBlock(type: _BlockType.listItem, text: trimmed.substring(2)));
      } else if (trimmed.startsWith('Days ') || trimmed.startsWith('Weeks ') || trimmed.startsWith('How ') || trimmed.startsWith('When ') || trimmed.startsWith('General ') || trimmed.startsWith('Practical ')) {
        blocks.add(_ContentBlock(type: _BlockType.subheading, text: trimmed));
      } else {
        blocks.add(_ContentBlock(type: _BlockType.paragraph, text: trimmed));
      }
    }
    return blocks;
  }
}

class _ContentBlock {
  final _BlockType type;
  final String text;
  const _ContentBlock({required this.type, required this.text});
}

enum _BlockType { heading, subheading, paragraph, listItem }

class _ArticleHeader extends StatelessWidget {
  final Article article;
  final Color categoryColor;
  final bool isDark;
  final bool hasReview;

  const _ArticleHeader({
    required this.article,
    required this.categoryColor,
    required this.isDark,
    required this.hasReview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Text(
                _categoryLabel(article.category),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: categoryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(Icons.schedule_rounded, size: 14, color: AppColors.slate),
            const SizedBox(width: AppSpacing.xxs),
            Text(
              '${article.readTimeMinutes} min read',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          article.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        if (article.summary != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            article.summary!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.slate,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        if (article.medicalReviewDate != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'Last reviewed: ${DateFormat('MMMM d, yyyy').format(article.medicalReviewDate!)}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.slate,
            ),
          ),
        ],
        if (article.tags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: article.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark ? AppColors.charcoal.withValues(alpha: 0.4) : AppColors.mistWhite,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Text(
                tag,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.slate,
                  fontSize: 10,
                ),
              ),
            )).toList(),
          ),
        ],
      ],
    );
  }
}

class _MedicalReviewBadge extends StatelessWidget {
  final Article article;
  final bool isDark;

  const _MedicalReviewBadge({required this.article, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.sage.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: AppColors.sage.withValues(alpha: isDark ? 0.3 : 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_rounded, size: 20, color: AppColors.sage),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medically reviewed',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.sage,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${article.reviewAuthor ?? 'Medical professional'} on ${DateFormat('MMMM d, yyyy').format(article.medicalReviewDate!)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FontSizeAdjuster extends ConsumerWidget {
  final double currentSize;
  final bool isDark;

  const _FontSizeAdjuster({required this.currentSize, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Icon(Icons.text_fields_rounded, size: 16, color: AppColors.slate),
        const SizedBox(width: AppSpacing.sm),
        _FontSizeButton(
          icon: Icons.text_decrease_rounded,
          onTap: () {
            final current = ref.read(_fontSizeProvider);
            if (current > 14) {
              ref.read(_fontSizeProvider.notifier).state = current - 2;
            }
          },
          isDark: isDark,
          enabled: currentSize > 14,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '${currentSize.round()}',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.slate,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _FontSizeButton(
          icon: Icons.text_increase_rounded,
          onTap: () {
            final current = ref.read(_fontSizeProvider);
            if (current < 22) {
              ref.read(_fontSizeProvider.notifier).state = current + 2;
            }
          },
          isDark: isDark,
          enabled: currentSize < 22,
        ),
      ],
    );
  }
}

class _FontSizeButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final bool enabled;

  const _FontSizeButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled
              ? (isDark ? AppColors.charcoal.withValues(alpha: 0.4) : AppColors.mistWhite)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: enabled
                ? (isDark ? AppColors.borderDark : AppColors.borderLight)
                : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.slate : AppColors.slate.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _ArticleContent extends StatelessWidget {
  final List<_ContentBlock> content;
  final double fontSize;
  final bool isDark;

  const _ArticleContent({
    required this.content,
    required this.fontSize,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content.map((block) {
        switch (block.type) {
          case _BlockType.heading:
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
              child: Text(
                block.text,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            );
          case _BlockType.subheading:
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
              child: Text(
                block.text,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            );
          case _BlockType.paragraph:
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                block.text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: fontSize,
                  height: 1.7,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            );
          case _BlockType.listItem:
            return Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.lg,
                bottom: AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\u2022',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: fontSize,
                      color: AppColors.forestGreen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      block.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: fontSize,
                        height: 1.7,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
      }).toList(),
    );
  }
}

class _RelatedArticlesSection extends ConsumerWidget {
  final Article article;
  final bool isDark;

  const _RelatedArticlesSection({required this.article, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final related = ref.watch(relatedArticlesProvider(article));

    if (related.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Articles',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...related.map((r) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: AppCard.interactive(
            padding: const EdgeInsets.all(AppSpacing.md),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => ArticleReaderScreen(articleId: r.id),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _categoryColor(r.category).withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    _categoryIcon(r.category),
                    size: 22,
                    color: _categoryColor(r.category),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded, size: 12, color: AppColors.slate),
                          const SizedBox(width: AppSpacing.xxs),
                          Text(
                            '${r.readTimeMinutes} min',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.slate,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 20, color: AppColors.slate),
              ],
            ),
          ),
        )),
      ],
    );
  }
}

class _DisclaimerFooter extends StatelessWidget {
  final bool isDark;

  const _DisclaimerFooter({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.charcoal.withValues(alpha: 0.3) : AppColors.warmIvory,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: AppColors.slate),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Educational Information',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This article is for educational purposes and does not constitute medical advice. '
            'Always consult a qualified healthcare provider for personal medical concerns, '
            'diagnosis, or treatment. The information in this article is based on medical '
            'literature available at the time of review and may not reflect the most current '
            'research or guidelines.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.slate,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

Color _categoryColor(String id) {
  switch (id) {
    case 'menstrual_health':
      return const Color(0xFFE86B6B);
    case 'fertility':
      return AppColors.softGold;
    case 'pregnancy':
      return AppColors.forestGreen;
    case 'nutrition':
      return AppColors.sage;
    case 'hormonal_health':
      return const Color(0xFF7C5CBF);
    case 'wellness':
      return const Color(0xFF5B8DEF);
    default:
      return AppColors.forestGreen;
  }
}

IconData _categoryIcon(String id) {
  switch (id) {
    case 'menstrual_health':
      return Icons.repeat_rounded;
    case 'fertility':
      return Icons.pets_rounded;
    case 'pregnancy':
      return Icons.child_care_rounded;
    case 'nutrition':
      return Icons.restaurant_rounded;
    case 'hormonal_health':
      return Icons.science_rounded;
    case 'wellness':
      return Icons.self_improvement_rounded;
    default:
      return Icons.article_rounded;
  }
}

String _categoryLabel(String id) {
  switch (id) {
    case 'menstrual_health':
      return 'Menstrual Health';
    case 'fertility':
      return 'Fertility';
    case 'pregnancy':
      return 'Pregnancy';
    case 'nutrition':
      return 'Nutrition';
    case 'hormonal_health':
      return 'Hormonal Health';
    case 'wellness':
      return 'Wellness';
    default:
      return 'General';
  }
}
