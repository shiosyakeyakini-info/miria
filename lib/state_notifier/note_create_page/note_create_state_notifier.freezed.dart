// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_create_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NoteCreate {
  NoteVisibility get noteVisibility => throw _privateConstructorUsedError;
  bool get localOnly => throw _privateConstructorUsedError;
  ReactionAcceptance? get reactionAcceptance =>
      throw _privateConstructorUsedError;
  List<User> get replyTo => throw _privateConstructorUsedError;
  List<MisskeyPostFile> get files => throw _privateConstructorUsedError;
  NoteCreateChannel? get channel => throw _privateConstructorUsedError;
  Note? get reply => throw _privateConstructorUsedError;
  Note? get renote => throw _privateConstructorUsedError;
  bool get isCw => throw _privateConstructorUsedError;
  String get cwText => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  bool get isTextFocused => throw _privateConstructorUsedError;
  NoteSendStatus? get isNoteSending => throw _privateConstructorUsedError;
  bool get isVote => throw _privateConstructorUsedError;
  List<String> get voteContent => throw _privateConstructorUsedError;
  int get voteContentCount => throw _privateConstructorUsedError;
  VoteExpireType get voteExpireType => throw _privateConstructorUsedError;
  bool get isVoteMultiple => throw _privateConstructorUsedError;
  DateTime? get voteDate => throw _privateConstructorUsedError;
  int? get voteDuration => throw _privateConstructorUsedError;
  VoteExpireDurationType get voteDurationType =>
      throw _privateConstructorUsedError;
  NoteCreationMode? get noteCreationMode => throw _privateConstructorUsedError;
  String? get noteId => throw _privateConstructorUsedError;

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteCreateCopyWith<NoteCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteCreateCopyWith<$Res> {
  factory $NoteCreateCopyWith(
          NoteCreate value, $Res Function(NoteCreate) then) =
      _$NoteCreateCopyWithImpl<$Res, NoteCreate>;
  @useResult
  $Res call(
      {NoteVisibility noteVisibility,
      bool localOnly,
      ReactionAcceptance? reactionAcceptance,
      List<User> replyTo,
      List<MisskeyPostFile> files,
      NoteCreateChannel? channel,
      Note? reply,
      Note? renote,
      bool isCw,
      String cwText,
      String text,
      bool isTextFocused,
      NoteSendStatus? isNoteSending,
      bool isVote,
      List<String> voteContent,
      int voteContentCount,
      VoteExpireType voteExpireType,
      bool isVoteMultiple,
      DateTime? voteDate,
      int? voteDuration,
      VoteExpireDurationType voteDurationType,
      NoteCreationMode? noteCreationMode,
      String? noteId});

  $NoteCreateChannelCopyWith<$Res>? get channel;
  $NoteCopyWith<$Res>? get reply;
  $NoteCopyWith<$Res>? get renote;
}

