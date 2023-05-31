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

@freezed
class GeneralSettings with _$GeneralSettings {
  const factory GeneralSettings({
    @Default("") String lightColorThemeId,
    @Default("") String darkColorThemeId,
    @Default(ThemeColorSystem.system) ThemeColorSystem themeColorSystem,
    @Default(NSFWInherit.inherit) NSFWInherit nsfwInherit,
    @Default(false) bool enableDirectReaction,
  }) = _GeneralSettings;

  factory GeneralSettings.fromJson(Map<String, dynamic> json) =>
      _$GeneralSettingsFromJson(json);
}
