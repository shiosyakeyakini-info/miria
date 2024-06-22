import "dart:convert";

import "package:flutter/foundation.dart";
import "package:miria/model/general_settings.dart";
import "package:shared_preferences/shared_preferences.dart";

class GeneralSettingsRepository extends ChangeNotifier {
  var _settings = const GeneralSettings();
  GeneralSettings get settings => _settings;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString("general_settings");
    if (storedData == null || storedData.isEmpty) {
      return;
    }

    try {
      _settings = GeneralSettings.fromJson(jsonDecode(storedData));
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> update(GeneralSettings settings) async {
    _settings = settings;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("general_settings", jsonEncode(settings.toJson()));
  }
}
