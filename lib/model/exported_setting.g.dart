// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exported_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExportedSetting _$ExportedSettingFromJson(Map<String, dynamic> json) =>
    _ExportedSetting(
      generalSettings: GeneralSettings.fromJson(
        json['generalSettings'] as Map<String, dynamic>,
      ),
      accountSettings:
          (json['accountSettings'] as List<dynamic>?)
              ?.map((e) => AccountSettings.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tabSettings:
          (json['tabSettings'] as List<dynamic>?)
              ?.map((e) => TabSetting.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ExportedSettingToJson(
  _ExportedSetting instance,
) => <String, dynamic>{
  'generalSettings': instance.generalSettings.toJson(),
  'accountSettings': instance.accountSettings.map((e) => e.toJson()).toList(),
  'tabSettings': instance.tabSettings.map((e) => e.toJson()).toList(),
};
