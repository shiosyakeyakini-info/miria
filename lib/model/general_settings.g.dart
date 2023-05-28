// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GeneralSettings _$$_GeneralSettingsFromJson(Map<String, dynamic> json) =>
    _$_GeneralSettings(
      lightColorThemeId: json['lightColorThemeId'] as String? ?? "",
      darkColorThemeId: json['darkColorThemeId'] as String? ?? "",
      themeColorSystem: $enumDecodeNullable(
              _$ThemeColorSystemEnumMap, json['themeColorSystem']) ??
          ThemeColorSystem.system,
      nsfwInherit:
          $enumDecodeNullable(_$NSFWInheritEnumMap, json['nsfwInherit']) ??
              NSFWInherit.inherit,
    );

Map<String, dynamic> _$$_GeneralSettingsToJson(_$_GeneralSettings instance) =>
    <String, dynamic>{
      'lightColorThemeId': instance.lightColorThemeId,
      'darkColorThemeId': instance.darkColorThemeId,
      'themeColorSystem': _$ThemeColorSystemEnumMap[instance.themeColorSystem]!,
      'nsfwInherit': _$NSFWInheritEnumMap[instance.nsfwInherit]!,
    };

const _$ThemeColorSystemEnumMap = {
  ThemeColorSystem.forceLight: 'forceLight',
  ThemeColorSystem.forceDark: 'forceDark',
  ThemeColorSystem.system: 'system',
};

const _$NSFWInheritEnumMap = {
  NSFWInherit.inherit: 'inherit',
  NSFWInherit.ignore: 'ignore',
  NSFWInherit.allHidden: 'allHidden',
  NSFWInherit.removeNsfw: 'removeNsfw',
};
