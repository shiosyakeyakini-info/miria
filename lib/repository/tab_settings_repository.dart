import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/tab_icon.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/tab_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabSettingsRepository extends ChangeNotifier {
  List<TabSetting> _tabSettings = [];

  Iterable<TabSetting> get tabSettings => _tabSettings;

  TabSettingsRepository();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString("tab_settings");
    if (storedData == null || storedData.isEmpty) {
      return;
    }
    try {
      _tabSettings
        ..clear()
        ..addAll((jsonDecode(storedData) as List)
            .map((e) => TabSetting.fromJson(e)));
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> save(List<TabSetting> tabSettings) async {
    _tabSettings = tabSettings.toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("tab_settings",
        jsonEncode(_tabSettings.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  Future<void> removeAccount(Account account) async {
    _tabSettings.removeWhere((tabSetting) => tabSetting.acct == account.acct);
    await save(_tabSettings);
    notifyListeners();
  }

  Future<void> initializeTabSettings(Account account) async {
    await save([
      ..._tabSettings,
      TabSetting(
        icon: TabIcon(codePoint: Icons.home.codePoint),
        tabType: TabType.homeTimeline,
        acct: account.acct,
      ),
      if (account.i.policies.ltlAvailable)
        TabSetting(
          icon: TabIcon(codePoint: Icons.public.codePoint),
          tabType: TabType.localTimeline,
          acct: account.acct,
        ),
      if (account.i.policies.gtlAvailable)
        TabSetting(
          icon: TabIcon(codePoint: Icons.rocket_launch.codePoint),
          tabType: TabType.globalTimeline,
          acct: account.acct,
        ),
    ]);
  }
}
