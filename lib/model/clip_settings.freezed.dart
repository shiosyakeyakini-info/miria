// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clip_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ClipSettings {
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;

  /// Create a copy of ClipSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClipSettingsCopyWith<ClipSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClipSettingsCopyWith<$Res> {
  factory $ClipSettingsCopyWith(
          ClipSettings value, $Res Function(ClipSettings) then) =
      _$ClipSettingsCopyWithImpl<$Res, ClipSettings>;
  @useResult
  $Res call({String name, String? description, bool isPublic});
}

/// @nodoc
class _$ClipSettingsCopyWithImpl<$Res, $Val extends ClipSettings>
    implements $ClipSettingsCopyWith<$Res> {
  _$ClipSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClipSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
    Object? isPublic = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClipSettingsImplCopyWith<$Res>
    implements $ClipSettingsCopyWith<$Res> {
  factory _$$ClipSettingsImplCopyWith(
          _$ClipSettingsImpl value, $Res Function(_$ClipSettingsImpl) then) =
      __$$ClipSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String? description, bool isPublic});
}

/// @nodoc
class __$$ClipSettingsImplCopyWithImpl<$Res>
    extends _$ClipSettingsCopyWithImpl<$Res, _$ClipSettingsImpl>
    implements _$$ClipSettingsImplCopyWith<$Res> {
  __$$ClipSettingsImplCopyWithImpl(
      _$ClipSettingsImpl _value, $Res Function(_$ClipSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClipSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
    Object? isPublic = null,
  }) {
    return _then(_$ClipSettingsImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ClipSettingsImpl extends _ClipSettings {
  const _$ClipSettingsImpl(
      {this.name = "", this.description, this.isPublic = false})
      : super._();

  @override
  @JsonKey()
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final bool isPublic;

  @override
  String toString() {
    return 'ClipSettings(name: $name, description: $description, isPublic: $isPublic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClipSettingsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, description, isPublic);

  /// Create a copy of ClipSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClipSettingsImplCopyWith<_$ClipSettingsImpl> get copyWith =>
      __$$ClipSettingsImplCopyWithImpl<_$ClipSettingsImpl>(this, _$identity);
}

abstract class _ClipSettings extends ClipSettings {
  const factory _ClipSettings(
      {final String name,
      final String? description,
      final bool isPublic}) = _$ClipSettingsImpl;
  const _ClipSettings._() : super._();

  @override
  String get name;
  @override
  String? get description;
  @override
  bool get isPublic;

  /// Create a copy of ClipSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClipSettingsImplCopyWith<_$ClipSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
