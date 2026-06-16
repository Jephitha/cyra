// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) {
  return _JournalEntry.fromJson(json);
}

/// @nodoc
mixin _$JournalEntry {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  List<String> get photoPaths => throw _privateConstructorUsedError;
  List<String> get voiceNotePaths => throw _privateConstructorUsedError;
  int get moodRating => throw _privateConstructorUsedError;
  String? get cycleDayId => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this JournalEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalEntryCopyWith<JournalEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalEntryCopyWith<$Res> {
  factory $JournalEntryCopyWith(
    JournalEntry value,
    $Res Function(JournalEntry) then,
  ) = _$JournalEntryCopyWithImpl<$Res, JournalEntry>;
  @useResult
  $Res call({
    String id,
    DateTime date,
    String? title,
    String? content,
    List<String> photoPaths,
    List<String> voiceNotePaths,
    int moodRating,
    String? cycleDayId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$JournalEntryCopyWithImpl<$Res, $Val extends JournalEntry>
    implements $JournalEntryCopyWith<$Res> {
  _$JournalEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? title = freezed,
    Object? content = freezed,
    Object? photoPaths = null,
    Object? voiceNotePaths = null,
    Object? moodRating = null,
    Object? cycleDayId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoPaths: null == photoPaths
                ? _value.photoPaths
                : photoPaths // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            voiceNotePaths: null == voiceNotePaths
                ? _value.voiceNotePaths
                : voiceNotePaths // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            moodRating: null == moodRating
                ? _value.moodRating
                : moodRating // ignore: cast_nullable_to_non_nullable
                      as int,
            cycleDayId: freezed == cycleDayId
                ? _value.cycleDayId
                : cycleDayId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JournalEntryImplCopyWith<$Res>
    implements $JournalEntryCopyWith<$Res> {
  factory _$$JournalEntryImplCopyWith(
    _$JournalEntryImpl value,
    $Res Function(_$JournalEntryImpl) then,
  ) = __$$JournalEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime date,
    String? title,
    String? content,
    List<String> photoPaths,
    List<String> voiceNotePaths,
    int moodRating,
    String? cycleDayId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$JournalEntryImplCopyWithImpl<$Res>
    extends _$JournalEntryCopyWithImpl<$Res, _$JournalEntryImpl>
    implements _$$JournalEntryImplCopyWith<$Res> {
  __$$JournalEntryImplCopyWithImpl(
    _$JournalEntryImpl _value,
    $Res Function(_$JournalEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? title = freezed,
    Object? content = freezed,
    Object? photoPaths = null,
    Object? voiceNotePaths = null,
    Object? moodRating = null,
    Object? cycleDayId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$JournalEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoPaths: null == photoPaths
            ? _value._photoPaths
            : photoPaths // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        voiceNotePaths: null == voiceNotePaths
            ? _value._voiceNotePaths
            : voiceNotePaths // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        moodRating: null == moodRating
            ? _value.moodRating
            : moodRating // ignore: cast_nullable_to_non_nullable
                  as int,
        cycleDayId: freezed == cycleDayId
            ? _value.cycleDayId
            : cycleDayId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JournalEntryImpl implements _JournalEntry {
  const _$JournalEntryImpl({
    required this.id,
    required this.date,
    this.title,
    this.content,
    final List<String> photoPaths = const [],
    final List<String> voiceNotePaths = const [],
    this.moodRating = 0,
    this.cycleDayId,
    this.createdAt,
    this.updatedAt,
  }) : _photoPaths = photoPaths,
       _voiceNotePaths = voiceNotePaths;

  factory _$JournalEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalEntryImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String? title;
  @override
  final String? content;
  final List<String> _photoPaths;
  @override
  @JsonKey()
  List<String> get photoPaths {
    if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoPaths);
  }

  final List<String> _voiceNotePaths;
  @override
  @JsonKey()
  List<String> get voiceNotePaths {
    if (_voiceNotePaths is EqualUnmodifiableListView) return _voiceNotePaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_voiceNotePaths);
  }

  @override
  @JsonKey()
  final int moodRating;
  @override
  final String? cycleDayId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'JournalEntry(id: $id, date: $date, title: $title, content: $content, photoPaths: $photoPaths, voiceNotePaths: $voiceNotePaths, moodRating: $moodRating, cycleDayId: $cycleDayId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(
              other._photoPaths,
              _photoPaths,
            ) &&
            const DeepCollectionEquality().equals(
              other._voiceNotePaths,
              _voiceNotePaths,
            ) &&
            (identical(other.moodRating, moodRating) ||
                other.moodRating == moodRating) &&
            (identical(other.cycleDayId, cycleDayId) ||
                other.cycleDayId == cycleDayId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    date,
    title,
    content,
    const DeepCollectionEquality().hash(_photoPaths),
    const DeepCollectionEquality().hash(_voiceNotePaths),
    moodRating,
    cycleDayId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalEntryImplCopyWith<_$JournalEntryImpl> get copyWith =>
      __$$JournalEntryImplCopyWithImpl<_$JournalEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalEntryImplToJson(this);
  }
}

abstract class _JournalEntry implements JournalEntry {
  const factory _JournalEntry({
    required final String id,
    required final DateTime date,
    final String? title,
    final String? content,
    final List<String> photoPaths,
    final List<String> voiceNotePaths,
    final int moodRating,
    final String? cycleDayId,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$JournalEntryImpl;

  factory _JournalEntry.fromJson(Map<String, dynamic> json) =
      _$JournalEntryImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  String? get title;
  @override
  String? get content;
  @override
  List<String> get photoPaths;
  @override
  List<String> get voiceNotePaths;
  @override
  int get moodRating;
  @override
  String? get cycleDayId;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalEntryImplCopyWith<_$JournalEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
