// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_extension_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShareExtensionData _$ShareExtensionDataFromJson(Map<String, dynamic> json) =>
    _ShareExtensionData(
      text: (json['text'] as List<dynamic>).map((e) => e as String).toList(),
      files: (json['files'] as List<dynamic>)
          .map((e) => SharedFiles.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ShareExtensionDataToJson(_ShareExtensionData instance) =>
    <String, dynamic>{
      'text': instance.text,
      'files': instance.files.map((e) => e.toJson()).toList(),
    };

_SharedFiles _$SharedFilesFromJson(Map<String, dynamic> json) => _SharedFiles(
  path: json['path'] as String,
  type: (json['type'] as num).toInt(),
);

Map<String, dynamic> _$SharedFilesToJson(_SharedFiles instance) =>
    <String, dynamic>{'path': instance.path, 'type': instance.type};
