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

  testWidgets("リスト一覧表示と詳細遷移", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "リスト");
    await pumpForSeconds(tester, 5);

    final list = find.text("テストリスト");
    expect(list, findsWidgets);

    await tester.tap(list.first);
    await pumpForSeconds(tester, 5);
    expect(find.byType(Scaffold), findsWidgets);
  });
}
