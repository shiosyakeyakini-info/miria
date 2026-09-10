// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aiscript_plugin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiScriptPlugin _$AiScriptPluginFromJson(
  Map<String, dynamic> json,
) => _AiScriptPlugin(
  installId: json['installId'] as String,
  name: json['name'] as String,
  version: json['version'] as String,
  author: json['author'] as String,
  src: json['src'] as String,
  description: json['description'] as String?,
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  config: json['config'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  configData:
      json['configData'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  active: json['active'] as bool? ?? true,
);

Map<String, dynamic> _$AiScriptPluginToJson(_AiScriptPlugin instance) =>
    <String, dynamic>{
      'installId': instance.installId,
      'name': instance.name,
      'version': instance.version,
      'author': instance.author,
      'src': instance.src,
      'description': instance.description,
      'permissions': instance.permissions,
      'config': instance.config,
      'configData': instance.configData,
      'active': instance.active,
    };

_AiScriptPluginMeta _$AiScriptPluginMetaFromJson(Map<String, dynamic> json) =>
    _AiScriptPluginMeta(
      name: json['name'] as String,
      version: json['version'] as String,
      author: json['author'] as String,
      description: json['description'] as String?,
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      config:
          json['config'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );

Map<String, dynamic> _$AiScriptPluginMetaToJson(_AiScriptPluginMeta instance) =>
    <String, dynamic>{
      'name': instance.name,
      'version': instance.version,
      'author': instance.author,
      'description': instance.description,
      'permissions': instance.permissions,
      'config': instance.config,
    };
