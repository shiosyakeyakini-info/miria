import "dart:async";
import "dart:convert";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:miria/model/account.dart";
import "package:miria/model/aiscript_plugin.dart";
import "package:miria/providers.dart";
import "package:miria/repository/aiscript_plugin_repository.dart";
import "package:miria/repository/aiscript_storage_repository.dart";
import "package:miria/rust/api/aiscript.dart";
import "package:miria/rust/api/aiscript/plugin.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/play_page/create_aiscript.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:url_launcher/url_launcher.dart";
import "package:uuid/uuid.dart";

part "aiscript_plugin_notifier.freezed.dart";
part "aiscript_plugin_notifier.g.dart";

/// ノートやユーザーのメニューにプラグインが生やした項目。
class PluginAction {
  final String installId;
  final String title;
  final PluginActionCallback callback;

  const PluginAction({
    required this.installId,
    required this.title,
    required this.callback,
  });
}

/// 投稿フォームにプラグインが生やした項目。
class PluginPostFormAction {
  final String installId;
  final String title;
  final PluginPostFormActionCallback callback;

  const PluginPostFormAction({
    required this.installId,
    required this.title,
    required this.callback,
  });
}

/// 表示や投稿の内容を書き換えるもの。
class PluginInterruptor {
  final String installId;
  final PluginInterruptorCallback callback;

  const PluginInterruptor({required this.installId, required this.callback});
}

@freezed
abstract class AiScriptPluginState with _$AiScriptPluginState {
  const factory AiScriptPluginState({
    @Default(<AiScriptPlugin>[]) List<AiScriptPlugin> plugins,
    @Default(<PluginAction>[]) List<PluginAction> noteActions,
    @Default(<PluginAction>[]) List<PluginAction> userActions,
    @Default(<PluginPostFormAction>[])
    List<PluginPostFormAction> postFormActions,
    @Default(<PluginInterruptor>[])
    List<PluginInterruptor> noteViewInterruptors,
    @Default(<PluginInterruptor>[])
    List<PluginInterruptor> notePostInterruptors,
    @Default(<PluginInterruptor>[])
    List<PluginInterruptor> pageViewInterruptors,

    /// プラグインごとの `<:` 出力とエラー。設定画面で見る。
    @Default(<String, List<String>>{}) Map<String, List<String>> logs,
  }) = _AiScriptPluginState;
}

/// 入れてあるプラグインを起動して面倒を見る。
///
/// 一覧は端末ごとだが、実行はアカウントごとに行う。`Mk:api` が使う
/// トークンがアカウントで違うため。
@Riverpod(keepAlive: true)
class AiScriptPluginNotifier extends _$AiScriptPluginNotifier {
  /// 動いているスクリプト。installId で引く。
  final _running = <String, AiScript>{};
  var _disposed = false;
  var _launched = false;

  @override
  AiScriptPluginState build(Account account) {
    _disposed = false;
    _launched = false;
    ref.onDispose(() {
      _disposed = true;
      for (final aiscript in _running.values) {
        unawaited(aiscript.abort());
      }
      _running.clear();
    });
    return const AiScriptPluginState();
  }

  AiScriptPluginRepository get _repository =>
      ref.read(aiScriptPluginRepositoryProvider);

  /// 入れてあるプラグインを読み込んで、有効なものを動かす。
  ///
  /// アプリの起動時に呼ぶ。呼ぶ側を選ばなくて済むよう、二度目以降は何も
  /// しない (アカウントごとに一度だけ動く)。
  Future<void> launchAll({required String locale}) async {
    if (_launched) return;
    _launched = true;
    final plugins = await _repository.load();
    if (_disposed) return;
    state = state.copyWith(plugins: plugins);
    for (final plugin in plugins.where((plugin) => plugin.active)) {
      await _launch(plugin, locale: locale);
    }
  }

