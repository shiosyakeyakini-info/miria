import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/model/tab_setting.dart';
import 'package:flutter_misskey_app/model/tab_type.dart';
import 'package:flutter_misskey_app/repository/tab_settings_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:misskey_dart/misskey_dart.dart';

class AccountRepository {
  final List<Account> _account = [];

  Iterable<Account> get account => _account;

  final TabSettingsRepository tabSettingsRepository;

  AccountRepository(this.tabSettingsRepository);

  Future<void> load() async {
    const prefs = FlutterSecureStorage();
    final storedData = await prefs.read(key: "accounts");
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
    final i = await Misskey(token: token, host: server).i.i();
    final account = Account(host: server, token: token, userId: userId, i: i);
    addAccount(account);
    await _addIfTabSettingNothing();
  }

  Future<void> loginAsToken(String server, String token) async {
    final i = await Misskey(token: token, host: server).i.i();
    addAccount(Account(host: server, userId: i.username, token: token, i: i));
    await _addIfTabSettingNothing();
  }

  Future<void> addAccount(Account account) async {
    _account.add(account);
    final prefs = FlutterSecureStorage();
    await prefs.write(
        key: "accounts",
        value: jsonEncode(_account.map((e) => e.toJson()).toList()));
  }
}
