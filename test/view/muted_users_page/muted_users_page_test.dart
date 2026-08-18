import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";
import "../../test_util/widget_tester_extension.dart";

class MockMisskeyMute extends Mock implements MisskeyMute {
  @override
  Future<Iterable<Muting>> list(MuteListRequest? request) =>
      super.noSuchMethod(
            Invocation.method(#list, [request]),
            returnValue: Future<Iterable<Muting>>.value(<Muting>[]),
            returnValueForMissingStub: Future<Iterable<Muting>>.value(
              <Muting>[],
            ),
          )
          as Future<Iterable<Muting>>;

  @override
  Future<void> delete(MuteDeleteRequest? request) =>
      super.noSuchMethod(
            Invocation.method(#delete, [request]),
            returnValue: Future<void>.value(),
            returnValueForMissingStub: Future<void>.value(),
          )
          as Future<void>;
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
            id: "1",
            createdAt: DateTime.now(),
            muteeId: user.id,
            mutee: user,
          ),
        ]),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, _) => misskey)],
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

    // 1ページ目を取ってそのままListViewに流していたので、続きを読み込む
    // 手段がなかった
    // https://github.com/shiosyakeyakini-info/miria/issues/777
    testWidgets("「さらに読み込む」で続きを読み込めること", (tester) async {
      final mute = MockMisskeyMute();
      final misskey = MockMisskey();
      when(misskey.mute).thenReturn(mute);
      final user = UserDetailedNotMe.fromJson(TestData.detailedUser1.toJson());

      Muting muting(String id) => Muting(
        id: id,
        createdAt: DateTime.now(),
        muteeId: user.id,
        mutee: user,
      );

      // 具体的なstubが後勝ちになるよう、先に既定を置く
      when(
        mute.list(any),
      ).thenAnswer((_) => Future<Iterable<Muting>>.value(<Muting>[]));
      when(mute.list(const MuteListRequest())).thenAnswer(
        (_) => Future<Iterable<Muting>>.value([muting("1"), muting("2")]),
      );
      when(
        mute.list(const MuteListRequest(untilId: "2")),
      ).thenAnswer((_) => Future<Iterable<Muting>>.value([muting("3")]));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, _) => misskey)],
          child: DefaultRootWidget(
            initialRoute: MutedUsersRoute(account: TestData.account),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(2));

      await tester.pageNation();

      // 2ページ目のぶんが足されていること
      expect(find.byType(ListTile), findsNWidgets(3));
      verify(mute.list(const MuteListRequest(untilId: "2"))).called(1);
    });

    // 一覧の持ち主がPushableListViewに移ったあとも、notifierを生かしておかないと
    // 確認ダイアログのawaitから戻ったときにRefが破棄されていて何も起きない
    testWidgets("ミュートを解除できること", (tester) async {
      final mute = MockMisskeyMute();
      final misskey = MockMisskey();
      when(misskey.mute).thenReturn(mute);
      final user = UserDetailedNotMe.fromJson(TestData.detailedUser1.toJson());

      when(
        mute.list(any),
      ).thenAnswer((_) => Future<Iterable<Muting>>.value(<Muting>[]));
      when(mute.list(const MuteListRequest())).thenAnswer(
        (_) => Future<Iterable<Muting>>.value([
          Muting(
            id: "1",
            createdAt: DateTime.now(),
            muteeId: user.id,
            mutee: user,
          ),
        ]),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, _) => misskey)],
          child: DefaultRootWidget(
            initialRoute: MutedUsersRoute(account: TestData.account),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.volume_up));
      await tester.pumpAndSettle();

      await tester.tap(find.text("ミュート解除"));
      await tester.pumpAndSettle();

      verify(mute.delete(MuteDeleteRequest(userId: user.id))).called(1);
    });
  });
}
