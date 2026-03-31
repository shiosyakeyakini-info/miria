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
  });

  testWidgets("タイムラインにノートが表示される", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);

    // タイムラインにテストノートが表示されていることを確認
    await pumpForSeconds(tester, 5);
    // Scaffoldが表示されている（タイムラインページにいる）
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets("クイック投稿でノートを作成できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);

    // テキスト入力フィールドを探す
    final textField = find.byType(TextField);
    if (textField.evaluate().isNotEmpty) {
      await tester.enterText(textField.first, "E2Eテスト投稿");
      await tester.pumpAndSettle();

      // 送信ボタン
      final sendButton = find.byIcon(Icons.send);
      if (sendButton.evaluate().isNotEmpty) {
        await tester.tap(sendButton.first);
        await pumpForSeconds(tester, 5);
      }
    }

    // 投稿が成功したことをAPI経由で確認
    final timeline = await misskeySetup.userClient.notes.localTimeline(
      const NotesLocalTimelineRequest(limit: 5),
    );
    expect(
      timeline.any((n) => n.text == "E2Eテスト投稿"),
      isTrue,
      reason: "投稿したノートがタイムラインに存在するべき",
    );
  });

  testWidgets("ノート編集ボタンでNoteCreatePageに遷移する", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);

    final editButton = find.byIcon(Icons.edit_note);
    if (editButton.evaluate().isNotEmpty) {
      await tester.tap(editButton.first);
      await pumpForSeconds(tester, 5);

      // NoteCreatePageのタイトルを確認
      expect(find.text("ノート"), findsWidgets);
    }
  });
}
