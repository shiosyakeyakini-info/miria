// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'acct.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Acct {
  String get host;
  String get username;

  /// Create a copy of Acct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AcctCopyWith<Acct> get copyWith =>
      _$AcctCopyWithImpl<Acct>(this as Acct, _$identity);

  /// Serializes this Acct to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Acct &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, host, username);
}

/// @nodoc
abstract mixin class $AcctCopyWith<$Res> {
  factory $AcctCopyWith(Acct value, $Res Function(Acct) _then) =
      _$AcctCopyWithImpl;
  @useResult
  $Res call({String host, String username});
}

/// @nodoc
class _$AcctCopyWithImpl<$Res> implements $AcctCopyWith<$Res> {
  _$AcctCopyWithImpl(this._self, this._then);

  final Acct _self;
  final $Res Function(Acct) _then;

  /// Create a copy of Acct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? host = null,
    Object? username = null,
  }) {
    return _then(_self.copyWith(
      host: null == host
          ? _self.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Acct extends Acct {
  const _Acct({required this.host, required this.username}) : super._();
  factory _Acct.fromJson(Map<String, dynamic> json) => _$AcctFromJson(json);

  @override
  final String host;
  @override
  final String username;

  /// Create a copy of Acct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AcctCopyWith<_Acct> get copyWith =>
      __$AcctCopyWithImpl<_Acct>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AcctToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Acct &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, host, username);
}

/// @nodoc
abstract mixin class _$AcctCopyWith<$Res> implements $AcctCopyWith<$Res> {
  factory _$AcctCopyWith(_Acct value, $Res Function(_Acct) _then) =
      __$AcctCopyWithImpl;
  @override
  @useResult
  $Res call({String host, String username});
}

/// @nodoc
class __$AcctCopyWithImpl<$Res> implements _$AcctCopyWith<$Res> {
  __$AcctCopyWithImpl(this._self, this._then);

  final _Acct _self;
  final $Res Function(_Acct) _then;

  /// Create a copy of Acct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? host = null,
    Object? username = null,
  }) {
    return _then(_Acct(
      host: null == host
          ? _self.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _self.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
