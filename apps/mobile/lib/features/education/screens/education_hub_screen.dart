import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/features/education/models/education_models.dart';
import 'package:cyra/features/education/providers/education_providers.dart';
import 'package:cyra/features/education/screens/article_list_screen.dart';
import 'package:cyra/features/education/screens/article_reader_screen.dart';

final _searchProvider = StateProvider<String>((ref) => '');

class EducationHubScreen extends ConsumerWidget {
  const EducationHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(articleCategoriesProvider);
    final featured = ref.watch(featuredArticlesProvider);
    final recent = ref.watch(recentlyViewedArticlesProvider);
    final offline = ref.watch(offlineArticlesProvider);
    final bookmarked = ref.watch(bookmarkedArticlesProvider);
    final searchQuery = ref.watch(_searchProvider);
    final searchResults = ref.watch(searchArticlesProvider(searchQuery));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Education Center'),
      ),
      body: Column(
        children: [
          _SearchBar(
            onChanged: (v) => ref.read(_searchProvider.notifier).state = v,
          ),
          Expanded(
            child: searchQuery.isNotEmpty
                ? _SearchResultsList(
                    results: searchResults,
                    query: searchQuery,
                    isDark: isDark,
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxxl,
                    ),
                    children: [
                      if (featured.isNotEmpty)
                        _FeaturedSection(
                          articles: featured,
                          isDark: isDark,
                        ),
                      const SizedBox(height: AppSpacing.xxl),
                      _SectionHeader(title: 'Browse by Topic'),
                      const SizedBox(height: AppSpacing.md),
                      _CategoryGrid(
                        categories: categories,
                        isDark: isDark,
                      ),
                      if (recent.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xxl),
                        _SectionHeader(title: 'Recently Viewed'),
                        const SizedBox(height: AppSpacing.md),
                        _ArticleHorizontalList(
                          articles: recent,
                          isDark: isDark,
                        ),
                      ],
                      if (offline.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xxl),
                        _SectionHeader(
                          title: 'Saved for Offline',
                          trailing: '${offline.length} articles',
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _ArticleHorizontalList(
                          articles: offline,
                          isDark: isDark,
                        ),
                      ],
                      if (bookmarked.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xxl),
                        _SectionHeader(
                          title: 'Bookmarked',
                          trailing: '${bookmarked.length} articles',
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _ArticleHorizontalList(
                          articles: bookmarked,
                          isDark: isDark,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm,
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search articles...',
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.slate),
          filled: true,
          fillColor: isDark
              ? AppColors.charcoal.withValues(alpha: 0.3)
              : AppColors.mistWhite,
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
            borderSide: const BorderSide(color: AppColors.forestGreen, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  final List<Article> results;
  final String query;
  final bool isDark;

  const _SearchResultsList({
    required this.results,
    required this.query,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded,
                  size: 48, color: AppColors.slate.withValues(alpha: 0.5)),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'No results found for "$query"',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.slate,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Try different keywords or browse categories',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.slate.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxxl,
      ),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final article = results[index];
        return _ArticleSearchTile(
          article: article,
          isDark: isDark,
          query: query,
        );
      },
    );
  }
}

class _ArticleSearchTile extends StatelessWidget {
  final Article article;
  final bool isDark;
  final String query;

  const _ArticleSearchTile({
    required this.article,
    required this.isDark,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(article.category);
    return AppCard.interactive(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ArticleReaderScreen(articleId: article.id),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              _categoryIcon(article.category),
              size: 22,
              color: categoryColor,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
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
                    _CategoryChip(label: _categoryLabel(article.category), color: categoryColor),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${article.readTimeMinutes} min',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.slate,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.chevron_right, size: 20, color: AppColors.slate),
        ],
      ),
    );
  }
}

class _FeaturedSection extends StatelessWidget {
  final List<Article> articles;
  final bool isDark;

  const _FeaturedSection({required this.articles, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: _SectionHeader(title: 'Featured Articles'),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final article = articles[index];
              return _FeaturedCard(article: article, isDark: isDark);
            },
          ),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Article article;
  final bool isDark;

  const _FeaturedCard({required this.article, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(article.category);
    return SizedBox(
      width: 260,
      child: AppCard.interactive(
        padding: const EdgeInsets.all(AppSpacing.lg),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArticleReaderScreen(articleId: article.id),
          ),
        ),
        child: Column(
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
                const Spacer(),
                Icon(Icons.bookmark_outline_rounded,
                    size: 18, color: AppColors.slate),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (article.summary != null)
                    Text(
                      article.summary!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.slate,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 14, color: AppColors.slate),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${article.readTimeMinutes} min read',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.slate,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;

  const _SectionHeader({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (trailing != null) ...[
          const Spacer(),
          Text(
            trailing!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.slate,
            ),
          ),
        ],
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final List<ArticleCategory> categories;
  final bool isDark;

  const _CategoryGrid({required this.categories, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.3,
      ),
      itemCount: categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryCard(category: category, isDark: isDark);
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ArticleCategory category;
  final bool isDark;

  const _CategoryCard({required this.category, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(category.id);
    return AppCard.interactive(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ArticleListScreen(categoryId: category.id),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: isDark ? 0.15 : 0.08),
              color.withValues(alpha: isDark ? 0.05 : 0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.3 : 0.15),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                _categoryIcon(category.id),
                size: 22,
                color: color,
              ),
            ),
            const Spacer(),
            Text(
              category.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              '${category.articleCount} articles',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.slate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleHorizontalList extends StatelessWidget {
  final List<Article> articles;
  final bool isDark;

  const _ArticleHorizontalList({required this.articles, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: articles.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final article = articles[index];
          return _MiniArticleCard(article: article, isDark: isDark);
        },
      ),
    );
  }
}

class _MiniArticleCard extends StatelessWidget {
  final Article article;
  final bool isDark;

  const _MiniArticleCard({required this.article, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor(article.category);
    return SizedBox(
      width: 200,
      child: AppCard.interactive(
        padding: const EdgeInsets.all(AppSpacing.md),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArticleReaderScreen(articleId: article.id),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_categoryIcon(article.category),
                    size: 14, color: categoryColor),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    _categoryLabel(article.category),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: categoryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: Text(
                article.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 12, color: AppColors.slate),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  '${article.readTimeMinutes} min',
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
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  const _CategoryChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: color),
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
