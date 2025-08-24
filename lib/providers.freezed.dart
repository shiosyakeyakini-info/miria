// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountContext {

/// 他鯖を取得するなどの目的で、非ログイン状態として使用されるアカウント
 Account get getAccount; Account get postAccount;
/// Create a copy of AccountContext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountContextCopyWith<AccountContext> get copyWith => _$AccountContextCopyWithImpl<AccountContext>(this as AccountContext, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountContext&&(identical(other.getAccount, getAccount) || other.getAccount == getAccount)&&(identical(other.postAccount, postAccount) || other.postAccount == postAccount));
}


@override
int get hashCode => Object.hash(runtimeType,getAccount,postAccount);

@override
String toString() {
  return 'AccountContext(getAccount: $getAccount, postAccount: $postAccount)';
}


}

/// @nodoc
abstract mixin class $AccountContextCopyWith<$Res>  {
  factory $AccountContextCopyWith(AccountContext value, $Res Function(AccountContext) _then) = _$AccountContextCopyWithImpl;
@useResult
$Res call({
 Account getAccount, Account postAccount
});


$AccountCopyWith<$Res> get getAccount;$AccountCopyWith<$Res> get postAccount;

}
/// @nodoc
class _$AccountContextCopyWithImpl<$Res>
    implements $AccountContextCopyWith<$Res> {
  _$AccountContextCopyWithImpl(this._self, this._then);

  final AccountContext _self;
  final $Res Function(AccountContext) _then;

/// Create a copy of AccountContext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? getAccount = null,Object? postAccount = null,}) {
  return _then(_self.copyWith(
getAccount: null == getAccount ? _self.getAccount : getAccount // ignore: cast_nullable_to_non_nullable
as Account,postAccount: null == postAccount ? _self.postAccount : postAccount // ignore: cast_nullable_to_non_nullable
as Account,
  ));
}
/// Create a copy of AccountContext
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountCopyWith<$Res> get getAccount {
  
  return $AccountCopyWith<$Res>(_self.getAccount, (value) {
    return _then(_self.copyWith(getAccount: value));
  });
}/// Create a copy of AccountContext
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountCopyWith<$Res> get postAccount {
  
  return $AccountCopyWith<$Res>(_self.postAccount, (value) {
    return _then(_self.copyWith(postAccount: value));
  });
}
}


/// Adds pattern-matching-related methods to [AccountContext].
extension AccountContextPatterns on AccountContext {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccountContext value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccountContext() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccountContext value)  $default,){
final _that = this;
switch (_that) {
case _AccountContext():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccountContext value)?  $default,){
final _that = this;
switch (_that) {
case _AccountContext() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Account getAccount,  Account postAccount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccountContext() when $default != null:
return $default(_that.getAccount,_that.postAccount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Account getAccount,  Account postAccount)  $default,) {final _that = this;
switch (_that) {
case _AccountContext():
return $default(_that.getAccount,_that.postAccount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Account getAccount,  Account postAccount)?  $default,) {final _that = this;
switch (_that) {
case _AccountContext() when $default != null:
return $default(_that.getAccount,_that.postAccount);case _:
  return null;

}
}

}

/// @nodoc


class _AccountContext extends AccountContext {
  const _AccountContext({required this.getAccount, required this.postAccount}): super._();
  

/// 他鯖を取得するなどの目的で、非ログイン状態として使用されるアカウント
@override final  Account getAccount;
@override final  Account postAccount;

/// Create a copy of AccountContext
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountContextCopyWith<_AccountContext> get copyWith => __$AccountContextCopyWithImpl<_AccountContext>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountContext&&(identical(other.getAccount, getAccount) || other.getAccount == getAccount)&&(identical(other.postAccount, postAccount) || other.postAccount == postAccount));
}


@override
int get hashCode => Object.hash(runtimeType,getAccount,postAccount);

@override
String toString() {
  return 'AccountContext(getAccount: $getAccount, postAccount: $postAccount)';
}


}

/// @nodoc
abstract mixin class _$AccountContextCopyWith<$Res> implements $AccountContextCopyWith<$Res> {
  factory _$AccountContextCopyWith(_AccountContext value, $Res Function(_AccountContext) _then) = __$AccountContextCopyWithImpl;
@override @useResult
$Res call({
 Account getAccount, Account postAccount
});


@override $AccountCopyWith<$Res> get getAccount;@override $AccountCopyWith<$Res> get postAccount;

}
/// @nodoc
class __$AccountContextCopyWithImpl<$Res>
    implements _$AccountContextCopyWith<$Res> {
  __$AccountContextCopyWithImpl(this._self, this._then);

  final _AccountContext _self;
  final $Res Function(_AccountContext) _then;

/// Create a copy of AccountContext
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? getAccount = null,Object? postAccount = null,}) {
  return _then(_AccountContext(
getAccount: null == getAccount ? _self.getAccount : getAccount // ignore: cast_nullable_to_non_nullable
as Account,postAccount: null == postAccount ? _self.postAccount : postAccount // ignore: cast_nullable_to_non_nullable
as Account,
  ));
}

/// Create a copy of AccountContext
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountCopyWith<$Res> get getAccount {
  
  return $AccountCopyWith<$Res>(_self.getAccount, (value) {
    return _then(_self.copyWith(getAccount: value));
  });
}/// Create a copy of AccountContext
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountCopyWith<$Res> get postAccount {
  
  return $AccountCopyWith<$Res>(_self.postAccount, (value) {
    return _then(_self.copyWith(postAccount: value));
  });
}
}

// dart format on
