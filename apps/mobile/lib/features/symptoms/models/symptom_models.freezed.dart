// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'symptom_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SymptomEntry _$SymptomEntryFromJson(Map<String, dynamic> json) {
  return _SymptomEntry.fromJson(json);
}

/// @nodoc
mixin _$SymptomEntry {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get symptomId => throw _privateConstructorUsedError;
  String get symptomName => throw _privateConstructorUsedError;
  int get severity => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SymptomEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SymptomEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SymptomEntryCopyWith<SymptomEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SymptomEntryCopyWith<$Res> {
  factory $SymptomEntryCopyWith(
    SymptomEntry value,
    $Res Function(SymptomEntry) then,
  ) = _$SymptomEntryCopyWithImpl<$Res, SymptomEntry>;
  @useResult
  $Res call({
    String id,
    DateTime date,
    String symptomId,
    String symptomName,
    int severity,
    String? notes,
    String? category,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$SymptomEntryCopyWithImpl<$Res, $Val extends SymptomEntry>
    implements $SymptomEntryCopyWith<$Res> {
  _$SymptomEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SymptomEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? symptomId = null,
    Object? symptomName = null,
    Object? severity = null,
    Object? notes = freezed,
    Object? category = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            symptomId: null == symptomId
                ? _value.symptomId
                : symptomId // ignore: cast_nullable_to_non_nullable
                      as String,
            symptomName: null == symptomName
                ? _value.symptomName
                : symptomName // ignore: cast_nullable_to_non_nullable
                      as String,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SymptomEntryImplCopyWith<$Res>
    implements $SymptomEntryCopyWith<$Res> {
  factory _$$SymptomEntryImplCopyWith(
    _$SymptomEntryImpl value,
    $Res Function(_$SymptomEntryImpl) then,
  ) = __$$SymptomEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime date,
    String symptomId,
    String symptomName,
    int severity,
    String? notes,
    String? category,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$SymptomEntryImplCopyWithImpl<$Res>
    extends _$SymptomEntryCopyWithImpl<$Res, _$SymptomEntryImpl>
    implements _$$SymptomEntryImplCopyWith<$Res> {
  __$$SymptomEntryImplCopyWithImpl(
    _$SymptomEntryImpl _value,
    $Res Function(_$SymptomEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SymptomEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? symptomId = null,
    Object? symptomName = null,
    Object? severity = null,
    Object? notes = freezed,
    Object? category = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$SymptomEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        symptomId: null == symptomId
            ? _value.symptomId
            : symptomId // ignore: cast_nullable_to_non_nullable
                  as String,
        symptomName: null == symptomName
            ? _value.symptomName
            : symptomName // ignore: cast_nullable_to_non_nullable
                  as String,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SymptomEntryImpl implements _SymptomEntry {
  const _$SymptomEntryImpl({
    required this.id,
    required this.date,
    required this.symptomId,
    required this.symptomName,
    this.severity = 1,
    this.notes,
    this.category,
    this.createdAt,
  });

  factory _$SymptomEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SymptomEntryImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String symptomId;
  @override
  final String symptomName;
  @override
  @JsonKey()
  final int severity;
  @override
  final String? notes;
  @override
  final String? category;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'SymptomEntry(id: $id, date: $date, symptomId: $symptomId, symptomName: $symptomName, severity: $severity, notes: $notes, category: $category, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SymptomEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.symptomId, symptomId) ||
                other.symptomId == symptomId) &&
            (identical(other.symptomName, symptomName) ||
                other.symptomName == symptomName) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    date,
    symptomId,
    symptomName,
    severity,
    notes,
    category,
    createdAt,
  );

  /// Create a copy of SymptomEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SymptomEntryImplCopyWith<_$SymptomEntryImpl> get copyWith =>
      __$$SymptomEntryImplCopyWithImpl<_$SymptomEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SymptomEntryImplToJson(this);
  }
}

abstract class _SymptomEntry implements SymptomEntry {
  const factory _SymptomEntry({
    required final String id,
    required final DateTime date,
    required final String symptomId,
    required final String symptomName,
    final int severity,
    final String? notes,
    final String? category,
    final DateTime? createdAt,
  }) = _$SymptomEntryImpl;

  factory _SymptomEntry.fromJson(Map<String, dynamic> json) =
      _$SymptomEntryImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  String get symptomId;
  @override
  String get symptomName;
  @override
  int get severity;
  @override
  String? get notes;
  @override
  String? get category;
  @override
  DateTime? get createdAt;

  /// Create a copy of SymptomEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SymptomEntryImplCopyWith<_$SymptomEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SymptomPattern _$SymptomPatternFromJson(Map<String, dynamic> json) {
  return _SymptomPattern.fromJson(json);
}

/// @nodoc
mixin _$SymptomPattern {
  String get symptomId => throw _privateConstructorUsedError;
  String get symptomName => throw _privateConstructorUsedError;
  int get frequency => throw _privateConstructorUsedError;
  double get averageSeverity => throw _privateConstructorUsedError;
  List<int> get commonCycleDays => throw _privateConstructorUsedError;
  String? get correlation => throw _privateConstructorUsedError;

  /// Serializes this SymptomPattern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SymptomPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SymptomPatternCopyWith<SymptomPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SymptomPatternCopyWith<$Res> {
  factory $SymptomPatternCopyWith(
    SymptomPattern value,
    $Res Function(SymptomPattern) then,
  ) = _$SymptomPatternCopyWithImpl<$Res, SymptomPattern>;
  @useResult
  $Res call({
    String symptomId,
    String symptomName,
    int frequency,
    double averageSeverity,
    List<int> commonCycleDays,
    String? correlation,
  });
}

/// @nodoc
class _$SymptomPatternCopyWithImpl<$Res, $Val extends SymptomPattern>
    implements $SymptomPatternCopyWith<$Res> {
  _$SymptomPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SymptomPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symptomId = null,
    Object? symptomName = null,
    Object? frequency = null,
    Object? averageSeverity = null,
    Object? commonCycleDays = null,
    Object? correlation = freezed,
  }) {
    return _then(
      _value.copyWith(
            symptomId: null == symptomId
                ? _value.symptomId
                : symptomId // ignore: cast_nullable_to_non_nullable
                      as String,
            symptomName: null == symptomName
                ? _value.symptomName
                : symptomName // ignore: cast_nullable_to_non_nullable
                      as String,
            frequency: null == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as int,
            averageSeverity: null == averageSeverity
                ? _value.averageSeverity
                : averageSeverity // ignore: cast_nullable_to_non_nullable
                      as double,
            commonCycleDays: null == commonCycleDays
                ? _value.commonCycleDays
                : commonCycleDays // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            correlation: freezed == correlation
                ? _value.correlation
                : correlation // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SymptomPatternImplCopyWith<$Res>
    implements $SymptomPatternCopyWith<$Res> {
  factory _$$SymptomPatternImplCopyWith(
    _$SymptomPatternImpl value,
    $Res Function(_$SymptomPatternImpl) then,
  ) = __$$SymptomPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String symptomId,
    String symptomName,
    int frequency,
    double averageSeverity,
    List<int> commonCycleDays,
    String? correlation,
  });
}

/// @nodoc
class __$$SymptomPatternImplCopyWithImpl<$Res>
    extends _$SymptomPatternCopyWithImpl<$Res, _$SymptomPatternImpl>
    implements _$$SymptomPatternImplCopyWith<$Res> {
  __$$SymptomPatternImplCopyWithImpl(
    _$SymptomPatternImpl _value,
    $Res Function(_$SymptomPatternImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SymptomPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symptomId = null,
    Object? symptomName = null,
    Object? frequency = null,
    Object? averageSeverity = null,
    Object? commonCycleDays = null,
    Object? correlation = freezed,
  }) {
    return _then(
      _$SymptomPatternImpl(
        symptomId: null == symptomId
            ? _value.symptomId
            : symptomId // ignore: cast_nullable_to_non_nullable
                  as String,
        symptomName: null == symptomName
            ? _value.symptomName
            : symptomName // ignore: cast_nullable_to_non_nullable
                  as String,
        frequency: null == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as int,
        averageSeverity: null == averageSeverity
            ? _value.averageSeverity
            : averageSeverity // ignore: cast_nullable_to_non_nullable
                  as double,
        commonCycleDays: null == commonCycleDays
            ? _value._commonCycleDays
            : commonCycleDays // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        correlation: freezed == correlation
            ? _value.correlation
            : correlation // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SymptomPatternImpl implements _SymptomPattern {
  const _$SymptomPatternImpl({
    required this.symptomId,
    required this.symptomName,
    this.frequency = 0,
    this.averageSeverity = 0.0,
    final List<int> commonCycleDays = const [],
    this.correlation,
  }) : _commonCycleDays = commonCycleDays;

  factory _$SymptomPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$SymptomPatternImplFromJson(json);

  @override
  final String symptomId;
  @override
  final String symptomName;
  @override
  @JsonKey()
  final int frequency;
  @override
  @JsonKey()
  final double averageSeverity;
  final List<int> _commonCycleDays;
  @override
  @JsonKey()
  List<int> get commonCycleDays {
    if (_commonCycleDays is EqualUnmodifiableListView) return _commonCycleDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commonCycleDays);
  }

  @override
  final String? correlation;

  @override
  String toString() {
    return 'SymptomPattern(symptomId: $symptomId, symptomName: $symptomName, frequency: $frequency, averageSeverity: $averageSeverity, commonCycleDays: $commonCycleDays, correlation: $correlation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SymptomPatternImpl &&
            (identical(other.symptomId, symptomId) ||
                other.symptomId == symptomId) &&
            (identical(other.symptomName, symptomName) ||
                other.symptomName == symptomName) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.averageSeverity, averageSeverity) ||
                other.averageSeverity == averageSeverity) &&
            const DeepCollectionEquality().equals(
              other._commonCycleDays,
              _commonCycleDays,
            ) &&
            (identical(other.correlation, correlation) ||
                other.correlation == correlation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    symptomId,
    symptomName,
    frequency,
    averageSeverity,
    const DeepCollectionEquality().hash(_commonCycleDays),
    correlation,
  );

  /// Create a copy of SymptomPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SymptomPatternImplCopyWith<_$SymptomPatternImpl> get copyWith =>
      __$$SymptomPatternImplCopyWithImpl<_$SymptomPatternImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SymptomPatternImplToJson(this);
  }
}

abstract class _SymptomPattern implements SymptomPattern {
  const factory _SymptomPattern({
    required final String symptomId,
    required final String symptomName,
    final int frequency,
    final double averageSeverity,
    final List<int> commonCycleDays,
    final String? correlation,
  }) = _$SymptomPatternImpl;

  factory _SymptomPattern.fromJson(Map<String, dynamic> json) =
      _$SymptomPatternImpl.fromJson;

  @override
  String get symptomId;
  @override
  String get symptomName;
  @override
  int get frequency;
  @override
  double get averageSeverity;
  @override
  List<int> get commonCycleDays;
  @override
  String? get correlation;

  /// Create a copy of SymptomPattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SymptomPatternImplCopyWith<_$SymptomPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MoodEntry _$MoodEntryFromJson(Map<String, dynamic> json) {
  return _MoodEntry.fromJson(json);
}

/// @nodoc
mixin _$MoodEntry {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get moodRating => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MoodEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoodEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoodEntryCopyWith<MoodEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodEntryCopyWith<$Res> {
  factory $MoodEntryCopyWith(MoodEntry value, $Res Function(MoodEntry) then) =
      _$MoodEntryCopyWithImpl<$Res, MoodEntry>;
  @useResult
  $Res call({
    String id,
    DateTime date,
    int moodRating,
    String? notes,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$MoodEntryCopyWithImpl<$Res, $Val extends MoodEntry>
    implements $MoodEntryCopyWith<$Res> {
  _$MoodEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoodEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? moodRating = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            moodRating: null == moodRating
                ? _value.moodRating
                : moodRating // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MoodEntryImplCopyWith<$Res>
    implements $MoodEntryCopyWith<$Res> {
  factory _$$MoodEntryImplCopyWith(
    _$MoodEntryImpl value,
    $Res Function(_$MoodEntryImpl) then,
  ) = __$$MoodEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime date,
    int moodRating,
    String? notes,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$MoodEntryImplCopyWithImpl<$Res>
    extends _$MoodEntryCopyWithImpl<$Res, _$MoodEntryImpl>
    implements _$$MoodEntryImplCopyWith<$Res> {
  __$$MoodEntryImplCopyWithImpl(
    _$MoodEntryImpl _value,
    $Res Function(_$MoodEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MoodEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? moodRating = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$MoodEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        moodRating: null == moodRating
            ? _value.moodRating
            : moodRating // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MoodEntryImpl implements _MoodEntry {
  const _$MoodEntryImpl({
    required this.id,
    required this.date,
    this.moodRating = 3,
    this.notes,
    this.createdAt,
  });

  factory _$MoodEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodEntryImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  @JsonKey()
  final int moodRating;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'MoodEntry(id: $id, date: $date, moodRating: $moodRating, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.moodRating, moodRating) ||
                other.moodRating == moodRating) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, date, moodRating, notes, createdAt);

  /// Create a copy of MoodEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodEntryImplCopyWith<_$MoodEntryImpl> get copyWith =>
      __$$MoodEntryImplCopyWithImpl<_$MoodEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodEntryImplToJson(this);
  }
}

abstract class _MoodEntry implements MoodEntry {
  const factory _MoodEntry({
    required final String id,
    required final DateTime date,
    final int moodRating,
    final String? notes,
    final DateTime? createdAt,
  }) = _$MoodEntryImpl;

  factory _MoodEntry.fromJson(Map<String, dynamic> json) =
      _$MoodEntryImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  int get moodRating;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;

  /// Create a copy of MoodEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodEntryImplCopyWith<_$MoodEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
