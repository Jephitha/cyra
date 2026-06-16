// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HealthReport _$HealthReportFromJson(Map<String, dynamic> json) {
  return _HealthReport.fromJson(json);
}

/// @nodoc
mixin _$HealthReport {
  String get id => throw _privateConstructorUsedError;
  String get reportType => throw _privateConstructorUsedError;
  DateTime get dateRangeStart => throw _privateConstructorUsedError;
  DateTime get dateRangeEnd => throw _privateConstructorUsedError;
  String? get filePath => throw _privateConstructorUsedError;
  int? get fileSize => throw _privateConstructorUsedError;
  bool get isGenerated => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this HealthReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HealthReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HealthReportCopyWith<HealthReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HealthReportCopyWith<$Res> {
  factory $HealthReportCopyWith(
    HealthReport value,
    $Res Function(HealthReport) then,
  ) = _$HealthReportCopyWithImpl<$Res, HealthReport>;
  @useResult
  $Res call({
    String id,
    String reportType,
    DateTime dateRangeStart,
    DateTime dateRangeEnd,
    String? filePath,
    int? fileSize,
    bool isGenerated,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$HealthReportCopyWithImpl<$Res, $Val extends HealthReport>
    implements $HealthReportCopyWith<$Res> {
  _$HealthReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HealthReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reportType = null,
    Object? dateRangeStart = null,
    Object? dateRangeEnd = null,
    Object? filePath = freezed,
    Object? fileSize = freezed,
    Object? isGenerated = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reportType: null == reportType
                ? _value.reportType
                : reportType // ignore: cast_nullable_to_non_nullable
                      as String,
            dateRangeStart: null == dateRangeStart
                ? _value.dateRangeStart
                : dateRangeStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dateRangeEnd: null == dateRangeEnd
                ? _value.dateRangeEnd
                : dateRangeEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            filePath: freezed == filePath
                ? _value.filePath
                : filePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            fileSize: freezed == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as int?,
            isGenerated: null == isGenerated
                ? _value.isGenerated
                : isGenerated // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$HealthReportImplCopyWith<$Res>
    implements $HealthReportCopyWith<$Res> {
  factory _$$HealthReportImplCopyWith(
    _$HealthReportImpl value,
    $Res Function(_$HealthReportImpl) then,
  ) = __$$HealthReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reportType,
    DateTime dateRangeStart,
    DateTime dateRangeEnd,
    String? filePath,
    int? fileSize,
    bool isGenerated,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$HealthReportImplCopyWithImpl<$Res>
    extends _$HealthReportCopyWithImpl<$Res, _$HealthReportImpl>
    implements _$$HealthReportImplCopyWith<$Res> {
  __$$HealthReportImplCopyWithImpl(
    _$HealthReportImpl _value,
    $Res Function(_$HealthReportImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HealthReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reportType = null,
    Object? dateRangeStart = null,
    Object? dateRangeEnd = null,
    Object? filePath = freezed,
    Object? fileSize = freezed,
    Object? isGenerated = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$HealthReportImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reportType: null == reportType
            ? _value.reportType
            : reportType // ignore: cast_nullable_to_non_nullable
                  as String,
        dateRangeStart: null == dateRangeStart
            ? _value.dateRangeStart
            : dateRangeStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dateRangeEnd: null == dateRangeEnd
            ? _value.dateRangeEnd
            : dateRangeEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        filePath: freezed == filePath
            ? _value.filePath
            : filePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        fileSize: freezed == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        isGenerated: null == isGenerated
            ? _value.isGenerated
            : isGenerated // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$HealthReportImpl implements _HealthReport {
  const _$HealthReportImpl({
    required this.id,
    required this.reportType,
    required this.dateRangeStart,
    required this.dateRangeEnd,
    this.filePath,
    this.fileSize,
    this.isGenerated = false,
    this.createdAt,
  });

  factory _$HealthReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$HealthReportImplFromJson(json);

  @override
  final String id;
  @override
  final String reportType;
  @override
  final DateTime dateRangeStart;
  @override
  final DateTime dateRangeEnd;
  @override
  final String? filePath;
  @override
  final int? fileSize;
  @override
  @JsonKey()
  final bool isGenerated;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'HealthReport(id: $id, reportType: $reportType, dateRangeStart: $dateRangeStart, dateRangeEnd: $dateRangeEnd, filePath: $filePath, fileSize: $fileSize, isGenerated: $isGenerated, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HealthReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reportType, reportType) ||
                other.reportType == reportType) &&
            (identical(other.dateRangeStart, dateRangeStart) ||
                other.dateRangeStart == dateRangeStart) &&
            (identical(other.dateRangeEnd, dateRangeEnd) ||
                other.dateRangeEnd == dateRangeEnd) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.isGenerated, isGenerated) ||
                other.isGenerated == isGenerated) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reportType,
    dateRangeStart,
    dateRangeEnd,
    filePath,
    fileSize,
    isGenerated,
    createdAt,
  );

  /// Create a copy of HealthReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HealthReportImplCopyWith<_$HealthReportImpl> get copyWith =>
      __$$HealthReportImplCopyWithImpl<_$HealthReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HealthReportImplToJson(this);
  }
}

abstract class _HealthReport implements HealthReport {
  const factory _HealthReport({
    required final String id,
    required final String reportType,
    required final DateTime dateRangeStart,
    required final DateTime dateRangeEnd,
    final String? filePath,
    final int? fileSize,
    final bool isGenerated,
    final DateTime? createdAt,
  }) = _$HealthReportImpl;

  factory _HealthReport.fromJson(Map<String, dynamic> json) =
      _$HealthReportImpl.fromJson;

  @override
  String get id;
  @override
  String get reportType;
  @override
  DateTime get dateRangeStart;
  @override
  DateTime get dateRangeEnd;
  @override
  String? get filePath;
  @override
  int? get fileSize;
  @override
  bool get isGenerated;
  @override
  DateTime? get createdAt;

  /// Create a copy of HealthReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HealthReportImplCopyWith<_$HealthReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SymptomEntry _$SymptomEntryFromJson(Map<String, dynamic> json) {
  return _SymptomEntry.fromJson(json);
}

/// @nodoc
mixin _$SymptomEntry {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  DateTime get loggedAt => throw _privateConstructorUsedError;
  int get severity => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

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
    String name,
    String category,
    DateTime loggedAt,
    int severity,
    String? notes,
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
    Object? name = null,
    Object? category = null,
    Object? loggedAt = null,
    Object? severity = null,
    Object? notes = freezed,
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
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            loggedAt: null == loggedAt
                ? _value.loggedAt
                : loggedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String name,
    String category,
    DateTime loggedAt,
    int severity,
    String? notes,
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
    Object? name = null,
    Object? category = null,
    Object? loggedAt = null,
    Object? severity = null,
    Object? notes = freezed,
  }) {
    return _then(
      _$SymptomEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        loggedAt: null == loggedAt
            ? _value.loggedAt
            : loggedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SymptomEntryImpl implements _SymptomEntry {
  const _$SymptomEntryImpl({
    required this.id,
    required this.name,
    required this.category,
    required this.loggedAt,
    this.severity = 0,
    this.notes,
  });

  factory _$SymptomEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SymptomEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final DateTime loggedAt;
  @override
  @JsonKey()
  final int severity;
  @override
  final String? notes;

  @override
  String toString() {
    return 'SymptomEntry(id: $id, name: $name, category: $category, loggedAt: $loggedAt, severity: $severity, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SymptomEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.loggedAt, loggedAt) ||
                other.loggedAt == loggedAt) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, category, loggedAt, severity, notes);

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
    required final String name,
    required final String category,
    required final DateTime loggedAt,
    final int severity,
    final String? notes,
  }) = _$SymptomEntryImpl;

  factory _SymptomEntry.fromJson(Map<String, dynamic> json) =
      _$SymptomEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get category;
  @override
  DateTime get loggedAt;
  @override
  int get severity;
  @override
  String? get notes;

  /// Create a copy of SymptomEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SymptomEntryImplCopyWith<_$SymptomEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReportData _$ReportDataFromJson(Map<String, dynamic> json) {
  return _ReportData.fromJson(json);
}

/// @nodoc
mixin _$ReportData {
  DateTime get generatedAt => throw _privateConstructorUsedError;
  DateTime get dateRangeStart => throw _privateConstructorUsedError;
  DateTime get dateRangeEnd => throw _privateConstructorUsedError;
  int get totalCycles => throw _privateConstructorUsedError;
  double get averageCycleLength => throw _privateConstructorUsedError;
  double get averagePeriodLength => throw _privateConstructorUsedError;
  double get variabilityScore => throw _privateConstructorUsedError;
  List<Cycle> get cycles => throw _privateConstructorUsedError;
  List<SymptomEntry> get symptoms => throw _privateConstructorUsedError;
  String? get fertilitySummary => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this ReportData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportDataCopyWith<ReportData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportDataCopyWith<$Res> {
  factory $ReportDataCopyWith(
    ReportData value,
    $Res Function(ReportData) then,
  ) = _$ReportDataCopyWithImpl<$Res, ReportData>;
  @useResult
  $Res call({
    DateTime generatedAt,
    DateTime dateRangeStart,
    DateTime dateRangeEnd,
    int totalCycles,
    double averageCycleLength,
    double averagePeriodLength,
    double variabilityScore,
    List<Cycle> cycles,
    List<SymptomEntry> symptoms,
    String? fertilitySummary,
    String? notes,
  });
}

/// @nodoc
class _$ReportDataCopyWithImpl<$Res, $Val extends ReportData>
    implements $ReportDataCopyWith<$Res> {
  _$ReportDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? generatedAt = null,
    Object? dateRangeStart = null,
    Object? dateRangeEnd = null,
    Object? totalCycles = null,
    Object? averageCycleLength = null,
    Object? averagePeriodLength = null,
    Object? variabilityScore = null,
    Object? cycles = null,
    Object? symptoms = null,
    Object? fertilitySummary = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            generatedAt: null == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dateRangeStart: null == dateRangeStart
                ? _value.dateRangeStart
                : dateRangeStart // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dateRangeEnd: null == dateRangeEnd
                ? _value.dateRangeEnd
                : dateRangeEnd // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalCycles: null == totalCycles
                ? _value.totalCycles
                : totalCycles // ignore: cast_nullable_to_non_nullable
                      as int,
            averageCycleLength: null == averageCycleLength
                ? _value.averageCycleLength
                : averageCycleLength // ignore: cast_nullable_to_non_nullable
                      as double,
            averagePeriodLength: null == averagePeriodLength
                ? _value.averagePeriodLength
                : averagePeriodLength // ignore: cast_nullable_to_non_nullable
                      as double,
            variabilityScore: null == variabilityScore
                ? _value.variabilityScore
                : variabilityScore // ignore: cast_nullable_to_non_nullable
                      as double,
            cycles: null == cycles
                ? _value.cycles
                : cycles // ignore: cast_nullable_to_non_nullable
                      as List<Cycle>,
            symptoms: null == symptoms
                ? _value.symptoms
                : symptoms // ignore: cast_nullable_to_non_nullable
                      as List<SymptomEntry>,
            fertilitySummary: freezed == fertilitySummary
                ? _value.fertilitySummary
                : fertilitySummary // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportDataImplCopyWith<$Res>
    implements $ReportDataCopyWith<$Res> {
  factory _$$ReportDataImplCopyWith(
    _$ReportDataImpl value,
    $Res Function(_$ReportDataImpl) then,
  ) = __$$ReportDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime generatedAt,
    DateTime dateRangeStart,
    DateTime dateRangeEnd,
    int totalCycles,
    double averageCycleLength,
    double averagePeriodLength,
    double variabilityScore,
    List<Cycle> cycles,
    List<SymptomEntry> symptoms,
    String? fertilitySummary,
    String? notes,
  });
}

/// @nodoc
class __$$ReportDataImplCopyWithImpl<$Res>
    extends _$ReportDataCopyWithImpl<$Res, _$ReportDataImpl>
    implements _$$ReportDataImplCopyWith<$Res> {
  __$$ReportDataImplCopyWithImpl(
    _$ReportDataImpl _value,
    $Res Function(_$ReportDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? generatedAt = null,
    Object? dateRangeStart = null,
    Object? dateRangeEnd = null,
    Object? totalCycles = null,
    Object? averageCycleLength = null,
    Object? averagePeriodLength = null,
    Object? variabilityScore = null,
    Object? cycles = null,
    Object? symptoms = null,
    Object? fertilitySummary = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$ReportDataImpl(
        generatedAt: null == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dateRangeStart: null == dateRangeStart
            ? _value.dateRangeStart
            : dateRangeStart // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dateRangeEnd: null == dateRangeEnd
            ? _value.dateRangeEnd
            : dateRangeEnd // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalCycles: null == totalCycles
            ? _value.totalCycles
            : totalCycles // ignore: cast_nullable_to_non_nullable
                  as int,
        averageCycleLength: null == averageCycleLength
            ? _value.averageCycleLength
            : averageCycleLength // ignore: cast_nullable_to_non_nullable
                  as double,
        averagePeriodLength: null == averagePeriodLength
            ? _value.averagePeriodLength
            : averagePeriodLength // ignore: cast_nullable_to_non_nullable
                  as double,
        variabilityScore: null == variabilityScore
            ? _value.variabilityScore
            : variabilityScore // ignore: cast_nullable_to_non_nullable
                  as double,
        cycles: null == cycles
            ? _value._cycles
            : cycles // ignore: cast_nullable_to_non_nullable
                  as List<Cycle>,
        symptoms: null == symptoms
            ? _value._symptoms
            : symptoms // ignore: cast_nullable_to_non_nullable
                  as List<SymptomEntry>,
        fertilitySummary: freezed == fertilitySummary
            ? _value.fertilitySummary
            : fertilitySummary // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportDataImpl implements _ReportData {
  const _$ReportDataImpl({
    required this.generatedAt,
    required this.dateRangeStart,
    required this.dateRangeEnd,
    required this.totalCycles,
    required this.averageCycleLength,
    required this.averagePeriodLength,
    required this.variabilityScore,
    required final List<Cycle> cycles,
    required final List<SymptomEntry> symptoms,
    this.fertilitySummary,
    this.notes,
  }) : _cycles = cycles,
       _symptoms = symptoms;

  factory _$ReportDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportDataImplFromJson(json);

  @override
  final DateTime generatedAt;
  @override
  final DateTime dateRangeStart;
  @override
  final DateTime dateRangeEnd;
  @override
  final int totalCycles;
  @override
  final double averageCycleLength;
  @override
  final double averagePeriodLength;
  @override
  final double variabilityScore;
  final List<Cycle> _cycles;
  @override
  List<Cycle> get cycles {
    if (_cycles is EqualUnmodifiableListView) return _cycles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cycles);
  }

  final List<SymptomEntry> _symptoms;
  @override
  List<SymptomEntry> get symptoms {
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptoms);
  }

  @override
  final String? fertilitySummary;
  @override
  final String? notes;

  @override
  String toString() {
    return 'ReportData(generatedAt: $generatedAt, dateRangeStart: $dateRangeStart, dateRangeEnd: $dateRangeEnd, totalCycles: $totalCycles, averageCycleLength: $averageCycleLength, averagePeriodLength: $averagePeriodLength, variabilityScore: $variabilityScore, cycles: $cycles, symptoms: $symptoms, fertilitySummary: $fertilitySummary, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportDataImpl &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt) &&
            (identical(other.dateRangeStart, dateRangeStart) ||
                other.dateRangeStart == dateRangeStart) &&
            (identical(other.dateRangeEnd, dateRangeEnd) ||
                other.dateRangeEnd == dateRangeEnd) &&
            (identical(other.totalCycles, totalCycles) ||
                other.totalCycles == totalCycles) &&
            (identical(other.averageCycleLength, averageCycleLength) ||
                other.averageCycleLength == averageCycleLength) &&
            (identical(other.averagePeriodLength, averagePeriodLength) ||
                other.averagePeriodLength == averagePeriodLength) &&
            (identical(other.variabilityScore, variabilityScore) ||
                other.variabilityScore == variabilityScore) &&
            const DeepCollectionEquality().equals(other._cycles, _cycles) &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms) &&
            (identical(other.fertilitySummary, fertilitySummary) ||
                other.fertilitySummary == fertilitySummary) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    generatedAt,
    dateRangeStart,
    dateRangeEnd,
    totalCycles,
    averageCycleLength,
    averagePeriodLength,
    variabilityScore,
    const DeepCollectionEquality().hash(_cycles),
    const DeepCollectionEquality().hash(_symptoms),
    fertilitySummary,
    notes,
  );

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportDataImplCopyWith<_$ReportDataImpl> get copyWith =>
      __$$ReportDataImplCopyWithImpl<_$ReportDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportDataImplToJson(this);
  }
}

abstract class _ReportData implements ReportData {
  const factory _ReportData({
    required final DateTime generatedAt,
    required final DateTime dateRangeStart,
    required final DateTime dateRangeEnd,
    required final int totalCycles,
    required final double averageCycleLength,
    required final double averagePeriodLength,
    required final double variabilityScore,
    required final List<Cycle> cycles,
    required final List<SymptomEntry> symptoms,
    final String? fertilitySummary,
    final String? notes,
  }) = _$ReportDataImpl;

  factory _ReportData.fromJson(Map<String, dynamic> json) =
      _$ReportDataImpl.fromJson;

  @override
  DateTime get generatedAt;
  @override
  DateTime get dateRangeStart;
  @override
  DateTime get dateRangeEnd;
  @override
  int get totalCycles;
  @override
  double get averageCycleLength;
  @override
  double get averagePeriodLength;
  @override
  double get variabilityScore;
  @override
  List<Cycle> get cycles;
  @override
  List<SymptomEntry> get symptoms;
  @override
  String? get fertilitySummary;
  @override
  String? get notes;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportDataImplCopyWith<_$ReportDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
