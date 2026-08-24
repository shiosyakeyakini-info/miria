import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/scratchpad_page/scratchpad_page.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

/// スクラッチパッド。
///
/// AiScript は Rust 側で動くため、`flutter test` からは
/// `rust/target/release/` の共有ライブラリが要る。事前に
/// `cargo build --release --manifest-path rust/Cargo.toml` を実行する。
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  /// AiScript の実行は Rust 側の本物の非同期なので、ウィジェットテストの
  /// 疑似時間では進まない。実時間を刻みながら描き直す。
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 40; i++) {
      await tester.pump();
      await tester.runAsync(
        () async => Future<void>.delayed(const Duration(milliseconds: 25)),
      );
    }
    await tester.pump();
  }

  Future<void> pumpScratchpad(WidgetTester tester) async {
    final mockMisskey = MockMisskey();
    when(
      mockMisskey.emojis(),
    ).thenAnswer((_) async => const EmojisResponse(emojis: []));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          misskeyProvider.overrideWith((ref, account) => mockMisskey),
        ],
        // AppRouter を噛ませると receive_sharing_intent の EventChannel が
        // runAsync 中に MissingPluginException を投げるので、ルーターなしで
        // 画面だけを組み立てる
        child: DefaultRootNoRouterWidget(
          child: AccountContextScope(
            context: TestData.accountContext,
            child: ScratchpadPage(accountContext: TestData.accountContext),
          ),
        ),
      ),
    );
    await settle(tester);
  }

  /// コードを打って実行する。
  Future<void> run(WidgetTester tester, String code) async {
    await tester.enterText(find.byType(TextField).first, code);
    await tester.pump();
    await tester.tap(find.text("実行"));
    await settle(tester);
  }

  group("スクラッチパッド", () {
    testWidgets("`<:` の出力が並ぶこと", (tester) async {
      await pumpScratchpad(tester);
      await run(tester, "<: 'こんにちは'\n<: 1 + 1");

      expect(find.text("こんにちは"), findsOneWidget);
      expect(find.text("2"), findsOneWidget);
    });

    testWidgets("スクリプトの評価結果が出ること", (tester) async {
      await pumpScratchpad(tester);
      await run(tester, "1 + 2");

      expect(find.text("3"), findsOneWidget);
    });

    testWidgets("構文エラーが出力欄に出ること", (tester) async {
      await pumpScratchpad(tester);
      await run(tester, "<: (");

      expect(find.textContaining("rror"), findsAtLeastNWidgets(1));
    });

    testWidgets("Ui:render の結果が UI 欄に出ること", (tester) async {
      await pumpScratchpad(tester);
      await run(tester, """
        Ui:render([
          Ui:C:text({ text: "うごいた" })
        ])
        """);

      expect(find.text("UI"), findsOneWidget);
      expect(find.text("うごいた"), findsOneWidget);
    });

    testWidgets("書いたコードが次に開いたとき戻ること", (tester) async {
      await pumpScratchpad(tester);
      await run(tester, "<: 'おぼえてる'");

      // 画面を作り直す
      await pumpScratchpad(tester);

      expect(
        tester.widget<TextField>(find.byType(TextField).first).controller?.text,
        "<: 'おぼえてる'",
      );
    });
  });
}
