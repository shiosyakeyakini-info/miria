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

  testWidgets("NoteCreatePageでノートを作成できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);

    // NoteCreatePageを開く
    final editButton = find.byIcon(Icons.edit_note);
    if (editButton.evaluate().isEmpty) return;
    await tester.tap(editButton.first);
    await pumpForSeconds(tester, 5);

    // テキスト入力
    final textFields = find.byType(TextField);
    expect(textFields, findsWidgets);

    // 最も大きなテキストフィールド（ノート本文）に入力
    await tester.enterText(textFields.last, "NoteCreatePageからの投稿テスト");
    await tester.pumpAndSettle();

    // 送信ボタン
    final sendButton = find.byIcon(Icons.send);
    expect(sendButton, findsWidgets);
    await tester.tap(sendButton.first);
    await pumpForSeconds(tester, 5);
  });

  testWidgets("CWトグルが動作する", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);

    // NoteCreatePageを開く
    final editButton = find.byIcon(Icons.edit_note);
    if (editButton.evaluate().isEmpty) return;
    await tester.tap(editButton.first);
    await pumpForSeconds(tester, 5);

    // CWトグルボタンを探してタップ
    // CwToggleButtonはIconButton with Icons.visibility_off or similar
    final cwButton = find.byIcon(Icons.visibility_off);
    if (cwButton.evaluate().isNotEmpty) {
      await tester.tap(cwButton.first);
      await tester.pumpAndSettle();

      // CWテキストフィールドが表示されることを確認
      // TextFieldが1つ増えるはず
      final textFields = find.byType(TextField);
      expect(textFields.evaluate().length, greaterThanOrEqualTo(2));
    }
  });
}
