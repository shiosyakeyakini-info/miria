// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserChatState {

 List<ChatMessage> get messages; bool get hasMoreMessages; List<PendingChatMessage> get pendingMessages;
/// Create a copy of UserChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserChatStateCopyWith<UserChatState> get copyWith => _$UserChatStateCopyWithImpl<UserChatState>(this as UserChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserChatState&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.hasMoreMessages, hasMoreMessages) || other.hasMoreMessages == hasMoreMessages)&&const DeepCollectionEquality().equals(other.pendingMessages, pendingMessages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(messages),hasMoreMessages,const DeepCollectionEquality().hash(pendingMessages));

@override
String toString() {
  return 'UserChatState(messages: $messages, hasMoreMessages: $hasMoreMessages, pendingMessages: $pendingMessages)';
}


}

/// @nodoc
abstract mixin class $UserChatStateCopyWith<$Res>  {
  factory $UserChatStateCopyWith(UserChatState value, $Res Function(UserChatState) _then) = _$UserChatStateCopyWithImpl;
@useResult
$Res call({
 List<ChatMessage> messages, bool hasMoreMessages, List<PendingChatMessage> pendingMessages
});




}
/// @nodoc
class _$UserChatStateCopyWithImpl<$Res>
    implements $UserChatStateCopyWith<$Res> {
  _$UserChatStateCopyWithImpl(this._self, this._then);

  final UserChatState _self;
  final $Res Function(UserChatState) _then;

/// Create a copy of UserChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messages = null,Object? hasMoreMessages = null,Object? pendingMessages = null,}) {
  return _then(_self.copyWith(
messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,hasMoreMessages: null == hasMoreMessages ? _self.hasMoreMessages : hasMoreMessages // ignore: cast_nullable_to_non_nullable
as bool,pendingMessages: null == pendingMessages ? _self.pendingMessages : pendingMessages // ignore: cast_nullable_to_non_nullable
as List<PendingChatMessage>,
  ));
}

}


/// @nodoc


class _UserChatState implements UserChatState {
  const _UserChatState({required final  List<ChatMessage> messages, this.hasMoreMessages = true, final  List<PendingChatMessage> pendingMessages = const []}): _messages = messages,_pendingMessages = pendingMessages;
  

 final  List<ChatMessage> _messages;
@override List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  bool hasMoreMessages;
 final  List<PendingChatMessage> _pendingMessages;
@override@JsonKey() List<PendingChatMessage> get pendingMessages {
  if (_pendingMessages is EqualUnmodifiableListView) return _pendingMessages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingMessages);
}


/// Create a copy of UserChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserChatStateCopyWith<_UserChatState> get copyWith => __$UserChatStateCopyWithImpl<_UserChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserChatState&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.hasMoreMessages, hasMoreMessages) || other.hasMoreMessages == hasMoreMessages)&&const DeepCollectionEquality().equals(other._pendingMessages, _pendingMessages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),hasMoreMessages,const DeepCollectionEquality().hash(_pendingMessages));

@override
String toString() {
  return 'UserChatState(messages: $messages, hasMoreMessages: $hasMoreMessages, pendingMessages: $pendingMessages)';
}


}

/// @nodoc
abstract mixin class _$UserChatStateCopyWith<$Res> implements $UserChatStateCopyWith<$Res> {
  factory _$UserChatStateCopyWith(_UserChatState value, $Res Function(_UserChatState) _then) = __$UserChatStateCopyWithImpl;
@override @useResult
$Res call({
 List<ChatMessage> messages, bool hasMoreMessages, List<PendingChatMessage> pendingMessages
});




}
/// @nodoc
class __$UserChatStateCopyWithImpl<$Res>
    implements _$UserChatStateCopyWith<$Res> {
  __$UserChatStateCopyWithImpl(this._self, this._then);

  final _UserChatState _self;
  final $Res Function(_UserChatState) _then;

/// Create a copy of UserChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? hasMoreMessages = null,Object? pendingMessages = null,}) {
  return _then(_UserChatState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,hasMoreMessages: null == hasMoreMessages ? _self.hasMoreMessages : hasMoreMessages // ignore: cast_nullable_to_non_nullable
as bool,pendingMessages: null == pendingMessages ? _self._pendingMessages : pendingMessages // ignore: cast_nullable_to_non_nullable
as List<PendingChatMessage>,
  ));
}


}

// dart format on
