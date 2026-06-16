import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:cyra/features/education/models/education_models.dart';
import 'package:cyra/features/education/repositories/education_repository.dart';

part 'education_providers.g.dart';

@Riverpod(keepAlive: true)
EducationRepository educationRepository(EducationRepositoryRef ref) {
  return EducationRepository();
}

@riverpod
List<ArticleCategory> articleCategories(ArticleCategoriesRef ref) {
  return ref.watch(educationRepositoryProvider).getCategories();
}

@riverpod
List<Article> allArticles(AllArticlesRef ref) {
  return ref.watch(educationRepositoryProvider).getAllArticles();
}

@riverpod
List<Article> articlesByCategory(ArticlesByCategoryRef ref, String category) {
  return ref.watch(educationRepositoryProvider).getArticlesByCategory(category);
}

@riverpod
List<Article> featuredArticles(FeaturedArticlesRef ref) {
  return ref.watch(educationRepositoryProvider).getFeaturedArticles();
}

@riverpod
List<Article> trendingArticles(TrendingArticlesRef ref) {
  return ref.watch(educationRepositoryProvider).getTrendingArticles();
}

@riverpod
List<Article> recentlyViewedArticles(RecentlyViewedArticlesRef ref) {
  return ref.watch(educationRepositoryProvider).getRecentlyViewedArticles();
}

@riverpod
List<Article> offlineArticles(OfflineArticlesRef ref) {
  final repo = ref.watch(educationRepositoryProvider);
  ref.listen(educationRepositoryProvider, (_, __) {});
  return repo.getOfflineArticles();
}

@riverpod
List<Article> bookmarkedArticles(BookmarkedArticlesRef ref) {
  final repo = ref.watch(educationRepositoryProvider);
  ref.listen(educationRepositoryProvider, (_, __) {});
  return repo.getBookmarkedArticles();
}

@riverpod
Article? articleById(ArticleByIdRef ref, String id) {
  return ref.watch(educationRepositoryProvider).getArticleById(id);
}

@riverpod
List<Article> relatedArticles(RelatedArticlesRef ref, Article article) {
  return ref.watch(educationRepositoryProvider).getRelatedArticles(article);
}

@riverpod
List<Article> searchArticles(SearchArticlesRef ref, String query) {
  return ref.watch(educationRepositoryProvider).searchArticles(query);
}

@riverpod
class ArticleActions extends _$ArticleActions {
  @override
  Future<void> build() => Future.value();

  void markAsRead(String articleId) {
    final repo = ref.read(educationRepositoryProvider);
    repo.markAsRead(articleId);
    ref.invalidate(recentlyViewedArticlesProvider);
  }

  void toggleOffline(String articleId) {
    final repo = ref.read(educationRepositoryProvider);
    repo.toggleOffline(articleId);
    ref.invalidate(offlineArticlesProvider);
  }

  void toggleBookmark(String articleId) {
    final repo = ref.read(educationRepositoryProvider);
    repo.toggleBookmark(articleId);
    ref.invalidate(bookmarkedArticlesProvider);
  }

  bool isRead(String articleId) {
    return ref.read(educationRepositoryProvider).isRead(articleId);
  }

  bool isOffline(String articleId) {
    return ref.read(educationRepositoryProvider).isOfflineAvailable(articleId);
  }

  bool isBookmarked(String articleId) {
    return ref.read(educationRepositoryProvider).isBookmarked(articleId);
  }
}
