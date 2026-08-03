// ignore_for_file: avoid_dynamic_calls

import "dart:convert";

import "package:flutter/foundation.dart";
import "package:miria/log.dart";
import "package:miria/model/account.dart";
import "package:miria/model/account_settings.dart";
import "package:miria/model/acct.dart";
import "package:miria/providers.dart";
import "package:miria/repository/shared_preference_controller.dart";
import "package:miria/util/server_utils.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preference_app_group/shared_preference_app_group.dart";
import "package:url_launcher/url_launcher.dart";
import "package:uuid/uuid.dart";

part "account_repository.g.dart";

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

@riverpod
class AccountRepository extends _$AccountRepository {
  late final SharedPreferenceController sharedPreferenceController = ref.read(
    sharedPrefenceControllerProvider,
  );

  AccountRepository();

  final _validatedAccts = <Acct>{};
  final _validateMetaAccts = <Acct>{};
  String _sessionId = "";

  String _buildHttpMiAuthUrl(Uri uri, String sessionId) {
    final baseUrl =
        "${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}";
    final permissions = Permission.values.map((p) => p.value).join(",");
    return "$baseUrl/miauth/$sessionId?name=Miria&permission=$permissions";
  }

  Future<String> _checkHttpMiAuthToken(Uri uri, String sessionId) async {
    final checkUrl =
        "${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}/api/miauth/$sessionId/check";
    final response = await ref.read(dioProvider).post(checkUrl);
    final data = response.data as Map<String, dynamic>;
    if (data["ok"] == true) {
      return data["token"] as String;
    } else {
      throw Exception("MiAuth authentication failed");
    }
  }

  @override
  List<Account> build() {
    return [];
  }

