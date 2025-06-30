// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Account {

 String get host; String get userId; MeDetailed get i; String? get token; MetaResponse? get meta; String? get scheme; int? get port;
/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountCopyWith<Account> get copyWith => _$AccountCopyWithImpl<Account>(this as Account, _$identity);

  /// Serializes this Account to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'Account(host: $host, userId: $userId, i: $i, token: $token, meta: $meta, scheme: $scheme, port: $port)';
}


}

/// @nodoc
abstract mixin class $AccountCopyWith<$Res>  {
  factory $AccountCopyWith(Account value, $Res Function(Account) _then) = _$AccountCopyWithImpl;
@useResult
$Res call({
 String host, String userId, MeDetailed i, String? token, MetaResponse? meta, String? scheme, int? port
});


$MeDetailedCopyWith<$Res> get i;$MetaResponseCopyWith<$Res>? get meta;

}
/// @nodoc
class _$AccountCopyWithImpl<$Res>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._self, this._then);

  final Account _self;
  final $Res Function(Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? host = null,Object? userId = null,Object? i = null,Object? token = freezed,Object? meta = freezed,Object? scheme = freezed,Object? port = freezed,}) {
  return _then(_self.copyWith(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,i: null == i ? _self.i : i // ignore: cast_nullable_to_non_nullable
as MeDetailed,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as MetaResponse?,scheme: freezed == scheme ? _self.scheme : scheme // ignore: cast_nullable_to_non_nullable
as String?,port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeDetailedCopyWith<$Res> get i {
  
  return $MeDetailedCopyWith<$Res>(_self.i, (value) {
    return _then(_self.copyWith(i: value));
  });
}/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaResponseCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $MetaResponseCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _Account extends Account {
  const _Account({required this.host, required this.userId, required this.i, this.token, this.meta, this.scheme, this.port}): super._();
  factory _Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

@override final  String host;
@override final  String userId;
@override final  MeDetailed i;
@override final  String? token;
@override final  MetaResponse? meta;
@override final  String? scheme;
@override final  int? port;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountCopyWith<_Account> get copyWith => __$AccountCopyWithImpl<_Account>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountToJson(this, );
}



@override
String toString() {
  return 'Account(host: $host, userId: $userId, i: $i, token: $token, meta: $meta, scheme: $scheme, port: $port)';
}


}

/// @nodoc
abstract mixin class _$AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$AccountCopyWith(_Account value, $Res Function(_Account) _then) = __$AccountCopyWithImpl;
@override @useResult
$Res call({
 String host, String userId, MeDetailed i, String? token, MetaResponse? meta, String? scheme, int? port
});


@override $MeDetailedCopyWith<$Res> get i;@override $MetaResponseCopyWith<$Res>? get meta;

}
/// @nodoc
class __$AccountCopyWithImpl<$Res>
    implements _$AccountCopyWith<$Res> {
  __$AccountCopyWithImpl(this._self, this._then);

  final _Account _self;
  final $Res Function(_Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? host = null,Object? userId = null,Object? i = null,Object? token = freezed,Object? meta = freezed,Object? scheme = freezed,Object? port = freezed,}) {
  return _then(_Account(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,i: null == i ? _self.i : i // ignore: cast_nullable_to_non_nullable
as MeDetailed,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as MetaResponse?,scheme: freezed == scheme ? _self.scheme : scheme // ignore: cast_nullable_to_non_nullable
as String?,port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeDetailedCopyWith<$Res> get i {
  
  return $MeDetailedCopyWith<$Res>(_self.i, (value) {
    return _then(_self.copyWith(i: value));
  });
}/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaResponseCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $MetaResponseCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
