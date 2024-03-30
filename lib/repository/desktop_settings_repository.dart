import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:miria/model/desktop_settings.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DesktopSettingsRepository extends ChangeNotifier {
  var _settings = const DesktopSettings();
  DesktopSettings get settings => _settings;

  Future<void> load() async {
    final f = File(await getSettingPath());
    if (kDebugMode) print("path: ${f.path}");
    try {
      _settings = (await f.exists())
          ? DesktopSettings.fromJson(await json.decode(await f.readAsString()))
          : const DesktopSettings();
    } catch (e) {
      if (kDebugMode) print(e);
      _settings = const DesktopSettings();
    }
  }

  Future<void> update(DesktopSettings settings) async {
    _settings = settings;
    notifyListeners();

    final f = File(await getSettingPath());
    await f.writeAsString(jsonEncode(settings.toJson()));
  }

  Future<String> getSettingPath() async {
    return join(
        (await getApplicationSupportDirectory()).path, "desktopSettings.json");
  }
}
