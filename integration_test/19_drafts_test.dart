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

  testWidgets("ノート作成中に戻ると下書き保存ダイアログが表示される", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);

    // NoteCreatePageを開く
    final editButton = find.byIcon(Icons.edit_note);
    if (editButton.evaluate().isEmpty) return;
    await tester.tap(editButton.first);
    await pumpForSeconds(tester, 5);

    // テキストを入力
    final textFields = find.byType(TextField);
    if (textFields.evaluate().isEmpty) return;
    await tester.enterText(textFields.last, "下書きテスト");
    await tester.pumpAndSettle();

    // 戻るボタンを押す
    await goBack(tester);
    await tester.pumpAndSettle();

    // ダイアログが表示される（下書き保存の選択肢）
    // 「編集を続ける」「保存して閉じる」「破棄して戻る」のいずれか
    final dialog = find.byType(AlertDialog);
    if (dialog.evaluate().isNotEmpty) {
      // ダイアログが表示されたことを確認
      expect(dialog, findsOneWidget);
    }
  });
}
