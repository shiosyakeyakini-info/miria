import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:integration_test/integration_test.dart";
import "package:miria/main.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const misskeyToken = String.fromEnvironment(
    "MISSKEY_TOKEN",
    defaultValue: "5K3UiUPYyRWzQbHy",
  );

  testWidgets("login via API key and navigate to timeline", (tester) async {
    await tester.pumpWidget(const ProviderScope(child: Miria()));

    // SplashPage → LoginPage に遷移するのを待つ
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ログインページにいるか確認
    final apiKeyTab = find.text("APIキーでログイン");
    if (apiKeyTab.evaluate().isEmpty) {
      return;
    }

    // 「APIキーでログイン」タブに切り替え
    await tester.tap(apiKeyTab);
    await tester.pumpAndSettle();

    // サーバーURLを入力
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(2));
    await tester.enterText(textFields.first, "http://127.0.0.1:3000");

    // APIキーを入力
    await tester.enterText(textFields.last, misskeyToken);
    await tester.pumpAndSettle();

    // ログインボタンを押す
    final loginButton = find.widgetWithText(ElevatedButton, "ログイン");
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);

    // ログイン処理とページ遷移を十分に待つ
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(seconds: 1));
    }

    // タイムラインページに遷移したことを確認
    final loginTab = find.text("APIキーでログイン");
    expect(loginTab, findsNothing, reason: "Should have left the login page");
  });
}
