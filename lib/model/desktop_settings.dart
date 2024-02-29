import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'desktop_settings.freezed.dart';
part 'desktop_settings.g.dart';

@freezed
class DesktopSettings with _$DesktopSettings {
  const factory DesktopSettings({
    @Default(DesktopWindowSettings()) DesktopWindowSettings window,
  }) = _DesktopSettings;

  factory DesktopSettings.fromJson(Map<String, dynamic> json) =>
      _$DesktopSettingsFromJson(json);
}

@freezed
class DesktopWindowSettings with _$DesktopWindowSettings {
  const factory DesktopWindowSettings({
    @Default(null) double? x,
    @Default(null) double? y,
    @Default(400) double w,
    @Default(700) double h,
  }) = _DesktopWindowSettings;

  factory DesktopWindowSettings.fromJson(Map<String, dynamic> json) =>
      _$DesktopWindowSettingsFromJson(json);
}
