// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ovulation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ovulationRepositoryHash() =>
    r'b3d1465b08a580400d19edc06272999457e62fd8';

/// See also [ovulationRepository].
@ProviderFor(ovulationRepository)
final ovulationRepositoryProvider = Provider<OvulationRepository>.internal(
  ovulationRepository,
  name: r'ovulationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ovulationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OvulationRepositoryRef = ProviderRef<OvulationRepository>;
String _$fertilityRepositoryHash() =>
    r'0cca2a43b9065482bcc27d7dc3e985151a1d979d';

/// See also [fertilityRepository].
@ProviderFor(fertilityRepository)
final fertilityRepositoryProvider = Provider<FertilityRepository>.internal(
  fertilityRepository,
  name: r'fertilityRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fertilityRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FertilityRepositoryRef = ProviderRef<FertilityRepository>;
String _$fertileWindowHash() => r'd861d513ba3fba9d569b009ece20d55bc47cdca0';

/// See also [fertileWindow].
@ProviderFor(fertileWindow)
final fertileWindowProvider = AutoDisposeFutureProvider<FertileWindow>.internal(
  fertileWindow,
  name: r'fertileWindowProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fertileWindowHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FertileWindowRef = AutoDisposeFutureProviderRef<FertileWindow>;
String _$ovulationDetectionHash() =>
    r'b92c1564476a54f4e65b8def20e47ef0ca7aaf0d';

/// See also [ovulationDetection].
@ProviderFor(ovulationDetection)
final ovulationDetectionProvider =
    AutoDisposeFutureProvider<OvulationResult>.internal(
      ovulationDetection,
      name: r'ovulationDetectionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ovulationDetectionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OvulationDetectionRef = AutoDisposeFutureProviderRef<OvulationResult>;
String _$conceptionLikelihoodHash() =>
    r'7c9152cb1e9db5c606952ede53a12698d0db5bae';

/// See also [conceptionLikelihood].
@ProviderFor(conceptionLikelihood)
final conceptionLikelihoodProvider =
    AutoDisposeFutureProvider<ConceptionLikelihood>.internal(
      conceptionLikelihood,
      name: r'conceptionLikelihoodProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$conceptionLikelihoodHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConceptionLikelihoodRef =
    AutoDisposeFutureProviderRef<ConceptionLikelihood>;
String _$bbtForCycleHash() => r'64bfa9ad925c7157aac805dc2eb8f21d0f55bbb2';

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

/// See also [bbtForCycle].
@ProviderFor(bbtForCycle)
const bbtForCycleProvider = BbtForCycleFamily();

/// See also [bbtForCycle].
class BbtForCycleFamily extends Family<AsyncValue<List<BBTRecord>>> {
  /// See also [bbtForCycle].
  const BbtForCycleFamily();

  /// See also [bbtForCycle].
  BbtForCycleProvider call(String cycleId) {
    return BbtForCycleProvider(cycleId);
  }

  @override
  BbtForCycleProvider getProviderOverride(
    covariant BbtForCycleProvider provider,
  ) {
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
  String? get name => r'bbtForCycleProvider';
}

/// See also [bbtForCycle].
class BbtForCycleProvider extends AutoDisposeFutureProvider<List<BBTRecord>> {
  /// See also [bbtForCycle].
  BbtForCycleProvider(String cycleId)
    : this._internal(
        (ref) => bbtForCycle(ref as BbtForCycleRef, cycleId),
        from: bbtForCycleProvider,
        name: r'bbtForCycleProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bbtForCycleHash,
        dependencies: BbtForCycleFamily._dependencies,
        allTransitiveDependencies: BbtForCycleFamily._allTransitiveDependencies,
        cycleId: cycleId,
      );

  BbtForCycleProvider._internal(
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
    FutureOr<List<BBTRecord>> Function(BbtForCycleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BbtForCycleProvider._internal(
        (ref) => create(ref as BbtForCycleRef),
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
  AutoDisposeFutureProviderElement<List<BBTRecord>> createElement() {
    return _BbtForCycleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BbtForCycleProvider && other.cycleId == cycleId;
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
mixin BbtForCycleRef on AutoDisposeFutureProviderRef<List<BBTRecord>> {
  /// The parameter `cycleId` of this provider.
  String get cycleId;
}

class _BbtForCycleProviderElement
    extends AutoDisposeFutureProviderElement<List<BBTRecord>>
    with BbtForCycleRef {
  _BbtForCycleProviderElement(super.provider);

  @override
  String get cycleId => (origin as BbtForCycleProvider).cycleId;
}

String _$opkForCycleHash() => r'4382523bf0daa404a2f3d7c244c4db4e05f63cce';

/// See also [opkForCycle].
@ProviderFor(opkForCycle)
const opkForCycleProvider = OpkForCycleFamily();

/// See also [opkForCycle].
class OpkForCycleFamily extends Family<AsyncValue<List<OPKTestResult>>> {
  /// See also [opkForCycle].
  const OpkForCycleFamily();

  /// See also [opkForCycle].
  OpkForCycleProvider call(String cycleId) {
    return OpkForCycleProvider(cycleId);
  }

  @override
  OpkForCycleProvider getProviderOverride(
    covariant OpkForCycleProvider provider,
  ) {
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
  String? get name => r'opkForCycleProvider';
}

/// See also [opkForCycle].
class OpkForCycleProvider
    extends AutoDisposeFutureProvider<List<OPKTestResult>> {
  /// See also [opkForCycle].
  OpkForCycleProvider(String cycleId)
    : this._internal(
        (ref) => opkForCycle(ref as OpkForCycleRef, cycleId),
        from: opkForCycleProvider,
        name: r'opkForCycleProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$opkForCycleHash,
        dependencies: OpkForCycleFamily._dependencies,
        allTransitiveDependencies: OpkForCycleFamily._allTransitiveDependencies,
        cycleId: cycleId,
      );

  OpkForCycleProvider._internal(
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
    FutureOr<List<OPKTestResult>> Function(OpkForCycleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OpkForCycleProvider._internal(
        (ref) => create(ref as OpkForCycleRef),
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
  AutoDisposeFutureProviderElement<List<OPKTestResult>> createElement() {
    return _OpkForCycleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OpkForCycleProvider && other.cycleId == cycleId;
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
mixin OpkForCycleRef on AutoDisposeFutureProviderRef<List<OPKTestResult>> {
  /// The parameter `cycleId` of this provider.
  String get cycleId;
}

class _OpkForCycleProviderElement
    extends AutoDisposeFutureProviderElement<List<OPKTestResult>>
    with OpkForCycleRef {
  _OpkForCycleProviderElement(super.provider);

  @override
  String get cycleId => (origin as OpkForCycleProvider).cycleId;
}

String _$mucusForCycleHash() => r'f6936fe026917674590a4d289909b04a9cfd91ab';

/// See also [mucusForCycle].
@ProviderFor(mucusForCycle)
const mucusForCycleProvider = MucusForCycleFamily();

/// See also [mucusForCycle].
class MucusForCycleFamily extends Family<AsyncValue<List<MucusObservation>>> {
  /// See also [mucusForCycle].
  const MucusForCycleFamily();

  /// See also [mucusForCycle].
  MucusForCycleProvider call(String cycleId) {
    return MucusForCycleProvider(cycleId);
  }

  @override
  MucusForCycleProvider getProviderOverride(
    covariant MucusForCycleProvider provider,
  ) {
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
  String? get name => r'mucusForCycleProvider';
}

/// See also [mucusForCycle].
class MucusForCycleProvider
    extends AutoDisposeFutureProvider<List<MucusObservation>> {
  /// See also [mucusForCycle].
  MucusForCycleProvider(String cycleId)
    : this._internal(
        (ref) => mucusForCycle(ref as MucusForCycleRef, cycleId),
        from: mucusForCycleProvider,
        name: r'mucusForCycleProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$mucusForCycleHash,
        dependencies: MucusForCycleFamily._dependencies,
        allTransitiveDependencies:
            MucusForCycleFamily._allTransitiveDependencies,
        cycleId: cycleId,
      );

  MucusForCycleProvider._internal(
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
    FutureOr<List<MucusObservation>> Function(MucusForCycleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MucusForCycleProvider._internal(
        (ref) => create(ref as MucusForCycleRef),
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
  AutoDisposeFutureProviderElement<List<MucusObservation>> createElement() {
    return _MucusForCycleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MucusForCycleProvider && other.cycleId == cycleId;
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
mixin MucusForCycleRef on AutoDisposeFutureProviderRef<List<MucusObservation>> {
  /// The parameter `cycleId` of this provider.
  String get cycleId;
}

class _MucusForCycleProviderElement
    extends AutoDisposeFutureProviderElement<List<MucusObservation>>
    with MucusForCycleRef {
  _MucusForCycleProviderElement(super.provider);

  @override
  String get cycleId => (origin as MucusForCycleProvider).cycleId;
}

String _$fertilityModeSettingHash() =>
    r'da0277d3d7ba16610341a4a8d1b447c07f664f20';

/// See also [FertilityModeSetting].
@ProviderFor(FertilityModeSetting)
final fertilityModeSettingProvider =
    AutoDisposeNotifierProvider<FertilityModeSetting, FertilityMode>.internal(
      FertilityModeSetting.new,
      name: r'fertilityModeSettingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fertilityModeSettingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FertilityModeSetting = AutoDisposeNotifier<FertilityMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
