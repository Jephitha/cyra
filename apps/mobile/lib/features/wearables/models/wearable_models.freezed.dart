// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wearable_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WearableDevice _$WearableDeviceFromJson(Map<String, dynamic> json) {
  return _WearableDevice.fromJson(json);
}

/// @nodoc
mixin _$WearableDevice {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  WearableType get type => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  DateTime? get lastSyncAt => throw _privateConstructorUsedError;
  Map<String, bool> get enabledDataTypes => throw _privateConstructorUsedError;
  String? get deviceModel => throw _privateConstructorUsedError;
  String? get firmwareVersion => throw _privateConstructorUsedError;

  /// Serializes this WearableDevice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WearableDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WearableDeviceCopyWith<WearableDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WearableDeviceCopyWith<$Res> {
  factory $WearableDeviceCopyWith(
    WearableDevice value,
    $Res Function(WearableDevice) then,
  ) = _$WearableDeviceCopyWithImpl<$Res, WearableDevice>;
  @useResult
  $Res call({
    String id,
    String name,
    WearableType type,
    bool isConnected,
    bool isEnabled,
    DateTime? lastSyncAt,
    Map<String, bool> enabledDataTypes,
    String? deviceModel,
    String? firmwareVersion,
  });
}

/// @nodoc
class _$WearableDeviceCopyWithImpl<$Res, $Val extends WearableDevice>
    implements $WearableDeviceCopyWith<$Res> {
  _$WearableDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WearableDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? isConnected = null,
    Object? isEnabled = null,
    Object? lastSyncAt = freezed,
    Object? enabledDataTypes = null,
    Object? deviceModel = freezed,
    Object? firmwareVersion = freezed,
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
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as WearableType,
            isConnected: null == isConnected
                ? _value.isConnected
                : isConnected // ignore: cast_nullable_to_non_nullable
                      as bool,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastSyncAt: freezed == lastSyncAt
                ? _value.lastSyncAt
                : lastSyncAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            enabledDataTypes: null == enabledDataTypes
                ? _value.enabledDataTypes
                : enabledDataTypes // ignore: cast_nullable_to_non_nullable
                      as Map<String, bool>,
            deviceModel: freezed == deviceModel
                ? _value.deviceModel
                : deviceModel // ignore: cast_nullable_to_non_nullable
                      as String?,
            firmwareVersion: freezed == firmwareVersion
                ? _value.firmwareVersion
                : firmwareVersion // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WearableDeviceImplCopyWith<$Res>
    implements $WearableDeviceCopyWith<$Res> {
  factory _$$WearableDeviceImplCopyWith(
    _$WearableDeviceImpl value,
    $Res Function(_$WearableDeviceImpl) then,
  ) = __$$WearableDeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    WearableType type,
    bool isConnected,
    bool isEnabled,
    DateTime? lastSyncAt,
    Map<String, bool> enabledDataTypes,
    String? deviceModel,
    String? firmwareVersion,
  });
}

