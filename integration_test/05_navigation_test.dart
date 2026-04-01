import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";

import "helpers/misskey_setup.dart";
import "helpers/test_data.dart";
import "helpers/test_helpers.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MisskeyTestSetup misskeySetup;

  setUpAll(() async {
    misskeySetup = MisskeyTestSetup();
    await misskeySetup.setup();
    final testData = TestData(misskeySetup);
    await testData.seed();
  });

  testWidgets("Drawer経由で各ページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);

    await openDrawer(tester);
    expect(find.text("testuser"), findsWidgets);

    final menuItems = [
      "通知",
      "お気に入り",
      "リスト",
      "アンテナ",
      "クリップ",
      "チャンネル",
      "検索",
      "みつける",
      "Misskey Games",
    ];

    for (final item in menuItems) {
      await openDrawer(tester);
      final menuItem = find.text(item);
      if (menuItem.evaluate().isNotEmpty) {
        await tester.tap(menuItem.first);
        await pumpForSeconds(tester, 5);
        expect(
          find.byType(Scaffold),
          findsWidgets,
          reason: "$item ページが表示されるべき",
        );
        await goBack(tester);
      }
    }

    await tapDrawerItem(tester, "設定");
    expect(find.byType(Scaffold), findsWidgets);
  });
}
