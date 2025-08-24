// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_create_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteCreate {

 NoteVisibility get noteVisibility; bool get localOnly; ReactionAcceptance? get reactionAcceptance; List<User> get replyTo; List<MisskeyPostFile> get files; NoteCreateChannel? get channel; Note? get reply; Note? get renote; bool get isCw; String get cwText; String get text; bool get isTextFocused; NoteSendStatus? get isNoteSending; bool get isVote; List<String> get voteContent; int get voteContentCount; VoteExpireType get voteExpireType; bool get isVoteMultiple; DateTime? get voteDate; int? get voteDuration; VoteExpireDurationType get voteDurationType; NoteCreationMode? get noteCreationMode; String? get noteId; String? get selectedDraftId;
/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteCreateCopyWith<NoteCreate> get copyWith => _$NoteCreateCopyWithImpl<NoteCreate>(this as NoteCreate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteCreate&&(identical(other.noteVisibility, noteVisibility) || other.noteVisibility == noteVisibility)&&(identical(other.localOnly, localOnly) || other.localOnly == localOnly)&&(identical(other.reactionAcceptance, reactionAcceptance) || other.reactionAcceptance == reactionAcceptance)&&const DeepCollectionEquality().equals(other.replyTo, replyTo)&&const DeepCollectionEquality().equals(other.files, files)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.renote, renote) || other.renote == renote)&&(identical(other.isCw, isCw) || other.isCw == isCw)&&(identical(other.cwText, cwText) || other.cwText == cwText)&&(identical(other.text, text) || other.text == text)&&(identical(other.isTextFocused, isTextFocused) || other.isTextFocused == isTextFocused)&&(identical(other.isNoteSending, isNoteSending) || other.isNoteSending == isNoteSending)&&(identical(other.isVote, isVote) || other.isVote == isVote)&&const DeepCollectionEquality().equals(other.voteContent, voteContent)&&(identical(other.voteContentCount, voteContentCount) || other.voteContentCount == voteContentCount)&&(identical(other.voteExpireType, voteExpireType) || other.voteExpireType == voteExpireType)&&(identical(other.isVoteMultiple, isVoteMultiple) || other.isVoteMultiple == isVoteMultiple)&&(identical(other.voteDate, voteDate) || other.voteDate == voteDate)&&(identical(other.voteDuration, voteDuration) || other.voteDuration == voteDuration)&&(identical(other.voteDurationType, voteDurationType) || other.voteDurationType == voteDurationType)&&(identical(other.noteCreationMode, noteCreationMode) || other.noteCreationMode == noteCreationMode)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.selectedDraftId, selectedDraftId) || other.selectedDraftId == selectedDraftId));
}


@override
int get hashCode => Object.hashAll([runtimeType,noteVisibility,localOnly,reactionAcceptance,const DeepCollectionEquality().hash(replyTo),const DeepCollectionEquality().hash(files),channel,reply,renote,isCw,cwText,text,isTextFocused,isNoteSending,isVote,const DeepCollectionEquality().hash(voteContent),voteContentCount,voteExpireType,isVoteMultiple,voteDate,voteDuration,voteDurationType,noteCreationMode,noteId,selectedDraftId]);

@override
String toString() {
  return 'NoteCreate(noteVisibility: $noteVisibility, localOnly: $localOnly, reactionAcceptance: $reactionAcceptance, replyTo: $replyTo, files: $files, channel: $channel, reply: $reply, renote: $renote, isCw: $isCw, cwText: $cwText, text: $text, isTextFocused: $isTextFocused, isNoteSending: $isNoteSending, isVote: $isVote, voteContent: $voteContent, voteContentCount: $voteContentCount, voteExpireType: $voteExpireType, isVoteMultiple: $isVoteMultiple, voteDate: $voteDate, voteDuration: $voteDuration, voteDurationType: $voteDurationType, noteCreationMode: $noteCreationMode, noteId: $noteId, selectedDraftId: $selectedDraftId)';
}


}

