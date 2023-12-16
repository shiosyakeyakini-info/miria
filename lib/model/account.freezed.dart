// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Account _$AccountFromJson(Map<String, dynamic> json) {
  return _Account.fromJson(json);
}

/// @nodoc
mixin _$Account {
  String get host => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  IResponse get i => throw _privateConstructorUsedError;
  MetaResponse? get meta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call(
      {String host,
      String userId,
      String? token,
      IResponse i,
      MetaResponse? meta});

  $IResponseCopyWith<$Res> get i;
  $MetaResponseCopyWith<$Res>? get meta;
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? host = null,
    Object? userId = null,
    Object? token = freezed,
    Object? i = null,
    Object? meta = freezed,
  }) {
    return _then(_value.copyWith(
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      i: null == i
          ? _value.i
          : i // ignore: cast_nullable_to_non_nullable
              as IResponse,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MetaResponse?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $IResponseCopyWith<$Res> get i {
    return $IResponseCopyWith<$Res>(_value.i, (value) {
      return _then(_value.copyWith(i: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MetaResponseCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $MetaResponseCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$_AccountCopyWith(
          _$_Account value, $Res Function(_$_Account) then) =
      __$$_AccountCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String host,
      String userId,
      String? token,
      IResponse i,
      MetaResponse? meta});

  @override
  $IResponseCopyWith<$Res> get i;
  @override
  $MetaResponseCopyWith<$Res>? get meta;
}

/// @nodoc
class __$$_AccountCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$_Account>
    implements _$$_AccountCopyWith<$Res> {
  __$$_AccountCopyWithImpl(_$_Account _value, $Res Function(_$_Account) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? host = null,
    Object? userId = null,
    Object? token = freezed,
    Object? i = null,
    Object? meta = freezed,
  }) {
    return _then(_$_Account(
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      i: null == i
          ? _value.i
          : i // ignore: cast_nullable_to_non_nullable
              as IResponse,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MetaResponse?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Account extends _Account {
  const _$_Account(
      {required this.host,
      required this.userId,
      this.token,
      required this.i,
      this.meta})
      : super._();

  factory _$_Account.fromJson(Map<String, dynamic> json) =>
      _$$_AccountFromJson(json);

  @override
  final String host;
  @override
  final String userId;
  @override
  final String? token;
  @override
  final IResponse i;
  @override
  final MetaResponse? meta;

  @override
  String toString() {
    return 'Account(host: $host, userId: $userId, token: $token, i: $i, meta: $meta)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AccountCopyWith<_$_Account> get copyWith =>
      __$$_AccountCopyWithImpl<_$_Account>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AccountToJson(
      this,
    );
  }
}

abstract class _Account extends Account {
  const factory _Account(
      {required final String host,
      required final String userId,
      final String? token,
      required final IResponse i,
      final MetaResponse? meta}) = _$_Account;
  const _Account._() : super._();

  factory _Account.fromJson(Map<String, dynamic> json) = _$_Account.fromJson;

  @override
  String get host;
  @override
  String get userId;
  @override
  String? get token;
  @override
  IResponse get i;
  @override
  MetaResponse? get meta;
  @override
  @JsonKey(ignore: true)
  _$$_AccountCopyWith<_$_Account> get copyWith =>
      throw _privateConstructorUsedError;
}
