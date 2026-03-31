import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:misskey_dart/misskey_dart.dart";

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

  testWidgets("API接続確認", (tester) async {
    final pong = await misskeySetup.userClient.ping();
    expect(pong, isNotNull);

    final me = await misskeySetup.userClient.i.i();
    expect(me.username, equals("testuser"));
  });

  testWidgets("APIキーでログインしてタイムラインに遷移する", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);

    final loginTab = find.text("APIキーでログイン");
    expect(loginTab, findsNothing, reason: "ログインページから離脱しているべき");
  });
}
