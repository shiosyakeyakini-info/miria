// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'desktop_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DesktopSettings _$DesktopSettingsFromJson(Map<String, dynamic> json) =>
    _DesktopSettings(
      window:
          json['window'] == null
              ? const DesktopWindowSettings()
              : DesktopWindowSettings.fromJson(
                json['window'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$DesktopSettingsToJson(_DesktopSettings instance) =>
    <String, dynamic>{'window': instance.window.toJson()};

_DesktopWindowSettings _$DesktopWindowSettingsFromJson(
  Map<String, dynamic> json,
) => _DesktopWindowSettings(
  x: (json['x'] as num?)?.toDouble() ?? null,
  y: (json['y'] as num?)?.toDouble() ?? null,
  w: (json['w'] as num?)?.toDouble() ?? 400,
  h: (json['h'] as num?)?.toDouble() ?? 700,
);

Map<String, dynamic> _$DesktopWindowSettingsToJson(
  _DesktopWindowSettings instance,
) => <String, dynamic>{
  'x': instance.x,
  'y': instance.y,
  'w': instance.w,
  'h': instance.h,
};
