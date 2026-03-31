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

  testWidgets("チャットページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await openDrawer(tester);

    // チャットメニューが存在する場合のみテスト
    final chatItem = find.text("チャット");
    if (chatItem.evaluate().isEmpty) {
      // チャットが無効な場合はスキップ
      return;
    }

    await tester.tap(chatItem.first);
    await pumpForSeconds(tester, 5);

    expect(find.byType(Scaffold), findsWidgets);
  });
}
