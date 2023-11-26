// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MisskeyTheme _$$_MisskeyThemeFromJson(Map<String, dynamic> json) =>
    _$_MisskeyTheme(
      id: json['id'] as String,
      name: json['name'] as String,
      author: json['author'] as String?,
      desc: json['desc'] as String?,
      base: json['base'] as String?,
      props: Map<String, String>.from(json['props'] as Map),
    );

Map<String, dynamic> _$$_MisskeyThemeToJson(_$_MisskeyTheme instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'author': instance.author,
      'desc': instance.desc,
      'base': instance.base,
      'props': instance.props,
    };
