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

  testWidgets("アンテナ一覧が表示される", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "アンテナ");
    await pumpForSeconds(tester, 5);

    // テストアンテナが表示される
    expect(find.text("テストアンテナ"), findsOneWidget);
  });

  testWidgets("アンテナをタップしてノート一覧に遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "アンテナ");
    await pumpForSeconds(tester, 5);

    final antenna = find.text("テストアンテナ");
    if (antenna.evaluate().isNotEmpty) {
      await tester.tap(antenna);
      await pumpForSeconds(tester, 5);
      expect(find.byType(Scaffold), findsWidgets);
    }
  });
}
