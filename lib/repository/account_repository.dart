import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/acct.dart';
import 'package:miria/providers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class AccountRepository extends Notifier<List<Account>> {
  final _validatedAccts = <Acct>{};
  String _sessionId = "";

  @override
  List<Account> build() {
    return [];
  }

  Future<void> load() async {
    const prefs = FlutterSecureStorage();
    final storedData = await prefs.read(key: "accounts");
    if (storedData == null) {
      return;
    }
    try {
      state = (jsonDecode(storedData) as List)
          .map((e) => Account.fromJson(e))
          .toList();
      _validatedAccts.clear();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> loadFromSourceIfNeed(Acct acct) async {
    if (_validatedAccts.contains(acct)) return;

    final index = state.indexWhere((e) => e.acct == acct);
    if (index < 0) return;
    final account = state[index];
    final i = await ref.read(misskeyProvider(account)).i.i();
    ref.read(notesProvider(account)).updateMute(i.mutedWords);

    final accounts = List.of(state);
    accounts[index] = account.copyWith(i: i);
    state = accounts;
    _validatedAccts.add(acct);
  }

  Future<void> createUnreadAnnouncement(
    Account account,
    AnnouncementsResponse announcement,
  ) async {
    final index = state.indexOf(account);
    final i = state[index].i.copyWith(
      unreadAnnouncements: [
        ...state[index].i.unreadAnnouncements,
        announcement
      ],
    );

    final accounts = List.of(state);
    accounts[index] = account.copyWith(i: i);
    state = accounts;
  }

  Future<void> removeUnreadAnnouncement(Account account) async {
    final index = state.indexOf(account);
    final i = state[index].i.copyWith(
      unreadAnnouncements: [],
    );

    final accounts = List.of(state);
    accounts[index] = account.copyWith(i: i);
    state = accounts;
  }

  Future<void> remove(Account account) async {
    state = state.where((e) => e != account).toList();
    _validatedAccts.remove(account.acct);
    await ref.read(tabSettingsRepositoryProvider).removeAccount(account);
    await ref.read(accountSettingsRepositoryProvider).removeAccount(account);
    await _save();
  }

  Future<void> _validateMisskey(String server) async {
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
      nodeInfo = await ref.read(dioProvider).getUri(uri);
    } catch (e) {
      throw SpecifiedException("$server はMisskeyサーバーとして認識できませんでした。");
    }
    final nodeInfoHref = nodeInfo.data["links"][0]["href"];
    final nodeInfoHrefResponse = await ref.read(dioProvider).get(nodeInfoHref);
    final nodeInfoResult = nodeInfoHrefResponse.data;

    final software = nodeInfoResult["software"]["name"];
    // these software already known as unavailable this app
    if (software == "mastodon" || software == "fedibird") {
      throw SpecifiedException("Miriaは$softwareに未対応です。");
    }

    final version = nodeInfoResult["software"]["version"];

    final endpoints = await ref
        .read(misskeyProvider(Account.demoAccount(server)))
        .endpoints();
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
    _addAccount(account);
  }

  Future<void> loginAsToken(String server, String token) async {
    await _validateMisskey(server);
    final i = await Misskey(token: token, host: server).i.i();
    _addAccount(Account(host: server, userId: i.username, token: token, i: i));
  }

  Future<void> openMiAuth(String server) async {
    await _validateMisskey(server);

    _sessionId = const Uuid().v4();
    await launchUrl(
      MisskeyServer().buildMiAuthURL(
        server,
        _sessionId,
        name: "Miria",
        permission: Permission.values,
      ),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> validateMiAuth(String server) async {
    final token = await MisskeyServer().checkMiAuthToken(server, _sessionId);
    final i = await Misskey(token: token, host: server).i.i();
    await _addAccount(
      Account(host: server, userId: i.username, token: token, i: i),
    );
  }

  Future<void> _addAccount(Account account) async {
    if (state.map((e) => e.acct).contains(account.acct)) {
      throw SpecifiedException("${account.acct}で既にログインしています");
    }

    state = [...state, account];
    _validatedAccts.add(account.acct);
    await ref.read(emojiRepositoryProvider(account)).loadFromSourceIfNeed();

    await _save();
    await _addIfTabSettingNothing();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final newState = state.toList();
    final item = newState.removeAt(oldIndex);
    newState.insert(newIndex, item);
    state = newState;

    await _save();
  }

  Future<void> _save() async {
    const prefs = FlutterSecureStorage();
    await prefs.write(
      key: "accounts",
      value: jsonEncode(state.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> _addIfTabSettingNothing() async {
    if (state.length == 1) {
      final account = state.first;
      ref
          .read(tabSettingsRepositoryProvider)
          .initializeTabSettings(account.acct);
    }
  }
}
