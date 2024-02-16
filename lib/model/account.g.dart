// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      host: json['host'] as String,
      userId: json['userId'] as String,
      token: json['token'] as String?,
      i: MeDetailed.fromJson(json['i'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : MetaResponse.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'host': instance.host,
      'userId': instance.userId,
      'token': instance.token,
      'i': instance.i.toJson(),
      'meta': instance.meta?.toJson(),
    };
