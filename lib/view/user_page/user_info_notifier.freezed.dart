// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserInfo {

 String get userId; UserDetailed get response; String? get remoteUserId; UserDetailed? get remoteResponse; MetaResponse? get metaResponse;
/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserInfoCopyWith<UserInfo> get copyWith => _$UserInfoCopyWithImpl<UserInfo>(this as UserInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserInfo&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.response, response) || other.response == response)&&(identical(other.remoteUserId, remoteUserId) || other.remoteUserId == remoteUserId)&&(identical(other.remoteResponse, remoteResponse) || other.remoteResponse == remoteResponse)&&(identical(other.metaResponse, metaResponse) || other.metaResponse == metaResponse));
}


@override
int get hashCode => Object.hash(runtimeType,userId,response,remoteUserId,remoteResponse,metaResponse);

@override
String toString() {
  return 'UserInfo(userId: $userId, response: $response, remoteUserId: $remoteUserId, remoteResponse: $remoteResponse, metaResponse: $metaResponse)';
}


}

/// @nodoc
abstract mixin class $UserInfoCopyWith<$Res>  {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) _then) = _$UserInfoCopyWithImpl;
@useResult
$Res call({
 String userId, UserDetailed response, String? remoteUserId, UserDetailed? remoteResponse, MetaResponse? metaResponse
});


$MetaResponseCopyWith<$Res>? get metaResponse;

}
/// @nodoc
class _$UserInfoCopyWithImpl<$Res>
    implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._self, this._then);

  final UserInfo _self;
  final $Res Function(UserInfo) _then;

/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? response = null,Object? remoteUserId = freezed,Object? remoteResponse = freezed,Object? metaResponse = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,response: null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as UserDetailed,remoteUserId: freezed == remoteUserId ? _self.remoteUserId : remoteUserId // ignore: cast_nullable_to_non_nullable
as String?,remoteResponse: freezed == remoteResponse ? _self.remoteResponse : remoteResponse // ignore: cast_nullable_to_non_nullable
as UserDetailed?,metaResponse: freezed == metaResponse ? _self.metaResponse : metaResponse // ignore: cast_nullable_to_non_nullable
as MetaResponse?,
  ));
}
/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaResponseCopyWith<$Res>? get metaResponse {
    if (_self.metaResponse == null) {
    return null;
  }

  return $MetaResponseCopyWith<$Res>(_self.metaResponse!, (value) {
    return _then(_self.copyWith(metaResponse: value));
  });
}
}


/// @nodoc


class _UserInfo extends UserInfo {
  const _UserInfo({required this.userId, required this.response, this.remoteUserId, this.remoteResponse, this.metaResponse}): super._();
  

@override final  String userId;
@override final  UserDetailed response;
@override final  String? remoteUserId;
@override final  UserDetailed? remoteResponse;
@override final  MetaResponse? metaResponse;

/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserInfoCopyWith<_UserInfo> get copyWith => __$UserInfoCopyWithImpl<_UserInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserInfo&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.response, response) || other.response == response)&&(identical(other.remoteUserId, remoteUserId) || other.remoteUserId == remoteUserId)&&(identical(other.remoteResponse, remoteResponse) || other.remoteResponse == remoteResponse)&&(identical(other.metaResponse, metaResponse) || other.metaResponse == metaResponse));
}


@override
int get hashCode => Object.hash(runtimeType,userId,response,remoteUserId,remoteResponse,metaResponse);

@override
String toString() {
  return 'UserInfo(userId: $userId, response: $response, remoteUserId: $remoteUserId, remoteResponse: $remoteResponse, metaResponse: $metaResponse)';
}


}

/// @nodoc
abstract mixin class _$UserInfoCopyWith<$Res> implements $UserInfoCopyWith<$Res> {
  factory _$UserInfoCopyWith(_UserInfo value, $Res Function(_UserInfo) _then) = __$UserInfoCopyWithImpl;
@override @useResult
$Res call({
 String userId, UserDetailed response, String? remoteUserId, UserDetailed? remoteResponse, MetaResponse? metaResponse
});


@override $MetaResponseCopyWith<$Res>? get metaResponse;

}
/// @nodoc
class __$UserInfoCopyWithImpl<$Res>
    implements _$UserInfoCopyWith<$Res> {
  __$UserInfoCopyWithImpl(this._self, this._then);

  final _UserInfo _self;
  final $Res Function(_UserInfo) _then;

/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? response = null,Object? remoteUserId = freezed,Object? remoteResponse = freezed,Object? metaResponse = freezed,}) {
  return _then(_UserInfo(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,response: null == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as UserDetailed,remoteUserId: freezed == remoteUserId ? _self.remoteUserId : remoteUserId // ignore: cast_nullable_to_non_nullable
as String?,remoteResponse: freezed == remoteResponse ? _self.remoteResponse : remoteResponse // ignore: cast_nullable_to_non_nullable
as UserDetailed?,metaResponse: freezed == metaResponse ? _self.metaResponse : metaResponse // ignore: cast_nullable_to_non_nullable
as MetaResponse?,
  ));
}

/// Create a copy of UserInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaResponseCopyWith<$Res>? get metaResponse {
    if (_self.metaResponse == null) {
    return null;
  }

  return $MetaResponseCopyWith<$Res>(_self.metaResponse!, (value) {
    return _then(_self.copyWith(metaResponse: value));
  });
}
}

// dart format on
