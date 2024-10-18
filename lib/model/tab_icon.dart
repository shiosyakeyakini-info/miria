import "package:freezed_annotation/freezed_annotation.dart";

part "tab_icon.freezed.dart";
part "tab_icon.g.dart";

@freezed
class TabIcon with _$TabIcon {
  const factory TabIcon({
    int? codePoint,
    String? customEmojiName,
  }) = _TabIcon;

  factory TabIcon.fromJson(Map<String, dynamic> json) =>
      _$TabIconFromJson(json);
}
