import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/account_settings.dart';
import 'package:miria/model/acct.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsRepository extends ChangeNotifier {
  List<AccountSettings> _accountSettings = [];
  Iterable<AccountSettings> get accountSettings => _accountSettings;

  Future<void> load() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await SharedPreferenceAppGroup.setAppGroup(
          "group.info.shiosyakeyakini.miria");
      final key = await SharedPreferenceAppGroup.get("account_settings");
      print(key);
    }

    final prefs = await SharedPreferences.getInstance();
    var storedData = prefs.getString("account_settings");
    if (storedData == null || storedData.isEmpty) {
      if (defaultTargetPlatform != TargetPlatform.iOS) {
        return;
      }
      final key = await SharedPreferenceAppGroup.get("account_settings");
      if (key is String) {
        storedData = key;
      } else {
        return;
      }
    } else {
      await SharedPreferenceAppGroup.setString("account_settings", storedData);
    }
    try {
      _accountSettings
        ..clear()
        ..addAll((jsonDecode(storedData) as List)
            .map((e) => AccountSettings.fromJson(e)));
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> save(AccountSettings settings) async {
    _accountSettings = _accountSettings
      ..removeWhere((oldSettings) => oldSettings.acct == settings.acct)
      ..add(settings)
      ..toList();
    await _saveAsList(_accountSettings);
  }

  Future<void> _saveAsList(List<AccountSettings> settings) async {
    final prefs = await SharedPreferences.getInstance();
    final value = jsonEncode(settings.map((e) => e.toJson()).toList());
    await prefs.setString("account_settings", value);
    notifyListeners();
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      SharedPreferenceAppGroup.setString("account_settings", value);
    }
  }

  Future<void> removeAccount(Account account) async {
    _accountSettings
        .removeWhere((accountSettings) => accountSettings.acct == account.acct);
    await _saveAsList(_accountSettings);
    notifyListeners();
  }

  AccountSettings fromAcct(Acct acct) {
    return _accountSettings.firstWhereOrNull(
          (accountSettings) => accountSettings.acct == acct,
        ) ??
        AccountSettings(
          userId: acct.username,
          host: acct.host,
        );
  }

  AccountSettings fromAccount(Account account) {
    return fromAcct(account.acct);
  }
}
