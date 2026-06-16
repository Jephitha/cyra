import 'package:flutter/foundation.dart';

import 'package:cyra/features/education/data/education_content.dart';
import 'package:cyra/features/education/models/education_models.dart';

class EducationRepository {
  final Set<String> _readArticleIds = {};
  final Set<String> _offlineArticleIds = {};
  final Set<String> _bookmarkedArticleIds = {};
  final List<String> _recentlyViewedIds = [];
  static const int _maxRecent = 10;
  final ValueNotifier<Set<String>> offlineNotifier = ValueNotifier({});
  final ValueNotifier<Set<String>> bookmarksNotifier = ValueNotifier({});

  List<Article> getAllArticles() => EducationContent.articles;

  List<Article> getArticlesByCategory(String category) =>
      EducationContent.getByCategory(category);

  List<Article> getArticlesByTag(String tag) =>
      EducationContent.getByTag(tag);

  Article? getArticleById(String id) => EducationContent.getById(id);

  List<Article> getFeaturedArticles() => EducationContent.featured;

  List<Article> getRelatedArticles(Article article) =>
      EducationContent.getRelated(article);

  List<Article> searchArticles(String query) {
    if (query.trim().isEmpty) return [];
    return EducationContent.search(query.trim());
  }

  List<ArticleCategory> getCategories() => EducationContent.categories;

  void markAsRead(String articleId) {
    _readArticleIds.add(articleId);
    final article = getArticleById(articleId);
    if (article != null) {
      _recentlyViewedIds.remove(articleId);
      _recentlyViewedIds.insert(0, articleId);
      if (_recentlyViewedIds.length > _maxRecent) {
        _recentlyViewedIds.removeLast();
      }
    }
  }

  bool isRead(String articleId) => _readArticleIds.contains(articleId);

  List<Article> getRecentlyViewed() {
    return _recentlyViewedIds
        .map((id) => getArticleById(id))
        .whereType<Article>()
        .toList();
  }

  void toggleOffline(String articleId) {
    final article = getArticleById(articleId);
    if (article == null) return;
    if (_offlineArticleIds.contains(articleId)) {
      _offlineArticleIds.remove(articleId);
    } else {
      _offlineArticleIds.add(articleId);
    }
    offlineNotifier.value = Set.from(_offlineArticleIds);
  }

  bool isOfflineAvailable(String articleId) =>
      _offlineArticleIds.contains(articleId);

  List<Article> getOfflineArticles() {
    return _offlineArticleIds
        .map((id) => getArticleById(id))
        .whereType<Article>()
        .toList();
  }

  void toggleBookmark(String articleId) {
    if (_bookmarkedArticleIds.contains(articleId)) {
      _bookmarkedArticleIds.remove(articleId);
    } else {
      _bookmarkedArticleIds.add(articleId);
    }
    bookmarksNotifier.value = Set.from(_bookmarkedArticleIds);
  }

  bool isBookmarked(String articleId) =>
      _bookmarkedArticleIds.contains(articleId);

  List<Article> getBookmarkedArticles() {
    return _bookmarkedArticleIds
        .map((id) => getArticleById(id))
        .whereType<Article>()
        .toList();
  }

  List<Article> getRecentlyViewedArticles() {
    return getRecentlyViewed();
  }

  List<Article> getTrendingArticles() {
    return EducationContent.articles
        .where((a) => a.tags.contains('cycle basics') || a.tags.contains('pain management'))
        .take(4)
        .toList();
  }
}
