// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomChatState {

 List<ChatMessage> get messages; bool get hasMoreMessages; List<PendingChatMessage> get pendingMessages;
/// Create a copy of RoomChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomChatStateCopyWith<RoomChatState> get copyWith => _$RoomChatStateCopyWithImpl<RoomChatState>(this as RoomChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomChatState&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.hasMoreMessages, hasMoreMessages) || other.hasMoreMessages == hasMoreMessages)&&const DeepCollectionEquality().equals(other.pendingMessages, pendingMessages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(messages),hasMoreMessages,const DeepCollectionEquality().hash(pendingMessages));

@override
String toString() {
  return 'RoomChatState(messages: $messages, hasMoreMessages: $hasMoreMessages, pendingMessages: $pendingMessages)';
}


}

/// @nodoc
abstract mixin class $RoomChatStateCopyWith<$Res>  {
  factory $RoomChatStateCopyWith(RoomChatState value, $Res Function(RoomChatState) _then) = _$RoomChatStateCopyWithImpl;
@useResult
$Res call({
 List<ChatMessage> messages, bool hasMoreMessages, List<PendingChatMessage> pendingMessages
});




}
/// @nodoc
class _$RoomChatStateCopyWithImpl<$Res>
    implements $RoomChatStateCopyWith<$Res> {
  _$RoomChatStateCopyWithImpl(this._self, this._then);

  final RoomChatState _self;
  final $Res Function(RoomChatState) _then;

/// Create a copy of RoomChatState
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


/// Adds pattern-matching-related methods to [RoomChatState].
extension RoomChatStatePatterns on RoomChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomChatState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomChatState value)  $default,){
final _that = this;
switch (_that) {
case _RoomChatState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomChatState value)?  $default,){
final _that = this;
switch (_that) {
case _RoomChatState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChatMessage> messages,  bool hasMoreMessages,  List<PendingChatMessage> pendingMessages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomChatState() when $default != null:
return $default(_that.messages,_that.hasMoreMessages,_that.pendingMessages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChatMessage> messages,  bool hasMoreMessages,  List<PendingChatMessage> pendingMessages)  $default,) {final _that = this;
switch (_that) {
case _RoomChatState():
return $default(_that.messages,_that.hasMoreMessages,_that.pendingMessages);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChatMessage> messages,  bool hasMoreMessages,  List<PendingChatMessage> pendingMessages)?  $default,) {final _that = this;
switch (_that) {
case _RoomChatState() when $default != null:
return $default(_that.messages,_that.hasMoreMessages,_that.pendingMessages);case _:
  return null;

}
}

}

/// @nodoc


class _RoomChatState implements RoomChatState {
  const _RoomChatState({required final  List<ChatMessage> messages, this.hasMoreMessages = true, final  List<PendingChatMessage> pendingMessages = const []}): _messages = messages,_pendingMessages = pendingMessages;
  

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


/// Create a copy of RoomChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomChatStateCopyWith<_RoomChatState> get copyWith => __$RoomChatStateCopyWithImpl<_RoomChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomChatState&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.hasMoreMessages, hasMoreMessages) || other.hasMoreMessages == hasMoreMessages)&&const DeepCollectionEquality().equals(other._pendingMessages, _pendingMessages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),hasMoreMessages,const DeepCollectionEquality().hash(_pendingMessages));

@override
String toString() {
  return 'RoomChatState(messages: $messages, hasMoreMessages: $hasMoreMessages, pendingMessages: $pendingMessages)';
}


}

/// @nodoc
abstract mixin class _$RoomChatStateCopyWith<$Res> implements $RoomChatStateCopyWith<$Res> {
  factory _$RoomChatStateCopyWith(_RoomChatState value, $Res Function(_RoomChatState) _then) = __$RoomChatStateCopyWithImpl;
@override @useResult
$Res call({
 List<ChatMessage> messages, bool hasMoreMessages, List<PendingChatMessage> pendingMessages
});




}
/// @nodoc
class __$RoomChatStateCopyWithImpl<$Res>
    implements _$RoomChatStateCopyWith<$Res> {
  __$RoomChatStateCopyWithImpl(this._self, this._then);

  final _RoomChatState _self;
  final $Res Function(_RoomChatState) _then;

/// Create a copy of RoomChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? hasMoreMessages = null,Object? pendingMessages = null,}) {
  return _then(_RoomChatState(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,hasMoreMessages: null == hasMoreMessages ? _self.hasMoreMessages : hasMoreMessages // ignore: cast_nullable_to_non_nullable
as bool,pendingMessages: null == pendingMessages ? _self._pendingMessages : pendingMessages // ignore: cast_nullable_to_non_nullable
as List<PendingChatMessage>,
  ));
}


}

// dart format on
