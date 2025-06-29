// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_preset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerPresets _$ServerPresetsFromJson(Map<String, dynamic> json) =>
    _ServerPresets(
      limitedApiServers:
          (json['limitedApiServers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      particularTimelinePresets:
          (json['particularTimelinePresets'] as List<dynamic>?)
              ?.map((e) => TimelinePreset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ServerPresetsToJson(_ServerPresets instance) =>
    <String, dynamic>{
      'limitedApiServers': instance.limitedApiServers,
      'particularTimelinePresets': instance.particularTimelinePresets
          .map((e) => e.toJson())
          .toList(),
    };

_TimelinePreset _$TimelinePresetFromJson(Map<String, dynamic> json) =>
    _TimelinePreset(
      host: json['host'] as String,
      name: json['name'] as String,
      endpoint: json['endpoint'] as String,
      websocketChannelName: json['websocketChannelName'] as String,
      parameters: json['parameters'] == null
          ? const <String, dynamic>{}
          : _paramsFromJson(json['parameters']),
    );

Map<String, dynamic> _$TimelinePresetToJson(_TimelinePreset instance) =>
    <String, dynamic>{
      'host': instance.host,
      'name': instance.name,
      'endpoint': instance.endpoint,
      'websocketChannelName': instance.websocketChannelName,
      'parameters': _paramsToJson(instance.parameters),
    };
