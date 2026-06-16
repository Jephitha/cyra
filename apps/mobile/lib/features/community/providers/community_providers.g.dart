// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$communityTopicsHash() => r'14fdbd8275eb65e12a0eb718821d2d27b1440df5';

/// See also [communityTopics].
@ProviderFor(communityTopics)
final communityTopicsProvider =
    AutoDisposeFutureProvider<List<CommunityTopic>>.internal(
      communityTopics,
      name: r'communityTopicsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$communityTopicsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CommunityTopicsRef = AutoDisposeFutureProviderRef<List<CommunityTopic>>;
String _$topicPostsHash() => r'e8c81d4b9b5ef77ea59d0ae11a052144b2edab37';

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

/// See also [topicPosts].
@ProviderFor(topicPosts)
const topicPostsProvider = TopicPostsFamily();

/// See also [topicPosts].
class TopicPostsFamily extends Family<AsyncValue<List<CommunityPost>>> {
  /// See also [topicPosts].
  const TopicPostsFamily();

  /// See also [topicPosts].
  TopicPostsProvider call(String topicId, {int page = 0}) {
    return TopicPostsProvider(topicId, page: page);
  }

  @override
  TopicPostsProvider getProviderOverride(
    covariant TopicPostsProvider provider,
  ) {
    return call(provider.topicId, page: provider.page);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'topicPostsProvider';
}

/// See also [topicPosts].
class TopicPostsProvider
    extends AutoDisposeFutureProvider<List<CommunityPost>> {
  /// See also [topicPosts].
  TopicPostsProvider(String topicId, {int page = 0})
    : this._internal(
        (ref) => topicPosts(ref as TopicPostsRef, topicId, page: page),
        from: topicPostsProvider,
        name: r'topicPostsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$topicPostsHash,
        dependencies: TopicPostsFamily._dependencies,
        allTransitiveDependencies: TopicPostsFamily._allTransitiveDependencies,
        topicId: topicId,
        page: page,
      );

  TopicPostsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.topicId,
    required this.page,
  }) : super.internal();

  final String topicId;
  final int page;

  @override
  Override overrideWith(
    FutureOr<List<CommunityPost>> Function(TopicPostsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TopicPostsProvider._internal(
        (ref) => create(ref as TopicPostsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        topicId: topicId,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CommunityPost>> createElement() {
    return _TopicPostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopicPostsProvider &&
        other.topicId == topicId &&
        other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, topicId.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TopicPostsRef on AutoDisposeFutureProviderRef<List<CommunityPost>> {
  /// The parameter `topicId` of this provider.
  String get topicId;

  /// The parameter `page` of this provider.
  int get page;
}

class _TopicPostsProviderElement
    extends AutoDisposeFutureProviderElement<List<CommunityPost>>
    with TopicPostsRef {
  _TopicPostsProviderElement(super.provider);

  @override
  String get topicId => (origin as TopicPostsProvider).topicId;
  @override
  int get page => (origin as TopicPostsProvider).page;
}

String _$postDetailHash() => r'6385bf8e8f22c765760ddf19f58e097da7dd8588';

/// See also [postDetail].
@ProviderFor(postDetail)
const postDetailProvider = PostDetailFamily();

/// See also [postDetail].
class PostDetailFamily extends Family<AsyncValue<CommunityPost>> {
  /// See also [postDetail].
  const PostDetailFamily();

  /// See also [postDetail].
  PostDetailProvider call(String postId) {
    return PostDetailProvider(postId);
  }

  @override
  PostDetailProvider getProviderOverride(
    covariant PostDetailProvider provider,
  ) {
    return call(provider.postId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postDetailProvider';
}

/// See also [postDetail].
class PostDetailProvider extends AutoDisposeFutureProvider<CommunityPost> {
  /// See also [postDetail].
  PostDetailProvider(String postId)
    : this._internal(
        (ref) => postDetail(ref as PostDetailRef, postId),
        from: postDetailProvider,
        name: r'postDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$postDetailHash,
        dependencies: PostDetailFamily._dependencies,
        allTransitiveDependencies: PostDetailFamily._allTransitiveDependencies,
        postId: postId,
      );

  PostDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    FutureOr<CommunityPost> Function(PostDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostDetailProvider._internal(
        (ref) => create(ref as PostDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CommunityPost> createElement() {
    return _PostDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostDetailProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostDetailRef on AutoDisposeFutureProviderRef<CommunityPost> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _PostDetailProviderElement
    extends AutoDisposeFutureProviderElement<CommunityPost>
    with PostDetailRef {
  _PostDetailProviderElement(super.provider);

  @override
  String get postId => (origin as PostDetailProvider).postId;
}

String _$myCommunityPostsHash() => r'01fa37e19805a1f1289d15de7614d0faa253e755';

/// See also [myCommunityPosts].
@ProviderFor(myCommunityPosts)
final myCommunityPostsProvider =
    AutoDisposeFutureProvider<List<CommunityPost>>.internal(
      myCommunityPosts,
      name: r'myCommunityPostsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$myCommunityPostsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyCommunityPostsRef = AutoDisposeFutureProviderRef<List<CommunityPost>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
