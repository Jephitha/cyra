// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportRepositoryHash() => r'1e34d2d1e1567d375b9cef075870642f05927989';

/// See also [reportRepository].
@ProviderFor(reportRepository)
final reportRepositoryProvider = Provider<ReportRepository>.internal(
  reportRepository,
  name: r'reportRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reportRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReportRepositoryRef = ProviderRef<ReportRepository>;
String _$allReportsHash() => r'e268a2da9fbaaf02dee693e31f13564db167cbbd';

/// See also [allReports].
@ProviderFor(allReports)
final allReportsProvider =
    AutoDisposeFutureProvider<List<HealthReport>>.internal(
      allReports,
      name: r'allReportsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allReportsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllReportsRef = AutoDisposeFutureProviderRef<List<HealthReport>>;
String _$reportByIdHash() => r'c4679e377742d93d5e8134bd3563dff42d031465';

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

/// See also [reportById].
@ProviderFor(reportById)
const reportByIdProvider = ReportByIdFamily();

/// See also [reportById].
class ReportByIdFamily extends Family<AsyncValue<HealthReport?>> {
  /// See also [reportById].
  const ReportByIdFamily();

  /// See also [reportById].
  ReportByIdProvider call(String id) {
    return ReportByIdProvider(id);
  }

  @override
  ReportByIdProvider getProviderOverride(
    covariant ReportByIdProvider provider,
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
  String? get name => r'reportByIdProvider';
}

/// See also [reportById].
class ReportByIdProvider extends AutoDisposeFutureProvider<HealthReport?> {
  /// See also [reportById].
  ReportByIdProvider(String id)
    : this._internal(
        (ref) => reportById(ref as ReportByIdRef, id),
        from: reportByIdProvider,
        name: r'reportByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$reportByIdHash,
        dependencies: ReportByIdFamily._dependencies,
        allTransitiveDependencies: ReportByIdFamily._allTransitiveDependencies,
        id: id,
      );

  ReportByIdProvider._internal(
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
    FutureOr<HealthReport?> Function(ReportByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReportByIdProvider._internal(
        (ref) => create(ref as ReportByIdRef),
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
  AutoDisposeFutureProviderElement<HealthReport?> createElement() {
    return _ReportByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReportByIdProvider && other.id == id;
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
mixin ReportByIdRef on AutoDisposeFutureProviderRef<HealthReport?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ReportByIdProviderElement
    extends AutoDisposeFutureProviderElement<HealthReport?>
    with ReportByIdRef {
  _ReportByIdProviderElement(super.provider);

  @override
  String get id => (origin as ReportByIdProvider).id;
}

String _$reportGeneratorHash() => r'c9b40db1e09e7fc400c428a3a008dba17880daa9';

/// See also [ReportGenerator].
@ProviderFor(ReportGenerator)
final reportGeneratorProvider =
    AutoDisposeAsyncNotifierProvider<ReportGenerator, void>.internal(
      ReportGenerator.new,
      name: r'reportGeneratorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reportGeneratorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReportGenerator = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
