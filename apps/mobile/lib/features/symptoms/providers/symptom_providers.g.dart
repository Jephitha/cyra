// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$symptomRepositoryHash() => r'84c2fc3e1cd3834db248f1c0bc55b59dbe96115b';

/// See also [symptomRepository].
@ProviderFor(symptomRepository)
final symptomRepositoryProvider = Provider<SymptomRepository>.internal(
  symptomRepository,
  name: r'symptomRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$symptomRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SymptomRepositoryRef = ProviderRef<SymptomRepository>;
String _$todaySymptomsHash() => r'3ebb7ed5f8a8dd0e4216e25fd1dcdeb87335a665';

/// See also [todaySymptoms].
@ProviderFor(todaySymptoms)
final todaySymptomsProvider =
    AutoDisposeFutureProvider<List<SymptomEntry>>.internal(
      todaySymptoms,
      name: r'todaySymptomsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todaySymptomsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodaySymptomsRef = AutoDisposeFutureProviderRef<List<SymptomEntry>>;
String _$symptomsForDateHash() => r'6f0fe50211e67a5729478b1042b662e041285aaf';

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

/// See also [symptomsForDate].
@ProviderFor(symptomsForDate)
const symptomsForDateProvider = SymptomsForDateFamily();

/// See also [symptomsForDate].
class SymptomsForDateFamily extends Family<AsyncValue<List<SymptomEntry>>> {
  /// See also [symptomsForDate].
  const SymptomsForDateFamily();

  /// See also [symptomsForDate].
  SymptomsForDateProvider call(DateTime date) {
    return SymptomsForDateProvider(date);
  }

  @override
  SymptomsForDateProvider getProviderOverride(
    covariant SymptomsForDateProvider provider,
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
  String? get name => r'symptomsForDateProvider';
}

/// See also [symptomsForDate].
class SymptomsForDateProvider
    extends AutoDisposeFutureProvider<List<SymptomEntry>> {
  /// See also [symptomsForDate].
  SymptomsForDateProvider(DateTime date)
    : this._internal(
        (ref) => symptomsForDate(ref as SymptomsForDateRef, date),
        from: symptomsForDateProvider,
        name: r'symptomsForDateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$symptomsForDateHash,
        dependencies: SymptomsForDateFamily._dependencies,
        allTransitiveDependencies:
            SymptomsForDateFamily._allTransitiveDependencies,
        date: date,
      );

  SymptomsForDateProvider._internal(
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
    FutureOr<List<SymptomEntry>> Function(SymptomsForDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SymptomsForDateProvider._internal(
        (ref) => create(ref as SymptomsForDateRef),
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
  AutoDisposeFutureProviderElement<List<SymptomEntry>> createElement() {
    return _SymptomsForDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SymptomsForDateProvider && other.date == date;
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
mixin SymptomsForDateRef on AutoDisposeFutureProviderRef<List<SymptomEntry>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _SymptomsForDateProviderElement
    extends AutoDisposeFutureProviderElement<List<SymptomEntry>>
    with SymptomsForDateRef {
  _SymptomsForDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as SymptomsForDateProvider).date;
}

String _$symptomPatternsHash() => r'154bbe65d89bc4b6131daf0310389b693b0d6df1';

/// See also [symptomPatterns].
@ProviderFor(symptomPatterns)
final symptomPatternsProvider =
    AutoDisposeFutureProvider<List<SymptomPattern>>.internal(
      symptomPatterns,
      name: r'symptomPatternsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$symptomPatternsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SymptomPatternsRef = AutoDisposeFutureProviderRef<List<SymptomPattern>>;
String _$symptomStreakHash() => r'63844498ad80666b988177d7771bc8a17035e8ed';

/// See also [symptomStreak].
@ProviderFor(symptomStreak)
final symptomStreakProvider = AutoDisposeFutureProvider<int>.internal(
  symptomStreak,
  name: r'symptomStreakProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$symptomStreakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SymptomStreakRef = AutoDisposeFutureProviderRef<int>;
String _$symptomsInRangeHash() => r'0cf47fe1a51f8387a73f34c160262d0d175576b2';

/// See also [symptomsInRange].
@ProviderFor(symptomsInRange)
const symptomsInRangeProvider = SymptomsInRangeFamily();

/// See also [symptomsInRange].
class SymptomsInRangeFamily extends Family<AsyncValue<List<SymptomEntry>>> {
  /// See also [symptomsInRange].
  const SymptomsInRangeFamily();

  /// See also [symptomsInRange].
  SymptomsInRangeProvider call(DateTime start, DateTime end) {
    return SymptomsInRangeProvider(start, end);
  }

  @override
  SymptomsInRangeProvider getProviderOverride(
    covariant SymptomsInRangeProvider provider,
  ) {
    return call(provider.start, provider.end);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'symptomsInRangeProvider';
}

/// See also [symptomsInRange].
class SymptomsInRangeProvider
    extends AutoDisposeFutureProvider<List<SymptomEntry>> {
  /// See also [symptomsInRange].
  SymptomsInRangeProvider(DateTime start, DateTime end)
    : this._internal(
        (ref) => symptomsInRange(ref as SymptomsInRangeRef, start, end),
        from: symptomsInRangeProvider,
        name: r'symptomsInRangeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$symptomsInRangeHash,
        dependencies: SymptomsInRangeFamily._dependencies,
        allTransitiveDependencies:
            SymptomsInRangeFamily._allTransitiveDependencies,
        start: start,
        end: end,
      );

  SymptomsInRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.start,
    required this.end,
  }) : super.internal();

  final DateTime start;
  final DateTime end;

  @override
  Override overrideWith(
    FutureOr<List<SymptomEntry>> Function(SymptomsInRangeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SymptomsInRangeProvider._internal(
        (ref) => create(ref as SymptomsInRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        start: start,
        end: end,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SymptomEntry>> createElement() {
    return _SymptomsInRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SymptomsInRangeProvider &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, start.hashCode);
    hash = _SystemHash.combine(hash, end.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SymptomsInRangeRef on AutoDisposeFutureProviderRef<List<SymptomEntry>> {
  /// The parameter `start` of this provider.
  DateTime get start;

  /// The parameter `end` of this provider.
  DateTime get end;
}

class _SymptomsInRangeProviderElement
    extends AutoDisposeFutureProviderElement<List<SymptomEntry>>
    with SymptomsInRangeRef {
  _SymptomsInRangeProviderElement(super.provider);

  @override
  DateTime get start => (origin as SymptomsInRangeProvider).start;
  @override
  DateTime get end => (origin as SymptomsInRangeProvider).end;
}

String _$moodForDateHash() => r'bfde1b0b2f61866789dbdb03f96bf5b6e4727a01';

/// See also [moodForDate].
@ProviderFor(moodForDate)
const moodForDateProvider = MoodForDateFamily();

/// See also [moodForDate].
class MoodForDateFamily extends Family<AsyncValue<MoodEntry?>> {
  /// See also [moodForDate].
  const MoodForDateFamily();

  /// See also [moodForDate].
  MoodForDateProvider call(DateTime date) {
    return MoodForDateProvider(date);
  }

  @override
  MoodForDateProvider getProviderOverride(
    covariant MoodForDateProvider provider,
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
  String? get name => r'moodForDateProvider';
}

/// See also [moodForDate].
class MoodForDateProvider extends AutoDisposeFutureProvider<MoodEntry?> {
  /// See also [moodForDate].
  MoodForDateProvider(DateTime date)
    : this._internal(
        (ref) => moodForDate(ref as MoodForDateRef, date),
        from: moodForDateProvider,
        name: r'moodForDateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$moodForDateHash,
        dependencies: MoodForDateFamily._dependencies,
        allTransitiveDependencies: MoodForDateFamily._allTransitiveDependencies,
        date: date,
      );

  MoodForDateProvider._internal(
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
    FutureOr<MoodEntry?> Function(MoodForDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MoodForDateProvider._internal(
        (ref) => create(ref as MoodForDateRef),
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
  AutoDisposeFutureProviderElement<MoodEntry?> createElement() {
    return _MoodForDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MoodForDateProvider && other.date == date;
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
mixin MoodForDateRef on AutoDisposeFutureProviderRef<MoodEntry?> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _MoodForDateProviderElement
    extends AutoDisposeFutureProviderElement<MoodEntry?>
    with MoodForDateRef {
  _MoodForDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as MoodForDateProvider).date;
}

String _$moodsInRangeHash() => r'318112848d6f051c42c43cde9d3315334c05d6f2';

/// See also [moodsInRange].
@ProviderFor(moodsInRange)
const moodsInRangeProvider = MoodsInRangeFamily();

/// See also [moodsInRange].
class MoodsInRangeFamily extends Family<AsyncValue<List<MoodEntry>>> {
  /// See also [moodsInRange].
  const MoodsInRangeFamily();

  /// See also [moodsInRange].
  MoodsInRangeProvider call(DateTime start, DateTime end) {
    return MoodsInRangeProvider(start, end);
  }

  @override
  MoodsInRangeProvider getProviderOverride(
    covariant MoodsInRangeProvider provider,
  ) {
    return call(provider.start, provider.end);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'moodsInRangeProvider';
}

/// See also [moodsInRange].
class MoodsInRangeProvider extends AutoDisposeFutureProvider<List<MoodEntry>> {
  /// See also [moodsInRange].
  MoodsInRangeProvider(DateTime start, DateTime end)
    : this._internal(
        (ref) => moodsInRange(ref as MoodsInRangeRef, start, end),
        from: moodsInRangeProvider,
        name: r'moodsInRangeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$moodsInRangeHash,
        dependencies: MoodsInRangeFamily._dependencies,
        allTransitiveDependencies:
            MoodsInRangeFamily._allTransitiveDependencies,
        start: start,
        end: end,
      );

  MoodsInRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.start,
    required this.end,
  }) : super.internal();

  final DateTime start;
  final DateTime end;

  @override
  Override overrideWith(
    FutureOr<List<MoodEntry>> Function(MoodsInRangeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MoodsInRangeProvider._internal(
        (ref) => create(ref as MoodsInRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        start: start,
        end: end,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MoodEntry>> createElement() {
    return _MoodsInRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MoodsInRangeProvider &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, start.hashCode);
    hash = _SystemHash.combine(hash, end.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MoodsInRangeRef on AutoDisposeFutureProviderRef<List<MoodEntry>> {
  /// The parameter `start` of this provider.
  DateTime get start;

  /// The parameter `end` of this provider.
  DateTime get end;
}

class _MoodsInRangeProviderElement
    extends AutoDisposeFutureProviderElement<List<MoodEntry>>
    with MoodsInRangeRef {
  _MoodsInRangeProviderElement(super.provider);

  @override
  DateTime get start => (origin as MoodsInRangeProvider).start;
  @override
  DateTime get end => (origin as MoodsInRangeProvider).end;
}

String _$moodCycleCorrelationHash() =>
    r'cbda1d9f3f7a4433bb4a4da6c2e864fb90929edc';

/// See also [moodCycleCorrelation].
@ProviderFor(moodCycleCorrelation)
final moodCycleCorrelationProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
      moodCycleCorrelation,
      name: r'moodCycleCorrelationProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$moodCycleCorrelationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MoodCycleCorrelationRef =
    AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$symptomLoggerHash() => r'd4a122c9f08c59a0e0dc31e3b65aa6ad438243a0';

/// See also [SymptomLogger].
@ProviderFor(SymptomLogger)
final symptomLoggerProvider =
    AutoDisposeAsyncNotifierProvider<SymptomLogger, void>.internal(
      SymptomLogger.new,
      name: r'symptomLoggerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$symptomLoggerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SymptomLogger = AutoDisposeAsyncNotifier<void>;
String _$moodLoggerHash() => r'd715305182f2063cd1d3f2fa440f5a2de246b9b9';

/// See also [MoodLogger].
@ProviderFor(MoodLogger)
final moodLoggerProvider =
    AutoDisposeAsyncNotifierProvider<MoodLogger, void>.internal(
      MoodLogger.new,
      name: r'moodLoggerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$moodLoggerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MoodLogger = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
