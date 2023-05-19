// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AccountSettings _$$_AccountSettingsFromJson(Map<String, dynamic> json) =>
    _$_AccountSettings(
      userId: json['userId'] as String,
      host: json['host'] as String,
      reactions:
          (json['reactions'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_AccountSettingsToJson(_$_AccountSettings instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'host': instance.host,
      'reactions': instance.reactions,
    };
