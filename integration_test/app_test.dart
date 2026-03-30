import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:miria/main.dart" as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("app starts successfully", (tester) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // アプリが起動できることを確認
    expect(find.bySubtype<MaterialApp>(), findsOneWidget);
  });
}