/// @nodoc
class _$NoteCreateCopyWithImpl<$Res, $Val extends NoteCreate>
    implements $NoteCreateCopyWith<$Res> {
  _$NoteCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noteVisibility = null,
    Object? localOnly = null,
    Object? reactionAcceptance = freezed,
    Object? replyTo = null,
    Object? files = null,
    Object? channel = freezed,
    Object? reply = freezed,
    Object? renote = freezed,
    Object? isCw = null,
    Object? cwText = null,
    Object? text = null,
    Object? isTextFocused = null,
    Object? isNoteSending = freezed,
    Object? isVote = null,
    Object? voteContent = null,
    Object? voteContentCount = null,
    Object? voteExpireType = null,
    Object? isVoteMultiple = null,
    Object? voteDate = freezed,
    Object? voteDuration = freezed,
    Object? voteDurationType = null,
    Object? noteCreationMode = freezed,
    Object? noteId = freezed,
  }) {
    return _then(_value.copyWith(
      noteVisibility: null == noteVisibility
          ? _value.noteVisibility
          : noteVisibility // ignore: cast_nullable_to_non_nullable
              as NoteVisibility,
      localOnly: null == localOnly
          ? _value.localOnly
          : localOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      reactionAcceptance: freezed == reactionAcceptance
          ? _value.reactionAcceptance
          : reactionAcceptance // ignore: cast_nullable_to_non_nullable
              as ReactionAcceptance?,
      replyTo: null == replyTo
          ? _value.replyTo
          : replyTo // ignore: cast_nullable_to_non_nullable
              as List<User>,
      files: null == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<MisskeyPostFile>,
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as NoteCreateChannel?,
      reply: freezed == reply
          ? _value.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as Note?,
      renote: freezed == renote
          ? _value.renote
          : renote // ignore: cast_nullable_to_non_nullable
              as Note?,
      isCw: null == isCw
          ? _value.isCw
          : isCw // ignore: cast_nullable_to_non_nullable
              as bool,
      cwText: null == cwText
          ? _value.cwText
          : cwText // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isTextFocused: null == isTextFocused
          ? _value.isTextFocused
          : isTextFocused // ignore: cast_nullable_to_non_nullable
              as bool,
      isNoteSending: freezed == isNoteSending
          ? _value.isNoteSending
          : isNoteSending // ignore: cast_nullable_to_non_nullable
              as NoteSendStatus?,
      isVote: null == isVote
          ? _value.isVote
          : isVote // ignore: cast_nullable_to_non_nullable
              as bool,
      voteContent: null == voteContent
          ? _value.voteContent
          : voteContent // ignore: cast_nullable_to_non_nullable
              as List<String>,
      voteContentCount: null == voteContentCount
          ? _value.voteContentCount
          : voteContentCount // ignore: cast_nullable_to_non_nullable
              as int,
      voteExpireType: null == voteExpireType
          ? _value.voteExpireType
          : voteExpireType // ignore: cast_nullable_to_non_nullable
              as VoteExpireType,
      isVoteMultiple: null == isVoteMultiple
          ? _value.isVoteMultiple
          : isVoteMultiple // ignore: cast_nullable_to_non_nullable
              as bool,
      voteDate: freezed == voteDate
          ? _value.voteDate
          : voteDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      voteDuration: freezed == voteDuration
          ? _value.voteDuration
          : voteDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      voteDurationType: null == voteDurationType
          ? _value.voteDurationType
          : voteDurationType // ignore: cast_nullable_to_non_nullable
              as VoteExpireDurationType,
      noteCreationMode: freezed == noteCreationMode
          ? _value.noteCreationMode
          : noteCreationMode // ignore: cast_nullable_to_non_nullable
              as NoteCreationMode?,
      noteId: freezed == noteId
          ? _value.noteId
          : noteId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NoteCreateChannelCopyWith<$Res>? get channel {
    if (_value.channel == null) {
      return null;
    }

    return $NoteCreateChannelCopyWith<$Res>(_value.channel!, (value) {
      return _then(_value.copyWith(channel: value) as $Val);
    });
  }

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NoteCopyWith<$Res>? get reply {
    if (_value.reply == null) {
      return null;
    }

    return $NoteCopyWith<$Res>(_value.reply!, (value) {
      return _then(_value.copyWith(reply: value) as $Val);
    });
  }

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NoteCopyWith<$Res>? get renote {
    if (_value.renote == null) {
      return null;
    }

    return $NoteCopyWith<$Res>(_value.renote!, (value) {
      return _then(_value.copyWith(renote: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NoteCreateImplCopyWith<$Res>
    implements $NoteCreateCopyWith<$Res> {
  factory _$$NoteCreateImplCopyWith(
          _$NoteCreateImpl value, $Res Function(_$NoteCreateImpl) then) =
      __$$NoteCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NoteVisibility noteVisibility,
      bool localOnly,
      ReactionAcceptance? reactionAcceptance,
      List<User> replyTo,
      List<MisskeyPostFile> files,
      NoteCreateChannel? channel,
      Note? reply,
      Note? renote,
      bool isCw,
      String cwText,
      String text,
      bool isTextFocused,
      NoteSendStatus? isNoteSending,
      bool isVote,
      List<String> voteContent,
      int voteContentCount,
      VoteExpireType voteExpireType,
      bool isVoteMultiple,
      DateTime? voteDate,
      int? voteDuration,
      VoteExpireDurationType voteDurationType,
      NoteCreationMode? noteCreationMode,
      String? noteId});

  @override
  $NoteCreateChannelCopyWith<$Res>? get channel;
  @override
  $NoteCopyWith<$Res>? get reply;
  @override
  $NoteCopyWith<$Res>? get renote;
}

/// @nodoc
class __$$NoteCreateImplCopyWithImpl<$Res>
    extends _$NoteCreateCopyWithImpl<$Res, _$NoteCreateImpl>
    implements _$$NoteCreateImplCopyWith<$Res> {
  __$$NoteCreateImplCopyWithImpl(
      _$NoteCreateImpl _value, $Res Function(_$NoteCreateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noteVisibility = null,
    Object? localOnly = null,
    Object? reactionAcceptance = freezed,
    Object? replyTo = null,
    Object? files = null,
    Object? channel = freezed,
    Object? reply = freezed,
    Object? renote = freezed,
    Object? isCw = null,
    Object? cwText = null,
    Object? text = null,
    Object? isTextFocused = null,
    Object? isNoteSending = freezed,
    Object? isVote = null,
    Object? voteContent = null,
    Object? voteContentCount = null,
    Object? voteExpireType = null,
    Object? isVoteMultiple = null,
    Object? voteDate = freezed,
    Object? voteDuration = freezed,
    Object? voteDurationType = null,
    Object? noteCreationMode = freezed,
    Object? noteId = freezed,
  }) {
    return _then(_$NoteCreateImpl(
      noteVisibility: null == noteVisibility
          ? _value.noteVisibility
          : noteVisibility // ignore: cast_nullable_to_non_nullable
              as NoteVisibility,
      localOnly: null == localOnly
          ? _value.localOnly
          : localOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      reactionAcceptance: freezed == reactionAcceptance
          ? _value.reactionAcceptance
          : reactionAcceptance // ignore: cast_nullable_to_non_nullable
              as ReactionAcceptance?,
      replyTo: null == replyTo
          ? _value._replyTo
          : replyTo // ignore: cast_nullable_to_non_nullable
              as List<User>,
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<MisskeyPostFile>,
      channel: freezed == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as NoteCreateChannel?,
      reply: freezed == reply
          ? _value.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as Note?,
      renote: freezed == renote
          ? _value.renote
          : renote // ignore: cast_nullable_to_non_nullable
              as Note?,
      isCw: null == isCw
          ? _value.isCw
          : isCw // ignore: cast_nullable_to_non_nullable
              as bool,
      cwText: null == cwText
          ? _value.cwText
          : cwText // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isTextFocused: null == isTextFocused
          ? _value.isTextFocused
          : isTextFocused // ignore: cast_nullable_to_non_nullable
              as bool,
      isNoteSending: freezed == isNoteSending
          ? _value.isNoteSending
          : isNoteSending // ignore: cast_nullable_to_non_nullable
              as NoteSendStatus?,
      isVote: null == isVote
          ? _value.isVote
          : isVote // ignore: cast_nullable_to_non_nullable
              as bool,
      voteContent: null == voteContent
          ? _value._voteContent
          : voteContent // ignore: cast_nullable_to_non_nullable
              as List<String>,
      voteContentCount: null == voteContentCount
          ? _value.voteContentCount
          : voteContentCount // ignore: cast_nullable_to_non_nullable
              as int,
      voteExpireType: null == voteExpireType
          ? _value.voteExpireType
          : voteExpireType // ignore: cast_nullable_to_non_nullable
              as VoteExpireType,
      isVoteMultiple: null == isVoteMultiple
          ? _value.isVoteMultiple
          : isVoteMultiple // ignore: cast_nullable_to_non_nullable
              as bool,
      voteDate: freezed == voteDate
          ? _value.voteDate
          : voteDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      voteDuration: freezed == voteDuration
          ? _value.voteDuration
          : voteDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      voteDurationType: null == voteDurationType
          ? _value.voteDurationType
          : voteDurationType // ignore: cast_nullable_to_non_nullable
              as VoteExpireDurationType,
      noteCreationMode: freezed == noteCreationMode
          ? _value.noteCreationMode
          : noteCreationMode // ignore: cast_nullable_to_non_nullable
              as NoteCreationMode?,
      noteId: freezed == noteId
          ? _value.noteId
          : noteId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NoteCreateImpl implements _NoteCreate {
  const _$NoteCreateImpl(
      {required this.noteVisibility,
      required this.localOnly,
      required this.reactionAcceptance,
      final List<User> replyTo = const [],
      final List<MisskeyPostFile> files = const [],
      this.channel,
      this.reply,
      this.renote,
      this.isCw = false,
      this.cwText = "",
      this.text = "",
      this.isTextFocused = false,
      this.isNoteSending,
      this.isVote = false,
      final List<String> voteContent = const ["", ""],
      this.voteContentCount = 2,
      this.voteExpireType = VoteExpireType.unlimited,
      this.isVoteMultiple = false,
      this.voteDate,
      this.voteDuration,
      this.voteDurationType = VoteExpireDurationType.seconds,
      this.noteCreationMode,
      this.noteId})
      : _replyTo = replyTo,
        _files = files,
        _voteContent = voteContent;

  @override
  final NoteVisibility noteVisibility;
  @override
  final bool localOnly;
  @override
  final ReactionAcceptance? reactionAcceptance;
  final List<User> _replyTo;
  @override
  @JsonKey()
  List<User> get replyTo {
    if (_replyTo is EqualUnmodifiableListView) return _replyTo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replyTo);
  }

  final List<MisskeyPostFile> _files;
  @override
  @JsonKey()
  List<MisskeyPostFile> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  final NoteCreateChannel? channel;
  @override
  final Note? reply;
  @override
  final Note? renote;
  @override
  @JsonKey()
  final bool isCw;
  @override
  @JsonKey()
  final String cwText;
  @override
  @JsonKey()
  final String text;
  @override
  @JsonKey()
  final bool isTextFocused;
  @override
  final NoteSendStatus? isNoteSending;
  @override
  @JsonKey()
  final bool isVote;
  final List<String> _voteContent;
  @override
  @JsonKey()
  List<String> get voteContent {
    if (_voteContent is EqualUnmodifiableListView) return _voteContent;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_voteContent);
  }

  @override
  @JsonKey()
  final int voteContentCount;
  @override
  @JsonKey()
  final VoteExpireType voteExpireType;
  @override
  @JsonKey()
  final bool isVoteMultiple;
  @override
  final DateTime? voteDate;
  @override
  final int? voteDuration;
  @override
  @JsonKey()
  final VoteExpireDurationType voteDurationType;
  @override
  final NoteCreationMode? noteCreationMode;
  @override
  final String? noteId;

  @override
  String toString() {
    return 'NoteCreate(noteVisibility: $noteVisibility, localOnly: $localOnly, reactionAcceptance: $reactionAcceptance, replyTo: $replyTo, files: $files, channel: $channel, reply: $reply, renote: $renote, isCw: $isCw, cwText: $cwText, text: $text, isTextFocused: $isTextFocused, isNoteSending: $isNoteSending, isVote: $isVote, voteContent: $voteContent, voteContentCount: $voteContentCount, voteExpireType: $voteExpireType, isVoteMultiple: $isVoteMultiple, voteDate: $voteDate, voteDuration: $voteDuration, voteDurationType: $voteDurationType, noteCreationMode: $noteCreationMode, noteId: $noteId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteCreateImpl &&
            (identical(other.noteVisibility, noteVisibility) ||
                other.noteVisibility == noteVisibility) &&
            (identical(other.localOnly, localOnly) ||
                other.localOnly == localOnly) &&
            (identical(other.reactionAcceptance, reactionAcceptance) ||
                other.reactionAcceptance == reactionAcceptance) &&
            const DeepCollectionEquality().equals(other._replyTo, _replyTo) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.reply, reply) || other.reply == reply) &&
            (identical(other.renote, renote) || other.renote == renote) &&
            (identical(other.isCw, isCw) || other.isCw == isCw) &&
            (identical(other.cwText, cwText) || other.cwText == cwText) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isTextFocused, isTextFocused) ||
                other.isTextFocused == isTextFocused) &&
            (identical(other.isNoteSending, isNoteSending) ||
                other.isNoteSending == isNoteSending) &&
            (identical(other.isVote, isVote) || other.isVote == isVote) &&
            const DeepCollectionEquality()
                .equals(other._voteContent, _voteContent) &&
            (identical(other.voteContentCount, voteContentCount) ||
                other.voteContentCount == voteContentCount) &&
            (identical(other.voteExpireType, voteExpireType) ||
                other.voteExpireType == voteExpireType) &&
            (identical(other.isVoteMultiple, isVoteMultiple) ||
                other.isVoteMultiple == isVoteMultiple) &&
            (identical(other.voteDate, voteDate) ||
                other.voteDate == voteDate) &&
            (identical(other.voteDuration, voteDuration) ||
                other.voteDuration == voteDuration) &&
            (identical(other.voteDurationType, voteDurationType) ||
                other.voteDurationType == voteDurationType) &&
            (identical(other.noteCreationMode, noteCreationMode) ||
                other.noteCreationMode == noteCreationMode) &&
            (identical(other.noteId, noteId) || other.noteId == noteId));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        noteVisibility,
        localOnly,
        reactionAcceptance,
        const DeepCollectionEquality().hash(_replyTo),
        const DeepCollectionEquality().hash(_files),
        channel,
        reply,
        renote,
        isCw,
        cwText,
        text,
        isTextFocused,
        isNoteSending,
        isVote,
        const DeepCollectionEquality().hash(_voteContent),
        voteContentCount,
        voteExpireType,
        isVoteMultiple,
        voteDate,
        voteDuration,
        voteDurationType,
        noteCreationMode,
        noteId
      ]);

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteCreateImplCopyWith<_$NoteCreateImpl> get copyWith =>
      __$$NoteCreateImplCopyWithImpl<_$NoteCreateImpl>(this, _$identity);
}

abstract class _NoteCreate implements NoteCreate {
  const factory _NoteCreate(
      {required final NoteVisibility noteVisibility,
      required final bool localOnly,
      required final ReactionAcceptance? reactionAcceptance,
      final List<User> replyTo,
      final List<MisskeyPostFile> files,
      final NoteCreateChannel? channel,
      final Note? reply,
      final Note? renote,
      final bool isCw,
      final String cwText,
      final String text,
      final bool isTextFocused,
      final NoteSendStatus? isNoteSending,
      final bool isVote,
      final List<String> voteContent,
      final int voteContentCount,
      final VoteExpireType voteExpireType,
      final bool isVoteMultiple,
      final DateTime? voteDate,
      final int? voteDuration,
      final VoteExpireDurationType voteDurationType,
      final NoteCreationMode? noteCreationMode,
      final String? noteId}) = _$NoteCreateImpl;

  @override
  NoteVisibility get noteVisibility;
  @override
  bool get localOnly;
  @override
  ReactionAcceptance? get reactionAcceptance;
  @override
  List<User> get replyTo;
  @override
  List<MisskeyPostFile> get files;
  @override
  NoteCreateChannel? get channel;
  @override
  Note? get reply;
  @override
  Note? get renote;
  @override
  bool get isCw;
  @override
  String get cwText;
  @override
  String get text;
  @override
  bool get isTextFocused;
  @override
  NoteSendStatus? get isNoteSending;
  @override
  bool get isVote;
  @override
  List<String> get voteContent;
  @override
  int get voteContentCount;
  @override
  VoteExpireType get voteExpireType;
  @override
  bool get isVoteMultiple;
  @override
  DateTime? get voteDate;
  @override
  int? get voteDuration;
  @override
  VoteExpireDurationType get voteDurationType;
  @override
  NoteCreationMode? get noteCreationMode;
  @override
  String? get noteId;

  /// Create a copy of NoteCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteCreateImplCopyWith<_$NoteCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NoteCreateChannel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Create a copy of NoteCreateChannel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteCreateChannelCopyWith<NoteCreateChannel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteCreateChannelCopyWith<$Res> {
  factory $NoteCreateChannelCopyWith(
          NoteCreateChannel value, $Res Function(NoteCreateChannel) then) =
      _$NoteCreateChannelCopyWithImpl<$Res, NoteCreateChannel>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$NoteCreateChannelCopyWithImpl<$Res, $Val extends NoteCreateChannel>
    implements $NoteCreateChannelCopyWith<$Res> {
  _$NoteCreateChannelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoteCreateChannel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteCreateChannelImplCopyWith<$Res>
    implements $NoteCreateChannelCopyWith<$Res> {
  factory _$$NoteCreateChannelImplCopyWith(_$NoteCreateChannelImpl value,
          $Res Function(_$NoteCreateChannelImpl) then) =
      __$$NoteCreateChannelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$NoteCreateChannelImplCopyWithImpl<$Res>
    extends _$NoteCreateChannelCopyWithImpl<$Res, _$NoteCreateChannelImpl>
    implements _$$NoteCreateChannelImplCopyWith<$Res> {
  __$$NoteCreateChannelImplCopyWithImpl(_$NoteCreateChannelImpl _value,
      $Res Function(_$NoteCreateChannelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NoteCreateChannel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$NoteCreateChannelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NoteCreateChannelImpl implements _NoteCreateChannel {
  const _$NoteCreateChannelImpl({required this.id, required this.name});

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'NoteCreateChannel(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteCreateChannelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of NoteCreateChannel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteCreateChannelImplCopyWith<_$NoteCreateChannelImpl> get copyWith =>
      __$$NoteCreateChannelImplCopyWithImpl<_$NoteCreateChannelImpl>(
          this, _$identity);
}

abstract class _NoteCreateChannel implements NoteCreateChannel {
  const factory _NoteCreateChannel(
      {required final String id,
      required final String name}) = _$NoteCreateChannelImpl;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of NoteCreateChannel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteCreateChannelImplCopyWith<_$NoteCreateChannelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
