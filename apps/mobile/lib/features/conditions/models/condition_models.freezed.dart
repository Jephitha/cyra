// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'condition_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserCondition _$UserConditionFromJson(Map<String, dynamic> json) {
  return _UserCondition.fromJson(json);
}

/// @nodoc
mixin _$UserCondition {
  String get id => throw _privateConstructorUsedError;
  String get conditionType => throw _privateConstructorUsedError;
  DateTime? get diagnosisDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String> get trackedSymptoms => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserCondition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserCondition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserConditionCopyWith<UserCondition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserConditionCopyWith<$Res> {
  factory $UserConditionCopyWith(
    UserCondition value,
    $Res Function(UserCondition) then,
  ) = _$UserConditionCopyWithImpl<$Res, UserCondition>;
  @useResult
  $Res call({
    String id,
    String conditionType,
    DateTime? diagnosisDate,
    bool isActive,
    String? notes,
    List<String> trackedSymptoms,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$UserConditionCopyWithImpl<$Res, $Val extends UserCondition>
    implements $UserConditionCopyWith<$Res> {
  _$UserConditionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserCondition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conditionType = null,
    Object? diagnosisDate = freezed,
    Object? isActive = null,
    Object? notes = freezed,
    Object? trackedSymptoms = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            conditionType: null == conditionType
                ? _value.conditionType
                : conditionType // ignore: cast_nullable_to_non_nullable
                      as String,
            diagnosisDate: freezed == diagnosisDate
                ? _value.diagnosisDate
                : diagnosisDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            trackedSymptoms: null == trackedSymptoms
                ? _value.trackedSymptoms
                : trackedSymptoms // ignore: cast_nullable_to_non_nullable
                      as List<String>,
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
abstract class _$$UserConditionImplCopyWith<$Res>
    implements $UserConditionCopyWith<$Res> {
  factory _$$UserConditionImplCopyWith(
    _$UserConditionImpl value,
    $Res Function(_$UserConditionImpl) then,
  ) = __$$UserConditionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String conditionType,
    DateTime? diagnosisDate,
    bool isActive,
    String? notes,
    List<String> trackedSymptoms,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$UserConditionImplCopyWithImpl<$Res>
    extends _$UserConditionCopyWithImpl<$Res, _$UserConditionImpl>
    implements _$$UserConditionImplCopyWith<$Res> {
  __$$UserConditionImplCopyWithImpl(
    _$UserConditionImpl _value,
    $Res Function(_$UserConditionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserCondition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conditionType = null,
    Object? diagnosisDate = freezed,
    Object? isActive = null,
    Object? notes = freezed,
    Object? trackedSymptoms = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$UserConditionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        conditionType: null == conditionType
            ? _value.conditionType
            : conditionType // ignore: cast_nullable_to_non_nullable
                  as String,
        diagnosisDate: freezed == diagnosisDate
            ? _value.diagnosisDate
            : diagnosisDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        trackedSymptoms: null == trackedSymptoms
            ? _value._trackedSymptoms
            : trackedSymptoms // ignore: cast_nullable_to_non_nullable
                  as List<String>,
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
class _$UserConditionImpl implements _UserCondition {
  const _$UserConditionImpl({
    required this.id,
    required this.conditionType,
    this.diagnosisDate,
    this.isActive = true,
    this.notes,
    final List<String> trackedSymptoms = const [],
    this.createdAt,
    this.updatedAt,
  }) : _trackedSymptoms = trackedSymptoms;

  factory _$UserConditionImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserConditionImplFromJson(json);

  @override
  final String id;
  @override
  final String conditionType;
  @override
  final DateTime? diagnosisDate;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? notes;
  final List<String> _trackedSymptoms;
  @override
  @JsonKey()
  List<String> get trackedSymptoms {
    if (_trackedSymptoms is EqualUnmodifiableListView) return _trackedSymptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trackedSymptoms);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserCondition(id: $id, conditionType: $conditionType, diagnosisDate: $diagnosisDate, isActive: $isActive, notes: $notes, trackedSymptoms: $trackedSymptoms, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserConditionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conditionType, conditionType) ||
                other.conditionType == conditionType) &&
            (identical(other.diagnosisDate, diagnosisDate) ||
                other.diagnosisDate == diagnosisDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(
              other._trackedSymptoms,
              _trackedSymptoms,
            ) &&
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
    conditionType,
    diagnosisDate,
    isActive,
    notes,
    const DeepCollectionEquality().hash(_trackedSymptoms),
    createdAt,
    updatedAt,
  );

  /// Create a copy of UserCondition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserConditionImplCopyWith<_$UserConditionImpl> get copyWith =>
      __$$UserConditionImplCopyWithImpl<_$UserConditionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserConditionImplToJson(this);
  }
}

abstract class _UserCondition implements UserCondition {
  const factory _UserCondition({
    required final String id,
    required final String conditionType,
    final DateTime? diagnosisDate,
    final bool isActive,
    final String? notes,
    final List<String> trackedSymptoms,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$UserConditionImpl;

  factory _UserCondition.fromJson(Map<String, dynamic> json) =
      _$UserConditionImpl.fromJson;

  @override
  String get id;
  @override
  String get conditionType;
  @override
  DateTime? get diagnosisDate;
  @override
  bool get isActive;
  @override
  String? get notes;
  @override
  List<String> get trackedSymptoms;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of UserCondition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserConditionImplCopyWith<_$UserConditionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConditionInfo _$ConditionInfoFromJson(Map<String, dynamic> json) {
  return _ConditionInfo.fromJson(json);
}

/// @nodoc
mixin _$ConditionInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get commonSymptoms => throw _privateConstructorUsedError;
  List<String> get trackingRecommendations =>
      throw _privateConstructorUsedError;
  String get managementTips => throw _privateConstructorUsedError;
  String get whenToSeeDoctor => throw _privateConstructorUsedError;
  String? get prevalenceInfo => throw _privateConstructorUsedError;
  bool get isVisible => throw _privateConstructorUsedError;

  /// Serializes this ConditionInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConditionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConditionInfoCopyWith<ConditionInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConditionInfoCopyWith<$Res> {
  factory $ConditionInfoCopyWith(
    ConditionInfo value,
    $Res Function(ConditionInfo) then,
  ) = _$ConditionInfoCopyWithImpl<$Res, ConditionInfo>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    List<String> commonSymptoms,
    List<String> trackingRecommendations,
    String managementTips,
    String whenToSeeDoctor,
    String? prevalenceInfo,
    bool isVisible,
  });
}

/// @nodoc
class _$ConditionInfoCopyWithImpl<$Res, $Val extends ConditionInfo>
    implements $ConditionInfoCopyWith<$Res> {
  _$ConditionInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConditionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? commonSymptoms = null,
    Object? trackingRecommendations = null,
    Object? managementTips = null,
    Object? whenToSeeDoctor = null,
    Object? prevalenceInfo = freezed,
    Object? isVisible = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            commonSymptoms: null == commonSymptoms
                ? _value.commonSymptoms
                : commonSymptoms // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            trackingRecommendations: null == trackingRecommendations
                ? _value.trackingRecommendations
                : trackingRecommendations // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            managementTips: null == managementTips
                ? _value.managementTips
                : managementTips // ignore: cast_nullable_to_non_nullable
                      as String,
            whenToSeeDoctor: null == whenToSeeDoctor
                ? _value.whenToSeeDoctor
                : whenToSeeDoctor // ignore: cast_nullable_to_non_nullable
                      as String,
            prevalenceInfo: freezed == prevalenceInfo
                ? _value.prevalenceInfo
                : prevalenceInfo // ignore: cast_nullable_to_non_nullable
                      as String?,
            isVisible: null == isVisible
                ? _value.isVisible
                : isVisible // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConditionInfoImplCopyWith<$Res>
    implements $ConditionInfoCopyWith<$Res> {
  factory _$$ConditionInfoImplCopyWith(
    _$ConditionInfoImpl value,
    $Res Function(_$ConditionInfoImpl) then,
  ) = __$$ConditionInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    List<String> commonSymptoms,
    List<String> trackingRecommendations,
    String managementTips,
    String whenToSeeDoctor,
    String? prevalenceInfo,
    bool isVisible,
  });
}

/// @nodoc
class __$$ConditionInfoImplCopyWithImpl<$Res>
    extends _$ConditionInfoCopyWithImpl<$Res, _$ConditionInfoImpl>
    implements _$$ConditionInfoImplCopyWith<$Res> {
  __$$ConditionInfoImplCopyWithImpl(
    _$ConditionInfoImpl _value,
    $Res Function(_$ConditionInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConditionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? commonSymptoms = null,
    Object? trackingRecommendations = null,
    Object? managementTips = null,
    Object? whenToSeeDoctor = null,
    Object? prevalenceInfo = freezed,
    Object? isVisible = null,
  }) {
    return _then(
      _$ConditionInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        commonSymptoms: null == commonSymptoms
            ? _value._commonSymptoms
            : commonSymptoms // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        trackingRecommendations: null == trackingRecommendations
            ? _value._trackingRecommendations
            : trackingRecommendations // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        managementTips: null == managementTips
            ? _value.managementTips
            : managementTips // ignore: cast_nullable_to_non_nullable
                  as String,
        whenToSeeDoctor: null == whenToSeeDoctor
            ? _value.whenToSeeDoctor
            : whenToSeeDoctor // ignore: cast_nullable_to_non_nullable
                  as String,
        prevalenceInfo: freezed == prevalenceInfo
            ? _value.prevalenceInfo
            : prevalenceInfo // ignore: cast_nullable_to_non_nullable
                  as String?,
        isVisible: null == isVisible
            ? _value.isVisible
            : isVisible // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConditionInfoImpl implements _ConditionInfo {
  const _$ConditionInfoImpl({
    required this.id,
    required this.name,
    required this.description,
    required final List<String> commonSymptoms,
    required final List<String> trackingRecommendations,
    required this.managementTips,
    required this.whenToSeeDoctor,
    this.prevalenceInfo,
    this.isVisible = false,
  }) : _commonSymptoms = commonSymptoms,
       _trackingRecommendations = trackingRecommendations;

  factory _$ConditionInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConditionInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  final List<String> _commonSymptoms;
  @override
  List<String> get commonSymptoms {
    if (_commonSymptoms is EqualUnmodifiableListView) return _commonSymptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commonSymptoms);
  }

  final List<String> _trackingRecommendations;
  @override
  List<String> get trackingRecommendations {
    if (_trackingRecommendations is EqualUnmodifiableListView)
      return _trackingRecommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trackingRecommendations);
  }

  @override
  final String managementTips;
  @override
  final String whenToSeeDoctor;
  @override
  final String? prevalenceInfo;
  @override
  @JsonKey()
  final bool isVisible;

  @override
  String toString() {
    return 'ConditionInfo(id: $id, name: $name, description: $description, commonSymptoms: $commonSymptoms, trackingRecommendations: $trackingRecommendations, managementTips: $managementTips, whenToSeeDoctor: $whenToSeeDoctor, prevalenceInfo: $prevalenceInfo, isVisible: $isVisible)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConditionInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._commonSymptoms,
              _commonSymptoms,
            ) &&
            const DeepCollectionEquality().equals(
              other._trackingRecommendations,
              _trackingRecommendations,
            ) &&
            (identical(other.managementTips, managementTips) ||
                other.managementTips == managementTips) &&
            (identical(other.whenToSeeDoctor, whenToSeeDoctor) ||
                other.whenToSeeDoctor == whenToSeeDoctor) &&
            (identical(other.prevalenceInfo, prevalenceInfo) ||
                other.prevalenceInfo == prevalenceInfo) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    const DeepCollectionEquality().hash(_commonSymptoms),
    const DeepCollectionEquality().hash(_trackingRecommendations),
    managementTips,
    whenToSeeDoctor,
    prevalenceInfo,
    isVisible,
  );

  /// Create a copy of ConditionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConditionInfoImplCopyWith<_$ConditionInfoImpl> get copyWith =>
      __$$ConditionInfoImplCopyWithImpl<_$ConditionInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConditionInfoImplToJson(this);
  }
}

abstract class _ConditionInfo implements ConditionInfo {
  const factory _ConditionInfo({
    required final String id,
    required final String name,
    required final String description,
    required final List<String> commonSymptoms,
    required final List<String> trackingRecommendations,
    required final String managementTips,
    required final String whenToSeeDoctor,
    final String? prevalenceInfo,
    final bool isVisible,
  }) = _$ConditionInfoImpl;

  factory _ConditionInfo.fromJson(Map<String, dynamic> json) =
      _$ConditionInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  List<String> get commonSymptoms;
  @override
  List<String> get trackingRecommendations;
  @override
  String get managementTips;
  @override
  String get whenToSeeDoctor;
  @override
  String? get prevalenceInfo;
  @override
  bool get isVisible;

  /// Create a copy of ConditionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConditionInfoImplCopyWith<_$ConditionInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
