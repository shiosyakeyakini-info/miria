// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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


/// Adds pattern-matching-related methods to [NoteModalSheetState].
extension NoteModalSheetStatePatterns on NoteModalSheetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NoteModalSheetState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NoteModalSheetState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NoteModalSheetState value)  $default,){
final _that = this;
switch (_that) {
case _NoteModalSheetState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NoteModalSheetState value)?  $default,){
final _that = this;
switch (_that) {
case _NoteModalSheetState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AsyncValue<NotesStateResponse>? noteState,  bool isSharingMode,  AsyncValue<UserDetailed>? user,  AsyncValue<void>? delete,  AsyncValue<void>? deleteRecreate,  AsyncValue<void>? favorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NoteModalSheetState() when $default != null:
return $default(_that.noteState,_that.isSharingMode,_that.user,_that.delete,_that.deleteRecreate,_that.favorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AsyncValue<NotesStateResponse>? noteState,  bool isSharingMode,  AsyncValue<UserDetailed>? user,  AsyncValue<void>? delete,  AsyncValue<void>? deleteRecreate,  AsyncValue<void>? favorite)  $default,) {final _that = this;
switch (_that) {
case _NoteModalSheetState():
return $default(_that.noteState,_that.isSharingMode,_that.user,_that.delete,_that.deleteRecreate,_that.favorite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AsyncValue<NotesStateResponse>? noteState,  bool isSharingMode,  AsyncValue<UserDetailed>? user,  AsyncValue<void>? delete,  AsyncValue<void>? deleteRecreate,  AsyncValue<void>? favorite)?  $default,) {final _that = this;
switch (_that) {
case _NoteModalSheetState() when $default != null:
return $default(_that.noteState,_that.isSharingMode,_that.user,_that.delete,_that.deleteRecreate,_that.favorite);case _:
  return null;

}
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
