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
abstract class _$$UsersListSettingsImplCopyWith<$Res>
    implements $UsersListSettingsCopyWith<$Res> {
  factory _$$UsersListSettingsImplCopyWith(_$UsersListSettingsImpl value,
          $Res Function(_$UsersListSettingsImpl) then) =
      __$$UsersListSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, bool isPublic});
}

/// @nodoc
class __$$UsersListSettingsImplCopyWithImpl<$Res>
    extends _$UsersListSettingsCopyWithImpl<$Res, _$UsersListSettingsImpl>
    implements _$$UsersListSettingsImplCopyWith<$Res> {
  __$$UsersListSettingsImplCopyWithImpl(_$UsersListSettingsImpl _value,
      $Res Function(_$UsersListSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? isPublic = null,
  }) {
    return _then(_$UsersListSettingsImpl(
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

class _$UsersListSettingsImpl extends _UsersListSettings {
  const _$UsersListSettingsImpl({this.name = "", this.isPublic = false})
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
            other is _$UsersListSettingsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, isPublic);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UsersListSettingsImplCopyWith<_$UsersListSettingsImpl> get copyWith =>
      __$$UsersListSettingsImplCopyWithImpl<_$UsersListSettingsImpl>(
          this, _$identity);
}

abstract class _UsersListSettings extends UsersListSettings {
  const factory _UsersListSettings({final String name, final bool isPublic}) =
      _$UsersListSettingsImpl;
  const _UsersListSettings._() : super._();

  @override
  String get name;
  @override
  bool get isPublic;
  @override
  @JsonKey(ignore: true)
  _$$UsersListSettingsImplCopyWith<_$UsersListSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
