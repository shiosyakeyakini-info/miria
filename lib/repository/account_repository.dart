import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/acct.dart';
import 'package:miria/model/tab_icon.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/tab_type.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/account_settings_repository.dart';
import 'package:miria/repository/tab_settings_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class AccountRepository extends ChangeNotifier {
  final List<Account> _account = [];
  final accountDataValidated = <bool>[];

  Iterable<Account> get account => _account;

  final TabSettingsRepository tabSettingsRepository;
  final AccountSettingsRepository accountSettingsRepository;
  final T Function<T>(ProviderListenable<T> provider) reader;

  AccountRepository(
      this.tabSettingsRepository, this.accountSettingsRepository, this.reader);

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

      accountDataValidated
        ..clear()
        ..addAll(Iterable.generate(_account.length, (index) => false));

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> loadFromSourceIfNeed(Acct acct) async {
    final index =
        _account.map((account) => account.acct).toList().indexOf(acct);
    if (index == -1) return;
    if (accountDataValidated.isNotEmpty && accountDataValidated[index]) return;
    final i = await reader(misskeyProvider(_account[index])).i.i();
    _account[index] = _account[index].copyWith(i: i);

    accountDataValidated[index] = true;
    reader(notesProvider(_account[index])).updateMute(i.mutedWords);
    notifyListeners();
  }

  Future<void> createUnreadAnnouncement(
      Account account, AnnouncementsResponse announcement) async {
    final i = _account[_account.indexOf(account)].i.copyWith(
        unreadAnnouncements: [
          ..._account[_account.indexOf(account)].i.unreadAnnouncements,
          announcement
        ]);
    _account[_account.indexOf(account)] =
        _account[_account.indexOf(account)].copyWith(i: i);
    notifyListeners();
  }

  Future<void> removeUnreadAnnouncement(Account account) async {
    final i =
        _account[_account.indexOf(account)].i.copyWith(unreadAnnouncements: []);
    _account[_account.indexOf(account)] =
        _account[_account.indexOf(account)].copyWith(i: i);
    notifyListeners();
  }

  //一つ目のアカウントが追加されたときに自動で追加されるタブ
  Future<void> _addIfTabSettingNothing() async {
    if (_account.length == 1) {
      final account = _account.first;
      await tabSettingsRepository.save([
        TabSetting(
          icon: TabIcon(codePoint: Icons.home.codePoint),
          tabType: TabType.homeTimeline,
          name: "ホームタイムライン",
          acct: account.acct,
        ),
        TabSetting(
          icon: TabIcon(codePoint: Icons.public.codePoint),
          tabType: TabType.localTimeline,
          name: "ローカルタイムライン",
          acct: account.acct,
        ),
        TabSetting(
          icon: TabIcon(codePoint: Icons.rocket_launch.codePoint),
          tabType: TabType.globalTimeline,
          name: "グローバルタイムライン",
          acct: account.acct,
        ),
      ]);
    }
  }

  Future<void> remove(Account account) async {
    _account.remove(account);
    await tabSettingsRepository.removeAccount(account);
    await accountSettingsRepository.removeAccount(account);
    await save();
  }

  Future<void> validateMisskey(String server) async {
    //先にnodeInfoを取得する
    final Response nodeInfo;

    final Uri uri;
    try {
      uri = Uri(
          scheme: "https",
          host: server,
          pathSegments: [".well-known", "nodeinfo"]);
    } catch (e) {
      throw SpecifiedException(
          "$server はサーバーとして認識できませんでした。\nサーバーには、「misskey.io」などを入力してください。");
    }

    try {
      nodeInfo = await reader(dioProvider).getUri(uri);
    } catch (e) {
      throw SpecifiedException("$server はMisskeyサーバーとして認識できませんでした。");
    }
    final nodeInfoHref = nodeInfo.data["links"][0]["href"];
    final nodeInfoHrefResponse = await reader(dioProvider).get(nodeInfoHref);
    final nodeInfoResult = nodeInfoHrefResponse.data;

    final software = nodeInfoResult["software"]["name"];
    // these software already known as unavailable this app
    if (software == "mastodon" || software == "fedibird") {
      throw SpecifiedException("Miriaは$softwareに未対応です。");
    }

    final version = nodeInfoResult["software"]["version"];

    final endpoints =
        await reader(misskeyProvider(Account.demoAccount(server))).endpoints();
    if (!endpoints.contains("emojis")) {
      throw SpecifiedException("Miriaと互換性のないソフトウェアです。\n$software $version");
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
    await validateMisskey(server);
    final i = await Misskey(token: token, host: server).i.i();
    addAccount(Account(host: server, userId: i.username, token: token, i: i));
    await _addIfTabSettingNothing();
  }

  String sessionId = "";

  Future<void> openMiAuth(String server) async {
    await validateMisskey(server);

    sessionId = const Uuid().v4();
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
    accountDataValidated.add(true);
    await reader(emojiRepositoryProvider(account)).loadFromSourceIfNeed();

    await save();
  }

  Future<void> save() async {
    const prefs = FlutterSecureStorage();
    await prefs.write(
        key: "accounts",
        value: jsonEncode(_account.map((e) => e.toJson()).toList()));
  }
}
