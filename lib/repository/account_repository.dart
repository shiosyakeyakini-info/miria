import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/tab_type.dart';
import 'package:miria/repository/account_settings_repository.dart';
import 'package:miria/repository/tab_settings_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class AccountRepository {
  final List<Account> _account = [];

  Iterable<Account> get account => _account;

  final TabSettingsRepository tabSettingsRepository;
  final AccountSettingsRepository accountSettingsRepository;

  AccountRepository(this.tabSettingsRepository, this.accountSettingsRepository);

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

  Future<void> remove(Account account) async {
    _account.remove(account);
    await tabSettingsRepository.removeAccount(account);
    await accountSettingsRepository.removeAccount(account);
    await save();
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

  final sessionId = const Uuid().v4();

  Future<void> openMiAuth(String server) async {
    await launchUrl(
      MisskeyServer().buildMiAuthURL(server, sessionId,
          name: "Miria", permission: Permission.values),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> validateMiAuth(String server) async {
    final token = await MisskeyServer().checkMiAuthToken(server, sessionId);
    final i = await Misskey(token: token, host: server).i.i();
    await addAccount(
        Account(host: server, userId: i.username, token: token, i: i));
    await _addIfTabSettingNothing();
  }

  Future<void> addAccount(Account account) async {
    _account.add(account);
    await save();
  }

  Future<void> save() async {
    const prefs = FlutterSecureStorage();
    await prefs.write(
        key: "accounts",
        value: jsonEncode(_account.map((e) => e.toJson()).toList()));
  }
}