  /// コードからプラグインを入れて動かす。
  ///
  /// メタデータが読めない、必須項目がない、同じ名前のものが既に入っている、
  /// のいずれかなら例外を投げる。
  Future<AiScriptPlugin> install(String code, {required String locale}) async {
    // メタデータの読み取りも Rust 側なので、先に初期化しておく
    await ensureAiScriptInitialized();
    final meta = await parsePluginMeta(input: code);
    final decoded = jsonDecode(meta);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException("メタデータがオブジェクトではありません");
    }
    if (decoded case {
      "name": final String name,
      "version": final String version,
      "author": final String author,
    }) {
      if (state.plugins.any((plugin) => plugin.name == name)) {
        throw StateError("同じ名前のプラグインが既に入っています: $name");
      }
      final plugin = AiScriptPlugin(
        installId: const Uuid().v4(),
        name: name,
        version: version,
        author: author,
        src: code,
        description: decoded["description"] as String?,
        permissions:
            (decoded["permissions"] as List?)?.cast<String>() ?? const [],
        config:
            (decoded["config"] as Map?)?.cast<String, dynamic>() ?? const {},
      );
      await _persist([...state.plugins, plugin]);
      await _launch(plugin, locale: locale);
      return plugin;
    }
    throw const FormatException("name / version / author が足りません");
  }

  Future<void> uninstall(AiScriptPlugin plugin) async {
    await _abort(plugin.installId);
    await _persist(
      state.plugins.where((e) => e.installId != plugin.installId).toList(),
    );
    await _repository.clearStorage(plugin.installId);
    state = state.copyWith(logs: {...state.logs}..remove(plugin.installId));
  }

  Future<void> setActive(
    AiScriptPlugin plugin,
    bool active, {
    required String locale,
  }) async {
    final updated = plugin.copyWith(active: active);
    await _persist(
      state.plugins
          .map((e) => e.installId == plugin.installId ? updated : e)
          .toList(),
    );
    if (active) {
      await _launch(updated, locale: locale);
    } else {
      await _abort(plugin.installId);
    }
  }

  /// 設定を書き換えて動かし直す。
  Future<void> updateConfig(
    AiScriptPlugin plugin,
    Map<String, dynamic> configData, {
    required String locale,
  }) async {
    final updated = plugin.copyWith(configData: configData);
    await _persist(
      state.plugins
          .map((e) => e.installId == plugin.installId ? updated : e)
          .toList(),
    );
    if (updated.active) {
      await _abort(plugin.installId);
      await _launch(updated, locale: locale);
    }
  }

  Future<void> _persist(List<AiScriptPlugin> plugins) async {
    await _repository.save(plugins);
    if (_disposed) return;
    state = state.copyWith(plugins: plugins);
  }

  /// 動いているスクリプトを止めて、登録されたハンドラを取り下げる。
  Future<void> _abort(String installId) async {
    await _running.remove(installId)?.abort();
    if (_disposed) return;
    bool isOther(String id) => id != installId;
    state = state.copyWith(
      noteActions: state.noteActions
          .where((e) => isOther(e.installId))
          .toList(),
      userActions: state.userActions
          .where((e) => isOther(e.installId))
          .toList(),
      postFormActions: state.postFormActions
          .where((e) => isOther(e.installId))
          .toList(),
      noteViewInterruptors: state.noteViewInterruptors
          .where((e) => isOther(e.installId))
          .toList(),
      notePostInterruptors: state.notePostInterruptors
          .where((e) => isOther(e.installId))
          .toList(),
      pageViewInterruptors: state.pageViewInterruptors
          .where((e) => isOther(e.installId))
          .toList(),
    );
  }

  Future<void> _launch(AiScriptPlugin plugin, {required String locale}) async {
    final installId = plugin.installId;
    try {
      // AsPluginLib は createAiScript の引数なので、その中の初期化より先に
      // 評価される。frb の sync な生成なのでこの時点で Rust を呼びに行き、
      // 初期化前だと Bad state で落ちる。ここで先に済ませておく
      await ensureAiScriptInitialized();
      final aiscript = await createAiScript(
        // providers.dart にも account という関数があるので this を付ける
        misskey: ref.read(misskeyProvider(this.account)),
        account: this.account,
        storage: ref.read(
          aiScriptStorageRepositoryProvider((
            account: this.account,
            namespace: "plugins:$installId",
          )),
        ),
        dialogs: ref.read(dialogStateProvider.notifier),
        locale: locale,
        write: (value) => _log(installId, value),
        plugin: AsPluginLib(
          config: jsonEncode(plugin.effectiveConfig),
          openUrl: (url) async {
            final uri = Uri.tryParse(url);
            if (uri != null) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          onAction: (kind, title, callback) {
            // Rust 側はこのコールバックが投げない前提なので、状態の更新は
            // 破棄後でも黙って捨てる
            if (_disposed) return;
            final action = PluginAction(
              installId: installId,
              title: title,
              callback: callback,
            );
            state = switch (kind) {
              "note" => state.copyWith(
                noteActions: [...state.noteActions, action],
              ),
              "user" => state.copyWith(
                userActions: [...state.userActions, action],
              ),
              _ => state,
            };
          },
          onPostFormAction: (title, callback) {
            if (_disposed) return;
            state = state.copyWith(
              postFormActions: [
                ...state.postFormActions,
                PluginPostFormAction(
                  installId: installId,
                  title: title,
                  callback: callback,
                ),
              ],
            );
          },
          onInterruptor: (kind, callback) {
            if (_disposed) return;
            final interruptor = PluginInterruptor(
              installId: installId,
              callback: callback,
            );
            state = switch (kind) {
              "note_view" => state.copyWith(
                noteViewInterruptors: [
                  ...state.noteViewInterruptors,
                  interruptor,
                ],
              ),
              "note_post" => state.copyWith(
                notePostInterruptors: [
                  ...state.notePostInterruptors,
                  interruptor,
                ],
              ),
              "page_view" => state.copyWith(
                pageViewInterruptors: [
                  ...state.pageViewInterruptors,
                  interruptor,
                ],
              ),
              _ => state,
            };
          },
        ),
      );
      if (_disposed) {
        await aiscript.abort();
        return;
      }
      _running[installId] = aiscript;
      await aiscript.exec(input: plugin.src);
    } catch (e) {
      _log(installId, e.toString());
    }
  }

  void _log(String installId, String message) {
    if (_disposed) return;
    final logs = [...?state.logs[installId], message];
    state = state.copyWith(
      logs: {
        ...state.logs,
        // 際限なく溜めても仕方ないので、後ろの方だけ残す
        installId: logs.length > 200 ? logs.sublist(logs.length - 200) : logs,
      },
    );
  }
}
