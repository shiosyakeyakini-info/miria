// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TabSetting _$$_TabSettingFromJson(Map<String, dynamic> json) =>
    _$_TabSetting(
      icon: const IconDataConverter().fromJson(json['icon']),
      tabType: $enumDecode(_$TabTypeEnumMap, json['tabType']),
      channelId: json['channelId'] as String?,
      listId: json['listId'] as String?,
      antennaId: json['antennaId'] as String?,
      isSubscribe: json['isSubscribe'] ?? true,
      name: json['name'] as String,
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      renoteDisplay: json['renoteDisplay'] as bool? ?? true,
    );

Map<String, dynamic> _$$_TabSettingToJson(_$_TabSetting instance) =>
    <String, dynamic>{
      'icon': const IconDataConverter().toJson(instance.icon),
      'tabType': _$TabTypeEnumMap[instance.tabType]!,
      'channelId': instance.channelId,
      'listId': instance.listId,
      'antennaId': instance.antennaId,
      'isSubscribe': instance.isSubscribe,
      'name': instance.name,
      'account': instance.account,
      'renoteDisplay': instance.renoteDisplay,
    };

const _$TabTypeEnumMap = {
  TabType.localTimeline: 'localTimeline',
  TabType.homeTimeline: 'homeTimeline',
  TabType.globalTimeline: 'globalTimeline',
  TabType.hybridTimeline: 'hybridTimeline',
  TabType.channel: 'channel',
  TabType.userList: 'userList',
  TabType.antenna: 'antenna',
};
