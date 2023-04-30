import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/tab_settings.dart';
import 'package:flutter_misskey_app/model/tab_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabSettingsRepositoryProvider =
    Provider((ref) => TabSettingsRepository());

class TabSettingsRepository {
  List<TabSettings> tabSettings = const [
    TabSettings(
        icon: Icons.house, tabType: TabType.homeTimeline, name: "ホームタイムライン"),
    TabSettings(
        icon: Icons.public,
        tabType: TabType.localTimeline,
        name: "パブリックタイムライン"),
    TabSettings(
        icon: Icons.rocket,
        tabType: TabType.globalTimeline,
        name: "グローバルタイムライン"),
    TabSettings(
        icon: Icons.hub, tabType: TabType.hybridTimeline, name: "ソーシャルタイムライン"),
    TabSettings(
        icon: Icons.games_rounded,
        tabType: TabType.channel,
        channelId: "9b3chwrm7f",
        name: "Misskeyアークナイツ部"),
    TabSettings(
        icon: Icons.gamepad_outlined,
        tabType: TabType.channel,
        channelId: "9c0i1s4abg",
        name: "ブル○カ変態妄想垂れ流し部"),
  ];
}
