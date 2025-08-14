// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
