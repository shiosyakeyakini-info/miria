// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_preset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServerPresetsImpl _$$ServerPresetsImplFromJson(Map<String, dynamic> json) =>
    _$ServerPresetsImpl(
      limitedApiServers: (json['limitedApiServers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      particularTimelinePresets: (json['particularTimelinePresets']
                  as List<dynamic>?)
              ?.map((e) => TimelinePreset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ServerPresetsImplToJson(_$ServerPresetsImpl instance) =>
    <String, dynamic>{
      'limitedApiServers': instance.limitedApiServers,
      'particularTimelinePresets':
          instance.particularTimelinePresets.map((e) => e.toJson()).toList(),
    };

_$TimelinePresetImpl _$$TimelinePresetImplFromJson(Map<String, dynamic> json) =>
    _$TimelinePresetImpl(
      host: json['host'] as String,
      name: json['name'] as String,
      endpoint: json['endpoint'] as String,
      websocketChannelName: json['websocketChannelName'] as String,
      parameters: json['parameters'] == null
          ? const <String, dynamic>{}
          : _paramsFromJson(json['parameters']),
    );

Map<String, dynamic> _$$TimelinePresetImplToJson(
        _$TimelinePresetImpl instance) =>
    <String, dynamic>{
      'host': instance.host,
      'name': instance.name,
      'endpoint': instance.endpoint,
      'websocketChannelName': instance.websocketChannelName,
      'parameters': _paramsToJson(instance.parameters),
    };
