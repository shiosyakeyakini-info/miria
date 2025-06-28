// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
