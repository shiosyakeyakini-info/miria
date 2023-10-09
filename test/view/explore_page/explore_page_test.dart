import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/default_root_widget.dart';
import '../../test_util/mock.mocks.dart';
import '../../test_util/test_datas.dart';

void main() {
  group("みつける", () {
    group("ハイライト", () {
      testWidgets("ハイライトのノートを表示できること", (tester) async {
        final notes = MockMisskeyNotes();
        final misskey = MockMisskey();
        when(misskey.notes).thenReturn(notes);
        when(notes.featured(any)).thenAnswer((_) async => [TestData.note1]);

        await tester.pumpWidget(ProviderScope(
            overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ExploreRoute(account: TestData.account),
            )));
        await tester.pumpAndSettle();

        expect(find.text(TestData.note1.text!), findsOneWidget);
        verify(notes.featured(argThat(equals(const NotesFeaturedRequest()))));
      });

      testWidgets("アンケートのノートを表示できること", (tester) async {
        final polls = MockMisskeyNotesPolls();
        final notes = MockMisskeyNotes();
        final misskey = MockMisskey();
        when(misskey.notes).thenReturn(notes);
        when(notes.polls).thenReturn(polls);
        when(polls.recommendation(any))
            .thenAnswer((_) async => [TestData.note1]);

        await tester.pumpWidget(ProviderScope(
            overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ExploreRoute(account: TestData.account),
            )));
        await tester.pumpAndSettle();
        await tester.tap(find.text("アンケート"));
        await tester.pumpAndSettle();

        expect(find.text(TestData.note1.text!), findsOneWidget);
        verify(polls.recommendation(
            argThat(equals(const NotesPollsRecommendationRequest()))));
      });
    });

    group("ユーザー", () {
      testWidgets("ピン留めされたユーザーを表示できること", (tester) async {
        final misskey = MockMisskey();
        final notes = MockMisskeyNotes();
        when(misskey.notes).thenReturn(notes);
        when(misskey.pinnedUsers())
            .thenAnswer((_) async => [TestData.detailedUser1]);

        await tester.pumpWidget(ProviderScope(
            overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ExploreRoute(account: TestData.account),
            )));
        await tester.pumpAndSettle();
        await tester.tap(find.text("ユーザー"));
        await tester.pumpAndSettle();

        expect(find.text(TestData.detailedUser1.name!), findsOneWidget);
      });

      testWidgets("ローカルのユーザーを表示できること", (tester) async {
        final misskey = MockMisskey();
        final notes = MockMisskeyNotes();
        final users = MockMisskeyUsers();
        when(misskey.notes).thenReturn(notes);
        when(misskey.users).thenReturn(users);
        when(users.users(any))
            .thenAnswer((_) async => [TestData.detailedUser1]);

        await tester.pumpWidget(ProviderScope(
            overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ExploreRoute(account: TestData.account),
            )));
        await tester.pumpAndSettle();
        await tester.tap(find.text("ユーザー"));
        await tester.pumpAndSettle();
        await tester.tap(find.text("ローカル"));
        await tester.pumpAndSettle();

        expect(find.text(TestData.detailedUser1.name!), findsOneWidget);
        verify(users.users(argThat(equals(const UsersUsersRequest(
            state: UsersState.alive,
            origin: Origin.local,
            sort: UsersSortType.followerDescendant)))));
      });

      testWidgets("リモートのユーザーを表示できること", (tester) async {
        final misskey = MockMisskey();
        final notes = MockMisskeyNotes();
        final users = MockMisskeyUsers();
        when(misskey.notes).thenReturn(notes);
        when(misskey.users).thenReturn(users);
        when(users.users(any))
            .thenAnswer((_) async => [TestData.detailedUser1]);

        await tester.pumpWidget(ProviderScope(
            overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ExploreRoute(account: TestData.account),
            )));
        await tester.pumpAndSettle();
        await tester.tap(find.text("ユーザー"));
        await tester.pumpAndSettle();
        await tester.tap(find.text("リモート"));
        await tester.pumpAndSettle();

        expect(find.text(TestData.detailedUser1.name!), findsOneWidget);
        verify(users.users(argThat(equals(const UsersUsersRequest(
            state: UsersState.alive,
            origin: Origin.remote,
            sort: UsersSortType.followerDescendant)))));
      });
    });

    group("ロール", () {
      testWidgets("公開ロールを表示できること", (tester) async {
        final misskey = MockMisskey();
        final roles = MockMisskeyRoles();
        when(misskey.roles).thenReturn(roles);
        when(misskey.notes).thenReturn(MockMisskeyNotes());
        when(roles.list())
            .thenAnswer((_) async => [TestData.role.copyWith(usersCount: 495)]);

        await tester.pumpWidget(ProviderScope(
            overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ExploreRoute(account: TestData.account),
            )));
        await tester.pumpAndSettle();
        await tester.tap(find.text("ロール"));
        await tester.pumpAndSettle();

        expect(find.textContaining(TestData.role.name, findRichText: true),
            findsOneWidget);
      });
    });

    group("ハッシュタグ", () {
      testWidgets("トレンドのハッシュタグを表示できること", (tester) async {
        final misskey = MockMisskey();
        final hashtags = MockMisskeyHashtags();
        when(misskey.hashtags).thenReturn(hashtags);
        when(misskey.notes).thenReturn(MockMisskeyNotes());
        when(hashtags.trend())
            .thenAnswer((_) async => [TestData.hashtagTrends]);

        await tester.pumpWidget(ProviderScope(
            overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ExploreRoute(account: TestData.account),
            )));
        await tester.pumpAndSettle();
        await tester.tap(find.text("ハッシュタグ"));
        await tester.pumpAndSettle();

        expect(find.textContaining(TestData.hashtagTrends.tag), findsOneWidget);
      });

      testWidgets("ローカルのハッシュタグを表示できること", (tester) async {
        final misskey = MockMisskey();
        final hashtags = MockMisskeyHashtags();
        when(misskey.hashtags).thenReturn(hashtags);
        when(misskey.notes).thenReturn(MockMisskeyNotes());
        when(hashtags.list(any)).thenAnswer((_) async => [TestData.hashtag]);

        await tester.pumpWidget(ProviderScope(
            overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ExploreRoute(account: TestData.account),
            )));
        await tester.pumpAndSettle();
        await tester.tap(find.text("ハッシュタグ"));
        await tester.pumpAndSettle();
        await tester.tap(find.text("ローカル"));
        await tester.pumpAndSettle();

        expect(find.textContaining(TestData.hashtag.tag), findsOneWidget);

        verify(hashtags.list(argThat(predicate<HashtagsListRequest>((request) =>
            request.attachedToLocalUserOnly == true &&
            request.sort ==
                HashtagsListSortType.attachedLocalUsersDescendant))));
      });

      testWidgets("リモートのハッシュタグを表示できること", (tester) async {
        final misskey = MockMisskey();
        final hashtags = MockMisskeyHashtags();
        when(misskey.hashtags).thenReturn(hashtags);
        when(misskey.notes).thenReturn(MockMisskeyNotes());
        when(hashtags.list(any)).thenAnswer((_) async => [TestData.hashtag]);

        await tester.pumpWidget(ProviderScope(
            overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
            child: DefaultRootWidget(
              initialRoute: ExploreRoute(account: TestData.account),
            )));
        await tester.pumpAndSettle();
        await tester.tap(find.text("ハッシュタグ"));
        await tester.pumpAndSettle();
        await tester.tap(find.text("リモート"));
        await tester.pumpAndSettle();

        expect(find.textContaining(TestData.hashtag.tag), findsOneWidget);

        verify(hashtags.list(argThat(predicate<HashtagsListRequest>((request) =>
            request.attachedToRemoteUserOnly == true &&
            request.sort ==
                HashtagsListSortType.attachedRemoteUsersDescendant))));
      });
    });

    group("よそのサーバー", () {});
  });
}