  Future<void> load() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await SharedPreferenceAppGroup.setAppGroup(
        "group.info.shiosyakeyakini.miria",
      );
    }

    final storedData = await sharedPreferenceController.getStringSecure(
      "accounts",
    );
    if (storedData == null) return;

    try {
      final list = jsonDecode(storedData) as List;
      final resultList = List.of(list);
      for (final element in list) {
        if ((element as Map<String, dynamic>)["meta"] == null) {
          try {
            final meta = await ref
                .read(misskeyWithoutAccountProvider(element["host"]))
                .meta();
            element["meta"] = jsonDecode(jsonEncode(meta.toJson()));
          } catch (e) {
            logger.warning(e);
          }
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
    final setting = ref
        .read(accountSettingsRepositoryProvider)
        .fromAccount(account);
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
    final setting = ref
        .read(accountSettingsRepositoryProvider)
        .fromAccount(account);
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
          case CacheStrategy.whenOneDay:
            final latestUpdated = setting.latestICached;
            if (latestUpdated == null ||
                latestUpdated.day != DateTime.now().day) {
              await updateI(account);
            }
          case CacheStrategy.whenTabChange:
            await updateI(account);
        }
      }),
      Future(() async {
        switch (setting.metaChacheStrategy) {
          case CacheStrategy.whenLaunch:
            if (!_validateMetaAccts.contains(acct)) await updateMeta(account);
          case CacheStrategy.whenOneDay:
            final latestUpdated = setting.latestMetaCached;
            if (latestUpdated == null ||
                latestUpdated.day != DateTime.now().day) {
              await updateMeta(account);
            }
          case CacheStrategy.whenTabChange:
            await updateMeta(account);
        }
      }),
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
        announcement,
      ],
    );

    final accounts = List.of(state);
    accounts[index] = account.copyWith(i: i);
    state = accounts;
  }

  Future<void> removeUnreadAnnouncement(Account account) async {
    final index = state.indexOf(account);
    final i = state[index].i.copyWith(unreadAnnouncements: []);

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

  Future<void> addUnreadChatMessages(Account account) async {
    final index = state.indexOf(account);
    final i = state[index].i.copyWith(hasUnreadChatMessages: true);

    final accounts = List.of(state);
    accounts[index] = account.copyWith(i: i);
    state = accounts;
  }

  Future<void> readAllChatMessages(Account account) async {
    final index = state.indexOf(account);
    final i = state[index].i.copyWith(hasUnreadChatMessages: false);

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

  /// サーバーが Miria と互換性のある Misskey かどうかを検証する。
  ///
  /// まず Misskey の API を素直に叩き、読めなければそのときだけ nodeinfo で
  /// サーバー種別を調べる。nodeinfo を入口にすると、連合をオフにしたサーバーが
  /// `.well-known/nodeinfo` を含む連合系エンドポイントを一律 403 で返すため
  /// ログインできない (#770)。
  Future<void> _validateMisskey(String server) async {
    final Uri serverUri;
    try {
      serverUri = serverToUri(server);
    } catch (e) {
      throw InvalidServerException(server);
    }

    final hostWithPort = serverUri.hasPort
        ? "${serverUri.host}:${serverUri.port}"
        : serverUri.host;
    final misskey = ref.read(
      misskeyWithoutAccountProvider("${serverUri.scheme}://$hostWithPort"),
    );

    final List<String> endpoints;
    try {
      endpoints = await misskey.endpoints();
    } catch (e) {
      // HandshakeExceptionの場合、HTTPを使用するよう促す
      if (e.toString().contains("HandshakeException") &&
          !server.startsWith("http://") &&
          !server.startsWith("https://")) {
        throw InvalidServerException(server);
      }

      // Misskey として読めなかったので、ここで初めてサーバー種別を調べる。
      final software = await _fetchSoftware(serverUri);
      // these software already known as unavailable this app
      if (software?.name == "mastodon" || software?.name == "fedibird") {
        throw SoftwareNotSupportedException(software!.name);
      }
      throw ServerIsNotMisskeyException(server);
    }

    // Misskey ではあるが、Miria が前提とするエンドポイントを持たない場合。
    if (!endpoints.contains("emojis")) {
      final software = await _fetchSoftware(serverUri);
      throw SoftwareNotCompatibleException(
        software?.name ?? hostWithPort,
        software?.version ?? "",
      );
    }
  }

  /// nodeinfo からソフトウェア名とバージョンを取得する。
  ///
  /// 取得できなければ `null`。連合をオフにしたサーバーは nodeinfo を 403 で
  /// 返すため、取れないこと自体は異常ではない。エラーメッセージを具体的に
  /// するためだけの情報なので、失敗しても呼び出し側の判定は変えない。
  Future<({String name, String version})?> _fetchSoftware(Uri serverUri) async {
    try {
      final dio = ref.read(dioProvider);
      final nodeInfo = await dio.getUri(
        Uri(
          scheme: serverUri.scheme,
          host: serverUri.host,
          port: serverUri.hasPort ? serverUri.port : null,
          pathSegments: [".well-known", "nodeinfo"],
        ),
      );
      final href = nodeInfo.data["links"][0]["href"];
      final software = (await dio.get(href.toString())).data["software"];
      return (
        name: software["name"].toString(),
        version: software["version"].toString(),
      );
    } catch (e) {
      logger.warning(e);
      return null;
    }
  }

  Future<void> loginAsPassword(
    String server,
    String userId,
    String password,
  ) async {
    final uri = serverToUri(server);
    final hostWithPort = uri.hasPort ? "${uri.host}:${uri.port}" : uri.host;
    final token = await MisskeyServer().loginAsPassword(
      hostWithPort,
      userId,
      password,
    );
    final i = await Misskey(token: token, host: hostWithPort).i.i();
    final meta = await Misskey(token: token, host: hostWithPort).meta();
    final account = Account(
      host: uri.host,
      token: token,
      userId: userId,
      i: i,
      meta: meta,
      scheme: uri.scheme == "http" ? "http" : null,
      port: uri.hasPort ? uri.port : null,
    );
    await _addAccount(account);
  }

  Future<void> loginAsToken(String server, String token) async {
    await _validateMisskey(server);
    final uri = serverToUri(server);
    final hostWithPort = uri.hasPort ? "${uri.host}:${uri.port}" : uri.host;
    final apiUrl = uri.scheme == "http" ? "http://$hostWithPort/api/" : null;
    final streamingUrl = uri.scheme == "http"
        ? "ws://$hostWithPort/streaming/"
        : null;
    final misskey = Misskey(
      token: token,
      host: hostWithPort,
      apiUrl: apiUrl,
      streamingUrl: streamingUrl,
    );
    final i = await misskey.i.i();
    final meta = await misskey.meta();
    await _addAccount(
      Account(
        host: uri.host,
        userId: i.username,
        token: token,
        i: i,
        meta: meta,
        scheme: uri.scheme == "http" ? "http" : null,
        port: uri.hasPort ? uri.port : null,
      ),
    );
  }

  Future<void> openMiAuth(String server) async {
    await _validateMisskey(server);
    final uri = serverToUri(server);
    final hostWithPort = uri.hasPort ? "${uri.host}:${uri.port}" : uri.host;

    _sessionId = const Uuid().v4();

    // MiAuth URLを構築
    final miAuthUrl = uri.scheme == "http"
        ? _buildHttpMiAuthUrl(uri, _sessionId)
        : MisskeyServer().buildMiAuthURL(
            uri.host,
            _sessionId,
            name: "Miria",
            permission: Permission.values,
          );

    await launchUrl(
      Uri.parse(miAuthUrl.toString()),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> validateMiAuth(String server) async {
    final uri = serverToUri(server);
    final hostWithPort = uri.hasPort ? "${uri.host}:${uri.port}" : uri.host;
    final token = uri.scheme == "http"
        ? await _checkHttpMiAuthToken(uri, _sessionId)
        : await MisskeyServer().checkMiAuthToken(uri.host, _sessionId);
    final apiUrl = uri.scheme == "http" ? "http://$hostWithPort/api/" : null;
    final streamingUrl = uri.scheme == "http"
        ? "ws://$hostWithPort/streaming/"
        : null;
    final misskey = Misskey(
      token: token,
      host: hostWithPort,
      apiUrl: apiUrl,
      streamingUrl: streamingUrl,
    );
    final i = await misskey.i.i();
    final meta = await misskey.meta();
    await _addAccount(
      Account(
        host: uri.host,
        userId: i.username,
        token: token,
        i: i,
        meta: meta,
        scheme: uri.scheme == "http" ? "http" : null,
        port: uri.hasPort ? uri.port : null,
      ),
    );
  }

  Future<void> _addAccount(Account account) async {
    final alreadyCreated = state.map((e) => e.acct).contains(account.acct);
    if (alreadyCreated) {
      state.removeWhere((e) => e.acct == account.acct);
    }

    state = [...state, account];
    _validatedAccts.add(account.acct);
    await ref.read(emojiRepositoryProvider(account)).loadFromSourceIfNeed();

    await _save();
    if (!alreadyCreated) {
      await ref
          .read(tabSettingsRepositoryProvider)
          .initializeTabSettings(account);
    }
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final actualIndex = newIndex - (oldIndex < newIndex ? 1 : 0);
    final newState = state.toList();
    final item = newState.removeAt(oldIndex);
    newState.insert(actualIndex, item);
    state = newState;

    await _save();
  }

  Future<void> _save() async {
    await sharedPreferenceController.setStringSecure(
      "accounts",
      jsonEncode(state.map((e) => e.toJson()).toList()),
    );
  }
}
