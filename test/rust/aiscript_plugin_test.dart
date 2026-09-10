import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:miria/rust/api/aiscript.dart";
import "package:miria/rust/api/aiscript/plugin.dart";
import "package:miria/rust/frb_generated.dart";

/// `Plugin:*` の配線。
///
/// プラグインは本家 Misskey にしかない機能で、aria には実装がない。ここでは
/// Rust 側に足した登録の口が Dart から使えることを見る。
///
/// なお `flutter test` は native assets を FFI に解決しないため、frb の
/// フォールバック先である `rust/target/release/` に共有ライブラリが必要。
/// 事前に `cargo build --release --manifest-path rust/Cargo.toml` を実行する。
void main() {
  setUpAll(() async => RustLib.init());

  /// 登録されたハンドラの受け皿。
  late Map<String, (String, PluginActionCallback)> actions;
  late Map<String, PluginPostFormActionCallback> postFormActions;
  late Map<String, PluginInterruptorCallback> interruptors;
  late List<String> openedUrls;
  late List<String> output;

  setUp(() {
    actions = {};
    postFormActions = {};
    interruptors = {};
    openedUrls = [];
    output = [];
  });

  /// プラグインを走らせて、登録が済んだ状態にする。
  Future<AiScript> launch(String script, {String config = "{}"}) async {
    final aiscript = await AiScript.newInstance(
      read: (_) async => "",
      write: output.add,
      plugin: AsPluginLib(
        config: config,
        openUrl: openedUrls.add,
        onAction: (kind, title, callback) => actions[kind] = (title, callback),
        onPostFormAction: (title, callback) =>
            postFormActions[title] = callback,
        onInterruptor: (kind, callback) => interruptors[kind] = callback,
      ),
    );
    await aiscript.exec(input: script);
    return aiscript;
  }

  test("メタデータが読めること", () async {
    final meta = jsonDecode(
      await parsePluginMeta(
        input: """
        /// @ 0.19.0
        ### {
          name: "テストプラグイン"
          version: "1.0.0"
          author: "みりあ"
          description: "ためしに書いたもの"
        }
        """,
      ),
    );

    expect(meta, {
      "name": "テストプラグイン",
      "version": "1.0.0",
      "author": "みりあ",
      "description": "ためしに書いたもの",
    });
  });

  test("メタデータがないと失敗すること", () async {
    await expectLater(parsePluginMeta(input: "<: 1"), throwsA(isA<String>()));
  });

  group("Plugin:register", () {
    test("note_action が登録され、ノートを渡して呼べること", () async {
      await launch("""
        Plugin:register:note_action("ノートに何かする", @(note) {
          <: note.text
        })
        """);

      expect(actions.keys, ["note"]);
      expect(actions["note"]!.$1, "ノートに何かする");

      await actions["note"]!.$2.call(
        value: jsonEncode({"id": "9abc", "text": "やあ"}),
      );
      expect(output, ["やあ"]);
    });

    test("user_action が登録されること", () async {
      await launch("""
        Plugin:register:user_action("ユーザーに何かする", @(user) {
          <: user.username
        })
        """);

      expect(actions["user"]!.$1, "ユーザーに何かする");
      await actions["user"]!.$2.call(value: jsonEncode({"username": "miria"}));
      expect(output, ["miria"]);
    });

    test("note_view_interruptor がノートを書き換えて返すこと", () async {
      await launch("""
        Plugin:register:note_view_interruptor(@(note) {
          note.text = `{note.text}!!`
          return note
        })
        """);

      final result = jsonDecode(
        await interruptors["note_view"]!.call(
          value: jsonEncode({"id": "9abc", "text": "やあ"}),
        ),
      );
      expect(result, {"id": "9abc", "text": "やあ!!"});
    });

    test("note_post_interruptor と page_view_interruptor も登録されること", () async {
      await launch("""
        Plugin:register:note_post_interruptor(@(note) { return note })
        Plugin:register:page_view_interruptor(@(page) { return page })
        """);

      expect(interruptors.keys, containsAll(["note_post", "page_view"]));
    });

    test("post_form_action の update した内容が返ること", () async {
      await launch("""
        Plugin:register:post_form_action("本文を書き換える", @(form, update) {
          update("text", `{form.text}っす`)
          update("cw", "注意")
        })
        """);

      expect(postFormActions.keys, ["本文を書き換える"]);

      final updates = jsonDecode(
        await postFormActions["本文を書き換える"]!.call(
          form: jsonEncode({"text": "こんにちは"}),
        ),
      );
      expect(updates, {"text": "こんにちはっす", "cw": "注意"});
    });

    test("アンダースコア表記の旧名でも登録できること", () async {
      await launch("""
        Plugin:register_note_action("旧", @(note) {})
        """);

      expect(actions["note"]!.$1, "旧");
    });
  });

  test("Plugin:config が渡ること", () async {
    await launch(
      "<: Plugin:config.greeting",
      config: jsonEncode({"greeting": "やあ"}),
    );

    expect(output, ["やあ"]);
  });

  test("Plugin:open_url が Dart 側を呼ぶこと", () async {
    await launch("""Plugin:open_url("https://example.test/")""");

    expect(openedUrls, ["https://example.test/"]);
  });
}
