import "dart:convert";

import "package:dio/dio.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/repository/aiscript_storage_repository.dart";
import "package:miria/rust/api/aiscript.dart";
import "package:miria/rust/api/aiscript/api.dart";
import "package:miria/rust/api/aiscript/play.dart";
import "package:miria/rust/api/aiscript/plugin.dart";
import "package:miria/rust/api/aiscript/ui.dart";
import "package:miria/rust/frb_generated.dart";
import "package:miria/util/nyaize.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:misskey_dart/misskey_dart.dart";

/// Rust 側の初期化が済んでいるか。
///
/// 済んだかどうかを [Future] ではなく真偽値で覚えるのが要点。Future を
/// 使い回すと、それを作ったゾーンの外から待ったときに永久に返らない
/// (ウィジェットテストは1件ごとに別ゾーンで走るため、2件目以降が固まる)。
bool _isRustInitialized = false;
Future<void>? _rustInitialization;

/// AiScript を使う前に呼ぶ。二度目以降は何もしない。
Future<void> ensureAiScriptInitialized() async {
  if (_isRustInitialized) return;
  await (_rustInitialization ??= RustLib.init());
  _isRustInitialized = true;
}

/// アカウントの繋ぎ先。`SERVER_URL` と `Mk:url` に渡す。
Uri serverUriOf(Account account) => Uri(
  scheme: account.scheme == "http" ? "http" : "https",
  host: account.host,
  port: account.port,
);

/// Play・スクラッチパッド・プラグインから使う AiScript の実行環境を組み立てる。
///
/// Rust 側は処理系だけを持っていて、Misskey に触る部分は全部 Dart から
/// 渡したコールバックで動く。ここがその配線。
///
/// [BuildContext] を要求しないのが要点。プラグインはアプリが動いている間
/// ずっと生きていて、特定の画面に紐づかないため。ダイアログは
/// [DialogStateNotifier] 経由で出す。
///
/// [namespace] は `Mk:save` / `Mk:load` の置き場を分ける名前。
/// [read] を渡さないと `Mk:readline` は空文字を返す。
/// [onComponentUpdate] を渡すと `Ui:render` の結果がそこに流れてくる。
/// [playId] を渡すと `THIS_ID` / `THIS_URL` が生える。
///
/// スクリプトは呼び出し元が消えたあとも [AiScript.abort] が効くまで動きうる
/// ので、[onComponentUpdate] は破棄済みの状態で呼ばれても平気に書くこと。
/// Rust 側はこのコールバックが投げないことを前提にしていて、投げると panic
/// する。
Future<AiScript> createAiScript({
  required Misskey misskey,
  required Account account,
  required AiScriptStorageRepository storage,
  required DialogStateNotifier dialogs,
  required String locale,
  Future<String> Function(String prompt)? read,
  void Function(String value)? write,
  void Function(String id, AsUiComponent component)? onComponentUpdate,
  String? playId,
  AsPluginLib? plugin,
}) async {
  await ensureAiScriptInitialized();

  final serverUrl = serverUriOf(account).toString();
  final url = playId != null ? "$serverUrl/play/$playId" : serverUrl;

  // CUSTOM_EMOJIS は取れなくても実行自体は続けられるので、失敗は握りつぶす
  String customEmojis;
  try {
    customEmojis = jsonEncode((await misskey.emojis()).emojis);
  } catch (_) {
    customEmojis = "[]";
  }

  // Ui:render は同じ id に対して何度も飛んでくる。到着順が前後しうるので、
  // 各 id について最後に見た更新番号より古いものは捨てる
  final updateCounts = <String, int>{};

  /// 題と本文をひとつの文言にまとめる。
  String messageOf(String title, String text) =>
      title.isEmpty ? text : "$title\n\n$text";

  return AiScript.newInstance(
    read: (prompt) async => await read?.call(prompt) ?? "",
    write: write ?? (_) {},
    api: AsApiLib(
      userId: account.isDemoAccount ? null : account.i.id,
      userName: account.i.name,
      userUsername: account.i.username,
      customEmojis: customEmojis,
      locale: locale,
      serverUrl: serverUrl,
      url: url,
      token: account.token,
      dialog: (title, text, _) async {
        await dialogs.showSimpleDialog(message: (_) => messageOf(title, text));
      },
      confirm: (title, text, _) async {
        final result = await dialogs.showDialog(
          message: (_) => messageOf(title, text),
          actions: (context) => [S.of(context).done, S.of(context).cancel],
        );
        return result == 0;
      },
      toast: (text) async {
        await dialogs.showSimpleDialog(message: (_) => text);
      },
      api: (endpoint, param, token) async {
        final decoded = jsonDecode(param);
        try {
          final response = await misskey.apiService.post<dynamic>(
            endpoint,
            decoded is Map<String, dynamic> ? decoded : {},
            // トークンは apiService が i として足すので、null でも消させない
            excludeRemoveNullPredicate: (key, _) => key != "i",
          );
          return (jsonEncode(response), null);
        } catch (e) {
          return ("", _encodeError(e));
        }
      },
      save: storage.save,
      load: storage.load,
      remove: storage.remove,
      nyaize: nyaize,
    ),
    ui: onComponentUpdate != null
        ? AsUiLib(
            onUpdate: (id, component, updateCount) {
              if (updateCounts[id] case final previous?
                  when updateCount < previous) {
                return;
              }
              updateCounts[id] = updateCount;
              onComponentUpdate(id, component);
            },
          )
        : null,
    play: playId != null ? AsPlayLib(thisId: playId, thisUrl: url) : null,
    plugin: plugin,
  );
}

/// AiScript 側は `Mk:api` の失敗を JSON 文字列として受け取る。
String _encodeError(Object error) {
  switch (error) {
    case MisskeyException():
      return jsonEncode(error);
    case DioException(:final response, :final type):
      if (response?.data case final Map<String, dynamic> data) {
        try {
          return jsonEncode(data["error"] ?? data);
        } catch (_) {}
      }
      return jsonEncode({"type": type.toString()});
    default:
      try {
        return jsonEncode(error);
      } catch (_) {
        return jsonEncode(error.toString());
      }
  }
}
