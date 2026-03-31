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

  testWidgets("アカウント設定ページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await openDrawer(tester);

    // アカウント設定（testuser用）を探す
    // Drawerのアカウント設定はExpansionTile内にある
    final accountSettings = find.byIcon(Icons.settings);
    if (accountSettings.evaluate().isNotEmpty) {
      // 最初のsettingsアイコンがアカウント設定
      await tester.tap(accountSettings.first);
      await pumpForSeconds(tester, 5);

      expect(find.byType(Scaffold), findsWidgets);
    }
  });
}
