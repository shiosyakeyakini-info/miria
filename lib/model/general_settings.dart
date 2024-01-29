import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'general_settings.freezed.dart';
part 'general_settings.g.dart';

enum ThemeColorSystem {
  forceLight,
  forceDark,
  system;

  String displayName(BuildContext context) {
    return switch (this) {
      ThemeColorSystem.forceLight => S.of(context).lightMode,
      ThemeColorSystem.forceDark => S.of(context).darkMode,
      ThemeColorSystem.system => S.of(context).syncWithSystem,
    };
  }
}

enum NSFWInherit {
  inherit,
  ignore,
  allHidden,
  removeNsfw;

  String displayName(BuildContext context) {
    return switch (this) {
      NSFWInherit.inherit => S.of(context).hideSensitiveMedia,
      NSFWInherit.ignore => S.of(context).showSensitiveMedia,
      NSFWInherit.allHidden => S.of(context).hideAllMedia,
      NSFWInherit.removeNsfw => S.of(context).removeSensitiveNotes,
    };
  }
}

enum AutomaticPush {
  automatic,
  none;

  String displayName(BuildContext context) {
    return switch (this) {
      AutomaticPush.automatic => S.of(context).enableInfiniteScroll,
      AutomaticPush.none => S.of(context).disableInfiniteScroll,
    };
  }
}

enum TabPosition {
  top,
  bottom;

  String displayName(BuildContext context) {
    return switch (this) {
      TabPosition.top => S.of(context).top,
      TabPosition.bottom => S.of(context).bottom,
    };
  }
}

enum EmojiType {
  twemoji,
  system;

  String displayName(BuildContext context) {
    return switch (this) {
      EmojiType.twemoji => "Twemoji",
      EmojiType.system => S.of(context).systemEmoji,
    };
  }
}

enum Languages {
  jaJP("日本語", "ja", "JP"),
  jaOJ("日本語（お嬢様）", "ja", "OJ");

  final String displayName;
  final String countryCode;
  final String languageCode;

  const Languages(this.displayName, this.countryCode, this.languageCode);
}

@freezed
class GeneralSettings with _$GeneralSettings {
  const factory GeneralSettings({
    @Default("") String lightColorThemeId,
    @Default("") String darkColorThemeId,
    @Default(ThemeColorSystem.system) ThemeColorSystem themeColorSystem,

    /// NSFW設定を継承する
    @Default(NSFWInherit.inherit) NSFWInherit nsfwInherit,

    /// ノートのカスタム絵文字直接タップでのリアクションを有効にする
    @Default(false) bool enableDirectReaction,

    /// TLの自動更新を有効にする
    @Default(AutomaticPush.none) AutomaticPush automaticPush,

    /// 動きのあるMFMを有効にする
    @Default(true) bool enableAnimatedMFM,

    /// 長いノートを省略する
    @Default(false) bool enableLongTextElipsed,

    /// リアクション済みノートを短くする
    @Default(true) bool enableFavoritedRenoteElipsed,

    /// タブの位置
    @Default(TabPosition.top) TabPosition tabPosition,

    /// 文字の大きさの倍率
    @Default(1.0) double textScaleFactor,

    /// 使用するUnicodeの絵文字種別
    @Default(EmojiType.twemoji) EmojiType emojiType,

    /// デフォルトのフォント名
    @Default("") String defaultFontName,

    /// `$[font.serif のフォント名
    @Default("") String serifFontName,

    /// `$[font.monospace およびコードブロックのフォント名
    @Default("") String monospaceFontName,

    /// `$[font.cursive のフォント名
    @Default("") String cursiveFontName,

    /// `$[font.fantasy のフォント名
    @Default("") String fantasyFontName,

    /// 言語設定
    @Default(Languages.jaJP) Languages languages,
  }) = _GeneralSettings;

  factory GeneralSettings.fromJson(Map<String, dynamic> json) =>
      _$GeneralSettingsFromJson(json);
}
