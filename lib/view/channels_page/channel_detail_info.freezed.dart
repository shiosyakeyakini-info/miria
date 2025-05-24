// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

 CommunityChannel get channel;
/// Create a copy of ChannelDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelDetailStateCopyWith<ChannelDetailState> get copyWith => _$ChannelDetailStateCopyWithImpl<ChannelDetailState>(this as ChannelDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChannelDetailState&&(identical(other.channel, channel) || other.channel == channel));
}


@override
int get hashCode => Object.hash(runtimeType,channel);

@override
String toString() {
  return 'ChannelDetailState(channel: $channel)';
}


}

/// @nodoc
abstract mixin class $ChannelDetailStateCopyWith<$Res>  {
  factory $ChannelDetailStateCopyWith(ChannelDetailState value, $Res Function(ChannelDetailState) _then) = _$ChannelDetailStateCopyWithImpl;
@useResult
$Res call({
 CommunityChannel channel
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
@pragma('vm:prefer-inline') @override $Res call({Object? channel = null,}) {
  return _then(_self.copyWith(
channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as CommunityChannel,
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


/// @nodoc


class _ChannelDetailState implements ChannelDetailState {
   _ChannelDetailState({required this.channel});
  

@override final  CommunityChannel channel;

/// Create a copy of ChannelDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelDetailStateCopyWith<_ChannelDetailState> get copyWith => __$ChannelDetailStateCopyWithImpl<_ChannelDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChannelDetailState&&(identical(other.channel, channel) || other.channel == channel));
}


@override
int get hashCode => Object.hash(runtimeType,channel);

@override
String toString() {
  return 'ChannelDetailState(channel: $channel)';
}


}

/// @nodoc
abstract mixin class _$ChannelDetailStateCopyWith<$Res> implements $ChannelDetailStateCopyWith<$Res> {
  factory _$ChannelDetailStateCopyWith(_ChannelDetailState value, $Res Function(_ChannelDetailState) _then) = __$ChannelDetailStateCopyWithImpl;
@override @useResult
$Res call({
 CommunityChannel channel
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
@override @pragma('vm:prefer-inline') $Res call({Object? channel = null,}) {
  return _then(_ChannelDetailState(
channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as CommunityChannel,
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
