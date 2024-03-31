// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'desktop_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DesktopSettingsImpl _$$DesktopSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$DesktopSettingsImpl(
      window: json['window'] == null
          ? const DesktopWindowSettings()
          : DesktopWindowSettings.fromJson(
              json['window'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DesktopSettingsImplToJson(
        _$DesktopSettingsImpl instance) =>
    <String, dynamic>{
      'window': instance.window.toJson(),
    };

_$DesktopWindowSettingsImpl _$$DesktopWindowSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$DesktopWindowSettingsImpl(
      x: (json['x'] as num?)?.toDouble() ?? null,
      y: (json['y'] as num?)?.toDouble() ?? null,
      w: (json['w'] as num?)?.toDouble() ?? 400,
      h: (json['h'] as num?)?.toDouble() ?? 700,
    );

Map<String, dynamic> _$$DesktopWindowSettingsImplToJson(
        _$DesktopWindowSettingsImpl instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'w': instance.w,
      'h': instance.h,
    };
