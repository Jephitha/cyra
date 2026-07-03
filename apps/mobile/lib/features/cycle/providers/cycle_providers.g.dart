// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cycleRepositoryHash() => r'ce1105339bb0577468330753993cace9b74c575b';

/// See also [cycleRepository].
@ProviderFor(cycleRepository)
final cycleRepositoryProvider = Provider<CycleRepository>.internal(
  cycleRepository,
  name: r'cycleRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cycleRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CycleRepositoryRef = ProviderRef<CycleRepository>;
String _$allCyclesHash() => r'af09d9efbf7dbfa0b4f8da9be6b72b1c4e843f1f';

/// See also [allCycles].
@ProviderFor(allCycles)
final allCyclesProvider = AutoDisposeFutureProvider<List<Cycle>>.internal(
  allCycles,
  name: r'allCyclesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allCyclesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllCyclesRef = AutoDisposeFutureProviderRef<List<Cycle>>;
String _$activeCycleHash() => r'1dcbc614d25cad30efc5d64ce2104fca21b3cffa';

/// See also [activeCycle].
@ProviderFor(activeCycle)
final activeCycleProvider = AutoDisposeFutureProvider<Cycle?>.internal(
  activeCycle,
  name: r'activeCycleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeCycleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveCycleRef = AutoDisposeFutureProviderRef<Cycle?>;
String _$cycleSummaryHash() => r'b884da47bdfd55ea9cae9ca33f1ef561eab3155e';

/// See also [cycleSummary].
@ProviderFor(cycleSummary)
final cycleSummaryProvider = AutoDisposeFutureProvider<CycleSummary>.internal(
  cycleSummary,
  name: r'cycleSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cycleSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CycleSummaryRef = AutoDisposeFutureProviderRef<CycleSummary>;
String _$nextPeriodPredictionHash() =>
    r'ade13316cef01b8d61da1c35300bd7c5720cb436';

/// See also [nextPeriodPrediction].
@ProviderFor(nextPeriodPrediction)
final nextPeriodPredictionProvider =
    AutoDisposeFutureProvider<PredictionResult>.internal(
      nextPeriodPrediction,
      name: r'nextPeriodPredictionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$nextPeriodPredictionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NextPeriodPredictionRef =
    AutoDisposeFutureProviderRef<PredictionResult>;
String _$cycleDaysHash() => r'eaf7a61d92ce985f1b50eb92550ea5827fede381';

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

/// See also [cycleDays].
@ProviderFor(cycleDays)
const cycleDaysProvider = CycleDaysFamily();

/// See also [cycleDays].
class CycleDaysFamily extends Family<AsyncValue<List<CycleDay>>> {
  /// See also [cycleDays].
  const CycleDaysFamily();

  /// See also [cycleDays].
  CycleDaysProvider call(String cycleId) {
    return CycleDaysProvider(cycleId);
  }

  @override
  CycleDaysProvider getProviderOverride(covariant CycleDaysProvider provider) {
    return call(provider.cycleId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cycleDaysProvider';
}

/// See also [cycleDays].
class CycleDaysProvider extends AutoDisposeFutureProvider<List<CycleDay>> {
  /// See also [cycleDays].
  CycleDaysProvider(String cycleId)
    : this._internal(
        (ref) => cycleDays(ref as CycleDaysRef, cycleId),
        from: cycleDaysProvider,
        name: r'cycleDaysProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$cycleDaysHash,
        dependencies: CycleDaysFamily._dependencies,
        allTransitiveDependencies: CycleDaysFamily._allTransitiveDependencies,
        cycleId: cycleId,
      );

  CycleDaysProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cycleId,
  }) : super.internal();

  final String cycleId;

  @override
  Override overrideWith(
    FutureOr<List<CycleDay>> Function(CycleDaysRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CycleDaysProvider._internal(
        (ref) => create(ref as CycleDaysRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cycleId: cycleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CycleDay>> createElement() {
    return _CycleDaysProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CycleDaysProvider && other.cycleId == cycleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cycleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CycleDaysRef on AutoDisposeFutureProviderRef<List<CycleDay>> {
  /// The parameter `cycleId` of this provider.
  String get cycleId;
}

class _CycleDaysProviderElement
    extends AutoDisposeFutureProviderElement<List<CycleDay>>
    with CycleDaysRef {
  _CycleDaysProviderElement(super.provider);

  @override
  String get cycleId => (origin as CycleDaysProvider).cycleId;
}

String _$cycleDayForDateHash() => r'22c8b04782fd9488ec8fbe6caeeabda8f67aa6f5';

/// See also [cycleDayForDate].
@ProviderFor(cycleDayForDate)
const cycleDayForDateProvider = CycleDayForDateFamily();

/// See also [cycleDayForDate].
class CycleDayForDateFamily extends Family<AsyncValue<CycleDay?>> {
  /// See also [cycleDayForDate].
  const CycleDayForDateFamily();

  /// See also [cycleDayForDate].
  CycleDayForDateProvider call(DateTime date) {
    return CycleDayForDateProvider(date);
  }

  @override
  CycleDayForDateProvider getProviderOverride(
    covariant CycleDayForDateProvider provider,
  ) {
    return call(provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cycleDayForDateProvider';
}

/// See also [cycleDayForDate].
class CycleDayForDateProvider extends AutoDisposeFutureProvider<CycleDay?> {
  /// See also [cycleDayForDate].
  CycleDayForDateProvider(DateTime date)
    : this._internal(
        (ref) => cycleDayForDate(ref as CycleDayForDateRef, date),
        from: cycleDayForDateProvider,
        name: r'cycleDayForDateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$cycleDayForDateHash,
        dependencies: CycleDayForDateFamily._dependencies,
        allTransitiveDependencies:
            CycleDayForDateFamily._allTransitiveDependencies,
        date: date,
      );

  CycleDayForDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    FutureOr<CycleDay?> Function(CycleDayForDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CycleDayForDateProvider._internal(
        (ref) => create(ref as CycleDayForDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CycleDay?> createElement() {
    return _CycleDayForDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CycleDayForDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CycleDayForDateRef on AutoDisposeFutureProviderRef<CycleDay?> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _CycleDayForDateProviderElement
    extends AutoDisposeFutureProviderElement<CycleDay?>
    with CycleDayForDateRef {
  _CycleDayForDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as CycleDayForDateProvider).date;
}

String _$dashboardInsightsHash() => r'ad958e1baa1f17f9cb00249b03b6a864f4e25fd7';

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
String _$flowLoggerHash() => r'689cdf44b13756033d5291083b90dc8394cbc551';

/// See also [FlowLogger].
@ProviderFor(FlowLogger)
final flowLoggerProvider =
    AutoDisposeAsyncNotifierProvider<FlowLogger, void>.internal(
      FlowLogger.new,
      name: r'flowLoggerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$flowLoggerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FlowLogger = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
