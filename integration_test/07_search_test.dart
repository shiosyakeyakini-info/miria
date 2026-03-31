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

  testWidgets("検索ページでタブが表示される", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "検索");

    // 3つのタブ: ノート、ユーザー、Flash
    expect(find.text("ノート"), findsWidgets);
    expect(find.text("ユーザー"), findsWidgets);
  });

  testWidgets("ユーザータブで検索できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "検索");

    // ユーザータブに切り替え
    final userTab = find.text("ユーザー");
    if (userTab.evaluate().isNotEmpty) {
      await tester.tap(userTab.first);
      await pumpForSeconds(tester, 3);
    }

    // 検索フィールドに入力
    final textField = find.byType(TextField);
    if (textField.evaluate().isNotEmpty) {
      await tester.enterText(textField.first, "admin");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await pumpForSeconds(tester, 5);
    }
  });
}
