import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/account_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsRepository extends ChangeNotifier {
  List<AccountSettings> _accountSettings = [];
  Iterable<AccountSettings> get accountSettings => _accountSettings;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString("account_settings");
    if (storedData == null || storedData.isEmpty) {
      return;
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
      ..removeWhere((element) =>
          element.userId == settings.userId && element.host == settings.host)
      ..add(settings)
      ..toList();
    await _saveAsList(_accountSettings);
  }

  Future<void> _saveAsList(List<AccountSettings> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("account_settings",
        jsonEncode(settings.map((e) => e.toJson()).toList()));
    notifyListeners();
  }

  Future<void> removeAccount(Account account) async {
    _accountSettings.removeWhere((element) =>
        element.host == account.host && element.userId == account.userId);
    await _saveAsList(_accountSettings);
    notifyListeners();
  }

  AccountSettings fromAccount(Account account) {
    return _accountSettings.firstWhereOrNull(
            (e) => e.host == account.host && e.userId == account.userId) ??
        AccountSettings(
          userId: account.userId,
          host: account.host,
          reactions: [],
        );
  }
}
