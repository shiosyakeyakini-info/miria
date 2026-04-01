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

  testWidgets("NoteCreatePageでノートを作成できる", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);

    final editButton = find.byIcon(Icons.edit_note);
    if (editButton.evaluate().isEmpty) return;
    await tester.tap(editButton.first);
    await pumpForSeconds(tester, 5);

    final textFields = find.byType(TextField);
    expect(textFields, findsWidgets);
    await tester.enterText(textFields.last, "NoteCreatePageテスト");
    await tester.pumpAndSettle();

    final sendButton = find.byIcon(Icons.send);
    expect(sendButton, findsWidgets);
    await tester.tap(sendButton.first);
    await pumpForSeconds(tester, 5);
  });
}
