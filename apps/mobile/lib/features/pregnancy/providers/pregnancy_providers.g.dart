// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pregnancy_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pregnancyRepositoryHash() =>
    r'116c7cbbce53785a24d3e186aca8a79a613de612';

/// See also [pregnancyRepository].
@ProviderFor(pregnancyRepository)
final pregnancyRepositoryProvider = Provider<PregnancyRepository>.internal(
  pregnancyRepository,
  name: r'pregnancyRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pregnancyRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PregnancyRepositoryRef = ProviderRef<PregnancyRepository>;
String _$currentPregnancyHash() => r'74625e25f3f090c396ce07f4472286c7c4877b3e';

/// See also [currentPregnancy].
@ProviderFor(currentPregnancy)
final currentPregnancyProvider = AutoDisposeFutureProvider<Pregnancy?>.internal(
  currentPregnancy,
  name: r'currentPregnancyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentPregnancyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentPregnancyRef = AutoDisposeFutureProviderRef<Pregnancy?>;
String _$currentWeekMilestoneHash() =>
    r'60b1ca60d3f24b11ba46ebbe952e565af7eaffd0';

/// See also [currentWeekMilestone].
@ProviderFor(currentWeekMilestone)
final currentWeekMilestoneProvider =
    AutoDisposeFutureProvider<WeeklyMilestone>.internal(
      currentWeekMilestone,
      name: r'currentWeekMilestoneProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentWeekMilestoneHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentWeekMilestoneRef = AutoDisposeFutureProviderRef<WeeklyMilestone>;
String _$fetalMeasurementsHash() => r'7d9baae12c5087b88d168a59f27dc1dd0ccffc83';

/// See also [fetalMeasurements].
@ProviderFor(fetalMeasurements)
final fetalMeasurementsProvider =
    AutoDisposeFutureProvider<List<FetalMeasurement>>.internal(
      fetalMeasurements,
      name: r'fetalMeasurementsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fetalMeasurementsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetalMeasurementsRef =
    AutoDisposeFutureProviderRef<List<FetalMeasurement>>;
String _$kickLogsHash() => r'62f96d617c602f0a2b9e39439732739cb479c750';

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

/// See also [kickLogs].
@ProviderFor(kickLogs)
const kickLogsProvider = KickLogsFamily();

/// See also [kickLogs].
class KickLogsFamily extends Family<AsyncValue<List<KickLog>>> {
  /// See also [kickLogs].
  const KickLogsFamily();

  /// See also [kickLogs].
  KickLogsProvider call({DateTime? from, DateTime? to}) {
    return KickLogsProvider(from: from, to: to);
  }

  @override
  KickLogsProvider getProviderOverride(covariant KickLogsProvider provider) {
    return call(from: provider.from, to: provider.to);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'kickLogsProvider';
}

/// See also [kickLogs].
class KickLogsProvider extends AutoDisposeFutureProvider<List<KickLog>> {
  /// See also [kickLogs].
  KickLogsProvider({DateTime? from, DateTime? to})
    : this._internal(
        (ref) => kickLogs(ref as KickLogsRef, from: from, to: to),
        from: kickLogsProvider,
        name: r'kickLogsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$kickLogsHash,
        dependencies: KickLogsFamily._dependencies,
        allTransitiveDependencies: KickLogsFamily._allTransitiveDependencies,
        from: from,
        to: to,
      );

  KickLogsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.from,
    required this.to,
  }) : super.internal();

  final DateTime? from;
  final DateTime? to;

  @override
  Override overrideWith(
    FutureOr<List<KickLog>> Function(KickLogsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: KickLogsProvider._internal(
        (ref) => create(ref as KickLogsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        from: from,
        to: to,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<KickLog>> createElement() {
    return _KickLogsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is KickLogsProvider && other.from == from && other.to == to;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, from.hashCode);
    hash = _SystemHash.combine(hash, to.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin KickLogsRef on AutoDisposeFutureProviderRef<List<KickLog>> {
  /// The parameter `from` of this provider.
  DateTime? get from;

  /// The parameter `to` of this provider.
  DateTime? get to;
}

class _KickLogsProviderElement
    extends AutoDisposeFutureProviderElement<List<KickLog>>
    with KickLogsRef {
  _KickLogsProviderElement(super.provider);

  @override
  DateTime? get from => (origin as KickLogsProvider).from;
  @override
  DateTime? get to => (origin as KickLogsProvider).to;
}

String _$pregnancyProgressHash() => r'2dd51019a40202ebb4ffbe243a959946f147485e';

/// See also [pregnancyProgress].
@ProviderFor(pregnancyProgress)
final pregnancyProgressProvider = AutoDisposeProvider<double>.internal(
  pregnancyProgress,
  name: r'pregnancyProgressProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pregnancyProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PregnancyProgressRef = AutoDisposeProviderRef<double>;
String _$pregnancyKeyDatesHash() => r'1c0cdc3e4af1a114bb11c8189a6fddc5e9b39de4';

/// See also [pregnancyKeyDates].
@ProviderFor(pregnancyKeyDates)
final pregnancyKeyDatesProvider =
    AutoDisposeProvider<Map<String, DateTime>>.internal(
      pregnancyKeyDates,
      name: r'pregnancyKeyDatesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pregnancyKeyDatesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PregnancyKeyDatesRef = AutoDisposeProviderRef<Map<String, DateTime>>;
String _$currentTrimesterHash() => r'10fedb013e437c48d1ef3d541d16f18f103df66a';

/// See also [currentTrimester].
@ProviderFor(currentTrimester)
final currentTrimesterProvider = AutoDisposeFutureProvider<int>.internal(
  currentTrimester,
  name: r'currentTrimesterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentTrimesterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentTrimesterRef = AutoDisposeFutureProviderRef<int>;
String _$weeksRemainingHash() => r'5e5ac3d4f7c26a8619a8c49848840fadde7fc58d';

/// See also [weeksRemaining].
@ProviderFor(weeksRemaining)
final weeksRemainingProvider = AutoDisposeFutureProvider<int>.internal(
  weeksRemaining,
  name: r'weeksRemainingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weeksRemainingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeeksRemainingRef = AutoDisposeFutureProviderRef<int>;
String _$trimesterMilestonesHash() =>
    r'24a99c56b8e3ed813a040f20c9cf5fbcfe8c28c3';

/// See also [trimesterMilestones].
@ProviderFor(trimesterMilestones)
final trimesterMilestonesProvider =
    AutoDisposeFutureProvider<List<WeeklyMilestone>>.internal(
      trimesterMilestones,
      name: r'trimesterMilestonesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$trimesterMilestonesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrimesterMilestonesRef =
    AutoDisposeFutureProviderRef<List<WeeklyMilestone>>;
String _$latestMeasurementHash() => r'5a8555f11d2c044062d1835dddb85969b7276757';

/// See also [latestMeasurement].
@ProviderFor(latestMeasurement)
final latestMeasurementProvider =
    AutoDisposeFutureProvider<FetalMeasurement?>.internal(
      latestMeasurement,
      name: r'latestMeasurementProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$latestMeasurementHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LatestMeasurementRef = AutoDisposeFutureProviderRef<FetalMeasurement?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
