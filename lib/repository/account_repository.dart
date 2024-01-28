import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/account_settings.dart';
import 'package:miria/model/acct.dart';
import 'package:miria/providers.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

sealed class ValidateMisskeyException implements Exception {}

class InvalidServerException implements ValidateMisskeyException {
  const InvalidServerException(this.server);

  final String server;
}

class ServerIsNotMisskeyException implements ValidateMisskeyException {
  const ServerIsNotMisskeyException(this.server);

  final String server;
}

class SoftwareNotSupportedException implements ValidateMisskeyException {
  const SoftwareNotSupportedException(this.software);

  final String software;
}

class SoftwareNotCompatibleException implements ValidateMisskeyException {
  const SoftwareNotCompatibleException(this.software, this.version);

  final String software;
  final String version;
}

class AlreadyLoggedInException implements ValidateMisskeyException {
  const AlreadyLoggedInException(this.acct);

  final String acct;
}

class AccountRepository extends Notifier<List<Account>> {
  final _validatedAccts = <Acct>{};
  final _validateMetaAccts = <Acct>{};
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
      final list = (jsonDecode(storedData) as List);
      final resultList = List.of(list);
      for (final element in list) {
        if (element["meta"] == null) {
          try {
            final meta = await ref
                .read(misskeyWithoutAccountProvider(element["host"]))
                .meta();
            element["meta"] = jsonDecode(jsonEncode(meta.toJson()));
          } catch (e) {}
        }
      }

      state = resultList.map((e) => Account.fromJson(e)).toList();

      _validatedAccts.clear();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> updateI(Account account) async {
    final setting =
        ref.read(accountSettingsRepositoryProvider).fromAccount(account);
    _validatedAccts.add(account.acct);

    final i = await ref.read(misskeyProvider(account)).i.i();
    await ref
        .read(accountSettingsRepositoryProvider)
        .save(setting.copyWith(latestICached: DateTime.now()));

    final accounts = List.of(state);
    final index = state.indexWhere((e) => e.acct == account.acct);
    if (index < 0) return;
    accounts[index] = account.copyWith(i: i);
    state = accounts;

    ref.read(notesProvider(account)).updateMute(i.mutedWords, i.hardMutedWords);
  }

  Future<void> updateMeta(Account account) async {
    final setting =
        ref.read(accountSettingsRepositoryProvider).fromAccount(account);
    _validateMetaAccts.add(account.acct);

    final meta = await ref.read(misskeyProvider(account)).meta();
    await ref
        .read(accountSettingsRepositoryProvider)
        .save(setting.copyWith(latestMetaCached: DateTime.now()));

    final accounts = List.of(state);
    final index = state.indexWhere((e) => e.acct == account.acct);
    if (index < 0) return;

    accounts[index] = account.copyWith(meta: meta);
    state = accounts;
  }

  Future<void> loadFromSourceIfNeed(Acct acct) async {
    final setting = ref.read(accountSettingsRepositoryProvider).fromAcct(acct);

    final account = state.firstWhere((element) => element.acct == acct);

    await Future.wait([
      Future(() async {
        switch (setting.iCacheStrategy) {
          case CacheStrategy.whenLaunch:
            if (!_validatedAccts.contains(acct)) await updateI(account);
            break;
          case CacheStrategy.whenOneDay:
            final latestUpdated = setting.latestICached;
            if (latestUpdated == null ||
                latestUpdated.day != DateTime.now().day) {
              await updateI(account);
            }
          case CacheStrategy.whenTabChange:
            await updateI(account);
            break;
        }
      }),
      Future(() async {
        switch (setting.metaChacheStrategy) {
          case CacheStrategy.whenLaunch:
            if (!_validateMetaAccts.contains(acct)) await updateMeta(account);
            break;
          case CacheStrategy.whenOneDay:
            final latestUpdated = setting.latestMetaCached;
            if (latestUpdated == null ||
                latestUpdated.day != DateTime.now().day) {
              await updateMeta(account);
            }
          case CacheStrategy.whenTabChange:
            await updateMeta(account);
            break;
        }
      })
    ]);

    await _save();
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

  Future<void> addUnreadNotification(Account account) async {
    final index = state.indexOf(account);
    final i = state[index].i.copyWith(hasUnreadNotification: true);

    final accounts = List.of(state);
    accounts[index] = account.copyWith(i: i);
    state = accounts;
  }

  Future<void> readAllNotification(Account account) async {
    final index = state.indexOf(account);
    final i = state[index].i.copyWith(hasUnreadNotification: false);

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
      throw InvalidServerException(server);
    }

    try {
      nodeInfo = await ref.read(dioProvider).getUri(uri);
    } catch (e) {
      throw ServerIsNotMisskeyException(server);
    }
    final nodeInfoHref = nodeInfo.data["links"][0]["href"];
    final nodeInfoHrefResponse = await ref.read(dioProvider).get(nodeInfoHref);
    final nodeInfoResult = nodeInfoHrefResponse.data;

    final software = nodeInfoResult["software"]["name"];
    // these software already known as unavailable this app
    if (software == "mastodon" || software == "fedibird") {
      throw SoftwareNotSupportedException(software.toString());
    }

    final version = nodeInfoResult["software"]["version"];

    try {
      final meta = await ref.read(misskeyWithoutAccountProvider(server)).meta();

      final endpoints = await ref
          .read(misskeyProvider(Account.demoAccount(server, meta)))
          .endpoints();
      if (!endpoints.contains("emojis")) {
        throw SoftwareNotCompatibleException(
          software.toString(),
          version.toString(),
        );
      }
    } catch (e) {
      throw SoftwareNotCompatibleException(
        software.toString(),
        version.toString(),
      );
    }
  }

  Future<void> loginAsPassword(
      String server, String userId, String password) async {
    final token =
        await MisskeyServer().loginAsPassword(server, userId, password);
    final i = await Misskey(token: token, host: server).i.i();
    final meta = await Misskey(token: token, host: server).meta();
    final account =
        Account(host: server, token: token, userId: userId, i: i, meta: meta);
    _addAccount(account);
  }

  Future<void> loginAsToken(String server, String token) async {
    await _validateMisskey(server);
    final misskey = Misskey(token: token, host: server);
    final i = await misskey.i.i();
    final meta = await misskey.meta();
    await _addAccount(
      Account(host: server, userId: i.username, token: token, i: i, meta: meta),
    );
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
    final misskey = Misskey(token: token, host: server);
    final i = await misskey.i.i();
    final meta = await misskey.meta();
    await _addAccount(
      Account(host: server, userId: i.username, token: token, i: i, meta: meta),
    );
  }

  Future<void> _addAccount(Account account) async {
    if (state.map((e) => e.acct).contains(account.acct)) {
      throw AlreadyLoggedInException(account.acct.toString());
    }

    state = [...state, account];
    _validatedAccts.add(account.acct);
    await ref.read(emojiRepositoryProvider(account)).loadFromSourceIfNeed();

    await _save();
    await ref
        .read(tabSettingsRepositoryProvider)
        .initializeTabSettings(account);
    ();
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
}
