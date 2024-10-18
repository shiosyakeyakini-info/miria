// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_detail_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChannelDetailState {
  CommunityChannel get channel => throw _privateConstructorUsedError;
  AsyncValue<void>? get follow => throw _privateConstructorUsedError;
  AsyncValue<void>? get favorite => throw _privateConstructorUsedError;

  /// Create a copy of ChannelDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChannelDetailStateCopyWith<ChannelDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChannelDetailStateCopyWith<$Res> {
  factory $ChannelDetailStateCopyWith(
          ChannelDetailState value, $Res Function(ChannelDetailState) then) =
      _$ChannelDetailStateCopyWithImpl<$Res, ChannelDetailState>;
  @useResult
  $Res call(
      {CommunityChannel channel,
      AsyncValue<void>? follow,
      AsyncValue<void>? favorite});

  $CommunityChannelCopyWith<$Res> get channel;
}

/// @nodoc
class _$ChannelDetailStateCopyWithImpl<$Res, $Val extends ChannelDetailState>
    implements $ChannelDetailStateCopyWith<$Res> {
  _$ChannelDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChannelDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? follow = freezed,
    Object? favorite = freezed,
  }) {
    return _then(_value.copyWith(
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as CommunityChannel,
      follow: freezed == follow
          ? _value.follow
          : follow // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      favorite: freezed == favorite
          ? _value.favorite
          : favorite // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
    ) as $Val);
  }

  /// Create a copy of ChannelDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommunityChannelCopyWith<$Res> get channel {
    return $CommunityChannelCopyWith<$Res>(_value.channel, (value) {
      return _then(_value.copyWith(channel: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChannelDetailStateImplCopyWith<$Res>
    implements $ChannelDetailStateCopyWith<$Res> {
  factory _$$ChannelDetailStateImplCopyWith(_$ChannelDetailStateImpl value,
          $Res Function(_$ChannelDetailStateImpl) then) =
      __$$ChannelDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CommunityChannel channel,
      AsyncValue<void>? follow,
      AsyncValue<void>? favorite});

  @override
  $CommunityChannelCopyWith<$Res> get channel;
}

/// @nodoc
class __$$ChannelDetailStateImplCopyWithImpl<$Res>
    extends _$ChannelDetailStateCopyWithImpl<$Res, _$ChannelDetailStateImpl>
    implements _$$ChannelDetailStateImplCopyWith<$Res> {
  __$$ChannelDetailStateImplCopyWithImpl(_$ChannelDetailStateImpl _value,
      $Res Function(_$ChannelDetailStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChannelDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? follow = freezed,
    Object? favorite = freezed,
  }) {
    return _then(_$ChannelDetailStateImpl(
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as CommunityChannel,
      follow: freezed == follow
          ? _value.follow
          : follow // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      favorite: freezed == favorite
          ? _value.favorite
          : favorite // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
    ));
  }
}

/// @nodoc

class _$ChannelDetailStateImpl implements _ChannelDetailState {
  _$ChannelDetailStateImpl({required this.channel, this.follow, this.favorite});

  @override
  final CommunityChannel channel;
  @override
  final AsyncValue<void>? follow;
  @override
  final AsyncValue<void>? favorite;

  @override
  String toString() {
    return 'ChannelDetailState(channel: $channel, follow: $follow, favorite: $favorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChannelDetailStateImpl &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.follow, follow) || other.follow == follow) &&
            (identical(other.favorite, favorite) ||
                other.favorite == favorite));
  }

  @override
  int get hashCode => Object.hash(runtimeType, channel, follow, favorite);

  /// Create a copy of ChannelDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChannelDetailStateImplCopyWith<_$ChannelDetailStateImpl> get copyWith =>
      __$$ChannelDetailStateImplCopyWithImpl<_$ChannelDetailStateImpl>(
          this, _$identity);
}

abstract class _ChannelDetailState implements ChannelDetailState {
  factory _ChannelDetailState(
      {required final CommunityChannel channel,
      final AsyncValue<void>? follow,
      final AsyncValue<void>? favorite}) = _$ChannelDetailStateImpl;

  @override
  CommunityChannel get channel;
  @override
  AsyncValue<void>? get follow;
  @override
  AsyncValue<void>? get favorite;

  /// Create a copy of ChannelDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChannelDetailStateImplCopyWith<_$ChannelDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
