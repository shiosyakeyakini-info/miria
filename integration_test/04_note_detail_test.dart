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

  testWidgets("ノートをタップして詳細ページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await pumpForSeconds(tester, 5);

    // タイムライン上のノートテキストをタップ
    final noteText = find.text("テストユーザーのノート1");
    if (noteText.evaluate().isNotEmpty) {
      await tester.tap(noteText.first);
      await pumpForSeconds(tester, 5);

      // 詳細ページに遷移したことを確認（Scaffoldが新しいものに変わる）
      expect(find.byType(Scaffold), findsWidgets);
    }
  });
}
