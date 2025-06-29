// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_modal_sheet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteModalSheetState implements DiagnosticableTreeMixin {

 AsyncValue<NotesStateResponse>? get noteState; bool get isSharingMode; AsyncValue<UserDetailed>? get user; AsyncValue<void>? get delete; AsyncValue<void>? get deleteRecreate; AsyncValue<void>? get favorite;
/// Create a copy of NoteModalSheetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteModalSheetStateCopyWith<NoteModalSheetState> get copyWith => _$NoteModalSheetStateCopyWithImpl<NoteModalSheetState>(this as NoteModalSheetState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NoteModalSheetState'))
    ..add(DiagnosticsProperty('noteState', noteState))..add(DiagnosticsProperty('isSharingMode', isSharingMode))..add(DiagnosticsProperty('user', user))..add(DiagnosticsProperty('delete', delete))..add(DiagnosticsProperty('deleteRecreate', deleteRecreate))..add(DiagnosticsProperty('favorite', favorite));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteModalSheetState&&(identical(other.noteState, noteState) || other.noteState == noteState)&&(identical(other.isSharingMode, isSharingMode) || other.isSharingMode == isSharingMode)&&(identical(other.user, user) || other.user == user)&&(identical(other.delete, delete) || other.delete == delete)&&(identical(other.deleteRecreate, deleteRecreate) || other.deleteRecreate == deleteRecreate)&&(identical(other.favorite, favorite) || other.favorite == favorite));
}


@override
int get hashCode => Object.hash(runtimeType,noteState,isSharingMode,user,delete,deleteRecreate,favorite);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NoteModalSheetState(noteState: $noteState, isSharingMode: $isSharingMode, user: $user, delete: $delete, deleteRecreate: $deleteRecreate, favorite: $favorite)';
}


}

/// @nodoc
abstract mixin class $NoteModalSheetStateCopyWith<$Res>  {
  factory $NoteModalSheetStateCopyWith(NoteModalSheetState value, $Res Function(NoteModalSheetState) _then) = _$NoteModalSheetStateCopyWithImpl;
@useResult
$Res call({
 AsyncValue<NotesStateResponse>? noteState, bool isSharingMode, AsyncValue<UserDetailed>? user, AsyncValue<void>? delete, AsyncValue<void>? deleteRecreate, AsyncValue<void>? favorite
});




}
/// @nodoc
class _$NoteModalSheetStateCopyWithImpl<$Res>
    implements $NoteModalSheetStateCopyWith<$Res> {
  _$NoteModalSheetStateCopyWithImpl(this._self, this._then);

  final NoteModalSheetState _self;
  final $Res Function(NoteModalSheetState) _then;

/// Create a copy of NoteModalSheetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? noteState = freezed,Object? isSharingMode = null,Object? user = freezed,Object? delete = freezed,Object? deleteRecreate = freezed,Object? favorite = freezed,}) {
  return _then(_self.copyWith(
noteState: freezed == noteState ? _self.noteState : noteState // ignore: cast_nullable_to_non_nullable
as AsyncValue<NotesStateResponse>?,isSharingMode: null == isSharingMode ? _self.isSharingMode : isSharingMode // ignore: cast_nullable_to_non_nullable
as bool,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AsyncValue<UserDetailed>?,delete: freezed == delete ? _self.delete : delete // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>?,deleteRecreate: freezed == deleteRecreate ? _self.deleteRecreate : deleteRecreate // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>?,favorite: freezed == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>?,
  ));
}

}


/// @nodoc


class _NoteModalSheetState extends NoteModalSheetState with DiagnosticableTreeMixin {
   _NoteModalSheetState({this.noteState, this.isSharingMode = false, this.user, this.delete, this.deleteRecreate, this.favorite}): super._();
  

@override final  AsyncValue<NotesStateResponse>? noteState;
@override@JsonKey() final  bool isSharingMode;
@override final  AsyncValue<UserDetailed>? user;
@override final  AsyncValue<void>? delete;
@override final  AsyncValue<void>? deleteRecreate;
@override final  AsyncValue<void>? favorite;

/// Create a copy of NoteModalSheetState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteModalSheetStateCopyWith<_NoteModalSheetState> get copyWith => __$NoteModalSheetStateCopyWithImpl<_NoteModalSheetState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NoteModalSheetState'))
    ..add(DiagnosticsProperty('noteState', noteState))..add(DiagnosticsProperty('isSharingMode', isSharingMode))..add(DiagnosticsProperty('user', user))..add(DiagnosticsProperty('delete', delete))..add(DiagnosticsProperty('deleteRecreate', deleteRecreate))..add(DiagnosticsProperty('favorite', favorite));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteModalSheetState&&(identical(other.noteState, noteState) || other.noteState == noteState)&&(identical(other.isSharingMode, isSharingMode) || other.isSharingMode == isSharingMode)&&(identical(other.user, user) || other.user == user)&&(identical(other.delete, delete) || other.delete == delete)&&(identical(other.deleteRecreate, deleteRecreate) || other.deleteRecreate == deleteRecreate)&&(identical(other.favorite, favorite) || other.favorite == favorite));
}


@override
int get hashCode => Object.hash(runtimeType,noteState,isSharingMode,user,delete,deleteRecreate,favorite);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NoteModalSheetState(noteState: $noteState, isSharingMode: $isSharingMode, user: $user, delete: $delete, deleteRecreate: $deleteRecreate, favorite: $favorite)';
}


}

/// @nodoc
abstract mixin class _$NoteModalSheetStateCopyWith<$Res> implements $NoteModalSheetStateCopyWith<$Res> {
  factory _$NoteModalSheetStateCopyWith(_NoteModalSheetState value, $Res Function(_NoteModalSheetState) _then) = __$NoteModalSheetStateCopyWithImpl;
@override @useResult
$Res call({
 AsyncValue<NotesStateResponse>? noteState, bool isSharingMode, AsyncValue<UserDetailed>? user, AsyncValue<void>? delete, AsyncValue<void>? deleteRecreate, AsyncValue<void>? favorite
});




}
/// @nodoc
class __$NoteModalSheetStateCopyWithImpl<$Res>
    implements _$NoteModalSheetStateCopyWith<$Res> {
  __$NoteModalSheetStateCopyWithImpl(this._self, this._then);

  final _NoteModalSheetState _self;
  final $Res Function(_NoteModalSheetState) _then;

/// Create a copy of NoteModalSheetState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? noteState = freezed,Object? isSharingMode = null,Object? user = freezed,Object? delete = freezed,Object? deleteRecreate = freezed,Object? favorite = freezed,}) {
  return _then(_NoteModalSheetState(
noteState: freezed == noteState ? _self.noteState : noteState // ignore: cast_nullable_to_non_nullable
as AsyncValue<NotesStateResponse>?,isSharingMode: null == isSharingMode ? _self.isSharingMode : isSharingMode // ignore: cast_nullable_to_non_nullable
as bool,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AsyncValue<UserDetailed>?,delete: freezed == delete ? _self.delete : delete // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>?,deleteRecreate: freezed == deleteRecreate ? _self.deleteRecreate : deleteRecreate // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>?,favorite: freezed == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>?,
  ));
}


}

// dart format on
