// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_list_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UsersListSettings {
  String get name => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UsersListSettingsCopyWith<UsersListSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersListSettingsCopyWith<$Res> {
  factory $UsersListSettingsCopyWith(
          UsersListSettings value, $Res Function(UsersListSettings) then) =
      _$UsersListSettingsCopyWithImpl<$Res, UsersListSettings>;
  @useResult
  $Res call({String name, bool isPublic});
}

/// @nodoc
class _$UsersListSettingsCopyWithImpl<$Res, $Val extends UsersListSettings>
    implements $UsersListSettingsCopyWith<$Res> {
  _$UsersListSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? isPublic = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UsersListSettingsCopyWith<$Res>
    implements $UsersListSettingsCopyWith<$Res> {
  factory _$$_UsersListSettingsCopyWith(_$_UsersListSettings value,
          $Res Function(_$_UsersListSettings) then) =
      __$$_UsersListSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, bool isPublic});
}

/// @nodoc
class __$$_UsersListSettingsCopyWithImpl<$Res>
    extends _$UsersListSettingsCopyWithImpl<$Res, _$_UsersListSettings>
    implements _$$_UsersListSettingsCopyWith<$Res> {
  __$$_UsersListSettingsCopyWithImpl(
      _$_UsersListSettings _value, $Res Function(_$_UsersListSettings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? isPublic = null,
  }) {
    return _then(_$_UsersListSettings(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_UsersListSettings extends _UsersListSettings {
  const _$_UsersListSettings({this.name = "", this.isPublic = false})
      : super._();

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final bool isPublic;

  @override
  String toString() {
    return 'UsersListSettings(name: $name, isPublic: $isPublic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UsersListSettings &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, isPublic);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UsersListSettingsCopyWith<_$_UsersListSettings> get copyWith =>
      __$$_UsersListSettingsCopyWithImpl<_$_UsersListSettings>(
          this, _$identity);
}

abstract class _UsersListSettings extends UsersListSettings {
  const factory _UsersListSettings({final String name, final bool isPublic}) =
      _$_UsersListSettings;
  const _UsersListSettings._() : super._();

  @override
  String get name;
  @override
  bool get isPublic;
  @override
  @JsonKey(ignore: true)
  _$$_UsersListSettingsCopyWith<_$_UsersListSettings> get copyWith =>
      throw _privateConstructorUsedError;
}