/// @nodoc
class __$$WearableDeviceImplCopyWithImpl<$Res>
    extends _$WearableDeviceCopyWithImpl<$Res, _$WearableDeviceImpl>
    implements _$$WearableDeviceImplCopyWith<$Res> {
  __$$WearableDeviceImplCopyWithImpl(
    _$WearableDeviceImpl _value,
    $Res Function(_$WearableDeviceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WearableDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? isConnected = null,
    Object? isEnabled = null,
    Object? lastSyncAt = freezed,
    Object? enabledDataTypes = null,
    Object? deviceModel = freezed,
    Object? firmwareVersion = freezed,
  }) {
    return _then(
      _$WearableDeviceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as WearableType,
        isConnected: null == isConnected
            ? _value.isConnected
            : isConnected // ignore: cast_nullable_to_non_nullable
                  as bool,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastSyncAt: freezed == lastSyncAt
            ? _value.lastSyncAt
            : lastSyncAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        enabledDataTypes: null == enabledDataTypes
            ? _value._enabledDataTypes
            : enabledDataTypes // ignore: cast_nullable_to_non_nullable
                  as Map<String, bool>,
        deviceModel: freezed == deviceModel
            ? _value.deviceModel
            : deviceModel // ignore: cast_nullable_to_non_nullable
                  as String?,
        firmwareVersion: freezed == firmwareVersion
            ? _value.firmwareVersion
            : firmwareVersion // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WearableDeviceImpl implements _WearableDevice {
  const _$WearableDeviceImpl({
    required this.id,
    required this.name,
    required this.type,
    required this.isConnected,
    required this.isEnabled,
    this.lastSyncAt,
    final Map<String, bool> enabledDataTypes = const {},
    this.deviceModel,
    this.firmwareVersion,
  }) : _enabledDataTypes = enabledDataTypes;

  factory _$WearableDeviceImpl.fromJson(Map<String, dynamic> json) =>
      _$$WearableDeviceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final WearableType type;
  @override
  final bool isConnected;
  @override
  final bool isEnabled;
  @override
  final DateTime? lastSyncAt;
  final Map<String, bool> _enabledDataTypes;
  @override
  @JsonKey()
  Map<String, bool> get enabledDataTypes {
    if (_enabledDataTypes is EqualUnmodifiableMapView) return _enabledDataTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_enabledDataTypes);
  }

  @override
  final String? deviceModel;
  @override
  final String? firmwareVersion;

  @override
  String toString() {
    return 'WearableDevice(id: $id, name: $name, type: $type, isConnected: $isConnected, isEnabled: $isEnabled, lastSyncAt: $lastSyncAt, enabledDataTypes: $enabledDataTypes, deviceModel: $deviceModel, firmwareVersion: $firmwareVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WearableDeviceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.lastSyncAt, lastSyncAt) ||
                other.lastSyncAt == lastSyncAt) &&
            const DeepCollectionEquality().equals(
              other._enabledDataTypes,
              _enabledDataTypes,
            ) &&
            (identical(other.deviceModel, deviceModel) ||
                other.deviceModel == deviceModel) &&
            (identical(other.firmwareVersion, firmwareVersion) ||
                other.firmwareVersion == firmwareVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    isConnected,
    isEnabled,
    lastSyncAt,
    const DeepCollectionEquality().hash(_enabledDataTypes),
    deviceModel,
    firmwareVersion,
  );

  /// Create a copy of WearableDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WearableDeviceImplCopyWith<_$WearableDeviceImpl> get copyWith =>
      __$$WearableDeviceImplCopyWithImpl<_$WearableDeviceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WearableDeviceImplToJson(this);
  }
}

abstract class _WearableDevice implements WearableDevice {
  const factory _WearableDevice({
    required final String id,
    required final String name,
    required final WearableType type,
    required final bool isConnected,
    required final bool isEnabled,
    final DateTime? lastSyncAt,
    final Map<String, bool> enabledDataTypes,
    final String? deviceModel,
    final String? firmwareVersion,
  }) = _$WearableDeviceImpl;

  factory _WearableDevice.fromJson(Map<String, dynamic> json) =
      _$WearableDeviceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  WearableType get type;
  @override
  bool get isConnected;
  @override
  bool get isEnabled;
  @override
  DateTime? get lastSyncAt;
  @override
  Map<String, bool> get enabledDataTypes;
  @override
  String? get deviceModel;
  @override
  String? get firmwareVersion;

  /// Create a copy of WearableDevice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WearableDeviceImplCopyWith<_$WearableDeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WearableDataPoint _$WearableDataPointFromJson(Map<String, dynamic> json) {
  return _WearableDataPoint.fromJson(json);
}

/// @nodoc
mixin _$WearableDataPoint {
  DateTime get timestamp => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  String? get externalId => throw _privateConstructorUsedError;

  /// Serializes this WearableDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WearableDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WearableDataPointCopyWith<WearableDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WearableDataPointCopyWith<$Res> {
  factory $WearableDataPointCopyWith(
    WearableDataPoint value,
    $Res Function(WearableDataPoint) then,
  ) = _$WearableDataPointCopyWithImpl<$Res, WearableDataPoint>;
  @useResult
  $Res call({
    DateTime timestamp,
    double value,
    String type,
    String? source,
    String? externalId,
  });
}

