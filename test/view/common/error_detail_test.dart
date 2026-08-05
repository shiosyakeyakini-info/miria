import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/view/common/error_detail.dart";
import "package:misskey_dart/misskey_dart.dart";

import "../../test_util/default_root_widget.dart";

MisskeyException _exception(String code, String message) => MisskeyException(
  id: "00000000-0000-0000-0000-000000000000",
  code: code,
  message: message,
  kind: MisskeyExceptionKind.client,
);

Widget _wrap(Widget child) => ProviderScope(
  child: DefaultRootNoRouterWidget(child: Scaffold(body: child)),
);

void main() {
  group("認証が通らないエラー (#545)", () {
    for (final code in ["AUTHENTICATION_FAILED", "CREDENTIAL_REQUIRED"]) {
      testWidgets("$code のとき、再ログインへの導線が出ること", (tester) async {
        await tester.pumpWidget(
          _wrap(
            ErrorDetail(
              error: _exception(code, "Authentication failed."),
              stackTrace: StackTrace.current,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text("再ログイン"), findsOneWidget);
        // サーバーの生メッセージやスタックトレースを浴びせない
        expect(find.textContaining("Authentication failed."), findsNothing);
        expect(find.textContaining("不明なエラー"), findsNothing);
      });
    }

    // ストリーミングの401はWebSocketExceptionで来るうえ、メッセージに
    // 接続先URLが載る。miriaはトークンをクエリで渡すので画面に出てしまう。
    testWidgets("ストリーミングが401で弾かれたとき、再ログインへの導線が出てトークンが出ないこと", (tester) async {
      const raw =
          "ParallelWaitError: WebSocketChannelException: WebSocketException: "
          "Connection to 'http://localhost:3000/streaming/?i=SECRET-TOKEN#' "
          "was not upgraded to websocket, HTTP status code: 401";

      await tester.pumpWidget(
        _wrap(ErrorDetail(error: raw, stackTrace: StackTrace.current)),
      );
      await tester.pumpAndSettle();

      expect(find.text("再ログイン"), findsOneWidget);
      expect(find.textContaining("SECRET-TOKEN"), findsNothing);
    });

    testWidgets("それ以外のMisskeyExceptionは、サーバーの文言をそのまま出すこと", (tester) async {
      await tester.pumpWidget(
        _wrap(
          ErrorDetail(
            error: _exception("NO_SUCH_NOTE", "No such note."),
            stackTrace: StackTrace.current,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("No such note."), findsOneWidget);
      expect(find.text("再ログイン"), findsNothing);
      // 以前は MisskeyException が素通りして
      // 「不明なエラー」＋toString＋スタックトレースになっていた
      expect(find.textContaining("不明なエラー"), findsNothing);
    });
  });

  group("長いエラーの高さ (#523)", () {
    // Misskey.io の障害時のように、応答本文がまるごと出てくる状況
    final hugeError = Exception("お知らせ" * 2000);

    testWidgets("BoundedErrorDetailは、下に置いた要素を画面外へ押し出さないこと", (tester) async {
      const tabBarKey = Key("tab-bar");
      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;

      await tester.pumpWidget(
        _wrap(
          Column(
            children: [
              BoundedErrorDetail(error: hugeError, stackTrace: null),
              const Expanded(child: SizedBox.expand()),
              const SizedBox(key: tabBarKey, height: 48, child: Text("タブバー")),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Columnが溢れていないこと（溢れるとRenderFlexのFlutterErrorが飛ぶ）
      expect(tester.takeException(), isNull);

      // タブバーが画面内に残っていること
      final tabBar = tester.getRect(find.byKey(tabBarKey));
      expect(tabBar.bottom, lessThanOrEqualTo(screenHeight));

      // エラー表示が画面の大半を占領していないこと
      final errorBox = tester.getRect(find.byType(BoundedErrorDetail));
      expect(errorBox.height, lessThan(screenHeight / 2));
    });
  });
}
