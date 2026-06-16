// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'opk_test_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OPKTestResult _$OPKTestResultFromJson(Map<String, dynamic> json) {
  return _OPKTestResult.fromJson(json);
}

/// @nodoc
mixin _$OPKTestResult {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  OPKResult get result => throw _privateConstructorUsedError;
  String? get timeOfDay => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get photoPath => throw _privateConstructorUsedError;

  /// Serializes this OPKTestResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OPKTestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OPKTestResultCopyWith<OPKTestResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OPKTestResultCopyWith<$Res> {
  factory $OPKTestResultCopyWith(
    OPKTestResult value,
    $Res Function(OPKTestResult) then,
  ) = _$OPKTestResultCopyWithImpl<$Res, OPKTestResult>;
  @useResult
  $Res call({
    String id,
    DateTime date,
    OPKResult result,
    String? timeOfDay,
    String? brand,
    String? photoPath,
  });
}

/// @nodoc
class _$OPKTestResultCopyWithImpl<$Res, $Val extends OPKTestResult>
    implements $OPKTestResultCopyWith<$Res> {
  _$OPKTestResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OPKTestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? result = null,
    Object? timeOfDay = freezed,
    Object? brand = freezed,
    Object? photoPath = freezed,
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
            result: null == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as OPKResult,
            timeOfDay: freezed == timeOfDay
                ? _value.timeOfDay
                : timeOfDay // ignore: cast_nullable_to_non_nullable
                      as String?,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoPath: freezed == photoPath
                ? _value.photoPath
                : photoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OPKTestResultImplCopyWith<$Res>
    implements $OPKTestResultCopyWith<$Res> {
  factory _$$OPKTestResultImplCopyWith(
    _$OPKTestResultImpl value,
    $Res Function(_$OPKTestResultImpl) then,
  ) = __$$OPKTestResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime date,
    OPKResult result,
    String? timeOfDay,
    String? brand,
    String? photoPath,
  });
}

/// @nodoc
class __$$OPKTestResultImplCopyWithImpl<$Res>
    extends _$OPKTestResultCopyWithImpl<$Res, _$OPKTestResultImpl>
    implements _$$OPKTestResultImplCopyWith<$Res> {
  __$$OPKTestResultImplCopyWithImpl(
    _$OPKTestResultImpl _value,
    $Res Function(_$OPKTestResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OPKTestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? result = null,
    Object? timeOfDay = freezed,
    Object? brand = freezed,
    Object? photoPath = freezed,
  }) {
    return _then(
      _$OPKTestResultImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        result: null == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                  as OPKResult,
        timeOfDay: freezed == timeOfDay
            ? _value.timeOfDay
            : timeOfDay // ignore: cast_nullable_to_non_nullable
                  as String?,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoPath: freezed == photoPath
            ? _value.photoPath
            : photoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OPKTestResultImpl implements _OPKTestResult {
  const _$OPKTestResultImpl({
    required this.id,
    required this.date,
    required this.result,
    this.timeOfDay,
    this.brand,
    this.photoPath,
  });

  factory _$OPKTestResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$OPKTestResultImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final OPKResult result;
  @override
  final String? timeOfDay;
  @override
  final String? brand;
  @override
  final String? photoPath;

  @override
  String toString() {
    return 'OPKTestResult(id: $id, date: $date, result: $result, timeOfDay: $timeOfDay, brand: $brand, photoPath: $photoPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OPKTestResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.timeOfDay, timeOfDay) ||
                other.timeOfDay == timeOfDay) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, date, result, timeOfDay, brand, photoPath);

  /// Create a copy of OPKTestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OPKTestResultImplCopyWith<_$OPKTestResultImpl> get copyWith =>
      __$$OPKTestResultImplCopyWithImpl<_$OPKTestResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OPKTestResultImplToJson(this);
  }
}

abstract class _OPKTestResult implements OPKTestResult {
  const factory _OPKTestResult({
    required final String id,
    required final DateTime date,
    required final OPKResult result,
    final String? timeOfDay,
    final String? brand,
    final String? photoPath,
  }) = _$OPKTestResultImpl;

  factory _OPKTestResult.fromJson(Map<String, dynamic> json) =
      _$OPKTestResultImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  OPKResult get result;
  @override
  String? get timeOfDay;
  @override
  String? get brand;
  @override
  String? get photoPath;

  /// Create a copy of OPKTestResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OPKTestResultImplCopyWith<_$OPKTestResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