/// @nodoc
abstract mixin class $NoteCreateCopyWith<$Res>  {
  factory $NoteCreateCopyWith(NoteCreate value, $Res Function(NoteCreate) _then) = _$NoteCreateCopyWithImpl;
@useResult
$Res call({
 NoteVisibility noteVisibility, bool localOnly, ReactionAcceptance? reactionAcceptance, List<User> replyTo, List<MisskeyPostFile> files, NoteCreateChannel? channel, Note? reply, Note? renote, bool isCw, String cwText, String text, bool isTextFocused, NoteSendStatus? isNoteSending, bool isVote, List<String> voteContent, int voteContentCount, VoteExpireType voteExpireType, bool isVoteMultiple, DateTime? voteDate, int? voteDuration, VoteExpireDurationType voteDurationType, NoteCreationMode? noteCreationMode, String? noteId, String? selectedDraftId
});


$NoteCreateChannelCopyWith<$Res>? get channel;$NoteCopyWith<$Res>? get reply;$NoteCopyWith<$Res>? get renote;

}
/// @nodoc
class _$NoteCreateCopyWithImpl<$Res>
    implements $NoteCreateCopyWith<$Res> {
  _$NoteCreateCopyWithImpl(this._self, this._then);

  final NoteCreate _self;
  final $Res Function(NoteCreate) _then;

/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noteVisibility = null,Object? localOnly = null,Object? reactionAcceptance = freezed,Object? replyTo = null,Object? files = null,Object? channel = freezed,Object? reply = freezed,Object? renote = freezed,Object? isCw = null,Object? cwText = null,Object? text = null,Object? isTextFocused = null,Object? isNoteSending = freezed,Object? isVote = null,Object? voteContent = null,Object? voteContentCount = null,Object? voteExpireType = null,Object? isVoteMultiple = null,Object? voteDate = freezed,Object? voteDuration = freezed,Object? voteDurationType = null,Object? noteCreationMode = freezed,Object? noteId = freezed,Object? selectedDraftId = freezed,}) {
  return _then(_self.copyWith(
noteVisibility: null == noteVisibility ? _self.noteVisibility : noteVisibility // ignore: cast_nullable_to_non_nullable
as NoteVisibility,localOnly: null == localOnly ? _self.localOnly : localOnly // ignore: cast_nullable_to_non_nullable
as bool,reactionAcceptance: freezed == reactionAcceptance ? _self.reactionAcceptance : reactionAcceptance // ignore: cast_nullable_to_non_nullable
as ReactionAcceptance?,replyTo: null == replyTo ? _self.replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as List<User>,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<MisskeyPostFile>,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NoteCreateChannel?,reply: freezed == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as Note?,renote: freezed == renote ? _self.renote : renote // ignore: cast_nullable_to_non_nullable
as Note?,isCw: null == isCw ? _self.isCw : isCw // ignore: cast_nullable_to_non_nullable
as bool,cwText: null == cwText ? _self.cwText : cwText // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isTextFocused: null == isTextFocused ? _self.isTextFocused : isTextFocused // ignore: cast_nullable_to_non_nullable
as bool,isNoteSending: freezed == isNoteSending ? _self.isNoteSending : isNoteSending // ignore: cast_nullable_to_non_nullable
as NoteSendStatus?,isVote: null == isVote ? _self.isVote : isVote // ignore: cast_nullable_to_non_nullable
as bool,voteContent: null == voteContent ? _self.voteContent : voteContent // ignore: cast_nullable_to_non_nullable
as List<String>,voteContentCount: null == voteContentCount ? _self.voteContentCount : voteContentCount // ignore: cast_nullable_to_non_nullable
as int,voteExpireType: null == voteExpireType ? _self.voteExpireType : voteExpireType // ignore: cast_nullable_to_non_nullable
as VoteExpireType,isVoteMultiple: null == isVoteMultiple ? _self.isVoteMultiple : isVoteMultiple // ignore: cast_nullable_to_non_nullable
as bool,voteDate: freezed == voteDate ? _self.voteDate : voteDate // ignore: cast_nullable_to_non_nullable
as DateTime?,voteDuration: freezed == voteDuration ? _self.voteDuration : voteDuration // ignore: cast_nullable_to_non_nullable
as int?,voteDurationType: null == voteDurationType ? _self.voteDurationType : voteDurationType // ignore: cast_nullable_to_non_nullable
as VoteExpireDurationType,noteCreationMode: freezed == noteCreationMode ? _self.noteCreationMode : noteCreationMode // ignore: cast_nullable_to_non_nullable
as NoteCreationMode?,noteId: freezed == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String?,selectedDraftId: freezed == selectedDraftId ? _self.selectedDraftId : selectedDraftId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteCreateChannelCopyWith<$Res>? get channel {
    if (_self.channel == null) {
    return null;
  }

  return $NoteCreateChannelCopyWith<$Res>(_self.channel!, (value) {
    return _then(_self.copyWith(channel: value));
  });
}/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteCopyWith<$Res>? get reply {
    if (_self.reply == null) {
    return null;
  }

  return $NoteCopyWith<$Res>(_self.reply!, (value) {
    return _then(_self.copyWith(reply: value));
  });
}/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteCopyWith<$Res>? get renote {
    if (_self.renote == null) {
    return null;
  }

  return $NoteCopyWith<$Res>(_self.renote!, (value) {
    return _then(_self.copyWith(renote: value));
  });
}
}


/// Adds pattern-matching-related methods to [NoteCreate].
extension NoteCreatePatterns on NoteCreate {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteCreate() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteCreate value)  $default,){
final _that = this;
switch (_that) {
case _NoteCreate():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteCreate value)?  $default,){
final _that = this;
switch (_that) {
case _NoteCreate() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NoteVisibility noteVisibility,  bool localOnly,  ReactionAcceptance? reactionAcceptance,  List<User> replyTo,  List<MisskeyPostFile> files,  NoteCreateChannel? channel,  Note? reply,  Note? renote,  bool isCw,  String cwText,  String text,  bool isTextFocused,  NoteSendStatus? isNoteSending,  bool isVote,  List<String> voteContent,  int voteContentCount,  VoteExpireType voteExpireType,  bool isVoteMultiple,  DateTime? voteDate,  int? voteDuration,  VoteExpireDurationType voteDurationType,  NoteCreationMode? noteCreationMode,  String? noteId,  String? selectedDraftId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteCreate() when $default != null:
return $default(_that.noteVisibility,_that.localOnly,_that.reactionAcceptance,_that.replyTo,_that.files,_that.channel,_that.reply,_that.renote,_that.isCw,_that.cwText,_that.text,_that.isTextFocused,_that.isNoteSending,_that.isVote,_that.voteContent,_that.voteContentCount,_that.voteExpireType,_that.isVoteMultiple,_that.voteDate,_that.voteDuration,_that.voteDurationType,_that.noteCreationMode,_that.noteId,_that.selectedDraftId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NoteVisibility noteVisibility,  bool localOnly,  ReactionAcceptance? reactionAcceptance,  List<User> replyTo,  List<MisskeyPostFile> files,  NoteCreateChannel? channel,  Note? reply,  Note? renote,  bool isCw,  String cwText,  String text,  bool isTextFocused,  NoteSendStatus? isNoteSending,  bool isVote,  List<String> voteContent,  int voteContentCount,  VoteExpireType voteExpireType,  bool isVoteMultiple,  DateTime? voteDate,  int? voteDuration,  VoteExpireDurationType voteDurationType,  NoteCreationMode? noteCreationMode,  String? noteId,  String? selectedDraftId)  $default,) {final _that = this;
switch (_that) {
case _NoteCreate():
return $default(_that.noteVisibility,_that.localOnly,_that.reactionAcceptance,_that.replyTo,_that.files,_that.channel,_that.reply,_that.renote,_that.isCw,_that.cwText,_that.text,_that.isTextFocused,_that.isNoteSending,_that.isVote,_that.voteContent,_that.voteContentCount,_that.voteExpireType,_that.isVoteMultiple,_that.voteDate,_that.voteDuration,_that.voteDurationType,_that.noteCreationMode,_that.noteId,_that.selectedDraftId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NoteVisibility noteVisibility,  bool localOnly,  ReactionAcceptance? reactionAcceptance,  List<User> replyTo,  List<MisskeyPostFile> files,  NoteCreateChannel? channel,  Note? reply,  Note? renote,  bool isCw,  String cwText,  String text,  bool isTextFocused,  NoteSendStatus? isNoteSending,  bool isVote,  List<String> voteContent,  int voteContentCount,  VoteExpireType voteExpireType,  bool isVoteMultiple,  DateTime? voteDate,  int? voteDuration,  VoteExpireDurationType voteDurationType,  NoteCreationMode? noteCreationMode,  String? noteId,  String? selectedDraftId)?  $default,) {final _that = this;
switch (_that) {
case _NoteCreate() when $default != null:
return $default(_that.noteVisibility,_that.localOnly,_that.reactionAcceptance,_that.replyTo,_that.files,_that.channel,_that.reply,_that.renote,_that.isCw,_that.cwText,_that.text,_that.isTextFocused,_that.isNoteSending,_that.isVote,_that.voteContent,_that.voteContentCount,_that.voteExpireType,_that.isVoteMultiple,_that.voteDate,_that.voteDuration,_that.voteDurationType,_that.noteCreationMode,_that.noteId,_that.selectedDraftId);case _:
  return null;

}
}

}

/// @nodoc


class _NoteCreate implements NoteCreate {
  const _NoteCreate({required this.noteVisibility, required this.localOnly, required this.reactionAcceptance, final  List<User> replyTo = const [], final  List<MisskeyPostFile> files = const [], this.channel, this.reply, this.renote, this.isCw = false, this.cwText = "", this.text = "", this.isTextFocused = false, this.isNoteSending, this.isVote = false, final  List<String> voteContent = const ["", ""], this.voteContentCount = 2, this.voteExpireType = VoteExpireType.unlimited, this.isVoteMultiple = false, this.voteDate, this.voteDuration, this.voteDurationType = VoteExpireDurationType.seconds, this.noteCreationMode, this.noteId, this.selectedDraftId}): _replyTo = replyTo,_files = files,_voteContent = voteContent;
  

@override final  NoteVisibility noteVisibility;
@override final  bool localOnly;
@override final  ReactionAcceptance? reactionAcceptance;
 final  List<User> _replyTo;
@override@JsonKey() List<User> get replyTo {
  if (_replyTo is EqualUnmodifiableListView) return _replyTo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replyTo);
}

 final  List<MisskeyPostFile> _files;
@override@JsonKey() List<MisskeyPostFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}

@override final  NoteCreateChannel? channel;
@override final  Note? reply;
@override final  Note? renote;
@override@JsonKey() final  bool isCw;
@override@JsonKey() final  String cwText;
@override@JsonKey() final  String text;
@override@JsonKey() final  bool isTextFocused;
@override final  NoteSendStatus? isNoteSending;
@override@JsonKey() final  bool isVote;
 final  List<String> _voteContent;
@override@JsonKey() List<String> get voteContent {
  if (_voteContent is EqualUnmodifiableListView) return _voteContent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_voteContent);
}

