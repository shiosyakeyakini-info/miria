import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("ブロック済みユーザー一覧", () {
    testWidgets("ブロック済みユーザーが表示されること", (tester) async {
      final blocking = MockMisskeyBlocking();
      final misskey = MockMisskey();
      when(misskey.blocking).thenReturn(blocking);
      final user = UserDetailedNotMe.fromJson(TestData.detailedUser1.toJson());
      when(blocking.list(const BlockingListRequest())).thenAnswer(
        (_) async => [
          Blocking(
            id: '1',
            createdAt: DateTime.now(),
            blockeeId: user.id,
            blockee: user,
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((_) => misskey)],
          child: DefaultRootWidget(
            initialRoute: BlockedUsersRoute(account: TestData.account),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining(TestData.detailedUser1.name!, findRichText: true),
        findsOneWidget,
      );
    });
  });
}
