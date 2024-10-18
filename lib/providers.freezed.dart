// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AccountContext {
  /// 他鯖を取得するなどの目的で、非ログイン状態として使用されるアカウント
  Account get getAccount => throw _privateConstructorUsedError;
  Account get postAccount => throw _privateConstructorUsedError;

  /// Create a copy of AccountContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountContextCopyWith<AccountContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountContextCopyWith<$Res> {
  factory $AccountContextCopyWith(
          AccountContext value, $Res Function(AccountContext) then) =
      _$AccountContextCopyWithImpl<$Res, AccountContext>;
  @useResult
  $Res call({Account getAccount, Account postAccount});

  $AccountCopyWith<$Res> get getAccount;
  $AccountCopyWith<$Res> get postAccount;
}

/// @nodoc
class _$AccountContextCopyWithImpl<$Res, $Val extends AccountContext>
    implements $AccountContextCopyWith<$Res> {
  _$AccountContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? getAccount = null,
    Object? postAccount = null,
  }) {
    return _then(_value.copyWith(
      getAccount: null == getAccount
          ? _value.getAccount
          : getAccount // ignore: cast_nullable_to_non_nullable
              as Account,
      postAccount: null == postAccount
          ? _value.postAccount
          : postAccount // ignore: cast_nullable_to_non_nullable
              as Account,
    ) as $Val);
  }

  /// Create a copy of AccountContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountCopyWith<$Res> get getAccount {
    return $AccountCopyWith<$Res>(_value.getAccount, (value) {
      return _then(_value.copyWith(getAccount: value) as $Val);
    });
  }

  /// Create a copy of AccountContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountCopyWith<$Res> get postAccount {
    return $AccountCopyWith<$Res>(_value.postAccount, (value) {
      return _then(_value.copyWith(postAccount: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AccountContextImplCopyWith<$Res>
    implements $AccountContextCopyWith<$Res> {
  factory _$$AccountContextImplCopyWith(_$AccountContextImpl value,
          $Res Function(_$AccountContextImpl) then) =
      __$$AccountContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Account getAccount, Account postAccount});

  @override
  $AccountCopyWith<$Res> get getAccount;
  @override
  $AccountCopyWith<$Res> get postAccount;
}

/// @nodoc
class __$$AccountContextImplCopyWithImpl<$Res>
    extends _$AccountContextCopyWithImpl<$Res, _$AccountContextImpl>
    implements _$$AccountContextImplCopyWith<$Res> {
  __$$AccountContextImplCopyWithImpl(
      _$AccountContextImpl _value, $Res Function(_$AccountContextImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? getAccount = null,
    Object? postAccount = null,
  }) {
    return _then(_$AccountContextImpl(
      getAccount: null == getAccount
          ? _value.getAccount
          : getAccount // ignore: cast_nullable_to_non_nullable
              as Account,
      postAccount: null == postAccount
          ? _value.postAccount
          : postAccount // ignore: cast_nullable_to_non_nullable
              as Account,
    ));
  }
}

/// @nodoc

class _$AccountContextImpl extends _AccountContext {
  const _$AccountContextImpl(
      {required this.getAccount, required this.postAccount})
      : super._();

  /// 他鯖を取得するなどの目的で、非ログイン状態として使用されるアカウント
  @override
  final Account getAccount;
  @override
  final Account postAccount;

  @override
  String toString() {
    return 'AccountContext(getAccount: $getAccount, postAccount: $postAccount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountContextImpl &&
            (identical(other.getAccount, getAccount) ||
                other.getAccount == getAccount) &&
            (identical(other.postAccount, postAccount) ||
                other.postAccount == postAccount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, getAccount, postAccount);

  /// Create a copy of AccountContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountContextImplCopyWith<_$AccountContextImpl> get copyWith =>
      __$$AccountContextImplCopyWithImpl<_$AccountContextImpl>(
          this, _$identity);
}

abstract class _AccountContext extends AccountContext {
  const factory _AccountContext(
      {required final Account getAccount,
      required final Account postAccount}) = _$AccountContextImpl;
  const _AccountContext._() : super._();

  /// 他鯖を取得するなどの目的で、非ログイン状態として使用されるアカウント
  @override
  Account get getAccount;
  @override
  Account get postAccount;

  /// Create a copy of AccountContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountContextImplCopyWith<_$AccountContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
