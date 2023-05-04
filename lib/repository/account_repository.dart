import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/model/tab_setting.dart';
import 'package:flutter_misskey_app/model/tab_type.dart';
import 'package:flutter_misskey_app/repository/tab_settings_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountRepository {
  final List<Account> _account = [];

  Iterable<Account> get account => _account;

  final TabSettingsRepository tabSettingsRepository;

  AccountRepository(this.tabSettingsRepository);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString("accounts");
    if (storedData == null) {
      return;
    }
    try {
      _account
        ..clear()
        ..addAll(
            (jsonDecode(storedData) as List).map((e) => Account.fromJson(e)));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addIfTabSettingNothing() async {
    if (_account.length == 1) {
      final account = _account.first;
      await tabSettingsRepository.save([
        TabSetting(
            icon: Icons.home,
            tabType: TabType.homeTimeline,
            name: "ホームタイムライン",
            account: account),
        TabSetting(
            icon: Icons.public,
            tabType: TabType.localTimeline,
            name: "ローカルタイムライン",
            account: account),
        TabSetting(
            icon: Icons.rocket_launch,
            tabType: TabType.globalTimeline,
            name: "グローバルタイムライン",
            account: account),
      ]);
    }
  }

  Future<void> loginAsPassword(
      String server, String userId, String password) async {
    final token =
        await MisskeyServer().loginAsPassword(server, userId, password);
    final account = Account(host: server, token: token, userId: userId);
    addAccount(account);
    await _addIfTabSettingNothing();
  }

  Future<void> loginAsToken(String server, String token) async {
    final me = await Misskey(token: token, host: server).i.i();
    addAccount(Account(host: server, userId: me.username, token: token));
    await _addIfTabSettingNothing();
  }

  Future<void> addAccount(Account account) async {
    _account.add(account);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "accounts", jsonEncode(_account.map((e) => e.toJson()).toList()));
  }
}
