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

  testWidgets("検索ページでタブ表示とユーザー検索", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "検索");

    expect(find.text("ノート"), findsWidgets);
    expect(find.text("ユーザー"), findsWidgets);

    final userTab = find.text("ユーザー");
    if (userTab.evaluate().isNotEmpty) {
      await tester.tap(userTab.first);
      await pumpForSeconds(tester, 3);
    }

    final textField = find.byType(TextField);
    if (textField.evaluate().isNotEmpty) {
      await tester.enterText(textField.first, "admin");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await pumpForSeconds(tester, 5);
    }
  });
}
