import 'package:freezed_annotation/freezed_annotation.dart';

part 'general_settings.freezed.dart';
part 'general_settings.g.dart';

enum ThemeColorSystem {
  forceLight("ライトモード"),
  forceDark("ダークモード"),
  system("デバイスの設定にしたがう");

  final String displayName;

  const ThemeColorSystem(this.displayName);
}

enum NSFWInherit {
  inherit("閲覧注意のメディアは隠す"),
  ignore("閲覧注意のメディアを隠さない"),
  allHidden("常にメディアを隠す"),
  removeNsfw("TLで閲覧注意つきのノートを表示しない");

  final String displayName;

  const NSFWInherit(this.displayName);
}

enum AutomaticPush {
  automatic("自動で次を読み込む"),
  none("自動で読み込まない");

  final String displayName;

  const AutomaticPush(this.displayName);
}

enum TabPosition {
  top("上"),
  bottom("下");

  final String displayName;

  const TabPosition(this.displayName);
}

enum EmojiType {
  twemoji("Twemoji"),
  system("標準");

  final String displayName;

  const EmojiType(this.displayName);
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
  }) = _GeneralSettings;

  factory GeneralSettings.fromJson(Map<String, dynamic> json) =>
      _$GeneralSettingsFromJson(json);
}
