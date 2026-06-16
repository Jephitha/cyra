// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CommunityTopic _$CommunityTopicFromJson(Map<String, dynamic> json) {
  return _CommunityTopic.fromJson(json);
}

/// @nodoc
mixin _$CommunityTopic {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get postCount => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  String? get iconAsset => throw _privateConstructorUsedError;
  bool get isJoined => throw _privateConstructorUsedError;
  bool get isModerated => throw _privateConstructorUsedError;

  /// Serializes this CommunityTopic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommunityTopic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommunityTopicCopyWith<CommunityTopic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityTopicCopyWith<$Res> {
  factory $CommunityTopicCopyWith(
    CommunityTopic value,
    $Res Function(CommunityTopic) then,
  ) = _$CommunityTopicCopyWithImpl<$Res, CommunityTopic>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    int postCount,
    int memberCount,
    String? iconAsset,
    bool isJoined,
    bool isModerated,
  });
}

/// @nodoc
class _$CommunityTopicCopyWithImpl<$Res, $Val extends CommunityTopic>
    implements $CommunityTopicCopyWith<$Res> {
  _$CommunityTopicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityTopic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? postCount = null,
    Object? memberCount = null,
    Object? iconAsset = freezed,
    Object? isJoined = null,
    Object? isModerated = null,
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
            postCount: null == postCount
                ? _value.postCount
                : postCount // ignore: cast_nullable_to_non_nullable
                      as int,
            memberCount: null == memberCount
                ? _value.memberCount
                : memberCount // ignore: cast_nullable_to_non_nullable
                      as int,
            iconAsset: freezed == iconAsset
                ? _value.iconAsset
                : iconAsset // ignore: cast_nullable_to_non_nullable
                      as String?,
            isJoined: null == isJoined
                ? _value.isJoined
                : isJoined // ignore: cast_nullable_to_non_nullable
                      as bool,
            isModerated: null == isModerated
                ? _value.isModerated
                : isModerated // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommunityTopicImplCopyWith<$Res>
    implements $CommunityTopicCopyWith<$Res> {
  factory _$$CommunityTopicImplCopyWith(
    _$CommunityTopicImpl value,
    $Res Function(_$CommunityTopicImpl) then,
  ) = __$$CommunityTopicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    int postCount,
    int memberCount,
    String? iconAsset,
    bool isJoined,
    bool isModerated,
  });
}

/// @nodoc
class __$$CommunityTopicImplCopyWithImpl<$Res>
    extends _$CommunityTopicCopyWithImpl<$Res, _$CommunityTopicImpl>
    implements _$$CommunityTopicImplCopyWith<$Res> {
  __$$CommunityTopicImplCopyWithImpl(
    _$CommunityTopicImpl _value,
    $Res Function(_$CommunityTopicImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityTopic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? postCount = null,
    Object? memberCount = null,
    Object? iconAsset = freezed,
    Object? isJoined = null,
    Object? isModerated = null,
  }) {
    return _then(
      _$CommunityTopicImpl(
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
        postCount: null == postCount
            ? _value.postCount
            : postCount // ignore: cast_nullable_to_non_nullable
                  as int,
        memberCount: null == memberCount
            ? _value.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int,
        iconAsset: freezed == iconAsset
            ? _value.iconAsset
            : iconAsset // ignore: cast_nullable_to_non_nullable
                  as String?,
        isJoined: null == isJoined
            ? _value.isJoined
            : isJoined // ignore: cast_nullable_to_non_nullable
                  as bool,
        isModerated: null == isModerated
            ? _value.isModerated
            : isModerated // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityTopicImpl implements _CommunityTopic {
  const _$CommunityTopicImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.postCount,
    this.memberCount = 0,
    this.iconAsset,
    this.isJoined = false,
    this.isModerated = false,
  });

  factory _$CommunityTopicImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityTopicImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final int postCount;
  @override
  @JsonKey()
  final int memberCount;
  @override
  final String? iconAsset;
  @override
  @JsonKey()
  final bool isJoined;
  @override
  @JsonKey()
  final bool isModerated;

  @override
  String toString() {
    return 'CommunityTopic(id: $id, name: $name, description: $description, postCount: $postCount, memberCount: $memberCount, iconAsset: $iconAsset, isJoined: $isJoined, isModerated: $isModerated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityTopicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.postCount, postCount) ||
                other.postCount == postCount) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.iconAsset, iconAsset) ||
                other.iconAsset == iconAsset) &&
            (identical(other.isJoined, isJoined) ||
                other.isJoined == isJoined) &&
            (identical(other.isModerated, isModerated) ||
                other.isModerated == isModerated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    postCount,
    memberCount,
    iconAsset,
    isJoined,
    isModerated,
  );

  /// Create a copy of CommunityTopic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityTopicImplCopyWith<_$CommunityTopicImpl> get copyWith =>
      __$$CommunityTopicImplCopyWithImpl<_$CommunityTopicImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityTopicImplToJson(this);
  }
}

