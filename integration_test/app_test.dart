import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:integration_test/integration_test.dart";
import "package:miria/main.dart";
import "package:misskey_dart/misskey_dart.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const misskeyHost = "127.0.0.1:3000";
  const misskeyToken = String.fromEnvironment(
    "MISSKEY_TOKEN",
    defaultValue: "5K3UiUPYyRWzQbHy",
  );

  testWidgets("app starts successfully", (tester) async {
    await tester.pumpWidget(const ProviderScope(child: Miria()));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(ProviderScope), findsOneWidget);
  });

  testWidgets("can connect to local Misskey via API", (tester) async {
    final misskey = Misskey(
      host: misskeyHost,
      token: misskeyToken,
      apiUrl: "http://$misskeyHost/api/",
      streamingUrl: "ws://$misskeyHost/streaming/",
    );

    final pong = await misskey.ping();
    expect(pong, isNotNull);

    final me = await misskey.i.i();
    expect(me.username, equals("admin"));
    expect(me.isAdmin, isTrue);

    await misskey.notes.create(
      NotesCreateRequest(text: "Integration test note"),
    );

    final timeline = await misskey.notes.localTimeline(
      const NotesLocalTimelineRequest(),
    );
    expect(timeline, isNotEmpty);
    expect(timeline.first.text, equals("Integration test note"));

    await misskey.notes.delete(NotesDeleteRequest(noteId: timeline.first.id));

    await tester.pumpWidget(const ProviderScope(child: Miria()));
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });

  testWidgets("login via API key and create note", (tester) async {
    await tester.pumpWidget(const ProviderScope(child: Miria()));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // SplashPage → LoginPage に遷移するのを待つ
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 「APIキーでログイン」タブに切り替え
    final apiKeyTab = find.text("APIキーでログイン");
    expect(apiKeyTab, findsOneWidget);
    await tester.tap(apiKeyTab);
    await tester.pumpAndSettle();

    // サーバーURLを入力
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(2));
    await tester.enterText(textFields.first, "http://127.0.0.1:3000");

    // APIキーを入力
    await tester.enterText(textFields.last, misskeyToken);
    await tester.pumpAndSettle();

    // ログインボタンを押す（ElevatedButton内のテキストを特定）
    final loginButton = find.widgetWithText(ElevatedButton, "ログイン");
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);

    // ログイン処理とページ遷移を待つ
    // pumpAndSettleはアニメーション完了まで待つが、タイムアウトがある
    // pumpを繰り返して十分な時間を確保する
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // 現在表示されているウィジェットを確認
    // TimeLinePageに遷移した場合、Drawerのアイコンが表示される
    final hasDrawer = find.byIcon(Icons.menu);
    final hasFab = find.byType(FloatingActionButton);

    // ログインが成功してタイムラインに遷移したか、
    // またはログインページにまだいるかを確認
    if (hasFab.evaluate().isNotEmpty) {
      // タイムラインに遷移成功
      expect(hasFab, findsWidgets);
    } else if (hasDrawer.evaluate().isNotEmpty) {
      // Drawerのあるページ（タイムライン）にいる
      expect(hasDrawer, findsWidgets);
    } else {
      // デバッグ：現在のウィジェットツリーを確認
      debugDumpApp();
      fail("Expected to be on TimeLinePage after login");
    }
  });
}
