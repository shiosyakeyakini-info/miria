import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_preset.freezed.dart';
part 'server_preset.g.dart';

@freezed
abstract class ServerPresets with _$ServerPresets {
  const factory ServerPresets({
    @JsonKey(fromJson: _limitedApiServersFromJson)
    @Default([])
    List<String> limitedApiServers,
    @Default([]) List<TimelinePreset> particularTimelinePresets,
  }) = _ServerPresets;

  factory ServerPresets.fromJson(Map<String, dynamic> json) =>
      _$ServerPresetsFromJson(json);
}

@freezed
abstract class TimelinePreset with _$TimelinePreset {
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
    try {
      final decoded = jsonDecode(source);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {
      // JSON解析に失敗した場合は空のMapを返す
    }
  }
  return <String, dynamic>{};
}

String _paramsToJson(Map<String, dynamic> source) => jsonEncode(source);

List<String> _limitedApiServersFromJson(dynamic source) {
  if (source is List) {
    return source
        .map((e) {
          if (e is String) return e;
          if (e is Map<String, dynamic> && e['host'] is String) {
            return e['host'] as String;
          }
          return null;
        })
        .whereType<String>()
        .toList();
  }
  return <String>[];
}
