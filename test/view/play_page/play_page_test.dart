import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/play_page/play_page.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

/// Play の実行画面。
///
/// AiScript は Rust 側で動くため、`flutter test` からは
/// `rust/target/release/` の共有ライブラリが要る。事前に
/// `cargo build --release --manifest-path rust/Cargo.toml` を実行する。
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Flash flash(String script) => Flash(
    id: "9zzzzzzzzz",
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
    title: "テストのPlay",
    summary: "あらまし",
    script: script,
    userId: TestData.account.userId,
    user: UserLite(
      id: TestData.account.userId,
      username: "miria",
      avatarUrl: Uri.https("example.test", "/avatar.png"),
    ),
  );

  /// AiScript の実行は Rust 側の本物の非同期なので、ウィジェットテストの
  /// 疑似時間では進まない。[WidgetTester.runAsync] で実時間を与えてから
  /// 描き直す。
  Future<void> settle(WidgetTester tester) async {
    // pumpAndSettle は読み込み中のくるくるが止まらないと返らないので、
    // 実時間を刻みながら描き直す
    for (var i = 0; i < 40; i++) {
      await tester.pump();
      await tester.runAsync(
        () async => Future<void>.delayed(const Duration(milliseconds: 25)),
      );
    }
    await tester.pump();
  }

  Future<void> pumpPlay(WidgetTester tester, String script) async {
    final mockMisskey = MockMisskey();
    when(
      mockMisskey.emojis(),
    ).thenAnswer((_) async => const EmojisResponse(emojis: []));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          misskeyProvider.overrideWith((ref, account) => mockMisskey),
        ],
        // AppRouter を噛ませると receive_sharing_intent の
        // EventChannel が runAsync 中に MissingPluginException を投げるので、
        // ルーターなしで画面だけを組み立てる
        child: DefaultRootNoRouterWidget(
          child: AccountContextScope(
            context: TestData.accountContext,
            child: PlayPage(
              accountContext: TestData.accountContext,
              flash: flash(script),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
  }

  group("Play", () {
    testWidgets("タイトルとあらましが表示されること", (tester) async {
      await pumpPlay(tester, "Ui:render([])");

      expect(find.textContaining("テストのPlay"), findsAtLeastNWidgets(1));
      expect(find.textContaining("あらまし"), findsAtLeastNWidgets(1));
    });

    testWidgets("Ui:C:text が表示されること", (tester) async {
      await pumpPlay(tester, """
        Ui:render([
          Ui:C:text({ text: "うごいた" })
        ])
        """);

      expect(find.text("うごいた"), findsOneWidget);
    });

    testWidgets("Ui:C:button を押すとスクリプトの続きが動くこと", (tester) async {
      await pumpPlay(tester, """
        let text = Ui:C:text({ text: "まだ" }, "text")
        Ui:render([
          Ui:C:button({
            text: "おす"
            onClick: @() {
              text.update({ text: "おされた" })
            }
          })
          text
        ])
        """);

      expect(find.text("まだ"), findsOneWidget);

      await tester.tap(find.text("おす"));
      await settle(tester);

      expect(find.text("おされた"), findsOneWidget);
    });

    testWidgets("Ui:C:switch が状態を持つこと", (tester) async {
      await pumpPlay(tester, """
        Ui:render([
          Ui:C:switch({ label: "きりかえ", default: false })
        ])
        """);

      expect(find.byType(Switch), findsOneWidget);
      expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);

      await tester.tap(find.byType(Switch));
      await settle(tester);

      expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);
    });

    testWidgets("Ui:C:textInput に打った内容が AiScript に渡ること", (tester) async {
      await pumpPlay(tester, """
        let out = Ui:C:text({ text: "" }, "out")
        Ui:render([
          Ui:C:textInput({
            label: "なまえ"
            onInput: @(v) {
              out.update({ text: `こんにちは、{v}` })
            }
          })
          out
        ])
        """);

      await tester.enterText(find.byType(TextField), "みりあ");
      await settle(tester);

      expect(find.text("こんにちは、みりあ"), findsOneWidget);
    });

    testWidgets("実行時エラーが画面に出ること", (tester) async {
      await pumpPlay(tester, "<: (");

      expect(find.byType(CircularProgressIndicator), findsNothing);
      // 例外の文言には依存せず、エラー表示が出ていることだけを見る
      expect(find.textContaining("rror"), findsAtLeastNWidgets(1));
    });
  });
}