@override@JsonKey() final  int voteContentCount;
@override@JsonKey() final  VoteExpireType voteExpireType;
@override@JsonKey() final  bool isVoteMultiple;
@override final  DateTime? voteDate;
@override final  int? voteDuration;
@override@JsonKey() final  VoteExpireDurationType voteDurationType;
@override final  NoteCreationMode? noteCreationMode;
@override final  String? noteId;
@override final  String? selectedDraftId;

/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteCreateCopyWith<_NoteCreate> get copyWith => __$NoteCreateCopyWithImpl<_NoteCreate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteCreate&&(identical(other.noteVisibility, noteVisibility) || other.noteVisibility == noteVisibility)&&(identical(other.localOnly, localOnly) || other.localOnly == localOnly)&&(identical(other.reactionAcceptance, reactionAcceptance) || other.reactionAcceptance == reactionAcceptance)&&const DeepCollectionEquality().equals(other._replyTo, _replyTo)&&const DeepCollectionEquality().equals(other._files, _files)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.reply, reply) || other.reply == reply)&&(identical(other.renote, renote) || other.renote == renote)&&(identical(other.isCw, isCw) || other.isCw == isCw)&&(identical(other.cwText, cwText) || other.cwText == cwText)&&(identical(other.text, text) || other.text == text)&&(identical(other.isTextFocused, isTextFocused) || other.isTextFocused == isTextFocused)&&(identical(other.isNoteSending, isNoteSending) || other.isNoteSending == isNoteSending)&&(identical(other.isVote, isVote) || other.isVote == isVote)&&const DeepCollectionEquality().equals(other._voteContent, _voteContent)&&(identical(other.voteContentCount, voteContentCount) || other.voteContentCount == voteContentCount)&&(identical(other.voteExpireType, voteExpireType) || other.voteExpireType == voteExpireType)&&(identical(other.isVoteMultiple, isVoteMultiple) || other.isVoteMultiple == isVoteMultiple)&&(identical(other.voteDate, voteDate) || other.voteDate == voteDate)&&(identical(other.voteDuration, voteDuration) || other.voteDuration == voteDuration)&&(identical(other.voteDurationType, voteDurationType) || other.voteDurationType == voteDurationType)&&(identical(other.noteCreationMode, noteCreationMode) || other.noteCreationMode == noteCreationMode)&&(identical(other.noteId, noteId) || other.noteId == noteId)&&(identical(other.selectedDraftId, selectedDraftId) || other.selectedDraftId == selectedDraftId));
}


