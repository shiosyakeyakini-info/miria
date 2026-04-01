import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:misskey_dart/misskey_dart.dart";

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

  testWidgets("タイムライン表示とクイック投稿", (tester) async {
    await loginViaApiKey(tester, misskeySetup.userToken);
    await pumpForSeconds(tester, 5);

    expect(find.byType(Scaffold), findsWidgets);

    final textField = find.byType(TextField);
    if (textField.evaluate().isNotEmpty) {
      await tester.enterText(textField.first, "E2Eテスト投稿");
      await tester.pumpAndSettle();
      final sendButton = find.byIcon(Icons.send);
      if (sendButton.evaluate().isNotEmpty) {
        await tester.tap(sendButton.first);
        await pumpForSeconds(tester, 5);
      }
    }

    final timeline = await misskeySetup.userClient.notes.localTimeline(
      const NotesLocalTimelineRequest(limit: 5),
    );
    expect(timeline.any((n) => n.text == "E2Eテスト投稿"), isTrue);
  });
}
