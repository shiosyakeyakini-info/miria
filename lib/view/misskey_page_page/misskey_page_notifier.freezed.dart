// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'misskey_page_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MisskeyPageNotifierState {

 Page get page; AsyncValue<void>? get likeOr;
/// Create a copy of MisskeyPageNotifierState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MisskeyPageNotifierStateCopyWith<MisskeyPageNotifierState> get copyWith => _$MisskeyPageNotifierStateCopyWithImpl<MisskeyPageNotifierState>(this as MisskeyPageNotifierState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MisskeyPageNotifierState&&(identical(other.page, page) || other.page == page)&&(identical(other.likeOr, likeOr) || other.likeOr == likeOr));
}


@override
int get hashCode => Object.hash(runtimeType,page,likeOr);

@override
String toString() {
  return 'MisskeyPageNotifierState(page: $page, likeOr: $likeOr)';
}


}

/// @nodoc
abstract mixin class $MisskeyPageNotifierStateCopyWith<$Res>  {
  factory $MisskeyPageNotifierStateCopyWith(MisskeyPageNotifierState value, $Res Function(MisskeyPageNotifierState) _then) = _$MisskeyPageNotifierStateCopyWithImpl;
@useResult
$Res call({
 Page page, AsyncValue<void>? likeOr
});


$PageCopyWith<$Res> get page;

}
/// @nodoc
class _$MisskeyPageNotifierStateCopyWithImpl<$Res>
    implements $MisskeyPageNotifierStateCopyWith<$Res> {
  _$MisskeyPageNotifierStateCopyWithImpl(this._self, this._then);

  final MisskeyPageNotifierState _self;
  final $Res Function(MisskeyPageNotifierState) _then;

/// Create a copy of MisskeyPageNotifierState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? likeOr = freezed,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as Page,likeOr: freezed == likeOr ? _self.likeOr : likeOr // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>?,
  ));
}
/// Create a copy of MisskeyPageNotifierState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageCopyWith<$Res> get page {
  
  return $PageCopyWith<$Res>(_self.page, (value) {
    return _then(_self.copyWith(page: value));
  });
}
}


/// @nodoc


class _MisskeyPageNotifierState implements MisskeyPageNotifierState {
  const _MisskeyPageNotifierState({required this.page, this.likeOr});
  

@override final  Page page;
@override final  AsyncValue<void>? likeOr;

/// Create a copy of MisskeyPageNotifierState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MisskeyPageNotifierStateCopyWith<_MisskeyPageNotifierState> get copyWith => __$MisskeyPageNotifierStateCopyWithImpl<_MisskeyPageNotifierState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MisskeyPageNotifierState&&(identical(other.page, page) || other.page == page)&&(identical(other.likeOr, likeOr) || other.likeOr == likeOr));
}


@override
int get hashCode => Object.hash(runtimeType,page,likeOr);

@override
String toString() {
  return 'MisskeyPageNotifierState(page: $page, likeOr: $likeOr)';
}


}

/// @nodoc
abstract mixin class _$MisskeyPageNotifierStateCopyWith<$Res> implements $MisskeyPageNotifierStateCopyWith<$Res> {
  factory _$MisskeyPageNotifierStateCopyWith(_MisskeyPageNotifierState value, $Res Function(_MisskeyPageNotifierState) _then) = __$MisskeyPageNotifierStateCopyWithImpl;
@override @useResult
$Res call({
 Page page, AsyncValue<void>? likeOr
});


@override $PageCopyWith<$Res> get page;

}
/// @nodoc
class __$MisskeyPageNotifierStateCopyWithImpl<$Res>
    implements _$MisskeyPageNotifierStateCopyWith<$Res> {
  __$MisskeyPageNotifierStateCopyWithImpl(this._self, this._then);

  final _MisskeyPageNotifierState _self;
  final $Res Function(_MisskeyPageNotifierState) _then;

/// Create a copy of MisskeyPageNotifierState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? likeOr = freezed,}) {
  return _then(_MisskeyPageNotifierState(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as Page,likeOr: freezed == likeOr ? _self.likeOr : likeOr // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>?,
  ));
}

/// Create a copy of MisskeyPageNotifierState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PageCopyWith<$Res> get page {
  
  return $PageCopyWith<$Res>(_self.page, (value) {
    return _then(_self.copyWith(page: value));
  });
}
}

// dart format on