@override
int get hashCode => Object.hashAll([runtimeType,noteVisibility,localOnly,reactionAcceptance,const DeepCollectionEquality().hash(_replyTo),const DeepCollectionEquality().hash(_files),channel,reply,renote,isCw,cwText,text,isTextFocused,isNoteSending,isVote,const DeepCollectionEquality().hash(_voteContent),voteContentCount,voteExpireType,isVoteMultiple,voteDate,voteDuration,voteDurationType,noteCreationMode,noteId,selectedDraftId]);

@override
String toString() {
  return 'NoteCreate(noteVisibility: $noteVisibility, localOnly: $localOnly, reactionAcceptance: $reactionAcceptance, replyTo: $replyTo, files: $files, channel: $channel, reply: $reply, renote: $renote, isCw: $isCw, cwText: $cwText, text: $text, isTextFocused: $isTextFocused, isNoteSending: $isNoteSending, isVote: $isVote, voteContent: $voteContent, voteContentCount: $voteContentCount, voteExpireType: $voteExpireType, isVoteMultiple: $isVoteMultiple, voteDate: $voteDate, voteDuration: $voteDuration, voteDurationType: $voteDurationType, noteCreationMode: $noteCreationMode, noteId: $noteId, selectedDraftId: $selectedDraftId)';
}


}

