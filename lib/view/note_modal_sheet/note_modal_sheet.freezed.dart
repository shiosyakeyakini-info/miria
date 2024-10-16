// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_modal_sheet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NoteModalSheetState {
  AsyncValue<NotesStateResponse> get noteState =>
      throw _privateConstructorUsedError;
  bool get isSharingMode => throw _privateConstructorUsedError;
  AsyncValue<UserDetailed>? get user => throw _privateConstructorUsedError;
  AsyncValue<void>? get delete => throw _privateConstructorUsedError;
  AsyncValue<void>? get deleteRecreate => throw _privateConstructorUsedError;
  AsyncValue<void>? get favorite => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NoteModalSheetStateCopyWith<NoteModalSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteModalSheetStateCopyWith<$Res> {
  factory $NoteModalSheetStateCopyWith(
          NoteModalSheetState value, $Res Function(NoteModalSheetState) then) =
      _$NoteModalSheetStateCopyWithImpl<$Res, NoteModalSheetState>;
  @useResult
  $Res call(
      {AsyncValue<NotesStateResponse> noteState,
      bool isSharingMode,
      AsyncValue<UserDetailed>? user,
      AsyncValue<void>? delete,
      AsyncValue<void>? deleteRecreate,
      AsyncValue<void>? favorite});
}

/// @nodoc
class _$NoteModalSheetStateCopyWithImpl<$Res, $Val extends NoteModalSheetState>
    implements $NoteModalSheetStateCopyWith<$Res> {
  _$NoteModalSheetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noteState = null,
    Object? isSharingMode = null,
    Object? user = freezed,
    Object? delete = freezed,
    Object? deleteRecreate = freezed,
    Object? favorite = freezed,
  }) {
    return _then(_value.copyWith(
      noteState: null == noteState
          ? _value.noteState
          : noteState // ignore: cast_nullable_to_non_nullable
              as AsyncValue<NotesStateResponse>,
      isSharingMode: null == isSharingMode
          ? _value.isSharingMode
          : isSharingMode // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as AsyncValue<UserDetailed>?,
      delete: freezed == delete
          ? _value.delete
          : delete // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      deleteRecreate: freezed == deleteRecreate
          ? _value.deleteRecreate
          : deleteRecreate // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      favorite: freezed == favorite
          ? _value.favorite
          : favorite // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteModalSheetStateImplCopyWith<$Res>
    implements $NoteModalSheetStateCopyWith<$Res> {
  factory _$$NoteModalSheetStateImplCopyWith(_$NoteModalSheetStateImpl value,
          $Res Function(_$NoteModalSheetStateImpl) then) =
      __$$NoteModalSheetStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AsyncValue<NotesStateResponse> noteState,
      bool isSharingMode,
      AsyncValue<UserDetailed>? user,
      AsyncValue<void>? delete,
      AsyncValue<void>? deleteRecreate,
      AsyncValue<void>? favorite});
}

/// @nodoc
class __$$NoteModalSheetStateImplCopyWithImpl<$Res>
    extends _$NoteModalSheetStateCopyWithImpl<$Res, _$NoteModalSheetStateImpl>
    implements _$$NoteModalSheetStateImplCopyWith<$Res> {
  __$$NoteModalSheetStateImplCopyWithImpl(_$NoteModalSheetStateImpl _value,
      $Res Function(_$NoteModalSheetStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noteState = null,
    Object? isSharingMode = null,
    Object? user = freezed,
    Object? delete = freezed,
    Object? deleteRecreate = freezed,
    Object? favorite = freezed,
  }) {
    return _then(_$NoteModalSheetStateImpl(
      noteState: null == noteState
          ? _value.noteState
          : noteState // ignore: cast_nullable_to_non_nullable
              as AsyncValue<NotesStateResponse>,
      isSharingMode: null == isSharingMode
          ? _value.isSharingMode
          : isSharingMode // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as AsyncValue<UserDetailed>?,
      delete: freezed == delete
          ? _value.delete
          : delete // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      deleteRecreate: freezed == deleteRecreate
          ? _value.deleteRecreate
          : deleteRecreate // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      favorite: freezed == favorite
          ? _value.favorite
          : favorite // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
    ));
  }
}

/// @nodoc

class _$NoteModalSheetStateImpl extends _NoteModalSheetState {
  _$NoteModalSheetStateImpl(
      {required this.noteState,
      this.isSharingMode = false,
      this.user,
      this.delete,
      this.deleteRecreate,
      this.favorite})
      : super._();

  @override
  final AsyncValue<NotesStateResponse> noteState;
  @override
  @JsonKey()
  final bool isSharingMode;
  @override
  final AsyncValue<UserDetailed>? user;
  @override
  final AsyncValue<void>? delete;
  @override
  final AsyncValue<void>? deleteRecreate;
  @override
  final AsyncValue<void>? favorite;

  @override
  String toString() {
    return 'NoteModalSheetState(noteState: $noteState, isSharingMode: $isSharingMode, user: $user, delete: $delete, deleteRecreate: $deleteRecreate, favorite: $favorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteModalSheetStateImpl &&
            (identical(other.noteState, noteState) ||
                other.noteState == noteState) &&
            (identical(other.isSharingMode, isSharingMode) ||
                other.isSharingMode == isSharingMode) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.delete, delete) || other.delete == delete) &&
            (identical(other.deleteRecreate, deleteRecreate) ||
                other.deleteRecreate == deleteRecreate) &&
            (identical(other.favorite, favorite) ||
                other.favorite == favorite));
  }

  @override
  int get hashCode => Object.hash(runtimeType, noteState, isSharingMode, user,
      delete, deleteRecreate, favorite);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteModalSheetStateImplCopyWith<_$NoteModalSheetStateImpl> get copyWith =>
      __$$NoteModalSheetStateImplCopyWithImpl<_$NoteModalSheetStateImpl>(
          this, _$identity);
}

abstract class _NoteModalSheetState extends NoteModalSheetState {
  factory _NoteModalSheetState(
      {required final AsyncValue<NotesStateResponse> noteState,
      final bool isSharingMode,
      final AsyncValue<UserDetailed>? user,
      final AsyncValue<void>? delete,
      final AsyncValue<void>? deleteRecreate,
      final AsyncValue<void>? favorite}) = _$NoteModalSheetStateImpl;
  _NoteModalSheetState._() : super._();

  @override
  AsyncValue<NotesStateResponse> get noteState;
  @override
  bool get isSharingMode;
  @override
  AsyncValue<UserDetailed>? get user;
  @override
  AsyncValue<void>? get delete;
  @override
  AsyncValue<void>? get deleteRecreate;
  @override
  AsyncValue<void>? get favorite;
  @override
  @JsonKey(ignore: true)
  _$$NoteModalSheetStateImplCopyWith<_$NoteModalSheetStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
