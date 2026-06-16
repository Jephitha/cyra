// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journalRepositoryHash() => r'f493e899684a19ba63fcc9e9a5768f62e91053b4';

/// See also [journalRepository].
@ProviderFor(journalRepository)
final journalRepositoryProvider = Provider<JournalRepository>.internal(
  journalRepository,
  name: r'journalRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JournalRepositoryRef = ProviderRef<JournalRepository>;
String _$recentJournalEntriesHash() =>
    r'7ab032076cfc6d7926c99cedb3ceb27481794423';

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

/// See also [recentJournalEntries].
@ProviderFor(recentJournalEntries)
const recentJournalEntriesProvider = RecentJournalEntriesFamily();

/// See also [recentJournalEntries].
class RecentJournalEntriesFamily
    extends Family<AsyncValue<List<JournalEntry>>> {
  /// See also [recentJournalEntries].
  const RecentJournalEntriesFamily();

  /// See also [recentJournalEntries].
  RecentJournalEntriesProvider call({int limit = 20}) {
    return RecentJournalEntriesProvider(limit: limit);
  }

  @override
  RecentJournalEntriesProvider getProviderOverride(
    covariant RecentJournalEntriesProvider provider,
  ) {
    return call(limit: provider.limit);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recentJournalEntriesProvider';
}

/// See also [recentJournalEntries].
class RecentJournalEntriesProvider
    extends AutoDisposeFutureProvider<List<JournalEntry>> {
  /// See also [recentJournalEntries].
  RecentJournalEntriesProvider({int limit = 20})
    : this._internal(
        (ref) =>
            recentJournalEntries(ref as RecentJournalEntriesRef, limit: limit),
        from: recentJournalEntriesProvider,
        name: r'recentJournalEntriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recentJournalEntriesHash,
        dependencies: RecentJournalEntriesFamily._dependencies,
        allTransitiveDependencies:
            RecentJournalEntriesFamily._allTransitiveDependencies,
        limit: limit,
      );

  RecentJournalEntriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<JournalEntry>> Function(RecentJournalEntriesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentJournalEntriesProvider._internal(
        (ref) => create(ref as RecentJournalEntriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<JournalEntry>> createElement() {
    return _RecentJournalEntriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentJournalEntriesProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecentJournalEntriesRef
    on AutoDisposeFutureProviderRef<List<JournalEntry>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _RecentJournalEntriesProviderElement
    extends AutoDisposeFutureProviderElement<List<JournalEntry>>
    with RecentJournalEntriesRef {
  _RecentJournalEntriesProviderElement(super.provider);

  @override
  int get limit => (origin as RecentJournalEntriesProvider).limit;
}

String _$journalEntriesByDateRangeHash() =>
    r'36a0e0100e58cd40839d990f90800af7afe95713';

/// See also [journalEntriesByDateRange].
@ProviderFor(journalEntriesByDateRange)
const journalEntriesByDateRangeProvider = JournalEntriesByDateRangeFamily();

/// See also [journalEntriesByDateRange].
class JournalEntriesByDateRangeFamily
    extends Family<AsyncValue<List<JournalEntry>>> {
  /// See also [journalEntriesByDateRange].
  const JournalEntriesByDateRangeFamily();

  /// See also [journalEntriesByDateRange].
  JournalEntriesByDateRangeProvider call(DateTime start, DateTime end) {
    return JournalEntriesByDateRangeProvider(start, end);
  }

  @override
  JournalEntriesByDateRangeProvider getProviderOverride(
    covariant JournalEntriesByDateRangeProvider provider,
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
  String? get name => r'journalEntriesByDateRangeProvider';
}

/// See also [journalEntriesByDateRange].
class JournalEntriesByDateRangeProvider
    extends AutoDisposeFutureProvider<List<JournalEntry>> {
  /// See also [journalEntriesByDateRange].
  JournalEntriesByDateRangeProvider(DateTime start, DateTime end)
    : this._internal(
        (ref) => journalEntriesByDateRange(
          ref as JournalEntriesByDateRangeRef,
          start,
          end,
        ),
        from: journalEntriesByDateRangeProvider,
        name: r'journalEntriesByDateRangeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$journalEntriesByDateRangeHash,
        dependencies: JournalEntriesByDateRangeFamily._dependencies,
        allTransitiveDependencies:
            JournalEntriesByDateRangeFamily._allTransitiveDependencies,
        start: start,
        end: end,
      );

  JournalEntriesByDateRangeProvider._internal(
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
    FutureOr<List<JournalEntry>> Function(JournalEntriesByDateRangeRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JournalEntriesByDateRangeProvider._internal(
        (ref) => create(ref as JournalEntriesByDateRangeRef),
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
  AutoDisposeFutureProviderElement<List<JournalEntry>> createElement() {
    return _JournalEntriesByDateRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JournalEntriesByDateRangeProvider &&
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
mixin JournalEntriesByDateRangeRef
    on AutoDisposeFutureProviderRef<List<JournalEntry>> {
  /// The parameter `start` of this provider.
  DateTime get start;

  /// The parameter `end` of this provider.
  DateTime get end;
}

class _JournalEntriesByDateRangeProviderElement
    extends AutoDisposeFutureProviderElement<List<JournalEntry>>
    with JournalEntriesByDateRangeRef {
  _JournalEntriesByDateRangeProviderElement(super.provider);

  @override
  DateTime get start => (origin as JournalEntriesByDateRangeProvider).start;
  @override
  DateTime get end => (origin as JournalEntriesByDateRangeProvider).end;
}

String _$journalEntryHash() => r'f8bf88828ec40e943abee73025f44485406b5c18';

/// See also [journalEntry].
@ProviderFor(journalEntry)
const journalEntryProvider = JournalEntryFamily();

/// See also [journalEntry].
class JournalEntryFamily extends Family<AsyncValue<JournalEntry?>> {
  /// See also [journalEntry].
  const JournalEntryFamily();

  /// See also [journalEntry].
  JournalEntryProvider call(String id) {
    return JournalEntryProvider(id);
  }

  @override
  JournalEntryProvider getProviderOverride(
    covariant JournalEntryProvider provider,
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
  String? get name => r'journalEntryProvider';
}

/// See also [journalEntry].
class JournalEntryProvider extends AutoDisposeFutureProvider<JournalEntry?> {
  /// See also [journalEntry].
  JournalEntryProvider(String id)
    : this._internal(
        (ref) => journalEntry(ref as JournalEntryRef, id),
        from: journalEntryProvider,
        name: r'journalEntryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$journalEntryHash,
        dependencies: JournalEntryFamily._dependencies,
        allTransitiveDependencies:
            JournalEntryFamily._allTransitiveDependencies,
        id: id,
      );

  JournalEntryProvider._internal(
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
    FutureOr<JournalEntry?> Function(JournalEntryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JournalEntryProvider._internal(
        (ref) => create(ref as JournalEntryRef),
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
  AutoDisposeFutureProviderElement<JournalEntry?> createElement() {
    return _JournalEntryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JournalEntryProvider && other.id == id;
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
mixin JournalEntryRef on AutoDisposeFutureProviderRef<JournalEntry?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _JournalEntryProviderElement
    extends AutoDisposeFutureProviderElement<JournalEntry?>
    with JournalEntryRef {
  _JournalEntryProviderElement(super.provider);

  @override
  String get id => (origin as JournalEntryProvider).id;
}

String _$journalEntriesForCycleHash() =>
    r'9969e197037c4f492a179cd423e5f625eee67acd';

/// See also [journalEntriesForCycle].
@ProviderFor(journalEntriesForCycle)
const journalEntriesForCycleProvider = JournalEntriesForCycleFamily();

/// See also [journalEntriesForCycle].
class JournalEntriesForCycleFamily
    extends Family<AsyncValue<List<JournalEntry>>> {
  /// See also [journalEntriesForCycle].
  const JournalEntriesForCycleFamily();

  /// See also [journalEntriesForCycle].
  JournalEntriesForCycleProvider call(String cycleDayId) {
    return JournalEntriesForCycleProvider(cycleDayId);
  }

  @override
  JournalEntriesForCycleProvider getProviderOverride(
    covariant JournalEntriesForCycleProvider provider,
  ) {
    return call(provider.cycleDayId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'journalEntriesForCycleProvider';
}

/// See also [journalEntriesForCycle].
class JournalEntriesForCycleProvider
    extends AutoDisposeFutureProvider<List<JournalEntry>> {
  /// See also [journalEntriesForCycle].
  JournalEntriesForCycleProvider(String cycleDayId)
    : this._internal(
        (ref) => journalEntriesForCycle(
          ref as JournalEntriesForCycleRef,
          cycleDayId,
        ),
        from: journalEntriesForCycleProvider,
        name: r'journalEntriesForCycleProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$journalEntriesForCycleHash,
        dependencies: JournalEntriesForCycleFamily._dependencies,
        allTransitiveDependencies:
            JournalEntriesForCycleFamily._allTransitiveDependencies,
        cycleDayId: cycleDayId,
      );

  JournalEntriesForCycleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cycleDayId,
  }) : super.internal();

  final String cycleDayId;

  @override
  Override overrideWith(
    FutureOr<List<JournalEntry>> Function(JournalEntriesForCycleRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JournalEntriesForCycleProvider._internal(
        (ref) => create(ref as JournalEntriesForCycleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cycleDayId: cycleDayId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<JournalEntry>> createElement() {
    return _JournalEntriesForCycleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JournalEntriesForCycleProvider &&
        other.cycleDayId == cycleDayId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cycleDayId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin JournalEntriesForCycleRef
    on AutoDisposeFutureProviderRef<List<JournalEntry>> {
  /// The parameter `cycleDayId` of this provider.
  String get cycleDayId;
}

class _JournalEntriesForCycleProviderElement
    extends AutoDisposeFutureProviderElement<List<JournalEntry>>
    with JournalEntriesForCycleRef {
  _JournalEntriesForCycleProviderElement(super.provider);

  @override
  String get cycleDayId =>
      (origin as JournalEntriesForCycleProvider).cycleDayId;
}

String _$journalSearchResultsHash() =>
    r'40b1c51b67b6585c4c4bca79b735076ccab0c98a';

/// See also [journalSearchResults].
@ProviderFor(journalSearchResults)
const journalSearchResultsProvider = JournalSearchResultsFamily();

/// See also [journalSearchResults].
class JournalSearchResultsFamily
    extends Family<AsyncValue<List<JournalEntry>>> {
  /// See also [journalSearchResults].
  const JournalSearchResultsFamily();

  /// See also [journalSearchResults].
  JournalSearchResultsProvider call(String query) {
    return JournalSearchResultsProvider(query);
  }

  @override
  JournalSearchResultsProvider getProviderOverride(
    covariant JournalSearchResultsProvider provider,
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
  String? get name => r'journalSearchResultsProvider';
}

/// See also [journalSearchResults].
class JournalSearchResultsProvider
    extends AutoDisposeFutureProvider<List<JournalEntry>> {
  /// See also [journalSearchResults].
  JournalSearchResultsProvider(String query)
    : this._internal(
        (ref) => journalSearchResults(ref as JournalSearchResultsRef, query),
        from: journalSearchResultsProvider,
        name: r'journalSearchResultsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$journalSearchResultsHash,
        dependencies: JournalSearchResultsFamily._dependencies,
        allTransitiveDependencies:
            JournalSearchResultsFamily._allTransitiveDependencies,
        query: query,
      );

  JournalSearchResultsProvider._internal(
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
    FutureOr<List<JournalEntry>> Function(JournalSearchResultsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JournalSearchResultsProvider._internal(
        (ref) => create(ref as JournalSearchResultsRef),
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
  AutoDisposeFutureProviderElement<List<JournalEntry>> createElement() {
    return _JournalSearchResultsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JournalSearchResultsProvider && other.query == query;
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
mixin JournalSearchResultsRef
    on AutoDisposeFutureProviderRef<List<JournalEntry>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _JournalSearchResultsProviderElement
    extends AutoDisposeFutureProviderElement<List<JournalEntry>>
    with JournalSearchResultsRef {
  _JournalSearchResultsProviderElement(super.provider);

  @override
  String get query => (origin as JournalSearchResultsProvider).query;
}

String _$journalWriterHash() => r'6e7dba9f18e5757a237f81546e62451ef8a05db5';

/// See also [JournalWriter].
@ProviderFor(JournalWriter)
final journalWriterProvider =
    AutoDisposeAsyncNotifierProvider<JournalWriter, void>.internal(
      JournalWriter.new,
      name: r'journalWriterProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$journalWriterHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$JournalWriter = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