/// @nodoc
abstract mixin class _$NoteCreateCopyWith<$Res> implements $NoteCreateCopyWith<$Res> {
  factory _$NoteCreateCopyWith(_NoteCreate value, $Res Function(_NoteCreate) _then) = __$NoteCreateCopyWithImpl;
@override @useResult
$Res call({
 NoteVisibility noteVisibility, bool localOnly, ReactionAcceptance? reactionAcceptance, List<User> replyTo, List<MisskeyPostFile> files, NoteCreateChannel? channel, Note? reply, Note? renote, bool isCw, String cwText, String text, bool isTextFocused, NoteSendStatus? isNoteSending, bool isVote, List<String> voteContent, int voteContentCount, VoteExpireType voteExpireType, bool isVoteMultiple, DateTime? voteDate, int? voteDuration, VoteExpireDurationType voteDurationType, NoteCreationMode? noteCreationMode, String? noteId, String? selectedDraftId
});


@override $NoteCreateChannelCopyWith<$Res>? get channel;@override $NoteCopyWith<$Res>? get reply;@override $NoteCopyWith<$Res>? get renote;

}
/// @nodoc
class __$NoteCreateCopyWithImpl<$Res>
    implements _$NoteCreateCopyWith<$Res> {
  __$NoteCreateCopyWithImpl(this._self, this._then);

  final _NoteCreate _self;
  final $Res Function(_NoteCreate) _then;

/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noteVisibility = null,Object? localOnly = null,Object? reactionAcceptance = freezed,Object? replyTo = null,Object? files = null,Object? channel = freezed,Object? reply = freezed,Object? renote = freezed,Object? isCw = null,Object? cwText = null,Object? text = null,Object? isTextFocused = null,Object? isNoteSending = freezed,Object? isVote = null,Object? voteContent = null,Object? voteContentCount = null,Object? voteExpireType = null,Object? isVoteMultiple = null,Object? voteDate = freezed,Object? voteDuration = freezed,Object? voteDurationType = null,Object? noteCreationMode = freezed,Object? noteId = freezed,Object? selectedDraftId = freezed,}) {
  return _then(_NoteCreate(
noteVisibility: null == noteVisibility ? _self.noteVisibility : noteVisibility // ignore: cast_nullable_to_non_nullable
as NoteVisibility,localOnly: null == localOnly ? _self.localOnly : localOnly // ignore: cast_nullable_to_non_nullable
as bool,reactionAcceptance: freezed == reactionAcceptance ? _self.reactionAcceptance : reactionAcceptance // ignore: cast_nullable_to_non_nullable
as ReactionAcceptance?,replyTo: null == replyTo ? _self._replyTo : replyTo // ignore: cast_nullable_to_non_nullable
as List<User>,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<MisskeyPostFile>,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as NoteCreateChannel?,reply: freezed == reply ? _self.reply : reply // ignore: cast_nullable_to_non_nullable
as Note?,renote: freezed == renote ? _self.renote : renote // ignore: cast_nullable_to_non_nullable
as Note?,isCw: null == isCw ? _self.isCw : isCw // ignore: cast_nullable_to_non_nullable
as bool,cwText: null == cwText ? _self.cwText : cwText // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,isTextFocused: null == isTextFocused ? _self.isTextFocused : isTextFocused // ignore: cast_nullable_to_non_nullable
as bool,isNoteSending: freezed == isNoteSending ? _self.isNoteSending : isNoteSending // ignore: cast_nullable_to_non_nullable
as NoteSendStatus?,isVote: null == isVote ? _self.isVote : isVote // ignore: cast_nullable_to_non_nullable
as bool,voteContent: null == voteContent ? _self._voteContent : voteContent // ignore: cast_nullable_to_non_nullable
as List<String>,voteContentCount: null == voteContentCount ? _self.voteContentCount : voteContentCount // ignore: cast_nullable_to_non_nullable
as int,voteExpireType: null == voteExpireType ? _self.voteExpireType : voteExpireType // ignore: cast_nullable_to_non_nullable
as VoteExpireType,isVoteMultiple: null == isVoteMultiple ? _self.isVoteMultiple : isVoteMultiple // ignore: cast_nullable_to_non_nullable
as bool,voteDate: freezed == voteDate ? _self.voteDate : voteDate // ignore: cast_nullable_to_non_nullable
as DateTime?,voteDuration: freezed == voteDuration ? _self.voteDuration : voteDuration // ignore: cast_nullable_to_non_nullable
as int?,voteDurationType: null == voteDurationType ? _self.voteDurationType : voteDurationType // ignore: cast_nullable_to_non_nullable
as VoteExpireDurationType,noteCreationMode: freezed == noteCreationMode ? _self.noteCreationMode : noteCreationMode // ignore: cast_nullable_to_non_nullable
as NoteCreationMode?,noteId: freezed == noteId ? _self.noteId : noteId // ignore: cast_nullable_to_non_nullable
as String?,selectedDraftId: freezed == selectedDraftId ? _self.selectedDraftId : selectedDraftId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteCreateChannelCopyWith<$Res>? get channel {
    if (_self.channel == null) {
    return null;
  }

  return $NoteCreateChannelCopyWith<$Res>(_self.channel!, (value) {
    return _then(_self.copyWith(channel: value));
  });
}/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteCopyWith<$Res>? get reply {
    if (_self.reply == null) {
    return null;
  }

  return $NoteCopyWith<$Res>(_self.reply!, (value) {
    return _then(_self.copyWith(reply: value));
  });
}/// Create a copy of NoteCreate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NoteCopyWith<$Res>? get renote {
    if (_self.renote == null) {
    return null;
  }

  return $NoteCopyWith<$Res>(_self.renote!, (value) {
    return _then(_self.copyWith(renote: value));
  });
}
}

/// @nodoc
mixin _$NoteCreateChannel {

 String get id; String get name;
/// Create a copy of NoteCreateChannel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteCreateChannelCopyWith<NoteCreateChannel> get copyWith => _$NoteCreateChannelCopyWithImpl<NoteCreateChannel>(this as NoteCreateChannel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteCreateChannel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'NoteCreateChannel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $NoteCreateChannelCopyWith<$Res>  {
  factory $NoteCreateChannelCopyWith(NoteCreateChannel value, $Res Function(NoteCreateChannel) _then) = _$NoteCreateChannelCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$NoteCreateChannelCopyWithImpl<$Res>
    implements $NoteCreateChannelCopyWith<$Res> {
  _$NoteCreateChannelCopyWithImpl(this._self, this._then);

  final NoteCreateChannel _self;
  final $Res Function(NoteCreateChannel) _then;

/// Create a copy of NoteCreateChannel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NoteCreateChannel].
extension NoteCreateChannelPatterns on NoteCreateChannel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteCreateChannel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteCreateChannel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteCreateChannel value)  $default,){
final _that = this;
switch (_that) {
case _NoteCreateChannel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteCreateChannel value)?  $default,){
final _that = this;
switch (_that) {
case _NoteCreateChannel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteCreateChannel() when $default != null:
return $default(_that.id,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _NoteCreateChannel():
return $default(_that.id,_that.name);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _NoteCreateChannel() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _NoteCreateChannel implements NoteCreateChannel {
  const _NoteCreateChannel({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of NoteCreateChannel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteCreateChannelCopyWith<_NoteCreateChannel> get copyWith => __$NoteCreateChannelCopyWithImpl<_NoteCreateChannel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteCreateChannel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'NoteCreateChannel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$NoteCreateChannelCopyWith<$Res> implements $NoteCreateChannelCopyWith<$Res> {
  factory _$NoteCreateChannelCopyWith(_NoteCreateChannel value, $Res Function(_NoteCreateChannel) _then) = __$NoteCreateChannelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$NoteCreateChannelCopyWithImpl<$Res>
    implements _$NoteCreateChannelCopyWith<$Res> {
  __$NoteCreateChannelCopyWithImpl(this._self, this._then);

  final _NoteCreateChannel _self;
  final $Res Function(_NoteCreateChannel) _then;

/// Create a copy of NoteCreateChannel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_NoteCreateChannel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
