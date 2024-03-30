// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_extension_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShareExtensionDataImpl _$$ShareExtensionDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ShareExtensionDataImpl(
      text: (json['text'] as List<dynamic>).map((e) => e as String).toList(),
      files: (json['files'] as List<dynamic>)
          .map((e) => SharedFiles.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ShareExtensionDataImplToJson(
        _$ShareExtensionDataImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'files': instance.files.map((e) => e.toJson()).toList(),
    };

_$SharedFilesImpl _$$SharedFilesImplFromJson(Map<String, dynamic> json) =>
    _$SharedFilesImpl(
      path: json['path'] as String,
      type: json['type'] as int,
    );

Map<String, dynamic> _$$SharedFilesImplToJson(_$SharedFilesImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'type': instance.type,
    };
