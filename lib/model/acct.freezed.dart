// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'acct.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Acct _$AcctFromJson(Map<String, dynamic> json) {
  return _Acct.fromJson(json);
}

/// @nodoc
mixin _$Acct {
  String get host => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AcctCopyWith<Acct> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AcctCopyWith<$Res> {
  factory $AcctCopyWith(Acct value, $Res Function(Acct) then) =
      _$AcctCopyWithImpl<$Res, Acct>;
  @useResult
  $Res call({String host, String username});
}

/// @nodoc
class _$AcctCopyWithImpl<$Res, $Val extends Acct>
    implements $AcctCopyWith<$Res> {
  _$AcctCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? host = null,
    Object? username = null,
  }) {
    return _then(_value.copyWith(
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AcctImplCopyWith<$Res> implements $AcctCopyWith<$Res> {
  factory _$$AcctImplCopyWith(
          _$AcctImpl value, $Res Function(_$AcctImpl) then) =
      __$$AcctImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String host, String username});
}

/// @nodoc
class __$$AcctImplCopyWithImpl<$Res>
    extends _$AcctCopyWithImpl<$Res, _$AcctImpl>
    implements _$$AcctImplCopyWith<$Res> {
  __$$AcctImplCopyWithImpl(_$AcctImpl _value, $Res Function(_$AcctImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? host = null,
    Object? username = null,
  }) {
    return _then(_$AcctImpl(
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AcctImpl extends _Acct {
  const _$AcctImpl({required this.host, required this.username}) : super._();

  factory _$AcctImpl.fromJson(Map<String, dynamic> json) =>
      _$$AcctImplFromJson(json);

  @override
  final String host;
  @override
  final String username;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AcctImpl &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, host, username);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AcctImplCopyWith<_$AcctImpl> get copyWith =>
      __$$AcctImplCopyWithImpl<_$AcctImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AcctImplToJson(
      this,
    );
  }
}

abstract class _Acct extends Acct {
  const factory _Acct(
      {required final String host,
      required final String username}) = _$AcctImpl;
  const _Acct._() : super._();

  factory _Acct.fromJson(Map<String, dynamic> json) = _$AcctImpl.fromJson;

  @override
  String get host;
  @override
  String get username;
  @override
  @JsonKey(ignore: true)
  _$$AcctImplCopyWith<_$AcctImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
