// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeneralSettings _$GeneralSettingsFromJson(Map<String, dynamic> json) =>
    _GeneralSettings(
      lightColorThemeId: json['lightColorThemeId'] as String? ?? "",
      darkColorThemeId: json['darkColorThemeId'] as String? ?? "",
      themeColorSystem:
          $enumDecodeNullable(
            _$ThemeColorSystemEnumMap,
            json['themeColorSystem'],
          ) ??
          ThemeColorSystem.system,
      nsfwInherit:
          $enumDecodeNullable(_$NSFWInheritEnumMap, json['nsfwInherit']) ??
          NSFWInherit.inherit,
      enableDirectReaction: json['enableDirectReaction'] as bool? ?? false,
      automaticPush:
          $enumDecodeNullable(_$AutomaticPushEnumMap, json['automaticPush']) ??
          AutomaticPush.none,
      enableAnimatedMFM: json['enableAnimatedMFM'] as bool? ?? true,
      enableLongTextElipsed: json['enableLongTextElipsed'] as bool? ?? false,
      enableFavoritedRenoteElipsed:
          json['enableFavoritedRenoteElipsed'] as bool? ?? true,
      tabPosition:
          $enumDecodeNullable(_$TabPositionEnumMap, json['tabPosition']) ??
          TabPosition.top,
      textScaleFactor: (json['textScaleFactor'] as num?)?.toDouble() ?? 1.0,
      bubbleGameBgmVolume:
          (json['bubbleGameBgmVolume'] as num?)?.toDouble() ?? 0.25,
      bubbleGameSfxVolume:
          (json['bubbleGameSfxVolume'] as num?)?.toDouble() ?? 1.0,
      emojiType:
          $enumDecodeNullable(_$EmojiTypeEnumMap, json['emojiType']) ??
          EmojiType.twemoji,
      defaultFontName: json['defaultFontName'] as String? ?? "",
      serifFontName: json['serifFontName'] as String? ?? "",
      monospaceFontName: json['monospaceFontName'] as String? ?? "",
      cursiveFontName: json['cursiveFontName'] as String? ?? "",
      fantasyFontName: json['fantasyFontName'] as String? ?? "",
      languages:
          $enumDecodeNullable(_$LanguagesEnumMap, json['languages']) ??
          Languages.jaJP,
      isDeckMode: json['isDeckMode'] as bool? ?? false,
      lightNoteBackgroundPublic: json['lightNoteBackgroundPublic'] == null
          ? null
          : const ColorConverter().fromJson(
              (json['lightNoteBackgroundPublic'] as num?)?.toInt(),
            ),
      lightNoteBackgroundHome: json['lightNoteBackgroundHome'] == null
          ? null
          : const ColorConverter().fromJson(
              (json['lightNoteBackgroundHome'] as num?)?.toInt(),
            ),
      lightNoteBackgroundFollowers: json['lightNoteBackgroundFollowers'] == null
          ? null
          : const ColorConverter().fromJson(
              (json['lightNoteBackgroundFollowers'] as num?)?.toInt(),
            ),
      lightNoteBackgroundDirect: json['lightNoteBackgroundDirect'] == null
          ? null
          : const ColorConverter().fromJson(
              (json['lightNoteBackgroundDirect'] as num?)?.toInt(),
            ),
      darkNoteBackgroundPublic: json['darkNoteBackgroundPublic'] == null
          ? null
          : const ColorConverter().fromJson(
              (json['darkNoteBackgroundPublic'] as num?)?.toInt(),
            ),
      darkNoteBackgroundHome: json['darkNoteBackgroundHome'] == null
          ? null
          : const ColorConverter().fromJson(
              (json['darkNoteBackgroundHome'] as num?)?.toInt(),
            ),
      darkNoteBackgroundFollowers: json['darkNoteBackgroundFollowers'] == null
          ? null
          : const ColorConverter().fromJson(
              (json['darkNoteBackgroundFollowers'] as num?)?.toInt(),
            ),
      darkNoteBackgroundDirect: json['darkNoteBackgroundDirect'] == null
          ? null
          : const ColorConverter().fromJson(
              (json['darkNoteBackgroundDirect'] as num?)?.toInt(),
            ),
    );

Map<String, dynamic> _$GeneralSettingsToJson(_GeneralSettings instance) =>
    <String, dynamic>{
      'lightColorThemeId': instance.lightColorThemeId,
      'darkColorThemeId': instance.darkColorThemeId,
      'themeColorSystem': _$ThemeColorSystemEnumMap[instance.themeColorSystem]!,
      'nsfwInherit': _$NSFWInheritEnumMap[instance.nsfwInherit]!,
      'enableDirectReaction': instance.enableDirectReaction,
      'automaticPush': _$AutomaticPushEnumMap[instance.automaticPush]!,
      'enableAnimatedMFM': instance.enableAnimatedMFM,
      'enableLongTextElipsed': instance.enableLongTextElipsed,
      'enableFavoritedRenoteElipsed': instance.enableFavoritedRenoteElipsed,
      'tabPosition': _$TabPositionEnumMap[instance.tabPosition]!,
      'textScaleFactor': instance.textScaleFactor,
      'bubbleGameBgmVolume': instance.bubbleGameBgmVolume,
      'bubbleGameSfxVolume': instance.bubbleGameSfxVolume,
      'emojiType': _$EmojiTypeEnumMap[instance.emojiType]!,
      'defaultFontName': instance.defaultFontName,
      'serifFontName': instance.serifFontName,
      'monospaceFontName': instance.monospaceFontName,
      'cursiveFontName': instance.cursiveFontName,
      'fantasyFontName': instance.fantasyFontName,
      'languages': _$LanguagesEnumMap[instance.languages]!,
      'isDeckMode': instance.isDeckMode,
      'lightNoteBackgroundPublic': const ColorConverter().toJson(
        instance.lightNoteBackgroundPublic,
      ),
      'lightNoteBackgroundHome': const ColorConverter().toJson(
        instance.lightNoteBackgroundHome,
      ),
      'lightNoteBackgroundFollowers': const ColorConverter().toJson(
        instance.lightNoteBackgroundFollowers,
      ),
      'lightNoteBackgroundDirect': const ColorConverter().toJson(
        instance.lightNoteBackgroundDirect,
      ),
      'darkNoteBackgroundPublic': const ColorConverter().toJson(
        instance.darkNoteBackgroundPublic,
      ),
      'darkNoteBackgroundHome': const ColorConverter().toJson(
        instance.darkNoteBackgroundHome,
      ),
      'darkNoteBackgroundFollowers': const ColorConverter().toJson(
        instance.darkNoteBackgroundFollowers,
      ),
      'darkNoteBackgroundDirect': const ColorConverter().toJson(
        instance.darkNoteBackgroundDirect,
      ),
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

const _$AutomaticPushEnumMap = {
  AutomaticPush.automatic: 'automatic',
  AutomaticPush.none: 'none',
};

const _$TabPositionEnumMap = {
  TabPosition.top: 'top',
  TabPosition.bottom: 'bottom',
};

const _$EmojiTypeEnumMap = {
  EmojiType.twemoji: 'twemoji',
  EmojiType.system: 'system',
};

const _$LanguagesEnumMap = {
  Languages.jaJP: 'jaJP',
  Languages.jaOJ: 'jaOJ',
  Languages.zhCN: 'zhCN',
};