abstract class _CommunityTopic implements CommunityTopic {
  const factory _CommunityTopic({
    required final String id,
    required final String name,
    required final String description,
    required final int postCount,
    final int memberCount,
    final String? iconAsset,
    final bool isJoined,
    final bool isModerated,
  }) = _$CommunityTopicImpl;

  factory _CommunityTopic.fromJson(Map<String, dynamic> json) =
      _$CommunityTopicImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  int get postCount;
  @override
  int get memberCount;
  @override
  String? get iconAsset;
  @override
  bool get isJoined;
  @override
  bool get isModerated;

  /// Create a copy of CommunityTopic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityTopicImplCopyWith<_$CommunityTopicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommunityPost _$CommunityPostFromJson(Map<String, dynamic> json) {
  return _CommunityPost.fromJson(json);
}

/// @nodoc
mixin _$CommunityPost {
  String get id => throw _privateConstructorUsedError;
  String get topicId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get anonymousUserId => throw _privateConstructorUsedError;
  bool get isAnonymous => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get replyCount => throw _privateConstructorUsedError;
  bool get isModerated => throw _privateConstructorUsedError;
  String? get moderationAction => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  List<CommunityReply> get replies => throw _privateConstructorUsedError;

  /// Serializes this CommunityPost to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommunityPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommunityPostCopyWith<CommunityPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityPostCopyWith<$Res> {
  factory $CommunityPostCopyWith(
    CommunityPost value,
    $Res Function(CommunityPost) then,
  ) = _$CommunityPostCopyWithImpl<$Res, CommunityPost>;
  @useResult
  $Res call({
    String id,
    String topicId,
    String content,
    String anonymousUserId,
    bool isAnonymous,
    int likeCount,
    int replyCount,
    bool isModerated,
    String? moderationAction,
    DateTime? createdAt,
    List<CommunityReply> replies,
  });
}

/// @nodoc
class _$CommunityPostCopyWithImpl<$Res, $Val extends CommunityPost>
    implements $CommunityPostCopyWith<$Res> {
  _$CommunityPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topicId = null,
    Object? content = null,
    Object? anonymousUserId = null,
    Object? isAnonymous = null,
    Object? likeCount = null,
    Object? replyCount = null,
    Object? isModerated = null,
    Object? moderationAction = freezed,
    Object? createdAt = freezed,
    Object? replies = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            topicId: null == topicId
                ? _value.topicId
                : topicId // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            anonymousUserId: null == anonymousUserId
                ? _value.anonymousUserId
                : anonymousUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            isAnonymous: null == isAnonymous
                ? _value.isAnonymous
                : isAnonymous // ignore: cast_nullable_to_non_nullable
                      as bool,
            likeCount: null == likeCount
                ? _value.likeCount
                : likeCount // ignore: cast_nullable_to_non_nullable
                      as int,
            replyCount: null == replyCount
                ? _value.replyCount
                : replyCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isModerated: null == isModerated
                ? _value.isModerated
                : isModerated // ignore: cast_nullable_to_non_nullable
                      as bool,
            moderationAction: freezed == moderationAction
                ? _value.moderationAction
                : moderationAction // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            replies: null == replies
                ? _value.replies
                : replies // ignore: cast_nullable_to_non_nullable
                      as List<CommunityReply>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommunityPostImplCopyWith<$Res>
    implements $CommunityPostCopyWith<$Res> {
  factory _$$CommunityPostImplCopyWith(
    _$CommunityPostImpl value,
    $Res Function(_$CommunityPostImpl) then,
  ) = __$$CommunityPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String topicId,
    String content,
    String anonymousUserId,
    bool isAnonymous,
    int likeCount,
    int replyCount,
    bool isModerated,
    String? moderationAction,
    DateTime? createdAt,
    List<CommunityReply> replies,
  });
}

