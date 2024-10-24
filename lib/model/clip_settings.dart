import "package:freezed_annotation/freezed_annotation.dart";
import "package:misskey_dart/misskey_dart.dart";

part "clip_settings.freezed.dart";

@freezed
class ClipSettings with _$ClipSettings {
  const factory ClipSettings({
    @Default("") String name,
    String? description,
    @Default(false) bool isPublic,
  }) = _ClipSettings;
  const ClipSettings._();

  factory ClipSettings.fromClip(Clip clip) {
    return ClipSettings(
      name: clip.name ?? "",
      description: clip.description,
      isPublic: clip.isPublic,
    );
  }
}
