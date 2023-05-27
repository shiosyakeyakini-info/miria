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

@freezed
class GeneralSettings with _$GeneralSettings {
  const factory GeneralSettings({
    @Default("") String lightColorThemeId,
    @Default("") String darkColorThemeId,
    @Default(ThemeColorSystem.system) ThemeColorSystem themeColorSystem,
  }) = _GeneralSettings;

  factory GeneralSettings.fromJson(Map<String, dynamic> json) =>
      _$GeneralSettingsFromJson(json);
}