/// @nodoc
class _$WearableDataPointCopyWithImpl<$Res, $Val extends WearableDataPoint>
    implements $WearableDataPointCopyWith<$Res> {
  _$WearableDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WearableDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? value = null,
    Object? type = null,
    Object? source = freezed,
    Object? externalId = freezed,
  }) {
    return _then(
      _value.copyWith(
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            source: freezed == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String?,
            externalId: freezed == externalId
                ? _value.externalId
                : externalId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WearableDataPointImplCopyWith<$Res>
    implements $WearableDataPointCopyWith<$Res> {
  factory _$$WearableDataPointImplCopyWith(
    _$WearableDataPointImpl value,
    $Res Function(_$WearableDataPointImpl) then,
  ) = __$$WearableDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime timestamp,
    double value,
    String type,
    String? source,
    String? externalId,
  });
}

/// @nodoc
class __$$WearableDataPointImplCopyWithImpl<$Res>
    extends _$WearableDataPointCopyWithImpl<$Res, _$WearableDataPointImpl>
    implements _$$WearableDataPointImplCopyWith<$Res> {
  __$$WearableDataPointImplCopyWithImpl(
    _$WearableDataPointImpl _value,
    $Res Function(_$WearableDataPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WearableDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? value = null,
    Object? type = null,
    Object? source = freezed,
    Object? externalId = freezed,
  }) {
    return _then(
      _$WearableDataPointImpl(
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        source: freezed == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String?,
        externalId: freezed == externalId
            ? _value.externalId
            : externalId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WearableDataPointImpl implements _WearableDataPoint {
  const _$WearableDataPointImpl({
    required this.timestamp,
    required this.value,
    required this.type,
    this.source,
    this.externalId,
  });

  factory _$WearableDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$WearableDataPointImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final double value;
  @override
  final String type;
  @override
  final String? source;
  @override
  final String? externalId;

  @override
  String toString() {
    return 'WearableDataPoint(timestamp: $timestamp, value: $value, type: $type, source: $source, externalId: $externalId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WearableDataPointImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.externalId, externalId) ||
                other.externalId == externalId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, timestamp, value, type, source, externalId);

  /// Create a copy of WearableDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WearableDataPointImplCopyWith<_$WearableDataPointImpl> get copyWith =>
      __$$WearableDataPointImplCopyWithImpl<_$WearableDataPointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WearableDataPointImplToJson(this);
  }
}

abstract class _WearableDataPoint implements WearableDataPoint {
  const factory _WearableDataPoint({
    required final DateTime timestamp,
    required final double value,
    required final String type,
    final String? source,
    final String? externalId,
  }) = _$WearableDataPointImpl;

  factory _WearableDataPoint.fromJson(Map<String, dynamic> json) =
      _$WearableDataPointImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  double get value;
  @override
  String get type;
  @override
  String? get source;
  @override
  String? get externalId;

  /// Create a copy of WearableDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WearableDataPointImplCopyWith<_$WearableDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WearableSyncStatus _$WearableSyncStatusFromJson(Map<String, dynamic> json) {
  return _WearableSyncStatus.fromJson(json);
}

/// @nodoc
mixin _$WearableSyncStatus {
  bool get isSyncing => throw _privateConstructorUsedError;
  DateTime? get lastSuccessfulSync => throw _privateConstructorUsedError;
  int get pendingRecords => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this WearableSyncStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WearableSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WearableSyncStatusCopyWith<WearableSyncStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WearableSyncStatusCopyWith<$Res> {
  factory $WearableSyncStatusCopyWith(
    WearableSyncStatus value,
    $Res Function(WearableSyncStatus) then,
  ) = _$WearableSyncStatusCopyWithImpl<$Res, WearableSyncStatus>;
  @useResult
  $Res call({
    bool isSyncing,
    DateTime? lastSuccessfulSync,
    int pendingRecords,
    String? errorMessage,
  });
}

/// @nodoc
class _$WearableSyncStatusCopyWithImpl<$Res, $Val extends WearableSyncStatus>
    implements $WearableSyncStatusCopyWith<$Res> {
  _$WearableSyncStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WearableSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSyncing = null,
    Object? lastSuccessfulSync = freezed,
    Object? pendingRecords = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isSyncing: null == isSyncing
                ? _value.isSyncing
                : isSyncing // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastSuccessfulSync: freezed == lastSuccessfulSync
                ? _value.lastSuccessfulSync
                : lastSuccessfulSync // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            pendingRecords: null == pendingRecords
                ? _value.pendingRecords
                : pendingRecords // ignore: cast_nullable_to_non_nullable
                      as int,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WearableSyncStatusImplCopyWith<$Res>
    implements $WearableSyncStatusCopyWith<$Res> {
  factory _$$WearableSyncStatusImplCopyWith(
    _$WearableSyncStatusImpl value,
    $Res Function(_$WearableSyncStatusImpl) then,
  ) = __$$WearableSyncStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isSyncing,
    DateTime? lastSuccessfulSync,
    int pendingRecords,
    String? errorMessage,
  });
}

/// @nodoc
class __$$WearableSyncStatusImplCopyWithImpl<$Res>
    extends _$WearableSyncStatusCopyWithImpl<$Res, _$WearableSyncStatusImpl>
    implements _$$WearableSyncStatusImplCopyWith<$Res> {
  __$$WearableSyncStatusImplCopyWithImpl(
    _$WearableSyncStatusImpl _value,
    $Res Function(_$WearableSyncStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WearableSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSyncing = null,
    Object? lastSuccessfulSync = freezed,
    Object? pendingRecords = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$WearableSyncStatusImpl(
        isSyncing: null == isSyncing
            ? _value.isSyncing
            : isSyncing // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastSuccessfulSync: freezed == lastSuccessfulSync
            ? _value.lastSuccessfulSync
            : lastSuccessfulSync // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        pendingRecords: null == pendingRecords
            ? _value.pendingRecords
            : pendingRecords // ignore: cast_nullable_to_non_nullable
                  as int,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WearableSyncStatusImpl implements _WearableSyncStatus {
  const _$WearableSyncStatusImpl({
    required this.isSyncing,
    required this.lastSuccessfulSync,
    required this.pendingRecords,
    this.errorMessage,
  });

  factory _$WearableSyncStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$WearableSyncStatusImplFromJson(json);

  @override
  final bool isSyncing;
  @override
  final DateTime? lastSuccessfulSync;
  @override
  final int pendingRecords;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'WearableSyncStatus(isSyncing: $isSyncing, lastSuccessfulSync: $lastSuccessfulSync, pendingRecords: $pendingRecords, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WearableSyncStatusImpl &&
            (identical(other.isSyncing, isSyncing) ||
                other.isSyncing == isSyncing) &&
            (identical(other.lastSuccessfulSync, lastSuccessfulSync) ||
                other.lastSuccessfulSync == lastSuccessfulSync) &&
            (identical(other.pendingRecords, pendingRecords) ||
                other.pendingRecords == pendingRecords) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isSyncing,
    lastSuccessfulSync,
    pendingRecords,
    errorMessage,
  );

  /// Create a copy of WearableSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WearableSyncStatusImplCopyWith<_$WearableSyncStatusImpl> get copyWith =>
      __$$WearableSyncStatusImplCopyWithImpl<_$WearableSyncStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WearableSyncStatusImplToJson(this);
  }
}

abstract class _WearableSyncStatus implements WearableSyncStatus {
  const factory _WearableSyncStatus({
    required final bool isSyncing,
    required final DateTime? lastSuccessfulSync,
    required final int pendingRecords,
    final String? errorMessage,
  }) = _$WearableSyncStatusImpl;

  factory _WearableSyncStatus.fromJson(Map<String, dynamic> json) =
      _$WearableSyncStatusImpl.fromJson;

  @override
  bool get isSyncing;
  @override
  DateTime? get lastSuccessfulSync;
  @override
  int get pendingRecords;
  @override
  String? get errorMessage;

  /// Create a copy of WearableSyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WearableSyncStatusImplCopyWith<_$WearableSyncStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WearableDataSummary _$WearableDataSummaryFromJson(Map<String, dynamic> json) {
  return _WearableDataSummary.fromJson(json);
}

/// @nodoc
mixin _$WearableDataSummary {
  double get averageTemperature => throw _privateConstructorUsedError;
  double get averageHeartRate => throw _privateConstructorUsedError;
  double get averageSleepHours => throw _privateConstructorUsedError;
  double get averageHrv => throw _privateConstructorUsedError;
  int get stepCount => throw _privateConstructorUsedError;
  int get dataPointCount => throw _privateConstructorUsedError;

  /// Serializes this WearableDataSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WearableDataSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WearableDataSummaryCopyWith<WearableDataSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WearableDataSummaryCopyWith<$Res> {
  factory $WearableDataSummaryCopyWith(
    WearableDataSummary value,
    $Res Function(WearableDataSummary) then,
  ) = _$WearableDataSummaryCopyWithImpl<$Res, WearableDataSummary>;
  @useResult
  $Res call({
    double averageTemperature,
    double averageHeartRate,
    double averageSleepHours,
    double averageHrv,
    int stepCount,
    int dataPointCount,
  });
}

/// @nodoc
class _$WearableDataSummaryCopyWithImpl<$Res, $Val extends WearableDataSummary>
    implements $WearableDataSummaryCopyWith<$Res> {
  _$WearableDataSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WearableDataSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageTemperature = null,
    Object? averageHeartRate = null,
    Object? averageSleepHours = null,
    Object? averageHrv = null,
    Object? stepCount = null,
    Object? dataPointCount = null,
  }) {
    return _then(
      _value.copyWith(
            averageTemperature: null == averageTemperature
                ? _value.averageTemperature
                : averageTemperature // ignore: cast_nullable_to_non_nullable
                      as double,
            averageHeartRate: null == averageHeartRate
                ? _value.averageHeartRate
                : averageHeartRate // ignore: cast_nullable_to_non_nullable
                      as double,
            averageSleepHours: null == averageSleepHours
                ? _value.averageSleepHours
                : averageSleepHours // ignore: cast_nullable_to_non_nullable
                      as double,
            averageHrv: null == averageHrv
                ? _value.averageHrv
                : averageHrv // ignore: cast_nullable_to_non_nullable
                      as double,
            stepCount: null == stepCount
                ? _value.stepCount
                : stepCount // ignore: cast_nullable_to_non_nullable
                      as int,
            dataPointCount: null == dataPointCount
                ? _value.dataPointCount
                : dataPointCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WearableDataSummaryImplCopyWith<$Res>
    implements $WearableDataSummaryCopyWith<$Res> {
  factory _$$WearableDataSummaryImplCopyWith(
    _$WearableDataSummaryImpl value,
    $Res Function(_$WearableDataSummaryImpl) then,
  ) = __$$WearableDataSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double averageTemperature,
    double averageHeartRate,
    double averageSleepHours,
    double averageHrv,
    int stepCount,
    int dataPointCount,
  });
}

/// @nodoc
class __$$WearableDataSummaryImplCopyWithImpl<$Res>
    extends _$WearableDataSummaryCopyWithImpl<$Res, _$WearableDataSummaryImpl>
    implements _$$WearableDataSummaryImplCopyWith<$Res> {
  __$$WearableDataSummaryImplCopyWithImpl(
    _$WearableDataSummaryImpl _value,
    $Res Function(_$WearableDataSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WearableDataSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageTemperature = null,
    Object? averageHeartRate = null,
    Object? averageSleepHours = null,
    Object? averageHrv = null,
    Object? stepCount = null,
    Object? dataPointCount = null,
  }) {
    return _then(
      _$WearableDataSummaryImpl(
        averageTemperature: null == averageTemperature
            ? _value.averageTemperature
            : averageTemperature // ignore: cast_nullable_to_non_nullable
                  as double,
        averageHeartRate: null == averageHeartRate
            ? _value.averageHeartRate
            : averageHeartRate // ignore: cast_nullable_to_non_nullable
                  as double,
        averageSleepHours: null == averageSleepHours
            ? _value.averageSleepHours
            : averageSleepHours // ignore: cast_nullable_to_non_nullable
                  as double,
        averageHrv: null == averageHrv
            ? _value.averageHrv
            : averageHrv // ignore: cast_nullable_to_non_nullable
                  as double,
        stepCount: null == stepCount
            ? _value.stepCount
            : stepCount // ignore: cast_nullable_to_non_nullable
                  as int,
        dataPointCount: null == dataPointCount
            ? _value.dataPointCount
            : dataPointCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WearableDataSummaryImpl implements _WearableDataSummary {
  const _$WearableDataSummaryImpl({
    required this.averageTemperature,
    required this.averageHeartRate,
    required this.averageSleepHours,
    this.averageHrv = 0.0,
    required this.stepCount,
    required this.dataPointCount,
  });

  factory _$WearableDataSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WearableDataSummaryImplFromJson(json);

  @override
  final double averageTemperature;
  @override
  final double averageHeartRate;
  @override
  final double averageSleepHours;
  @override
  @JsonKey()
  final double averageHrv;
  @override
  final int stepCount;
  @override
  final int dataPointCount;

  @override
  String toString() {
    return 'WearableDataSummary(averageTemperature: $averageTemperature, averageHeartRate: $averageHeartRate, averageSleepHours: $averageSleepHours, averageHrv: $averageHrv, stepCount: $stepCount, dataPointCount: $dataPointCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WearableDataSummaryImpl &&
            (identical(other.averageTemperature, averageTemperature) ||
                other.averageTemperature == averageTemperature) &&
            (identical(other.averageHeartRate, averageHeartRate) ||
                other.averageHeartRate == averageHeartRate) &&
            (identical(other.averageSleepHours, averageSleepHours) ||
                other.averageSleepHours == averageSleepHours) &&
            (identical(other.averageHrv, averageHrv) ||
                other.averageHrv == averageHrv) &&
            (identical(other.stepCount, stepCount) ||
                other.stepCount == stepCount) &&
            (identical(other.dataPointCount, dataPointCount) ||
                other.dataPointCount == dataPointCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    averageTemperature,
    averageHeartRate,
    averageSleepHours,
    averageHrv,
    stepCount,
    dataPointCount,
  );

  /// Create a copy of WearableDataSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WearableDataSummaryImplCopyWith<_$WearableDataSummaryImpl> get copyWith =>
      __$$WearableDataSummaryImplCopyWithImpl<_$WearableDataSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WearableDataSummaryImplToJson(this);
  }
}

abstract class _WearableDataSummary implements WearableDataSummary {
  const factory _WearableDataSummary({
    required final double averageTemperature,
    required final double averageHeartRate,
    required final double averageSleepHours,
    final double averageHrv,
    required final int stepCount,
    required final int dataPointCount,
  }) = _$WearableDataSummaryImpl;

  factory _WearableDataSummary.fromJson(Map<String, dynamic> json) =
      _$WearableDataSummaryImpl.fromJson;

  @override
  double get averageTemperature;
  @override
  double get averageHeartRate;
  @override
  double get averageSleepHours;
  @override
  double get averageHrv;
  @override
  int get stepCount;
  @override
  int get dataPointCount;

  /// Create a copy of WearableDataSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WearableDataSummaryImplCopyWith<_$WearableDataSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
