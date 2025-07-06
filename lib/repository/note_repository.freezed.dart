// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NoteStatus implements DiagnosticableTreeMixin {

 bool get isCwOpened; bool get isLongVisible; bool get isReactionedRenote; bool get isLongVisibleInitialized; bool get isIncludeMuteWord; bool get isMuteOpened;
/// Create a copy of NoteStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoteStatusCopyWith<NoteStatus> get copyWith => _$NoteStatusCopyWithImpl<NoteStatus>(this as NoteStatus, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NoteStatus'))
    ..add(DiagnosticsProperty('isCwOpened', isCwOpened))..add(DiagnosticsProperty('isLongVisible', isLongVisible))..add(DiagnosticsProperty('isReactionedRenote', isReactionedRenote))..add(DiagnosticsProperty('isLongVisibleInitialized', isLongVisibleInitialized))..add(DiagnosticsProperty('isIncludeMuteWord', isIncludeMuteWord))..add(DiagnosticsProperty('isMuteOpened', isMuteOpened));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoteStatus&&(identical(other.isCwOpened, isCwOpened) || other.isCwOpened == isCwOpened)&&(identical(other.isLongVisible, isLongVisible) || other.isLongVisible == isLongVisible)&&(identical(other.isReactionedRenote, isReactionedRenote) || other.isReactionedRenote == isReactionedRenote)&&(identical(other.isLongVisibleInitialized, isLongVisibleInitialized) || other.isLongVisibleInitialized == isLongVisibleInitialized)&&(identical(other.isIncludeMuteWord, isIncludeMuteWord) || other.isIncludeMuteWord == isIncludeMuteWord)&&(identical(other.isMuteOpened, isMuteOpened) || other.isMuteOpened == isMuteOpened));
}


@override
int get hashCode => Object.hash(runtimeType,isCwOpened,isLongVisible,isReactionedRenote,isLongVisibleInitialized,isIncludeMuteWord,isMuteOpened);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NoteStatus(isCwOpened: $isCwOpened, isLongVisible: $isLongVisible, isReactionedRenote: $isReactionedRenote, isLongVisibleInitialized: $isLongVisibleInitialized, isIncludeMuteWord: $isIncludeMuteWord, isMuteOpened: $isMuteOpened)';
}


}

