// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Account _$$_AccountFromJson(Map<String, dynamic> json) => _$_Account(
      host: json['host'] as String,
      userId: json['userId'] as String,
      token: json['token'] as String?,
      i: IResponse.fromJson(json['i'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AccountToJson(_$_Account instance) =>
    <String, dynamic>{
      'host': instance.host,
      'userId': instance.userId,
      'token': instance.token,
      'i': instance.i.toJson(),
    };
