// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_list_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsersListSettings {

 String get name; bool get isPublic;
/// Create a copy of UsersListSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsersListSettingsCopyWith<UsersListSettings> get copyWith => _$UsersListSettingsCopyWithImpl<UsersListSettings>(this as UsersListSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersListSettings&&(identical(other.name, name) || other.name == name)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic));
}


@override
int get hashCode => Object.hash(runtimeType,name,isPublic);

@override
String toString() {
  return 'UsersListSettings(name: $name, isPublic: $isPublic)';
}


}

/// @nodoc
abstract mixin class $UsersListSettingsCopyWith<$Res>  {
  factory $UsersListSettingsCopyWith(UsersListSettings value, $Res Function(UsersListSettings) _then) = _$UsersListSettingsCopyWithImpl;
@useResult
$Res call({
 String name, bool isPublic
});




}
/// @nodoc
class _$UsersListSettingsCopyWithImpl<$Res>
    implements $UsersListSettingsCopyWith<$Res> {
  _$UsersListSettingsCopyWithImpl(this._self, this._then);

  final UsersListSettings _self;
  final $Res Function(UsersListSettings) _then;

/// Create a copy of UsersListSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? isPublic = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UsersListSettings].
extension UsersListSettingsPatterns on UsersListSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsersListSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsersListSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsersListSettings value)  $default,){
final _that = this;
switch (_that) {
case _UsersListSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsersListSettings value)?  $default,){
final _that = this;
switch (_that) {
case _UsersListSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool isPublic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsersListSettings() when $default != null:
return $default(_that.name,_that.isPublic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool isPublic)  $default,) {final _that = this;
switch (_that) {
case _UsersListSettings():
return $default(_that.name,_that.isPublic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool isPublic)?  $default,) {final _that = this;
switch (_that) {
case _UsersListSettings() when $default != null:
return $default(_that.name,_that.isPublic);case _:
  return null;

}
}

}

/// @nodoc


class _UsersListSettings extends UsersListSettings {
  const _UsersListSettings({this.name = "", this.isPublic = false}): super._();
  

@override@JsonKey() final  String name;
@override@JsonKey() final  bool isPublic;

/// Create a copy of UsersListSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsersListSettingsCopyWith<_UsersListSettings> get copyWith => __$UsersListSettingsCopyWithImpl<_UsersListSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsersListSettings&&(identical(other.name, name) || other.name == name)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic));
}


@override
int get hashCode => Object.hash(runtimeType,name,isPublic);

@override
String toString() {
  return 'UsersListSettings(name: $name, isPublic: $isPublic)';
}


}

/// @nodoc
abstract mixin class _$UsersListSettingsCopyWith<$Res> implements $UsersListSettingsCopyWith<$Res> {
  factory _$UsersListSettingsCopyWith(_UsersListSettings value, $Res Function(_UsersListSettings) _then) = __$UsersListSettingsCopyWithImpl;
@override @useResult
$Res call({
 String name, bool isPublic
});




}
/// @nodoc
class __$UsersListSettingsCopyWithImpl<$Res>
    implements _$UsersListSettingsCopyWith<$Res> {
  __$UsersListSettingsCopyWithImpl(this._self, this._then);

  final _UsersListSettings _self;
  final $Res Function(_UsersListSettings) _then;

/// Create a copy of UsersListSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? isPublic = null,}) {
  return _then(_UsersListSettings(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