/// @nodoc
class __$$CommunityPostImplCopyWithImpl<$Res>
    extends _$CommunityPostCopyWithImpl<$Res, _$CommunityPostImpl>
    implements _$$CommunityPostImplCopyWith<$Res> {
  __$$CommunityPostImplCopyWithImpl(
    _$CommunityPostImpl _value,
    $Res Function(_$CommunityPostImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topicId = null,
    Object? content = null,
    Object? anonymousUserId = null,
    Object? isAnonymous = null,
    Object? likeCount = null,
    Object? replyCount = null,
    Object? isModerated = null,
    Object? moderationAction = freezed,
    Object? createdAt = freezed,
    Object? replies = null,
  }) {
    return _then(
      _$CommunityPostImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        topicId: null == topicId
            ? _value.topicId
            : topicId // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        anonymousUserId: null == anonymousUserId
            ? _value.anonymousUserId
            : anonymousUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        isAnonymous: null == isAnonymous
            ? _value.isAnonymous
            : isAnonymous // ignore: cast_nullable_to_non_nullable
                  as bool,
        likeCount: null == likeCount
            ? _value.likeCount
            : likeCount // ignore: cast_nullable_to_non_nullable
                  as int,
        replyCount: null == replyCount
            ? _value.replyCount
            : replyCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isModerated: null == isModerated
            ? _value.isModerated
            : isModerated // ignore: cast_nullable_to_non_nullable
                  as bool,
        moderationAction: freezed == moderationAction
            ? _value.moderationAction
            : moderationAction // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        replies: null == replies
            ? _value._replies
            : replies // ignore: cast_nullable_to_non_nullable
                  as List<CommunityReply>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommunityPostImpl implements _CommunityPost {
  const _$CommunityPostImpl({
    required this.id,
    required this.topicId,
    required this.content,
    required this.anonymousUserId,
    this.isAnonymous = true,
    this.likeCount = 0,
    this.replyCount = 0,
    this.isModerated = false,
    this.moderationAction,
    this.createdAt,
    final List<CommunityReply> replies = const [],
  }) : _replies = replies;

  factory _$CommunityPostImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityPostImplFromJson(json);

  @override
  final String id;
  @override
  final String topicId;
  @override
  final String content;
  @override
  final String anonymousUserId;
  @override
  @JsonKey()
  final bool isAnonymous;
  @override
  @JsonKey()
  final int likeCount;
  @override
  @JsonKey()
  final int replyCount;
  @override
  @JsonKey()
  final bool isModerated;
  @override
  final String? moderationAction;
  @override
  final DateTime? createdAt;
  final List<CommunityReply> _replies;
  @override
  @JsonKey()
  List<CommunityReply> get replies {
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replies);
  }

  @override
  String toString() {
    return 'CommunityPost(id: $id, topicId: $topicId, content: $content, anonymousUserId: $anonymousUserId, isAnonymous: $isAnonymous, likeCount: $likeCount, replyCount: $replyCount, isModerated: $isModerated, moderationAction: $moderationAction, createdAt: $createdAt, replies: $replies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityPostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.anonymousUserId, anonymousUserId) ||
                other.anonymousUserId == anonymousUserId) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount) &&
            (identical(other.isModerated, isModerated) ||
                other.isModerated == isModerated) &&
            (identical(other.moderationAction, moderationAction) ||
                other.moderationAction == moderationAction) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._replies, _replies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    topicId,
    content,
    anonymousUserId,
    isAnonymous,
    likeCount,
    replyCount,
    isModerated,
    moderationAction,
    createdAt,
    const DeepCollectionEquality().hash(_replies),
  );

  /// Create a copy of CommunityPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityPostImplCopyWith<_$CommunityPostImpl> get copyWith =>
      __$$CommunityPostImplCopyWithImpl<_$CommunityPostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityPostImplToJson(this);
  }
}

abstract class _CommunityPost implements CommunityPost {
  const factory _CommunityPost({
    required final String id,
    required final String topicId,
    required final String content,
    required final String anonymousUserId,
    final bool isAnonymous,
    final int likeCount,
    final int replyCount,
    final bool isModerated,
    final String? moderationAction,
    final DateTime? createdAt,
    final List<CommunityReply> replies,
  }) = _$CommunityPostImpl;

  factory _CommunityPost.fromJson(Map<String, dynamic> json) =
      _$CommunityPostImpl.fromJson;

  @override
  String get id;
  @override
  String get topicId;
  @override
  String get content;
  @override
  String get anonymousUserId;
  @override
  bool get isAnonymous;
  @override
  int get likeCount;
  @override
  int get replyCount;
  @override
  bool get isModerated;
  @override
  String? get moderationAction;
  @override
  DateTime? get createdAt;
  @override
  List<CommunityReply> get replies;

  /// Create a copy of CommunityPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityPostImplCopyWith<_$CommunityPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommunityReply _$CommunityReplyFromJson(Map<String, dynamic> json) {
  return _CommunityReply.fromJson(json);
}

