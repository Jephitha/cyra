// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$educationRepositoryHash() =>
    r'd8ee5d941d906df932040e1111779e70afe9b10a';

/// See also [educationRepository].
@ProviderFor(educationRepository)
final educationRepositoryProvider = Provider<EducationRepository>.internal(
  educationRepository,
  name: r'educationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$educationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EducationRepositoryRef = ProviderRef<EducationRepository>;
String _$articleCategoriesHash() => r'69f9ed603dbfcbd56dccac43ded31a4874264827';

/// See also [articleCategories].
@ProviderFor(articleCategories)
final articleCategoriesProvider =
    AutoDisposeProvider<List<ArticleCategory>>.internal(
      articleCategories,
      name: r'articleCategoriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$articleCategoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ArticleCategoriesRef = AutoDisposeProviderRef<List<ArticleCategory>>;
String _$allArticlesHash() => r'20c75c9f2dc4a6777a91b15ffc72024e0650a625';

/// See also [allArticles].
@ProviderFor(allArticles)
final allArticlesProvider = AutoDisposeProvider<List<Article>>.internal(
  allArticles,
  name: r'allArticlesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allArticlesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllArticlesRef = AutoDisposeProviderRef<List<Article>>;
String _$articlesByCategoryHash() =>
    r'9957b336947b3e1ca34942fb6c2c869c0976b7cd';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [articlesByCategory].
@ProviderFor(articlesByCategory)
const articlesByCategoryProvider = ArticlesByCategoryFamily();

/// See also [articlesByCategory].
class ArticlesByCategoryFamily extends Family<List<Article>> {
  /// See also [articlesByCategory].
  const ArticlesByCategoryFamily();

  /// See also [articlesByCategory].
  ArticlesByCategoryProvider call(String category) {
    return ArticlesByCategoryProvider(category);
  }

  @override
  ArticlesByCategoryProvider getProviderOverride(
    covariant ArticlesByCategoryProvider provider,
  ) {
    return call(provider.category);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'articlesByCategoryProvider';
}

/// See also [articlesByCategory].
class ArticlesByCategoryProvider extends AutoDisposeProvider<List<Article>> {
  /// See also [articlesByCategory].
  ArticlesByCategoryProvider(String category)
    : this._internal(
        (ref) => articlesByCategory(ref as ArticlesByCategoryRef, category),
        from: articlesByCategoryProvider,
        name: r'articlesByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$articlesByCategoryHash,
        dependencies: ArticlesByCategoryFamily._dependencies,
        allTransitiveDependencies:
            ArticlesByCategoryFamily._allTransitiveDependencies,
        category: category,
      );

  ArticlesByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    List<Article> Function(ArticlesByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArticlesByCategoryProvider._internal(
        (ref) => create(ref as ArticlesByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Article>> createElement() {
    return _ArticlesByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArticlesByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArticlesByCategoryRef on AutoDisposeProviderRef<List<Article>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _ArticlesByCategoryProviderElement
    extends AutoDisposeProviderElement<List<Article>>
    with ArticlesByCategoryRef {
  _ArticlesByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as ArticlesByCategoryProvider).category;
}

String _$featuredArticlesHash() => r'0e49a4bbe0aed243b80242b214f622373d2dd5c6';

/// See also [featuredArticles].
@ProviderFor(featuredArticles)
final featuredArticlesProvider = AutoDisposeProvider<List<Article>>.internal(
  featuredArticles,
  name: r'featuredArticlesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$featuredArticlesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeaturedArticlesRef = AutoDisposeProviderRef<List<Article>>;
String _$trendingArticlesHash() => r'17cee80654bf1d774913076408a38d7fa4d70304';

/// See also [trendingArticles].
@ProviderFor(trendingArticles)
final trendingArticlesProvider = AutoDisposeProvider<List<Article>>.internal(
  trendingArticles,
  name: r'trendingArticlesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trendingArticlesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrendingArticlesRef = AutoDisposeProviderRef<List<Article>>;
String _$recentlyViewedArticlesHash() =>
    r'b7527223c9b84eca26fdef157f8c14ce3cc448b8';

/// See also [recentlyViewedArticles].
@ProviderFor(recentlyViewedArticles)
final recentlyViewedArticlesProvider =
    AutoDisposeProvider<List<Article>>.internal(
      recentlyViewedArticles,
      name: r'recentlyViewedArticlesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentlyViewedArticlesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentlyViewedArticlesRef = AutoDisposeProviderRef<List<Article>>;
String _$offlineArticlesHash() => r'2a18ae992af6a9844d672677c5b20438ed1d355a';

/// See also [offlineArticles].
@ProviderFor(offlineArticles)
final offlineArticlesProvider = AutoDisposeProvider<List<Article>>.internal(
  offlineArticles,
  name: r'offlineArticlesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$offlineArticlesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OfflineArticlesRef = AutoDisposeProviderRef<List<Article>>;
String _$bookmarkedArticlesHash() =>
    r'a244311e93c9b4a4e7011ea9a3f6d362941b417c';

/// See also [bookmarkedArticles].
@ProviderFor(bookmarkedArticles)
final bookmarkedArticlesProvider = AutoDisposeProvider<List<Article>>.internal(
  bookmarkedArticles,
  name: r'bookmarkedArticlesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookmarkedArticlesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BookmarkedArticlesRef = AutoDisposeProviderRef<List<Article>>;
String _$articleByIdHash() => r'c13a0b655c02a78da6d6419753dcee8e701da95b';

/// See also [articleById].
@ProviderFor(articleById)
const articleByIdProvider = ArticleByIdFamily();

/// See also [articleById].
class ArticleByIdFamily extends Family<Article?> {
  /// See also [articleById].
  const ArticleByIdFamily();

  /// See also [articleById].
  ArticleByIdProvider call(String id) {
    return ArticleByIdProvider(id);
  }

  @override
  ArticleByIdProvider getProviderOverride(
    covariant ArticleByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'articleByIdProvider';
}

/// See also [articleById].
class ArticleByIdProvider extends AutoDisposeProvider<Article?> {
  /// See also [articleById].
  ArticleByIdProvider(String id)
    : this._internal(
        (ref) => articleById(ref as ArticleByIdRef, id),
        from: articleByIdProvider,
        name: r'articleByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$articleByIdHash,
        dependencies: ArticleByIdFamily._dependencies,
        allTransitiveDependencies: ArticleByIdFamily._allTransitiveDependencies,
        id: id,
      );

  ArticleByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(Article? Function(ArticleByIdRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: ArticleByIdProvider._internal(
        (ref) => create(ref as ArticleByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Article?> createElement() {
    return _ArticleByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArticleByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArticleByIdRef on AutoDisposeProviderRef<Article?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ArticleByIdProviderElement extends AutoDisposeProviderElement<Article?>
    with ArticleByIdRef {
  _ArticleByIdProviderElement(super.provider);

  @override
  String get id => (origin as ArticleByIdProvider).id;
}

String _$relatedArticlesHash() => r'5e002a067eb6e10271ec62a8fe9a1b0974014678';

/// See also [relatedArticles].
@ProviderFor(relatedArticles)
const relatedArticlesProvider = RelatedArticlesFamily();

/// See also [relatedArticles].
class RelatedArticlesFamily extends Family<List<Article>> {
  /// See also [relatedArticles].
  const RelatedArticlesFamily();

  /// See also [relatedArticles].
  RelatedArticlesProvider call(Article article) {
    return RelatedArticlesProvider(article);
  }

  @override
  RelatedArticlesProvider getProviderOverride(
    covariant RelatedArticlesProvider provider,
  ) {
    return call(provider.article);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'relatedArticlesProvider';
}

/// See also [relatedArticles].
class RelatedArticlesProvider extends AutoDisposeProvider<List<Article>> {
  /// See also [relatedArticles].
  RelatedArticlesProvider(Article article)
    : this._internal(
        (ref) => relatedArticles(ref as RelatedArticlesRef, article),
        from: relatedArticlesProvider,
        name: r'relatedArticlesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$relatedArticlesHash,
        dependencies: RelatedArticlesFamily._dependencies,
        allTransitiveDependencies:
            RelatedArticlesFamily._allTransitiveDependencies,
        article: article,
      );

  RelatedArticlesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.article,
  }) : super.internal();

  final Article article;

  @override
  Override overrideWith(
    List<Article> Function(RelatedArticlesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RelatedArticlesProvider._internal(
        (ref) => create(ref as RelatedArticlesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        article: article,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Article>> createElement() {
    return _RelatedArticlesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RelatedArticlesProvider && other.article == article;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, article.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RelatedArticlesRef on AutoDisposeProviderRef<List<Article>> {
  /// The parameter `article` of this provider.
  Article get article;
}

class _RelatedArticlesProviderElement
    extends AutoDisposeProviderElement<List<Article>>
    with RelatedArticlesRef {
  _RelatedArticlesProviderElement(super.provider);

  @override
  Article get article => (origin as RelatedArticlesProvider).article;
}

String _$searchArticlesHash() => r'394be5368a7c7547ad78b0826f6a6c8451b683bb';

/// See also [searchArticles].
@ProviderFor(searchArticles)
const searchArticlesProvider = SearchArticlesFamily();

/// See also [searchArticles].
class SearchArticlesFamily extends Family<List<Article>> {
  /// See also [searchArticles].
  const SearchArticlesFamily();

  /// See also [searchArticles].
  SearchArticlesProvider call(String query) {
    return SearchArticlesProvider(query);
  }

  @override
  SearchArticlesProvider getProviderOverride(
    covariant SearchArticlesProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchArticlesProvider';
}

/// See also [searchArticles].
class SearchArticlesProvider extends AutoDisposeProvider<List<Article>> {
  /// See also [searchArticles].
  SearchArticlesProvider(String query)
    : this._internal(
        (ref) => searchArticles(ref as SearchArticlesRef, query),
        from: searchArticlesProvider,
        name: r'searchArticlesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$searchArticlesHash,
        dependencies: SearchArticlesFamily._dependencies,
        allTransitiveDependencies:
            SearchArticlesFamily._allTransitiveDependencies,
        query: query,
      );

  SearchArticlesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    List<Article> Function(SearchArticlesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchArticlesProvider._internal(
        (ref) => create(ref as SearchArticlesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Article>> createElement() {
    return _SearchArticlesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchArticlesProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchArticlesRef on AutoDisposeProviderRef<List<Article>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchArticlesProviderElement
    extends AutoDisposeProviderElement<List<Article>>
    with SearchArticlesRef {
  _SearchArticlesProviderElement(super.provider);

  @override
  String get query => (origin as SearchArticlesProvider).query;
}

String _$articleActionsHash() => r'dc020d05c03b445a77780b41727f2fb4f38ee5e6';

/// See also [ArticleActions].
@ProviderFor(ArticleActions)
final articleActionsProvider =
    AutoDisposeAsyncNotifierProvider<ArticleActions, void>.internal(
      ArticleActions.new,
      name: r'articleActionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$articleActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ArticleActions = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
