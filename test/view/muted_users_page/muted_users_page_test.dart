import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/muted_users_page/muted_users_notifier.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

class MockMisskeyMute extends Mock implements MisskeyMute {
  @override
  Future<Iterable<Muting>> list(MuteListRequest? request) => super.noSuchMethod(
        Invocation.method(#list, [request]),
        returnValue: Future<Iterable<Muting>>.value(<Muting>[]),
        returnValueForMissingStub: Future<Iterable<Muting>>.value(<Muting>[]),
      ) as Future<Iterable<Muting>>;
}

void main() {
  group("ミュート済みユーザー一覧", () {
    testWidgets("ミュート済みユーザーが表示されること", (tester) async {
      final mute = MockMisskeyMute();
      final misskey = MockMisskey();
      when(misskey.mute).thenReturn(mute);
      final user = UserDetailedNotMe.fromJson(TestData.detailedUser1.toJson());
      when(mute.list(const MuteListRequest())).thenAnswer(
        (_) => Future<Iterable<Muting>>.value([
          Muting(
            id: '1',
            createdAt: DateTime.now(),
            muteeId: user.id,
            mutee: user,
          )
        ]),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((_) => misskey)],
          child: DefaultRootWidget(
            initialRoute: MutedUsersRoute(account: TestData.account),
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