/// @nodoc
abstract mixin class $NoteStatusCopyWith<$Res>  {
  factory $NoteStatusCopyWith(NoteStatus value, $Res Function(NoteStatus) _then) = _$NoteStatusCopyWithImpl;
@useResult
$Res call({
 bool isCwOpened, bool isLongVisible, bool isReactionedRenote, bool isLongVisibleInitialized, bool isIncludeMuteWord, bool isMuteOpened
});




}
/// @nodoc
class _$NoteStatusCopyWithImpl<$Res>
    implements $NoteStatusCopyWith<$Res> {
  _$NoteStatusCopyWithImpl(this._self, this._then);

  final NoteStatus _self;
  final $Res Function(NoteStatus) _then;

/// Create a copy of NoteStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isCwOpened = null,Object? isLongVisible = null,Object? isReactionedRenote = null,Object? isLongVisibleInitialized = null,Object? isIncludeMuteWord = null,Object? isMuteOpened = null,}) {
  return _then(_self.copyWith(
isCwOpened: null == isCwOpened ? _self.isCwOpened : isCwOpened // ignore: cast_nullable_to_non_nullable
as bool,isLongVisible: null == isLongVisible ? _self.isLongVisible : isLongVisible // ignore: cast_nullable_to_non_nullable
as bool,isReactionedRenote: null == isReactionedRenote ? _self.isReactionedRenote : isReactionedRenote // ignore: cast_nullable_to_non_nullable
as bool,isLongVisibleInitialized: null == isLongVisibleInitialized ? _self.isLongVisibleInitialized : isLongVisibleInitialized // ignore: cast_nullable_to_non_nullable
as bool,isIncludeMuteWord: null == isIncludeMuteWord ? _self.isIncludeMuteWord : isIncludeMuteWord // ignore: cast_nullable_to_non_nullable
as bool,isMuteOpened: null == isMuteOpened ? _self.isMuteOpened : isMuteOpened // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _NoteStatus with DiagnosticableTreeMixin implements NoteStatus {
  const _NoteStatus({required this.isCwOpened, required this.isLongVisible, required this.isReactionedRenote, required this.isLongVisibleInitialized, required this.isIncludeMuteWord, required this.isMuteOpened});
  

@override final  bool isCwOpened;
@override final  bool isLongVisible;
@override final  bool isReactionedRenote;
@override final  bool isLongVisibleInitialized;
@override final  bool isIncludeMuteWord;
@override final  bool isMuteOpened;

/// Create a copy of NoteStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteStatusCopyWith<_NoteStatus> get copyWith => __$NoteStatusCopyWithImpl<_NoteStatus>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'NoteStatus'))
    ..add(DiagnosticsProperty('isCwOpened', isCwOpened))..add(DiagnosticsProperty('isLongVisible', isLongVisible))..add(DiagnosticsProperty('isReactionedRenote', isReactionedRenote))..add(DiagnosticsProperty('isLongVisibleInitialized', isLongVisibleInitialized))..add(DiagnosticsProperty('isIncludeMuteWord', isIncludeMuteWord))..add(DiagnosticsProperty('isMuteOpened', isMuteOpened));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteStatus&&(identical(other.isCwOpened, isCwOpened) || other.isCwOpened == isCwOpened)&&(identical(other.isLongVisible, isLongVisible) || other.isLongVisible == isLongVisible)&&(identical(other.isReactionedRenote, isReactionedRenote) || other.isReactionedRenote == isReactionedRenote)&&(identical(other.isLongVisibleInitialized, isLongVisibleInitialized) || other.isLongVisibleInitialized == isLongVisibleInitialized)&&(identical(other.isIncludeMuteWord, isIncludeMuteWord) || other.isIncludeMuteWord == isIncludeMuteWord)&&(identical(other.isMuteOpened, isMuteOpened) || other.isMuteOpened == isMuteOpened));
}


@override
int get hashCode => Object.hash(runtimeType,isCwOpened,isLongVisible,isReactionedRenote,isLongVisibleInitialized,isIncludeMuteWord,isMuteOpened);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'NoteStatus(isCwOpened: $isCwOpened, isLongVisible: $isLongVisible, isReactionedRenote: $isReactionedRenote, isLongVisibleInitialized: $isLongVisibleInitialized, isIncludeMuteWord: $isIncludeMuteWord, isMuteOpened: $isMuteOpened)';
}


}

/// @nodoc
abstract mixin class _$NoteStatusCopyWith<$Res> implements $NoteStatusCopyWith<$Res> {
  factory _$NoteStatusCopyWith(_NoteStatus value, $Res Function(_NoteStatus) _then) = __$NoteStatusCopyWithImpl;
@override @useResult
$Res call({
 bool isCwOpened, bool isLongVisible, bool isReactionedRenote, bool isLongVisibleInitialized, bool isIncludeMuteWord, bool isMuteOpened
});




}
/// @nodoc
class __$NoteStatusCopyWithImpl<$Res>
    implements _$NoteStatusCopyWith<$Res> {
  __$NoteStatusCopyWithImpl(this._self, this._then);

  final _NoteStatus _self;
  final $Res Function(_NoteStatus) _then;

/// Create a copy of NoteStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isCwOpened = null,Object? isLongVisible = null,Object? isReactionedRenote = null,Object? isLongVisibleInitialized = null,Object? isIncludeMuteWord = null,Object? isMuteOpened = null,}) {
  return _then(_NoteStatus(
isCwOpened: null == isCwOpened ? _self.isCwOpened : isCwOpened // ignore: cast_nullable_to_non_nullable
as bool,isLongVisible: null == isLongVisible ? _self.isLongVisible : isLongVisible // ignore: cast_nullable_to_non_nullable
as bool,isReactionedRenote: null == isReactionedRenote ? _self.isReactionedRenote : isReactionedRenote // ignore: cast_nullable_to_non_nullable
as bool,isLongVisibleInitialized: null == isLongVisibleInitialized ? _self.isLongVisibleInitialized : isLongVisibleInitialized // ignore: cast_nullable_to_non_nullable
as bool,isIncludeMuteWord: null == isIncludeMuteWord ? _self.isIncludeMuteWord : isIncludeMuteWord // ignore: cast_nullable_to_non_nullable
as bool,isMuteOpened: null == isMuteOpened ? _self.isMuteOpened : isMuteOpened // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
