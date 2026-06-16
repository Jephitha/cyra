// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'education_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return _Article.fromJson(json);
}

/// @nodoc
mixin _$Article {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;
  bool get isOfflineAvailable => throw _privateConstructorUsedError;
  DateTime? get medicalReviewDate => throw _privateConstructorUsedError;
  String? get reviewAuthor => throw _privateConstructorUsedError;
  int get readTimeMinutes => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get imageAsset => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Article to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArticleCopyWith<Article> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleCopyWith<$Res> {
  factory $ArticleCopyWith(Article value, $Res Function(Article) then) =
      _$ArticleCopyWithImpl<$Res, Article>;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    String category,
    String? summary,
    bool isOfflineAvailable,
    DateTime? medicalReviewDate,
    String? reviewAuthor,
    int readTimeMinutes,
    List<String> tags,
    String? imageAsset,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ArticleCopyWithImpl<$Res, $Val extends Article>
    implements $ArticleCopyWith<$Res> {
  _$ArticleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? category = null,
    Object? summary = freezed,
    Object? isOfflineAvailable = null,
    Object? medicalReviewDate = freezed,
    Object? reviewAuthor = freezed,
    Object? readTimeMinutes = null,
    Object? tags = null,
    Object? imageAsset = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            summary: freezed == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOfflineAvailable: null == isOfflineAvailable
                ? _value.isOfflineAvailable
                : isOfflineAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            medicalReviewDate: freezed == medicalReviewDate
                ? _value.medicalReviewDate
                : medicalReviewDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            reviewAuthor: freezed == reviewAuthor
                ? _value.reviewAuthor
                : reviewAuthor // ignore: cast_nullable_to_non_nullable
                      as String?,
            readTimeMinutes: null == readTimeMinutes
                ? _value.readTimeMinutes
                : readTimeMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            imageAsset: freezed == imageAsset
                ? _value.imageAsset
                : imageAsset // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArticleImplCopyWith<$Res> implements $ArticleCopyWith<$Res> {
  factory _$$ArticleImplCopyWith(
    _$ArticleImpl value,
    $Res Function(_$ArticleImpl) then,
  ) = __$$ArticleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    String category,
    String? summary,
    bool isOfflineAvailable,
    DateTime? medicalReviewDate,
    String? reviewAuthor,
    int readTimeMinutes,
    List<String> tags,
    String? imageAsset,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ArticleImplCopyWithImpl<$Res>
    extends _$ArticleCopyWithImpl<$Res, _$ArticleImpl>
    implements _$$ArticleImplCopyWith<$Res> {
  __$$ArticleImplCopyWithImpl(
    _$ArticleImpl _value,
    $Res Function(_$ArticleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? category = null,
    Object? summary = freezed,
    Object? isOfflineAvailable = null,
    Object? medicalReviewDate = freezed,
    Object? reviewAuthor = freezed,
    Object? readTimeMinutes = null,
    Object? tags = null,
    Object? imageAsset = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ArticleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        summary: freezed == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOfflineAvailable: null == isOfflineAvailable
            ? _value.isOfflineAvailable
            : isOfflineAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        medicalReviewDate: freezed == medicalReviewDate
            ? _value.medicalReviewDate
            : medicalReviewDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewAuthor: freezed == reviewAuthor
            ? _value.reviewAuthor
            : reviewAuthor // ignore: cast_nullable_to_non_nullable
                  as String?,
        readTimeMinutes: null == readTimeMinutes
            ? _value.readTimeMinutes
            : readTimeMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        imageAsset: freezed == imageAsset
            ? _value.imageAsset
            : imageAsset // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleImpl implements _Article {
  const _$ArticleImpl({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.summary,
    this.isOfflineAvailable = false,
    this.medicalReviewDate,
    this.reviewAuthor,
    this.readTimeMinutes = 5,
    final List<String> tags = const [],
    this.imageAsset,
    this.createdAt,
    this.updatedAt,
  }) : _tags = tags;

  factory _$ArticleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final String category;
  @override
  final String? summary;
  @override
  @JsonKey()
  final bool isOfflineAvailable;
  @override
  final DateTime? medicalReviewDate;
  @override
  final String? reviewAuthor;
  @override
  @JsonKey()
  final int readTimeMinutes;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? imageAsset;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Article(id: $id, title: $title, content: $content, category: $category, summary: $summary, isOfflineAvailable: $isOfflineAvailable, medicalReviewDate: $medicalReviewDate, reviewAuthor: $reviewAuthor, readTimeMinutes: $readTimeMinutes, tags: $tags, imageAsset: $imageAsset, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.isOfflineAvailable, isOfflineAvailable) ||
                other.isOfflineAvailable == isOfflineAvailable) &&
            (identical(other.medicalReviewDate, medicalReviewDate) ||
                other.medicalReviewDate == medicalReviewDate) &&
            (identical(other.reviewAuthor, reviewAuthor) ||
                other.reviewAuthor == reviewAuthor) &&
            (identical(other.readTimeMinutes, readTimeMinutes) ||
                other.readTimeMinutes == readTimeMinutes) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.imageAsset, imageAsset) ||
                other.imageAsset == imageAsset) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    content,
    category,
    summary,
    isOfflineAvailable,
    medicalReviewDate,
    reviewAuthor,
    readTimeMinutes,
    const DeepCollectionEquality().hash(_tags),
    imageAsset,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleImplCopyWith<_$ArticleImpl> get copyWith =>
      __$$ArticleImplCopyWithImpl<_$ArticleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleImplToJson(this);
  }
}

abstract class _Article implements Article {
  const factory _Article({
    required final String id,
    required final String title,
    required final String content,
    required final String category,
    final String? summary,
    final bool isOfflineAvailable,
    final DateTime? medicalReviewDate,
    final String? reviewAuthor,
    final int readTimeMinutes,
    final List<String> tags,
    final String? imageAsset,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ArticleImpl;

  factory _Article.fromJson(Map<String, dynamic> json) = _$ArticleImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  String get category;
  @override
  String? get summary;
  @override
  bool get isOfflineAvailable;
  @override
  DateTime? get medicalReviewDate;
  @override
  String? get reviewAuthor;
  @override
  int get readTimeMinutes;
  @override
  List<String> get tags;
  @override
  String? get imageAsset;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Article
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArticleImplCopyWith<_$ArticleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ArticleCategory _$ArticleCategoryFromJson(Map<String, dynamic> json) {
  return _ArticleCategory.fromJson(json);
}

/// @nodoc
mixin _$ArticleCategory {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get iconName => throw _privateConstructorUsedError;
  int get articleCount => throw _privateConstructorUsedError;

  /// Serializes this ArticleCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArticleCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArticleCategoryCopyWith<ArticleCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleCategoryCopyWith<$Res> {
  factory $ArticleCategoryCopyWith(
    ArticleCategory value,
    $Res Function(ArticleCategory) then,
  ) = _$ArticleCategoryCopyWithImpl<$Res, ArticleCategory>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String iconName,
    int articleCount,
  });
}

/// @nodoc
class _$ArticleCategoryCopyWithImpl<$Res, $Val extends ArticleCategory>
    implements $ArticleCategoryCopyWith<$Res> {
  _$ArticleCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArticleCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? iconName = null,
    Object? articleCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            iconName: null == iconName
                ? _value.iconName
                : iconName // ignore: cast_nullable_to_non_nullable
                      as String,
            articleCount: null == articleCount
                ? _value.articleCount
                : articleCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArticleCategoryImplCopyWith<$Res>
    implements $ArticleCategoryCopyWith<$Res> {
  factory _$$ArticleCategoryImplCopyWith(
    _$ArticleCategoryImpl value,
    $Res Function(_$ArticleCategoryImpl) then,
  ) = __$$ArticleCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String iconName,
    int articleCount,
  });
}

/// @nodoc
class __$$ArticleCategoryImplCopyWithImpl<$Res>
    extends _$ArticleCategoryCopyWithImpl<$Res, _$ArticleCategoryImpl>
    implements _$$ArticleCategoryImplCopyWith<$Res> {
  __$$ArticleCategoryImplCopyWithImpl(
    _$ArticleCategoryImpl _value,
    $Res Function(_$ArticleCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArticleCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? iconName = null,
    Object? articleCount = null,
  }) {
    return _then(
      _$ArticleCategoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        iconName: null == iconName
            ? _value.iconName
            : iconName // ignore: cast_nullable_to_non_nullable
                  as String,
        articleCount: null == articleCount
            ? _value.articleCount
            : articleCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleCategoryImpl implements _ArticleCategory {
  const _$ArticleCategoryImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.articleCount,
  });

  factory _$ArticleCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String iconName;
  @override
  final int articleCount;

  @override
  String toString() {
    return 'ArticleCategory(id: $id, name: $name, description: $description, iconName: $iconName, articleCount: $articleCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.articleCount, articleCount) ||
                other.articleCount == articleCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, description, iconName, articleCount);

  /// Create a copy of ArticleCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleCategoryImplCopyWith<_$ArticleCategoryImpl> get copyWith =>
      __$$ArticleCategoryImplCopyWithImpl<_$ArticleCategoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleCategoryImplToJson(this);
  }
}

abstract class _ArticleCategory implements ArticleCategory {
  const factory _ArticleCategory({
    required final String id,
    required final String name,
    required final String description,
    required final String iconName,
    required final int articleCount,
  }) = _$ArticleCategoryImpl;

  factory _ArticleCategory.fromJson(Map<String, dynamic> json) =
      _$ArticleCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get iconName;
  @override
  int get articleCount;

  /// Create a copy of ArticleCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArticleCategoryImplCopyWith<_$ArticleCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
