import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/main.dart";

/// アプリを起動して安定するまで待つ
Future<void> launchApp(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: Miria()));
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(seconds: 1));
  }
  await tester.pumpAndSettle(const Duration(seconds: 3));
}

/// WebSocket接続がある状態でも安定して待てるpump
/// pumpAndSettleはストリーミング接続でタイムアウトするため
Future<void> pumpForSeconds(WidgetTester tester, int seconds) async {
  for (var i = 0; i < seconds; i++) {
    await tester.pump(const Duration(seconds: 1));
  }
}

/// APIキーでログインする
Future<void> loginViaApiKey(WidgetTester tester, String token) async {
  await launchApp(tester);

  // LoginPageにいるか確認
  final apiKeyTab = find.text("APIキーでログイン");
  if (apiKeyTab.evaluate().isEmpty) {
    // 既にログイン済み
    return;
  }

  await tester.tap(apiKeyTab);
  await tester.pumpAndSettle();

  final textFields = find.byType(TextField);
  await tester.enterText(textFields.first, "http://127.0.0.1:3000");
  await tester.enterText(textFields.last, token);
  await tester.pumpAndSettle();

  final loginButton = find.widgetWithText(ElevatedButton, "ログイン");
  await tester.tap(loginButton);

  await pumpForSeconds(tester, 30);
}

/// Drawerを開く
Future<void> openDrawer(WidgetTester tester) async {
  final menuButton = find.byIcon(Icons.menu);
  if (menuButton.evaluate().isNotEmpty) {
    await tester.tap(menuButton);
    await tester.pumpAndSettle();
  }
}

/// Drawerのメニュー項目をテキストでタップ
Future<void> tapDrawerItem(WidgetTester tester, String text) async {
  await openDrawer(tester);
  final item = find.text(text);
  expect(item, findsWidgets);
  await tester.tap(item.first);
  await pumpForSeconds(tester, 5);
}

/// 前のページに戻る
Future<void> goBack(WidgetTester tester) async {
  final backButton = find.byType(BackButton);
  if (backButton.evaluate().isNotEmpty) {
    await tester.tap(backButton.first);
    await pumpForSeconds(tester, 3);
    return;
  }
  // AppBarのback buttonアイコンでも試す
  final arrowBack = find.byIcon(Icons.arrow_back);
  if (arrowBack.evaluate().isNotEmpty) {
    await tester.tap(arrowBack.first);
    await pumpForSeconds(tester, 3);
  }
}
