import "package:freezed_annotation/freezed_annotation.dart";

part "misskey_theme.freezed.dart";
part "misskey_theme.g.dart";

@freezed
class MisskeyTheme with _$MisskeyTheme {
  const factory MisskeyTheme({
    required String id,
    required String name,
    required Map<String, String> props,
    String? author,
    String? desc,
    String? base,
  }) = _MisskeyTheme;

  factory MisskeyTheme.fromJson(Map<String, dynamic> json) =>
      _$MisskeyThemeFromJson(json);
}
