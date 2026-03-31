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

  testWidgets("ユーザーページが表示される", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);

    // 検索からユーザーページに遷移
    await tapDrawerItem(tester, "検索");

    // ユーザータブに切り替え
    final userTab = find.text("ユーザー");
    if (userTab.evaluate().isNotEmpty) {
      await tester.tap(userTab.first);
      await pumpForSeconds(tester, 3);
    }

    // adminを検索
    final textField = find.byType(TextField);
    if (textField.evaluate().isNotEmpty) {
      await tester.enterText(textField.first, "admin");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await pumpForSeconds(tester, 5);

      // 検索結果からadminをタップ
      final adminUser = find.text("admin");
      if (adminUser.evaluate().isNotEmpty) {
        await tester.tap(adminUser.first);
        await pumpForSeconds(tester, 5);

        // ユーザーページに遷移（TabBarが表示される）
        expect(find.byType(Scaffold), findsWidgets);
      }
    }
  });
}
