import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";

import "helpers/misskey_setup.dart";
import "helpers/test_data.dart";
import "helpers/test_helpers.dart";

late MisskeyTestSetup misskeySetup;
late TestData testData;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    misskeySetup = MisskeyTestSetup();
    await misskeySetup.setup();
    testData = TestData(misskeySetup);
    await testData.seed();
  });

  /// Drawer経由で各メニューに遷移し、ページが表示されることを確認
  testWidgets("Drawerを開ける", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);

    await openDrawer(tester);
    // Drawerが表示されている（ユーザー名が見える）
    expect(find.text("testuser"), findsWidgets);
  });

  testWidgets("通知ページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "通知");
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets("お気に入りページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "お気に入り");
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets("リストページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "リスト");
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets("アンテナページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "アンテナ");
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets("クリップページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "クリップ");
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets("チャンネルページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "チャンネル");
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets("検索ページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "検索");
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets("みつけるページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "みつける");
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets("Misskey Gamesページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "Misskey Games");
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets("設定ページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "設定");
    expect(find.byType(Scaffold), findsWidgets);
  });
}
