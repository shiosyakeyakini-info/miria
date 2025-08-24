// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_detail_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChannelDetailState {

 CommunityChannel get channel; AsyncValue<void>? get follow; AsyncValue<void>? get favorite;
/// Create a copy of ChannelDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelDetailStateCopyWith<ChannelDetailState> get copyWith => _$ChannelDetailStateCopyWithImpl<ChannelDetailState>(this as ChannelDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelDetailState&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.follow, follow) || other.follow == follow)&&(identical(other.favorite, favorite) || other.favorite == favorite));
}


@override
int get hashCode => Object.hash(runtimeType,channel,follow,favorite);

@override
String toString() {
  return 'ChannelDetailState(channel: $channel, follow: $follow, favorite: $favorite)';
}


}

/// @nodoc
abstract mixin class $ChannelDetailStateCopyWith<$Res>  {
  factory $ChannelDetailStateCopyWith(ChannelDetailState value, $Res Function(ChannelDetailState) _then) = _$ChannelDetailStateCopyWithImpl;
@useResult
$Res call({
 CommunityChannel channel, AsyncValue<void>? follow, AsyncValue<void>? favorite
});


$CommunityChannelCopyWith<$Res> get channel;

}
/// @nodoc
class _$ChannelDetailStateCopyWithImpl<$Res>
    implements $ChannelDetailStateCopyWith<$Res> {
  _$ChannelDetailStateCopyWithImpl(this._self, this._then);

  final ChannelDetailState _self;
  final $Res Function(ChannelDetailState) _then;

/// Create a copy of ChannelDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channel = null,Object? follow = freezed,Object? favorite = freezed,}) {
  return _then(_self.copyWith(
channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as CommunityChannel,follow: freezed == follow ? _self.follow : follow // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>?,favorite: freezed == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>?,
  ));
}
/// Create a copy of ChannelDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommunityChannelCopyWith<$Res> get channel {
  
  return $CommunityChannelCopyWith<$Res>(_self.channel, (value) {
    return _then(_self.copyWith(channel: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChannelDetailState].
extension ChannelDetailStatePatterns on ChannelDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChannelDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChannelDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChannelDetailState value)  $default,){
final _that = this;
switch (_that) {
case _ChannelDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChannelDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _ChannelDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CommunityChannel channel,  AsyncValue<void>? follow,  AsyncValue<void>? favorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChannelDetailState() when $default != null:
return $default(_that.channel,_that.follow,_that.favorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CommunityChannel channel,  AsyncValue<void>? follow,  AsyncValue<void>? favorite)  $default,) {final _that = this;
switch (_that) {
case _ChannelDetailState():
return $default(_that.channel,_that.follow,_that.favorite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CommunityChannel channel,  AsyncValue<void>? follow,  AsyncValue<void>? favorite)?  $default,) {final _that = this;
switch (_that) {
case _ChannelDetailState() when $default != null:
return $default(_that.channel,_that.follow,_that.favorite);case _:
  return null;

}
}

}

/// @nodoc


class _ChannelDetailState implements ChannelDetailState {
   _ChannelDetailState({required this.channel, this.follow, this.favorite});
  

@override final  CommunityChannel channel;
@override final  AsyncValue<void>? follow;
@override final  AsyncValue<void>? favorite;

/// Create a copy of ChannelDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelDetailStateCopyWith<_ChannelDetailState> get copyWith => __$ChannelDetailStateCopyWithImpl<_ChannelDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelDetailState&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.follow, follow) || other.follow == follow)&&(identical(other.favorite, favorite) || other.favorite == favorite));
}


@override
int get hashCode => Object.hash(runtimeType,channel,follow,favorite);

@override
String toString() {
  return 'ChannelDetailState(channel: $channel, follow: $follow, favorite: $favorite)';
}


}

/// @nodoc
abstract mixin class _$ChannelDetailStateCopyWith<$Res> implements $ChannelDetailStateCopyWith<$Res> {
  factory _$ChannelDetailStateCopyWith(_ChannelDetailState value, $Res Function(_ChannelDetailState) _then) = __$ChannelDetailStateCopyWithImpl;
@override @useResult
$Res call({
 CommunityChannel channel, AsyncValue<void>? follow, AsyncValue<void>? favorite
});


@override $CommunityChannelCopyWith<$Res> get channel;

}
/// @nodoc
class __$ChannelDetailStateCopyWithImpl<$Res>
    implements _$ChannelDetailStateCopyWith<$Res> {
  __$ChannelDetailStateCopyWithImpl(this._self, this._then);

  final _ChannelDetailState _self;
  final $Res Function(_ChannelDetailState) _then;

/// Create a copy of ChannelDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channel = null,Object? follow = freezed,Object? favorite = freezed,}) {
  return _then(_ChannelDetailState(
channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as CommunityChannel,follow: freezed == follow ? _self.follow : follow // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>?,favorite: freezed == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as AsyncValue<void>?,
  ));
}

/// Create a copy of ChannelDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommunityChannelCopyWith<$Res> get channel {
  
  return $CommunityChannelCopyWith<$Res>(_self.channel, (value) {
    return _then(_self.copyWith(channel: value));
  });
}
}

// dart format on
