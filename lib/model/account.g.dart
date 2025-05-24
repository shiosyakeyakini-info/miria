// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
  host: json['host'] as String,
  userId: json['userId'] as String,
  i: MeDetailed.fromJson(json['i'] as Map<String, dynamic>),
  token: json['token'] as String?,
  meta: json['meta'] == null
      ? null
      : MetaResponse.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
  'host': instance.host,
  'userId': instance.userId,
  'i': instance.i.toJson(),
  'token': instance.token,
  'meta': instance.meta?.toJson(),
};
