import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyra/core/design/app_colors.dart';
import 'package:cyra/core/design/tokens/app_spacing.dart';
import 'package:cyra/core/design/tokens/app_radius.dart';
import 'package:cyra/core/design/widgets/app_card.dart';
import 'package:cyra/features/education/models/education_models.dart';
import 'package:cyra/features/education/providers/education_providers.dart';
import 'package:cyra/features/education/screens/article_reader_screen.dart';

enum _SortOption { newest, alphabetical, readTime }

final _categorySearchProvider = StateProvider<String>((ref) => '');
final _sortOptionProvider = StateProvider<_SortOption>((ref) => _SortOption.newest);
final _selectedTagProvider = StateProvider<String?>((ref) => null);

class ArticleListScreen extends ConsumerWidget {
  final String categoryId;

  const ArticleListScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(articleCategoriesProvider);
    final category = categories.where((c) => c.id == categoryId).firstOrNull;
    final allArticles = ref.watch(articlesByCategoryProvider(categoryId));
    final searchQuery = ref.watch(_categorySearchProvider);
    final sortOption = ref.watch(_sortOptionProvider);
    final selectedTag = ref.watch(_selectedTagProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    List<Article> processed = List.from(allArticles);

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      processed = processed.where((a) =>
        a.title.toLowerCase().contains(q) ||
        (a.summary?.toLowerCase().contains(q) ?? false) ||
        a.tags.any((t) => t.toLowerCase().contains(q)),
      ).toList();
    }

    if (selectedTag != null) {
      processed = processed.where((a) => a.tags.contains(selectedTag)).toList();
    }

    switch (sortOption) {
      case _SortOption.newest:
        processed.sort((a, b) => (b.createdAt ?? DateTime(2000)).compareTo(a.createdAt ?? DateTime(2000)));
      case _SortOption.alphabetical:
        processed.sort((a, b) => a.title.compareTo(b.title));
      case _SortOption.readTime:
        processed.sort((a, b) => a.readTimeMinutes.compareTo(b.readTimeMinutes));
    }

    final allTags = allArticles
        .expand((a) => a.tags)
        .toSet()
        .toList()
      ..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text(category?.name ?? 'Articles'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm,
            ),
            child: TextField(
              onChanged: (v) => ref.read(_categorySearchProvider.notifier).state = v,
              decoration: InputDecoration(
                hintText: 'Search in ${category?.name ?? 'this category'}...',
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
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                _SortDropdown(sortOption: sortOption, isDark: isDark),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: allTags.isEmpty
                        ? null
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: allTags.length + 1,
                            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return _FilterChip(
                                  label: 'All',
                                  selected: selectedTag == null,
                                  onSelected: () => ref.read(_selectedTagProvider.notifier).state = null,
                                  isDark: isDark,
                                );
                              }
                              final tag = allTags[index - 1];
                              return _FilterChip(
                                label: tag,
                                selected: selectedTag == tag,
                                onSelected: () => ref.read(_selectedTagProvider.notifier).state = tag,
                                isDark: isDark,
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (category != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                category.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: processed.isEmpty
                ? _EmptyState(categoryName: category?.name ?? 'this category', isDark: isDark)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxxl,
                    ),
                    itemCount: processed.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final article = processed[index];
                      return _ArticleCard(
                        article: article,
                        isDark: isDark,
                        categoryColor: _categoryColor(categoryId),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SortDropdown extends ConsumerWidget {
  final _SortOption sortOption;
  final bool isDark;

  const _SortDropdown({required this.sortOption, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: PopupMenuButton<_SortOption>(
        initialValue: sortOption,
        onSelected: (value) => ref.read(_sortOptionProvider.notifier).state = value,
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: _SortOption.newest,
            child: Text('Newest'),
          ),
          const PopupMenuItem(
            value: _SortOption.alphabetical,
            child: Text('Alphabetical'),
          ),
          const PopupMenuItem(
            value: _SortOption.readTime,
            child: Text('Read Time'),
          ),
        ],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort_rounded, size: 18, color: AppColors.slate),
            const SizedBox(width: AppSpacing.xs),
            Text(
              _sortLabel(sortOption),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.slate,
              ),
            ),
            Icon(Icons.arrow_drop_down, size: 18, color: AppColors.slate),
          ],
        ),
      ),
    );
  }

  String _sortLabel(_SortOption option) {
    switch (option) {
      case _SortOption.newest:
        return 'Newest';
      case _SortOption.alphabetical:
        return 'A-Z';
      case _SortOption.readTime:
        return 'Read Time';
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final bool isDark;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.forestGreen.withValues(alpha: isDark ? 0.3 : 0.1)
              : (isDark ? AppColors.charcoal.withValues(alpha: 0.3) : AppColors.mistWhite),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: selected
                ? AppColors.forestGreen
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: selected ? AppColors.forestGreen : AppColors.slate,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ArticleCard extends ConsumerWidget {
  final Article article;
  final bool isDark;
  final Color categoryColor;

  const _ArticleCard({
    required this.article,
    required this.isDark,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline =
        ref.read(articleActionsProvider.notifier).isOffline(article.id);
    final hasReview = article.medicalReviewDate != null;

    return AppCard.interactive(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  article.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
                  ),
                ),
              ),
              if (isOffline)
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                  child: Icon(Icons.download_done_rounded,
                      size: 18, color: AppColors.forestGreen),
                ),
            ],
          ),
          if (article.summary != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              article.summary!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.slate,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 14, color: AppColors.slate),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                '${article.readTimeMinutes} min read',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.slate,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              if (hasReview) ...[
                Icon(Icons.verified_rounded, size: 14, color: AppColors.sage),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  'Medically reviewed',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.sage,
                  ),
                ),
              ],
              const Spacer(),
              Icon(Icons.chevron_right, size: 20, color: AppColors.slate),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String categoryName;
  final bool isDark;

  const _EmptyState({required this.categoryName, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded,
                size: 64, color: AppColors.slate.withValues(alpha: 0.3)),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'No articles in ${categoryName.toLowerCase()} yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.charcoal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Check back soon for new content in this category.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.slate,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
