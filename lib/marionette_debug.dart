/// marionette_mcp（AI エージェントから実行中アプリを操作・観測する MCP サーバー）
/// との接続を debug ビルド限定で有効にする。
///
/// リリースビルドでは [kDebugMode] ガードによりすべて無効化され、marionette 由来の
/// コードはツリーシェイクで落ちる。アプリの状態を無制限に読めるため、
/// リリースに混入させてはならない。
///
/// 使い方は `marionette_riverpod_plugin/README.md` を参照。
library;

import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:marionette_flutter/marionette_flutter.dart";
import "package:marionette_riverpod_plugin/marionette_riverpod_plugin.dart";
import "package:miria/log.dart";

/// root [ProviderContainer] を捕捉する observer。
///
/// Riverpod にはグローバルな container レジストリがないため、`riverpod_snapshot`
/// にどの container を見せるかはアプリ側から渡す必要がある。observer なら
/// 既存の [ProviderScope] に引数を 1 つ足すだけで済み、
/// `UncontrolledProviderScope` への組み替えが要らない。
final _observer = kDebugMode ? MarionetteRiverpodObserver() : null;

/// Flutter の binding を初期化する。
///
/// [WidgetsFlutterBinding.ensureInitialized] の代わりに `main()` の先頭で呼ぶこと。
/// debug 時は marionette の binding（[WidgetsFlutterBinding] の派生）を立て、
/// release 時は通常の binding を立てる。
void initializeMarionetteBinding() {
  if (!kDebugMode) {
    WidgetsFlutterBinding.ensureInitialized();
    return;
  }

  // miria のログ (lib/log.dart) を marionette の `get_logs` に流す。
  // これがないと `get_logs` は「ロガーが未設定」というエラーを返すだけになる。
  final logCollector = PrintLogCollector();
  MarionetteBinding.ensureInitialized(
    MarionetteConfiguration(logCollector: logCollector),
  );
  logger.onLogged = (log, info) => logCollector.addLog(log);

  registerRiverpodMarionetteExtensions(containerLocator: _observer!.locate);
}

/// [ProviderScope] に渡す observer。release ビルドでは空になる。
List<ProviderObserver> get marionetteObservers => [?_observer];
