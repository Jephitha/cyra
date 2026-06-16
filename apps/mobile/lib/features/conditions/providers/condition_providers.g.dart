// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conditionRepositoryHash() =>
    r'f69af429ca70cdb8ed2f007230c0f8d4cf5c5c3e';

/// See also [conditionRepository].
@ProviderFor(conditionRepository)
final conditionRepositoryProvider = Provider<ConditionRepository>.internal(
  conditionRepository,
  name: r'conditionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$conditionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConditionRepositoryRef = ProviderRef<ConditionRepository>;
String _$allConditionsHash() => r'4da1c59b10c2329ab333d160363e0414729e23b4';

/// See also [allConditions].
@ProviderFor(allConditions)
final allConditionsProvider =
    AutoDisposeFutureProvider<List<UserCondition>>.internal(
      allConditions,
      name: r'allConditionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allConditionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllConditionsRef = AutoDisposeFutureProviderRef<List<UserCondition>>;
String _$activeConditionsHash() => r'bfd5048b4334911c576ad6d9a74021c9cb6e89ea';

/// See also [activeConditions].
@ProviderFor(activeConditions)
final activeConditionsProvider =
    AutoDisposeFutureProvider<List<UserCondition>>.internal(
      activeConditions,
      name: r'activeConditionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeConditionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveConditionsRef = AutoDisposeFutureProviderRef<List<UserCondition>>;
String _$conditionByIdHash() => r'97ba325df69a485eab61b698ef485dc1d921b636';

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

/// See also [conditionById].
@ProviderFor(conditionById)
const conditionByIdProvider = ConditionByIdFamily();

/// See also [conditionById].
class ConditionByIdFamily extends Family<AsyncValue<UserCondition?>> {
  /// See also [conditionById].
  const ConditionByIdFamily();

  /// See also [conditionById].
  ConditionByIdProvider call(String id) {
    return ConditionByIdProvider(id);
  }

  @override
  ConditionByIdProvider getProviderOverride(
    covariant ConditionByIdProvider provider,
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
  String? get name => r'conditionByIdProvider';
}

/// See also [conditionById].
class ConditionByIdProvider extends AutoDisposeFutureProvider<UserCondition?> {
  /// See also [conditionById].
  ConditionByIdProvider(String id)
    : this._internal(
        (ref) => conditionById(ref as ConditionByIdRef, id),
        from: conditionByIdProvider,
        name: r'conditionByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$conditionByIdHash,
        dependencies: ConditionByIdFamily._dependencies,
        allTransitiveDependencies:
            ConditionByIdFamily._allTransitiveDependencies,
        id: id,
      );

  ConditionByIdProvider._internal(
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
  Override overrideWith(
    FutureOr<UserCondition?> Function(ConditionByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConditionByIdProvider._internal(
        (ref) => create(ref as ConditionByIdRef),
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
  AutoDisposeFutureProviderElement<UserCondition?> createElement() {
    return _ConditionByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConditionByIdProvider && other.id == id;
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
mixin ConditionByIdRef on AutoDisposeFutureProviderRef<UserCondition?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ConditionByIdProviderElement
    extends AutoDisposeFutureProviderElement<UserCondition?>
    with ConditionByIdRef {
  _ConditionByIdProviderElement(super.provider);

  @override
  String get id => (origin as ConditionByIdProvider).id;
}

String _$conditionPatternsHash() => r'd2207d9a6d9f0239d63c585151ca517e937c6ebb';

/// See also [conditionPatterns].
@ProviderFor(conditionPatterns)
const conditionPatternsProvider = ConditionPatternsFamily();

/// See also [conditionPatterns].
class ConditionPatternsFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [conditionPatterns].
  const ConditionPatternsFamily();

  /// See also [conditionPatterns].
  ConditionPatternsProvider call(String conditionType) {
    return ConditionPatternsProvider(conditionType);
  }

  @override
  ConditionPatternsProvider getProviderOverride(
    covariant ConditionPatternsProvider provider,
  ) {
    return call(provider.conditionType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'conditionPatternsProvider';
}

/// See also [conditionPatterns].
class ConditionPatternsProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>> {
  /// See also [conditionPatterns].
  ConditionPatternsProvider(String conditionType)
    : this._internal(
        (ref) => conditionPatterns(ref as ConditionPatternsRef, conditionType),
        from: conditionPatternsProvider,
        name: r'conditionPatternsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$conditionPatternsHash,
        dependencies: ConditionPatternsFamily._dependencies,
        allTransitiveDependencies:
            ConditionPatternsFamily._allTransitiveDependencies,
        conditionType: conditionType,
      );

  ConditionPatternsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conditionType,
  }) : super.internal();

  final String conditionType;

  @override
  Override overrideWith(
    FutureOr<Map<String, dynamic>> Function(ConditionPatternsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConditionPatternsProvider._internal(
        (ref) => create(ref as ConditionPatternsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conditionType: conditionType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, dynamic>> createElement() {
    return _ConditionPatternsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConditionPatternsProvider &&
        other.conditionType == conditionType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conditionType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConditionPatternsRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>> {
  /// The parameter `conditionType` of this provider.
  String get conditionType;
}

class _ConditionPatternsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>>
    with ConditionPatternsRef {
  _ConditionPatternsProviderElement(super.provider);

  @override
  String get conditionType =>
      (origin as ConditionPatternsProvider).conditionType;
}

String _$trackingRecommendationsHash() =>
    r'f26f2eb9331a68cf47a3139bfa4384f81ea10f63';

/// See also [trackingRecommendations].
@ProviderFor(trackingRecommendations)
const trackingRecommendationsProvider = TrackingRecommendationsFamily();

/// See also [trackingRecommendations].
class TrackingRecommendationsFamily extends Family<AsyncValue<List<String>>> {
  /// See also [trackingRecommendations].
  const TrackingRecommendationsFamily();

  /// See also [trackingRecommendations].
  TrackingRecommendationsProvider call(String conditionType) {
    return TrackingRecommendationsProvider(conditionType);
  }

  @override
  TrackingRecommendationsProvider getProviderOverride(
    covariant TrackingRecommendationsProvider provider,
  ) {
    return call(provider.conditionType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'trackingRecommendationsProvider';
}

/// See also [trackingRecommendations].
class TrackingRecommendationsProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// See also [trackingRecommendations].
  TrackingRecommendationsProvider(String conditionType)
    : this._internal(
        (ref) => trackingRecommendations(
          ref as TrackingRecommendationsRef,
          conditionType,
        ),
        from: trackingRecommendationsProvider,
        name: r'trackingRecommendationsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$trackingRecommendationsHash,
        dependencies: TrackingRecommendationsFamily._dependencies,
        allTransitiveDependencies:
            TrackingRecommendationsFamily._allTransitiveDependencies,
        conditionType: conditionType,
      );

  TrackingRecommendationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.conditionType,
  }) : super.internal();

  final String conditionType;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(TrackingRecommendationsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TrackingRecommendationsProvider._internal(
        (ref) => create(ref as TrackingRecommendationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        conditionType: conditionType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _TrackingRecommendationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackingRecommendationsProvider &&
        other.conditionType == conditionType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, conditionType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TrackingRecommendationsRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `conditionType` of this provider.
  String get conditionType;
}

class _TrackingRecommendationsProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with TrackingRecommendationsRef {
  _TrackingRecommendationsProviderElement(super.provider);

  @override
  String get conditionType =>
      (origin as TrackingRecommendationsProvider).conditionType;
}

String _$conditionManagerHash() => r'a753f71b64b1440dd9cd235bac6bafea6a348c72';

/// See also [ConditionManager].
@ProviderFor(ConditionManager)
final conditionManagerProvider =
    AutoDisposeAsyncNotifierProvider<ConditionManager, void>.internal(
      ConditionManager.new,
      name: r'conditionManagerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$conditionManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ConditionManager = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
