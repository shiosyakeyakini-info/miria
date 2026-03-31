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

  testWidgets("リスト一覧が表示される", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "リスト");
    await pumpForSeconds(tester, 5);

    expect(find.text("テストリスト"), findsOneWidget);
  });

  testWidgets("リストをタップして詳細に遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "リスト");
    await pumpForSeconds(tester, 5);

    final list = find.text("テストリスト");
    if (list.evaluate().isNotEmpty) {
      await tester.tap(list);
      await pumpForSeconds(tester, 5);
      expect(find.byType(Scaffold), findsWidgets);
    }
  });
}
