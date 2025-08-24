// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_input_state_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatInputState {

 List<MisskeyPostFile> get files;
/// Create a copy of ChatInputState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatInputStateCopyWith<ChatInputState> get copyWith => _$ChatInputStateCopyWithImpl<ChatInputState>(this as ChatInputState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInputState&&const DeepCollectionEquality().equals(other.files, files));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'ChatInputState(files: $files)';
}


}

/// @nodoc
abstract mixin class $ChatInputStateCopyWith<$Res>  {
  factory $ChatInputStateCopyWith(ChatInputState value, $Res Function(ChatInputState) _then) = _$ChatInputStateCopyWithImpl;
@useResult
$Res call({
 List<MisskeyPostFile> files
});




}
/// @nodoc
class _$ChatInputStateCopyWithImpl<$Res>
    implements $ChatInputStateCopyWith<$Res> {
  _$ChatInputStateCopyWithImpl(this._self, this._then);

  final ChatInputState _self;
  final $Res Function(ChatInputState) _then;

/// Create a copy of ChatInputState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? files = null,}) {
  return _then(_self.copyWith(
files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<MisskeyPostFile>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatInputState].
extension ChatInputStatePatterns on ChatInputState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatInputState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatInputState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatInputState value)  $default,){
final _that = this;
switch (_that) {
case _ChatInputState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatInputState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatInputState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MisskeyPostFile> files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatInputState() when $default != null:
return $default(_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MisskeyPostFile> files)  $default,) {final _that = this;
switch (_that) {
case _ChatInputState():
return $default(_that.files);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MisskeyPostFile> files)?  $default,) {final _that = this;
switch (_that) {
case _ChatInputState() when $default != null:
return $default(_that.files);case _:
  return null;

}
}

}

/// @nodoc


class _ChatInputState implements ChatInputState {
  const _ChatInputState({final  List<MisskeyPostFile> files = const []}): _files = files;
  

 final  List<MisskeyPostFile> _files;
@override@JsonKey() List<MisskeyPostFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of ChatInputState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatInputStateCopyWith<_ChatInputState> get copyWith => __$ChatInputStateCopyWithImpl<_ChatInputState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatInputState&&const DeepCollectionEquality().equals(other._files, _files));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'ChatInputState(files: $files)';
}


}

/// @nodoc
abstract mixin class _$ChatInputStateCopyWith<$Res> implements $ChatInputStateCopyWith<$Res> {
  factory _$ChatInputStateCopyWith(_ChatInputState value, $Res Function(_ChatInputState) _then) = __$ChatInputStateCopyWithImpl;
@override @useResult
$Res call({
 List<MisskeyPostFile> files
});




}
/// @nodoc
class __$ChatInputStateCopyWithImpl<$Res>
    implements _$ChatInputStateCopyWith<$Res> {
  __$ChatInputStateCopyWithImpl(this._self, this._then);

  final _ChatInputState _self;
  final $Res Function(_ChatInputState) _then;

/// Create a copy of ChatInputState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? files = null,}) {
  return _then(_ChatInputState(
files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<MisskeyPostFile>,
  ));
}


}

// dart format on
