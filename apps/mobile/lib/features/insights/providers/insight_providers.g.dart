// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardInsightsHash() => r'abf2b37e0aeb0642b878f7adf57108c52c68320e';

/// See also [dashboardInsights].
@ProviderFor(dashboardInsights)
final dashboardInsightsProvider =
    AutoDisposeFutureProvider<DashboardInsights>.internal(
      dashboardInsights,
      name: r'dashboardInsightsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardInsightsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardInsightsRef = AutoDisposeFutureProviderRef<DashboardInsights>;
String _$topicInsightHash() => r'ba0a03daecac3230d0e057026e06a78206f8cc0c';

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

/// See also [topicInsight].
@ProviderFor(topicInsight)
const topicInsightProvider = TopicInsightFamily();

/// See also [topicInsight].
class TopicInsightFamily extends Family<AsyncValue<TopicInsight>> {
  /// See also [topicInsight].
  const TopicInsightFamily();

  /// See also [topicInsight].
  TopicInsightProvider call(InsightTopic topic) {
    return TopicInsightProvider(topic);
  }

  @override
  TopicInsightProvider getProviderOverride(
    covariant TopicInsightProvider provider,
  ) {
    return call(provider.topic);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'topicInsightProvider';
}

/// See also [topicInsight].
class TopicInsightProvider extends AutoDisposeFutureProvider<TopicInsight> {
  /// See also [topicInsight].
  TopicInsightProvider(InsightTopic topic)
    : this._internal(
        (ref) => topicInsight(ref as TopicInsightRef, topic),
        from: topicInsightProvider,
        name: r'topicInsightProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$topicInsightHash,
        dependencies: TopicInsightFamily._dependencies,
        allTransitiveDependencies:
            TopicInsightFamily._allTransitiveDependencies,
        topic: topic,
      );

  TopicInsightProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.topic,
  }) : super.internal();

  final InsightTopic topic;

  @override
  Override overrideWith(
    FutureOr<TopicInsight> Function(TopicInsightRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TopicInsightProvider._internal(
        (ref) => create(ref as TopicInsightRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        topic: topic,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TopicInsight> createElement() {
    return _TopicInsightProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopicInsightProvider && other.topic == topic;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, topic.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TopicInsightRef on AutoDisposeFutureProviderRef<TopicInsight> {
  /// The parameter `topic` of this provider.
  InsightTopic get topic;
}

class _TopicInsightProviderElement
    extends AutoDisposeFutureProviderElement<TopicInsight>
    with TopicInsightRef {
  _TopicInsightProviderElement(super.provider);

  @override
  InsightTopic get topic => (origin as TopicInsightProvider).topic;
}

String _$weeklySummaryHash() => r'9bf916e8d06bb797ec7989f585aaaa69bd5af1a2';

/// See also [weeklySummary].
@ProviderFor(weeklySummary)
final weeklySummaryProvider = AutoDisposeFutureProvider<WeeklySummary>.internal(
  weeklySummary,
  name: r'weeklySummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weeklySummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeeklySummaryRef = AutoDisposeFutureProviderRef<WeeklySummary>;
String _$healthTipHash() => r'e6d7c5ca4ee368c86475cb053e4024be202ef5e9';

/// See also [healthTip].
@ProviderFor(healthTip)
final healthTipProvider = AutoDisposeFutureProvider<String>.internal(
  healthTip,
  name: r'healthTipProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$healthTipHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HealthTipRef = AutoDisposeFutureProviderRef<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
