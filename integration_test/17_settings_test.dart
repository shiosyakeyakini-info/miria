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

  testWidgets("設定ページのメニュー項目が表示される", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "設定");
    await pumpForSeconds(tester, 3);

    expect(find.text("一般設定"), findsOneWidget);
    expect(find.text("アカウント設定"), findsOneWidget);
    expect(find.text("タブ設定"), findsOneWidget);
    expect(find.text("Miriaについて"), findsOneWidget);
  });

  testWidgets("一般設定ページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "設定");
    await pumpForSeconds(tester, 3);

    await tester.tap(find.text("一般設定"));
    await pumpForSeconds(tester, 3);

    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets("タブ設定ページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "設定");
    await pumpForSeconds(tester, 3);

    await tester.tap(find.text("タブ設定"));
    await pumpForSeconds(tester, 3);

    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets("Miriaについてページに遷移できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "設定");
    await pumpForSeconds(tester, 3);

    await tester.tap(find.text("Miriaについて"));
    await pumpForSeconds(tester, 3);

    expect(find.byType(Scaffold), findsWidgets);
  });
}
