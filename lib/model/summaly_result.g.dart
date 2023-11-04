// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summaly_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SummalyResultImpl _$$SummalyResultImplFromJson(Map<String, dynamic> json) =>
    _$SummalyResultImpl(
      title: json['title'] as String?,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      sitename: json['sitename'] as String?,
      sensitive: json['sensitive'] as bool?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$SummalyResultImplToJson(_$SummalyResultImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'icon': instance.icon,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'player': instance.player.toJson(),
      'sitename': instance.sitename,
      'sensitive': instance.sensitive,
      'url': instance.url,
    };

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
      url: json['url'] as String?,
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      allow:
          (json['allow'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'allow': instance.allow,
    };
