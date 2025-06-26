import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_preset.freezed.dart';
part 'server_preset.g.dart';

@freezed
class ServerPresets with _$ServerPresets {
  const factory ServerPresets({
    @Default([]) List<String> limitedApiServers,
    @Default([]) List<TimelinePreset> particularTimelinePresets,
  }) = _ServerPresets;

  factory ServerPresets.fromJson(Map<String, dynamic> json) =>
      _$ServerPresetsFromJson(json);
}

@freezed
class TimelinePreset with _$TimelinePreset {
  const factory TimelinePreset({
    required String host,
    required String name,
    required String endpoint,
    required String websocketChannelName,
    @JsonKey(fromJson: _paramsFromJson, toJson: _paramsToJson)
    @Default(<String, dynamic>{})
    Map<String, dynamic> parameters,
  }) = _TimelinePreset;

  factory TimelinePreset.fromJson(Map<String, dynamic> json) =>
      _$TimelinePresetFromJson(json);
}

Map<String, dynamic> _paramsFromJson(dynamic source) {
  if (source is Map<String, dynamic>) return source;
  if (source is String && source.isNotEmpty) {
    final decoded = jsonDecode(source);
    if (decoded is Map<String, dynamic>) return decoded;
  }
  return <String, dynamic>{};
}

String _paramsToJson(Map<String, dynamic> source) => jsonEncode(source);
