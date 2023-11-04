// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exported_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExportedSettingImpl _$$ExportedSettingImplFromJson(
        Map<String, dynamic> json) =>
    _$ExportedSettingImpl(
      accountSettings: (json['accountSettings'] as List<dynamic>?)
              ?.map((e) => AccountSettings.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      generalSettings: GeneralSettings.fromJson(
          json['generalSettings'] as Map<String, dynamic>),
      tabSettings: (json['tabSettings'] as List<dynamic>?)
              ?.map((e) => TabSetting.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ExportedSettingImplToJson(
        _$ExportedSettingImpl instance) =>
    <String, dynamic>{
      'accountSettings':
          instance.accountSettings.map((e) => e.toJson()).toList(),
      'generalSettings': instance.generalSettings.toJson(),
      'tabSettings': instance.tabSettings.map((e) => e.toJson()).toList(),
    };
