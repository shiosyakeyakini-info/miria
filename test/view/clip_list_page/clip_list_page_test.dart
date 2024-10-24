import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("クリップ一覧", () {
    testWidgets("クリップ一覧が表示されること", (tester) async {
      final clip = MockMisskeyClips();
      final misskey = MockMisskey();
      when(misskey.clips).thenReturn(clip);
      when(clip.list()).thenAnswer((_) async => [TestData.clip]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((_) => misskey)],
          child: DefaultRootWidget(
            initialRoute:
                ClipListRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(TestData.clip.name!), findsOneWidget);
    });
  });
}
