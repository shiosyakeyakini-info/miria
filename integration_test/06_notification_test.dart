import "package:flutter/material.dart";
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

    // 通知を発生させる: 管理者がテストユーザーのノートにリアクション
    if (testData.noteId != null) {
      await misskeySetup.adminClient.notes.reactions.create(
        NotesReactionsCreateRequest(noteId: testData.noteId!, reaction: "👍"),
      );
    }
  });

  testWidgets("通知ページが表示される", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await tapDrawerItem(tester, "通知");
    await pumpForSeconds(tester, 5);

    expect(find.byType(Scaffold), findsWidgets);
    // タブが表示されている（すべて、自分宛て等）
    expect(find.byType(TabBar), findsWidgets);
  });
}
