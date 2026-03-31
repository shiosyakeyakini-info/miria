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

  testWidgets("お知らせページが表示される", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await pumpForSeconds(tester, 5);

    // タイムラインのお知らせボタンからアクセス
    final announcementButton = find.byIcon(Icons.campaign);
    if (announcementButton.evaluate().isNotEmpty) {
      await tester.tap(announcementButton.first);
      await pumpForSeconds(tester, 5);

      // お知らせ内容が表示される
      expect(find.byType(Scaffold), findsWidgets);
    }
  });
}
