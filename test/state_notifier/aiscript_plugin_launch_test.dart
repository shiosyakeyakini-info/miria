import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/aiscript_plugin_notifier.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../test_util/mock.mocks.dart";
import "../test_util/test_datas.dart";

/// アプリを起動した直後の、入れてあるプラグインの立ち上げ。
///
/// このファイルは他のどこでも AiScript を触らないまま `launchAll` から始める
/// のが要点。`install` を先に通すと Rust 側の初期化が済んでしまい、起動時
/// だけ踏む不具合が隠れる。実際に一度、`AsPluginLib` が `createAiScript` の
/// 引数として先に評価されるせいで「flutter_rust_bridge has not been
/// initialized」で起動時だけ落ちていた。
///
/// AiScript は Rust 側で動くため、`flutter test` からは
/// `rust/target/release/` の共有ライブラリが要る。事前に
/// `cargo build --release --manifest-path rust/Cargo.toml` を実行する。
void main() {
  test("入れてあるプラグインが、初期化を挟まずに起動できること", () async {
    // 前回の起動で入れてあった体で、保存済みの一覧を先に置く
    SharedPreferences.setMockInitialValues({
      "aiscript:plugins": jsonEncode([
        {
          "installId": "11111111-2222-3333-4444-555555555555",
          "name": "起動時に動くもの",
          "version": "1.0.0",
          "author": "みりあ",
          "src": """
            /// @ 0.19.0
            ### {
              name: "起動時に動くもの"
              version: "1.0.0"
              author: "みりあ"
            }
            Plugin:register:note_action("起動時に登録された", @(note) {})
            """,
          "active": true,
        },
      ]),
    });

    final mockMisskey = MockMisskey();
    when(
      mockMisskey.emojis(),
    ).thenAnswer((_) async => const EmojisResponse(emojis: []));
    final container = ProviderContainer(
      overrides: [misskeyProvider.overrideWith((ref, account) => mockMisskey)],
    );
    addTearDown(container.dispose);

    await container
        .read(aiScriptPluginProvider(TestData.account).notifier)
        .launchAll(locale: "ja-JP");

    final state = container.read(aiScriptPluginProvider(TestData.account));
    expect(state.plugins, hasLength(1));
    // 起動に失敗するとログにだけ残ってハンドラが生えない
    expect(state.logs[state.plugins.single.installId] ?? const [], isEmpty);
    expect(state.noteActions.single.title, "起動時に登録された");
  });
}
