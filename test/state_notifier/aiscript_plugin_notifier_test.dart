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

/// プラグインの出し入れと、登録されたハンドラの面倒。
///
/// AiScript は Rust 側で動くため、`flutter test` からは
/// `rust/target/release/` の共有ライブラリが要る。事前に
/// `cargo build --release --manifest-path rust/Cargo.toml` を実行する。
void main() {
  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    final mockMisskey = MockMisskey();
    when(
      mockMisskey.emojis(),
    ).thenAnswer((_) async => const EmojisResponse(emojis: []));
    container = ProviderContainer(
      overrides: [misskeyProvider.overrideWith((ref, account) => mockMisskey)],
    );
    addTearDown(container.dispose);
  });

  AiScriptPluginNotifier notifier() =>
      container.read(aiScriptPluginProvider(TestData.account).notifier);

  AiScriptPluginState get() =>
      container.read(aiScriptPluginProvider(TestData.account));

  /// 動く最小のプラグイン。
  String plugin({
    required String name,
    String body = "",
    String extraMeta = "",
  }) =>
      """
      /// @ 0.19.0
      ### {
        name: "$name"
        version: "1.0.0"
        author: "みりあ"
        $extraMeta
      }
      $body
      """;

  group("入れる", () {
    test("メタデータが読まれて一覧に載ること", () async {
      await notifier().install(plugin(name: "ためし"), locale: "ja-JP");

      expect(get().plugins, hasLength(1));
      final installed = get().plugins.single;
      expect(installed.name, "ためし");
      expect(installed.version, "1.0.0");
      expect(installed.author, "みりあ");
      expect(installed.active, isTrue);
    });

    test("メタデータがないと失敗すること", () async {
      await expectLater(
        notifier().install("<: 1", locale: "ja-JP"),
        throwsA(anything),
      );
      expect(get().plugins, isEmpty);
    });

    test("同じ名前のものは入れられないこと", () async {
      await notifier().install(plugin(name: "ためし"), locale: "ja-JP");

      await expectLater(
        notifier().install(plugin(name: "ためし"), locale: "ja-JP"),
        throwsA(isA<StateError>()),
      );
      expect(get().plugins, hasLength(1));
    });
  });

  group("ハンドラ", () {
    test("note_action と user_action が登録されること", () async {
      await notifier().install(
        plugin(
          name: "メニュー",
          body: """
          Plugin:register:note_action("ノートに", @(note) {})
          Plugin:register:user_action("ユーザーに", @(user) {})
          """,
        ),
        locale: "ja-JP",
      );

      expect(get().noteActions.single.title, "ノートに");
      expect(get().userActions.single.title, "ユーザーに");
    });

    test("interruptor が登録され、呼ぶとノートが書き換わること", () async {
      await notifier().install(
        plugin(
          name: "書き換え",
          body: """
          Plugin:register:note_view_interruptor(@(note) {
            note.text = "書き換えた"
            return note
          })
          """,
        ),
        locale: "ja-JP",
      );

      final interruptor = get().noteViewInterruptors.single;
      final result = jsonDecode(
        await interruptor.callback.call(value: jsonEncode({"text": "もと"})),
      );
      expect(result, {"text": "書き換えた"});
    });

    test("無効にするとハンドラが取り下げられ、有効に戻すと生えること", () async {
      await notifier().install(
        plugin(
          name: "メニュー",
          body: """Plugin:register:note_action("ノートに", @(note) {})""",
        ),
        locale: "ja-JP",
      );
      expect(get().noteActions, hasLength(1));

      final installed = get().plugins.single;
      await notifier().setActive(installed, false, locale: "ja-JP");
      expect(get().noteActions, isEmpty);
      expect(get().plugins.single.active, isFalse);

      await notifier().setActive(get().plugins.single, true, locale: "ja-JP");
      expect(get().noteActions, hasLength(1));
    });

    test("消すとハンドラも消えること", () async {
      await notifier().install(
        plugin(
          name: "メニュー",
          body: """Plugin:register:note_action("ノートに", @(note) {})""",
        ),
        locale: "ja-JP",
      );

      await notifier().uninstall(get().plugins.single);

      expect(get().plugins, isEmpty);
      expect(get().noteActions, isEmpty);
    });

    test("片方だけ消しても、もう片方のハンドラは残ること", () async {
      await notifier().install(
        plugin(
          name: "いち",
          body: """Plugin:register:note_action("いち", @(note) {})""",
        ),
        locale: "ja-JP",
      );
      await notifier().install(
        plugin(
          name: "に",
          body: """Plugin:register:note_action("に", @(note) {})""",
        ),
        locale: "ja-JP",
      );
      expect(get().noteActions, hasLength(2));

      await notifier().uninstall(
        get().plugins.firstWhere((e) => e.name == "いち"),
      );

      expect(get().noteActions.single.title, "に");
    });
  });

  group("設定", () {
    test("Plugin:config に既定値が渡ること", () async {
      await notifier().install(
        plugin(
          name: "設定つき",
          extraMeta:
              """config: { greeting: { type: "string", default: "やあ" } }""",
          body: "<: Plugin:config.greeting",
        ),
        locale: "ja-JP",
      );

      final installId = get().plugins.single.installId;
      expect(get().logs[installId], contains("やあ"));
    });

    test("設定を書き換えると、その値で動き直すこと", () async {
      await notifier().install(
        plugin(
          name: "設定つき",
          extraMeta:
              """config: { greeting: { type: "string", default: "やあ" } }""",
          body: "<: Plugin:config.greeting",
        ),
        locale: "ja-JP",
      );

      await notifier().updateConfig(get().plugins.single, {
        "greeting": "こんばんは",
      }, locale: "ja-JP");

      final installId = get().plugins.single.installId;
      expect(get().logs[installId], contains("こんばんは"));
    });
  });

  test("入れ直したあと、起動時に読み直して動くこと", () async {
    await notifier().install(
      plugin(
        name: "メニュー",
        body: """Plugin:register:note_action("ノートに", @(note) {})""",
      ),
      locale: "ja-JP",
    );

    // アプリを立ち上げ直した体で、状態を作り直す
    container.dispose();
    final mockMisskey = MockMisskey();
    when(
      mockMisskey.emojis(),
    ).thenAnswer((_) async => const EmojisResponse(emojis: []));
    container = ProviderContainer(
      overrides: [misskeyProvider.overrideWith((ref, account) => mockMisskey)],
    );
    addTearDown(container.dispose);

    await notifier().launchAll(locale: "ja-JP");

    expect(get().plugins, hasLength(1));
    expect(get().noteActions.single.title, "ノートに");
  });
}
