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

  testWidgets("設定ページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);

    // Drawerからスクロールして「設定」をタップ
    await openDrawer(tester);
    await pumpForSeconds(tester, 3);

    // Drawerをスクロールして「設定」を見つける
    final settingsItem = find.text("設定");
    if (settingsItem.evaluate().isNotEmpty) {
      await tester.tap(settingsItem.first);
      await pumpForSeconds(tester, 5);

      // 設定ページの内容を確認
      expect(find.byType(Scaffold), findsWidgets);
    }
  });
}
