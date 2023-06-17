// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'general_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GeneralSettings _$GeneralSettingsFromJson(Map<String, dynamic> json) {
  return _GeneralSettings.fromJson(json);
}

/// @nodoc
mixin _$GeneralSettings {
  String get lightColorThemeId => throw _privateConstructorUsedError;
  String get darkColorThemeId => throw _privateConstructorUsedError;
  ThemeColorSystem get themeColorSystem => throw _privateConstructorUsedError;
  NSFWInherit get nsfwInherit => throw _privateConstructorUsedError;
  bool get enableDirectReaction => throw _privateConstructorUsedError;
  AutomaticPush get automaticPush => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GeneralSettingsCopyWith<GeneralSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeneralSettingsCopyWith<$Res> {
  factory $GeneralSettingsCopyWith(
          GeneralSettings value, $Res Function(GeneralSettings) then) =
      _$GeneralSettingsCopyWithImpl<$Res, GeneralSettings>;
  @useResult
  $Res call(
      {String lightColorThemeId,
      String darkColorThemeId,
      ThemeColorSystem themeColorSystem,
      NSFWInherit nsfwInherit,
      bool enableDirectReaction,
      AutomaticPush automaticPush});
}

/// @nodoc
class _$GeneralSettingsCopyWithImpl<$Res, $Val extends GeneralSettings>
    implements $GeneralSettingsCopyWith<$Res> {
  _$GeneralSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lightColorThemeId = null,
    Object? darkColorThemeId = null,
    Object? themeColorSystem = null,
    Object? nsfwInherit = null,
    Object? enableDirectReaction = null,
    Object? automaticPush = null,
  }) {
    return _then(_value.copyWith(
      lightColorThemeId: null == lightColorThemeId
          ? _value.lightColorThemeId
          : lightColorThemeId // ignore: cast_nullable_to_non_nullable
              as String,
      darkColorThemeId: null == darkColorThemeId
          ? _value.darkColorThemeId
          : darkColorThemeId // ignore: cast_nullable_to_non_nullable
              as String,
      themeColorSystem: null == themeColorSystem
          ? _value.themeColorSystem
          : themeColorSystem // ignore: cast_nullable_to_non_nullable
              as ThemeColorSystem,
      nsfwInherit: null == nsfwInherit
          ? _value.nsfwInherit
          : nsfwInherit // ignore: cast_nullable_to_non_nullable
              as NSFWInherit,
      enableDirectReaction: null == enableDirectReaction
          ? _value.enableDirectReaction
          : enableDirectReaction // ignore: cast_nullable_to_non_nullable
              as bool,
      automaticPush: null == automaticPush
          ? _value.automaticPush
          : automaticPush // ignore: cast_nullable_to_non_nullable
              as AutomaticPush,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GeneralSettingsCopyWith<$Res>
    implements $GeneralSettingsCopyWith<$Res> {
  factory _$$_GeneralSettingsCopyWith(
          _$_GeneralSettings value, $Res Function(_$_GeneralSettings) then) =
      __$$_GeneralSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String lightColorThemeId,
      String darkColorThemeId,
      ThemeColorSystem themeColorSystem,
      NSFWInherit nsfwInherit,
      bool enableDirectReaction,
      AutomaticPush automaticPush});
}

/// @nodoc
class __$$_GeneralSettingsCopyWithImpl<$Res>
    extends _$GeneralSettingsCopyWithImpl<$Res, _$_GeneralSettings>
    implements _$$_GeneralSettingsCopyWith<$Res> {
  __$$_GeneralSettingsCopyWithImpl(
      _$_GeneralSettings _value, $Res Function(_$_GeneralSettings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lightColorThemeId = null,
    Object? darkColorThemeId = null,
    Object? themeColorSystem = null,
    Object? nsfwInherit = null,
    Object? enableDirectReaction = null,
    Object? automaticPush = null,
  }) {
    return _then(_$_GeneralSettings(
      lightColorThemeId: null == lightColorThemeId
          ? _value.lightColorThemeId
          : lightColorThemeId // ignore: cast_nullable_to_non_nullable
              as String,
      darkColorThemeId: null == darkColorThemeId
          ? _value.darkColorThemeId
          : darkColorThemeId // ignore: cast_nullable_to_non_nullable
              as String,
      themeColorSystem: null == themeColorSystem
          ? _value.themeColorSystem
          : themeColorSystem // ignore: cast_nullable_to_non_nullable
              as ThemeColorSystem,
      nsfwInherit: null == nsfwInherit
          ? _value.nsfwInherit
          : nsfwInherit // ignore: cast_nullable_to_non_nullable
              as NSFWInherit,
      enableDirectReaction: null == enableDirectReaction
          ? _value.enableDirectReaction
          : enableDirectReaction // ignore: cast_nullable_to_non_nullable
              as bool,
      automaticPush: null == automaticPush
          ? _value.automaticPush
          : automaticPush // ignore: cast_nullable_to_non_nullable
              as AutomaticPush,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GeneralSettings implements _GeneralSettings {
  const _$_GeneralSettings(
      {this.lightColorThemeId = "",
      this.darkColorThemeId = "",
      this.themeColorSystem = ThemeColorSystem.system,
      this.nsfwInherit = NSFWInherit.inherit,
      this.enableDirectReaction = false,
      this.automaticPush = AutomaticPush.none});

  factory _$_GeneralSettings.fromJson(Map<String, dynamic> json) =>
      _$$_GeneralSettingsFromJson(json);

  @override
  @JsonKey()
  final String lightColorThemeId;
  @override
  @JsonKey()
  final String darkColorThemeId;
  @override
  @JsonKey()
  final ThemeColorSystem themeColorSystem;
  @override
  @JsonKey()
  final NSFWInherit nsfwInherit;
  @override
  @JsonKey()
  final bool enableDirectReaction;
  @override
  @JsonKey()
  final AutomaticPush automaticPush;

  @override
  String toString() {
    return 'GeneralSettings(lightColorThemeId: $lightColorThemeId, darkColorThemeId: $darkColorThemeId, themeColorSystem: $themeColorSystem, nsfwInherit: $nsfwInherit, enableDirectReaction: $enableDirectReaction, automaticPush: $automaticPush)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GeneralSettings &&
            (identical(other.lightColorThemeId, lightColorThemeId) ||
                other.lightColorThemeId == lightColorThemeId) &&
            (identical(other.darkColorThemeId, darkColorThemeId) ||
                other.darkColorThemeId == darkColorThemeId) &&
            (identical(other.themeColorSystem, themeColorSystem) ||
                other.themeColorSystem == themeColorSystem) &&
            (identical(other.nsfwInherit, nsfwInherit) ||
                other.nsfwInherit == nsfwInherit) &&
            (identical(other.enableDirectReaction, enableDirectReaction) ||
                other.enableDirectReaction == enableDirectReaction) &&
            (identical(other.automaticPush, automaticPush) ||
                other.automaticPush == automaticPush));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      lightColorThemeId,
      darkColorThemeId,
      themeColorSystem,
      nsfwInherit,
      enableDirectReaction,
      automaticPush);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GeneralSettingsCopyWith<_$_GeneralSettings> get copyWith =>
      __$$_GeneralSettingsCopyWithImpl<_$_GeneralSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GeneralSettingsToJson(
      this,
    );
  }
}

abstract class _GeneralSettings implements GeneralSettings {
  const factory _GeneralSettings(
      {final String lightColorThemeId,
      final String darkColorThemeId,
      final ThemeColorSystem themeColorSystem,
      final NSFWInherit nsfwInherit,
      final bool enableDirectReaction,
      final AutomaticPush automaticPush}) = _$_GeneralSettings;

  factory _GeneralSettings.fromJson(Map<String, dynamic> json) =
      _$_GeneralSettings.fromJson;

  @override
  String get lightColorThemeId;
  @override
  String get darkColorThemeId;
  @override
  ThemeColorSystem get themeColorSystem;
  @override
  NSFWInherit get nsfwInherit;
  @override
  bool get enableDirectReaction;
  @override
  AutomaticPush get automaticPush;
  @override
  @JsonKey(ignore: true)
  _$$_GeneralSettingsCopyWith<_$_GeneralSettings> get copyWith =>
      throw _privateConstructorUsedError;
}
