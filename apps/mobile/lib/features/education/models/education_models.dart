import 'package:freezed_annotation/freezed_annotation.dart';

part 'education_models.freezed.dart';
part 'education_models.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    required String id,
    required String title,
    required String content,
    required String category,
    String? summary,
    @Default(false) bool isOfflineAvailable,
    DateTime? medicalReviewDate,
    String? reviewAuthor,
    @Default(5) int readTimeMinutes,
    @Default([]) List<String> tags,
    String? imageAsset,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}

@freezed
class ArticleCategory with _$ArticleCategory {
  const factory ArticleCategory({
    required String id,
    required String name,
    required String description,
    required String iconName,
    required int articleCount,
  }) = _ArticleCategory;

  factory ArticleCategory.fromJson(Map<String, dynamic> json) =>
      _$ArticleCategoryFromJson(json);
}