/// @nodoc
mixin _$CommunityReply {
  String get id => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get anonymousUserId => throw _privateConstructorUsedError;
  bool get isAnonymous => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  bool get isModerated => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CommunityReply to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommunityReply
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommunityReplyCopyWith<CommunityReply> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityReplyCopyWith<$Res> {
  factory $CommunityReplyCopyWith(
    CommunityReply value,
    $Res Function(CommunityReply) then,
  ) = _$CommunityReplyCopyWithImpl<$Res, CommunityReply>;
  @useResult
  $Res call({
    String id,
    String postId,
    String content,
    String anonymousUserId,
    bool isAnonymous,
    int likeCount,
    bool isModerated,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$CommunityReplyCopyWithImpl<$Res, $Val extends CommunityReply>
    implements $CommunityReplyCopyWith<$Res> {
  _$CommunityReplyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityReply
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? content = null,
    Object? anonymousUserId = null,
    Object? isAnonymous = null,
    Object? likeCount = null,
    Object? isModerated = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            postId: null == postId
                ? _value.postId
                : postId // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            anonymousUserId: null == anonymousUserId
                ? _value.anonymousUserId
                : anonymousUserId // ignore: cast_nullable_to_non_nullable
                      as String,
            isAnonymous: null == isAnonymous
                ? _value.isAnonymous
                : isAnonymous // ignore: cast_nullable_to_non_nullable
                      as bool,
            likeCount: null == likeCount
                ? _value.likeCount
                : likeCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isModerated: null == isModerated
                ? _value.isModerated
                : isModerated // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CommunityReplyImplCopyWith<$Res>
    implements $CommunityReplyCopyWith<$Res> {
  factory _$$CommunityReplyImplCopyWith(
    _$CommunityReplyImpl value,
    $Res Function(_$CommunityReplyImpl) then,
  ) = __$$CommunityReplyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String postId,
    String content,
    String anonymousUserId,
    bool isAnonymous,
    int likeCount,
    bool isModerated,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$CommunityReplyImplCopyWithImpl<$Res>
    extends _$CommunityReplyCopyWithImpl<$Res, _$CommunityReplyImpl>
    implements _$$CommunityReplyImplCopyWith<$Res> {
  __$$CommunityReplyImplCopyWithImpl(
    _$CommunityReplyImpl _value,
    $Res Function(_$CommunityReplyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommunityReply
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? content = null,
    Object? anonymousUserId = null,
    Object? isAnonymous = null,
    Object? likeCount = null,
    Object? isModerated = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$CommunityReplyImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        postId: null == postId
            ? _value.postId
            : postId // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        anonymousUserId: null == anonymousUserId
            ? _value.anonymousUserId
            : anonymousUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        isAnonymous: null == isAnonymous
            ? _value.isAnonymous
            : isAnonymous // ignore: cast_nullable_to_non_nullable
                  as bool,
        likeCount: null == likeCount
            ? _value.likeCount
            : likeCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isModerated: null == isModerated
            ? _value.isModerated
            : isModerated // ignore: cast_nullable_to_non_nullable
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
class _$CommunityReplyImpl implements _CommunityReply {
  const _$CommunityReplyImpl({
    required this.id,
    required this.postId,
    required this.content,
    required this.anonymousUserId,
    this.isAnonymous = true,
    this.likeCount = 0,
    this.isModerated = false,
    this.createdAt,
  });

  factory _$CommunityReplyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommunityReplyImplFromJson(json);

  @override
  final String id;
  @override
  final String postId;
  @override
  final String content;
  @override
  final String anonymousUserId;
  @override
  @JsonKey()
  final bool isAnonymous;
  @override
  @JsonKey()
  final int likeCount;
  @override
  @JsonKey()
  final bool isModerated;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CommunityReply(id: $id, postId: $postId, content: $content, anonymousUserId: $anonymousUserId, isAnonymous: $isAnonymous, likeCount: $likeCount, isModerated: $isModerated, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityReplyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.anonymousUserId, anonymousUserId) ||
                other.anonymousUserId == anonymousUserId) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.isModerated, isModerated) ||
                other.isModerated == isModerated) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    postId,
    content,
    anonymousUserId,
    isAnonymous,
    likeCount,
    isModerated,
    createdAt,
  );

  /// Create a copy of CommunityReply
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityReplyImplCopyWith<_$CommunityReplyImpl> get copyWith =>
      __$$CommunityReplyImplCopyWithImpl<_$CommunityReplyImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CommunityReplyImplToJson(this);
  }
}

abstract class _CommunityReply implements CommunityReply {
  const factory _CommunityReply({
    required final String id,
    required final String postId,
    required final String content,
    required final String anonymousUserId,
    final bool isAnonymous,
    final int likeCount,
    final bool isModerated,
    final DateTime? createdAt,
  }) = _$CommunityReplyImpl;

  factory _CommunityReply.fromJson(Map<String, dynamic> json) =
      _$CommunityReplyImpl.fromJson;

  @override
  String get id;
  @override
  String get postId;
  @override
  String get content;
  @override
  String get anonymousUserId;
  @override
  bool get isAnonymous;
  @override
  int get likeCount;
  @override
  bool get isModerated;
  @override
  DateTime? get createdAt;

  /// Create a copy of CommunityReply
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityReplyImplCopyWith<_$CommunityReplyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
