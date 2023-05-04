import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_misskey_app/model/tab_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabSettingsRepository extends ChangeNotifier {
  List<TabSetting> _tabSettings = [];

  Iterable<TabSetting> get tabSettings => _tabSettings;

  TabSettingsRepository();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString("tab_settings");
    if (storedData == null) {
      return;
    }
    try {
      _tabSettings
        ..clear()
        ..addAll((jsonDecode(storedData) as List)
            .map((e) => TabSetting.fromJson(e)));
    } catch (e) {
      print(e);
    }
  }

  Future<void> save(List<TabSetting> tabSettings) async {
    _tabSettings = tabSettings.toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("tab_settings",
        jsonEncode(_tabSettings.map((e) => e.toJson()).toList()));
    notifyListeners();
  }
}
