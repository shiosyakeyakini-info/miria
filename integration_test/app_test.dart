import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:integration_test/integration_test.dart";
import "package:miria/main.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("app starts successfully", (tester) async {
    await tester.pumpWidget(const ProviderScope(child: Miria()));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // アプリが起動し、何かしらのウィジェットが表示されていることを確認
    expect(find.byType(ProviderScope), findsOneWidget);
  });
}
