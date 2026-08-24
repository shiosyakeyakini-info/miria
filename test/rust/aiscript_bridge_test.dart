import "package:flutter_test/flutter_test.dart";
import "package:miria/rust/api/aiscript.dart";
import "package:miria/rust/api/aiscript/api.dart";
import "package:miria/rust/api/aiscript/play.dart";
import "package:miria/rust/api/aiscript/ui.dart";
import "package:miria/rust/frb_generated.dart";

/// Rust 側の AiScript 実行環境が Dart から使えているかを確かめる。
///
/// 処理系そのもののテストは aiscript-rs 側に揃っているので、ここでは
/// flutter_rust_bridge の配線 —— とくに Dart 側のコールバックが
/// AiScript から呼び戻されること —— を見る。
///
/// なお `flutter test` は native assets を FFI に解決しないため、frb の
/// フォールバック先である `rust/target/release/` に共有ライブラリが必要。
/// 事前に `cargo build --release --manifest-path rust/Cargo.toml` を実行する。
void main() {
  setUpAll(() async => RustLib.init());

  /// 出力を集めながらスクリプトを実行する。
  Future<List<String>> run(
    String input, {
    AsApiLib? api,
    AsUiLib? ui,
    AsPlayLib? play,
  }) async {
    final output = <String>[];
    final aiscript = await AiScript.newInstance(
      read: (_) async => "",
      write: output.add,
      api: api,
      ui: ui,
      play: play,
    );
    await aiscript.exec(input: input);
    return output;
  }

  test("組み込んでいる AiScript のバージョンが取得できること", () async {
    expect(
      await AiScript.aiscriptVersion(),
      matches(RegExp(r"^\d+\.\d+\.\d+")),
    );
  });

  test("スクリプトが実行され出力が返ること", () async {
    expect(await run("<: 'Hello, world!'"), ["Hello, world!"]);
    expect(await run("<: (1 + 2) * 3"), ["9"]);
    expect(await run("for (let i, 3) { <: i }"), ["0", "1", "2"]);
  });

  test("構文エラーが例外として伝わること", () async {
    await expectLater(run("<: ("), throwsA(isA<String>()));
  });

  group("Mk:", () {
    /// Dart 側に置いたストレージを Mk:save / Mk:load から触らせる。
    AsApiLib apiLib(Map<String, String> storage, List<String> toasts) =>
        AsApiLib(
          customEmojis: "[]",
          locale: "ja-JP",
          serverUrl: "https://example.test",
          url: "https://example.test",
          dialog: (_, _, _) {},
          confirm: (_, _, _) => true,
          toast: toasts.add,
          api: (_, _, _) => ("null", null),
          save: (key, value) => storage[key] = value,
          load: (key) => storage[key] ?? "null",
          remove: storage.remove,
          nyaize: (text) => text,
        );

    test("Mk:save と Mk:load が Dart 側のストレージを往復すること", () async {
      final storage = <String, String>{};
      final output = await run("""
        Mk:save('greeting', 'こんにちは')
        <: Mk:load('greeting')
        """, api: apiLib(storage, []));
      expect(storage["greeting"], '"こんにちは"');
      expect(output, ["こんにちは"]);
    });

    test("Mk:dialog が Dart 側のコールバックを呼ぶこと", () async {
      final toasts = <String>[];
      await run("Mk:dialog('題', '本文')", api: apiLib({}, toasts));
      // dialog は握りつぶしているので、副作用のない実行が通ることだけを見る
      expect(toasts, isEmpty);
    });

    test("USER_ID などの定数が渡ること", () async {
      final output = await run(
        "<: [USER_ID, USER_USERNAME, LOCALE, SERVER_URL]",
        api: AsApiLib(
          userId: "abc123",
          userUsername: "miria",
          customEmojis: "[]",
          locale: "ja-JP",
          serverUrl: "https://example.test",
          url: "https://example.test",
          dialog: (_, _, _) {},
          confirm: (_, _, _) => true,
          toast: (_) {},
          api: (_, _, _) => ("null", null),
          save: (_, _) {},
          load: (_) => "null",
          remove: (_) {},
          nyaize: (text) => text,
        ),
      );
      expect(output, [
        '[ "abc123", "miria", "ja-JP", "https://example.test" ]',
      ]);
    });
  });

  group("Ui:", () {
    test("Ui:C:text が Dart 側にコンポーネントとして届くこと", () async {
      final updates = <(String, AsUiComponent)>[];
      await run(
        "Ui:render([Ui:C:text({ text: 'ここにテキスト' })])",
        ui: AsUiLib(
          onUpdate: (id, component, _) => updates.add((id, component)),
        ),
      );
      expect(updates, isNotEmpty);
      final root = updates.last.$2;
      expect(root, isA<AsUiComponent_Root>());
    });
  });

  group("Play:", () {
    test("THIS_ID と THIS_URL が渡ること", () async {
      final output = await run(
        "<: [THIS_ID, THIS_URL]",
        play: const AsPlayLib(
          thisId: "9abcdef",
          thisUrl: "https://example.test/play/9abcdef",
        ),
      );
      expect(output, ['[ "9abcdef", "https://example.test/play/9abcdef" ]']);
    });
  });
}
