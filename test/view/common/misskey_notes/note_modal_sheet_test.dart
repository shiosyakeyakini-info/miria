import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../../test_util/default_root_widget.dart";
import "../../../test_util/mock.mocks.dart";
import "../../../test_util/test_datas.dart";

void main() {
  group("お気に入り", () {
    testWidgets("該当のノートがお気に入りにされていない場合、お気に入り登録ができること", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskeyNotes.featured(any))
          .thenAnswer((e) async => [TestData.note1]);
      final misskeyFavorites = MockMisskeyNotesFavorites();
      when(misskeyNotes.favorites).thenAnswer((e) => misskeyFavorites);
      when(misskey.notes).thenReturn(misskeyNotes);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text("お気に入り", skipOffstage: false));
      await tester.pumpAndSettle();
      await tester.tap(find.text("お気に入り", skipOffstage: false));

      verify(
        misskeyFavorites.create(
          argThat(
            equals(NotesFavoritesCreateRequest(noteId: TestData.note1.id)),
          ),
        ),
      );
    });

    testWidgets("該当のノートがお気に入り済みの場合、お気に入り解除ができること", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: true, isMutedThread: false),
      );
      final misskeyFavorites = MockMisskeyNotesFavorites();
      when(misskeyNotes.favorites).thenAnswer((e) => misskeyFavorites);
      when(misskey.notes).thenReturn(misskeyNotes);
      when(misskeyNotes.featured(any))
          .thenAnswer((_) async => [TestData.note1]);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text("お気に入り解除", skipOffstage: false));
      await tester.pumpAndSettle();
      await tester.tap(find.text("お気に入り解除", skipOffstage: false));

      verify(
        misskeyFavorites.delete(
          argThat(
            equals(NotesFavoritesDeleteRequest(noteId: TestData.note1.id)),
          ),
        ),
      );
    });
  });

  group("削除", () {
    testWidgets("自分が投稿したノートの削除ができること", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskeyNotes.featured(any))
          .thenAnswer((e) async => [TestData.note1]);
      when(misskey.notes).thenReturn(misskeyNotes);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text("削除", skipOffstage: false));
      await tester.pumpAndSettle();
      await tester.tap(find.text("削除"));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TextButton).hitTestable().at(0));
      await tester.pumpAndSettle();

      verify(
        misskeyNotes.delete(
          argThat(equals(NotesDeleteRequest(noteId: TestData.note1.id))),
        ),
      );
    });

    testWidgets("Renoteのみのノートは削除できないこと", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskeyNotes.featured(any)).thenAnswer(
        (e) async => [
          TestData.note1.copyWith(
            text: null,
            cw: null,
            poll: null,
            renote: TestData.note1,
          ),
        ],
      );
      when(misskey.notes).thenReturn(misskeyNotes);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      expect(find.text("削除", skipOffstage: false), findsNothing);
      expect(find.text("削除してなおす", skipOffstage: false), findsNothing);
    });

    testWidgets("他人のノートを削除できないこと", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskeyNotes.featured(any))
          .thenAnswer((e) async => [TestData.note3AsAnotherUser]);
      when(misskey.notes).thenReturn(misskeyNotes);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      expect(find.text("削除", skipOffstage: false), findsNothing);
      expect(find.text("削除してなおす", skipOffstage: false), findsNothing);
    });

    testWidgets("メディアのみのノートを削除できること", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskey.notes).thenReturn(misskeyNotes);
      final testNote = TestData.note1.copyWith(
        text: null,
        fileIds: [TestData.drive1.id],
        files: [TestData.drive1],
      );
      when(misskeyNotes.featured(any)).thenAnswer((e) async => [testNote]);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      expect(find.text("削除", skipOffstage: false), findsOneWidget);
    });

    testWidgets("投票のみのノートを削除できること", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskey.notes).thenReturn(misskeyNotes);
      final testNote = TestData.note1.copyWith(
        text: null,
        poll: NotePoll(
          choices: const [
            NotePollChoice(text: ":ai_yay:", votes: 1, isVoted: false),
            NotePollChoice(
              text: ":ai_yay_superfast:",
              votes: 2,
              isVoted: false,
            ),
          ],
          multiple: false,
          expiresAt: DateTime.now(),
        ),
      );
      when(misskeyNotes.featured(any)).thenAnswer((e) async => [testNote]);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      expect(find.text("削除", skipOffstage: false), findsOneWidget);
    });

    testWidgets("自分がした引用Renoteを削除できること", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskey.notes).thenReturn(misskeyNotes);
      when(misskeyNotes.featured(any)).thenAnswer(
        (e) async =>
            [TestData.note1.copyWith(text: "やっほー", renote: TestData.note2)],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text("削除", skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.text("削除", skipOffstage: false), findsOneWidget);
      expect(find.text("削除してなおす", skipOffstage: false), findsOneWidget);
    });

    testWidgets("自分がしたメディアつきテキストなしの引用Renoteを削除できること", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskey.notes).thenReturn(misskeyNotes);
      final note = TestData.note1.copyWith(
        text: null,
        renote: TestData.note2,
        fileIds: [TestData.drive1.id],
        files: [TestData.drive1],
      );
      when(misskeyNotes.featured(any)).thenAnswer((e) async => [note]);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text("削除", skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.text("削除", skipOffstage: false), findsOneWidget);
      expect(find.text("削除してなおす", skipOffstage: false), findsOneWidget);
    });

    testWidgets("自分がした投票つきテキストなしの引用Renoteを削除できること", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskey.notes).thenReturn(misskeyNotes);
      final note = TestData.note1.copyWith(
        text: null,
        renote: TestData.note2,
        poll: NotePoll(
          choices: const [
            NotePollChoice(text: ":ai_yay:", votes: 1, isVoted: false),
            NotePollChoice(
              text: ":ai_yay_superfast:",
              votes: 2,
              isVoted: false,
            ),
          ],
          multiple: false,
          expiresAt: DateTime.now(),
        ),
      );
      when(misskeyNotes.featured(any)).thenAnswer((e) async => [note]);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text("削除", skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.text("削除", skipOffstage: false), findsOneWidget);
      expect(find.text("削除してなおす", skipOffstage: false), findsOneWidget);
    });
  });

  group("リノート解除", () {
    testWidgets("自分がしたノートをリノート解除できること", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskey.notes).thenReturn(misskeyNotes);
      when(misskeyNotes.featured(any)).thenAnswer(
        (e) async =>
            [TestData.note1.copyWith(text: null, renote: TestData.note2)],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text("リノートを解除する", skipOffstage: false));
      await tester.pumpAndSettle();
      await tester.tap(find.text("リノートを解除する"));
      await tester.pumpAndSettle();

      verify(
        misskeyNotes.delete(
          argThat(equals(NotesDeleteRequest(noteId: TestData.note1.id))),
        ),
      );
    });

    testWidgets("自分がした引用Renoteをリノート解除できないこと", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskey.notes).thenReturn(misskeyNotes);
      when(misskeyNotes.featured(any)).thenAnswer(
        (e) async =>
            [TestData.note1.copyWith(text: "やっほー", renote: TestData.note2)],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      expect(find.text("リノートを解除する", skipOffstage: false), findsNothing);
    });

    testWidgets("自分がしたメディアつきテキストなしの引用Renoteをリノート解除できないこと", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskey.notes).thenReturn(misskeyNotes);
      final note = TestData.note1.copyWith(
        text: null,
        renote: TestData.note2,
        fileIds: [TestData.drive1.id],
        files: [TestData.drive1],
      );
      when(misskeyNotes.featured(any)).thenAnswer(
        (e) async => [note],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      expect(find.text("リノートを解除する", skipOffstage: false), findsNothing);
    });

    testWidgets("自分がした投票つきテキストなしの引用Renoteをリノート解除できないこと", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskey.notes).thenReturn(misskeyNotes);
      final note = TestData.note1.copyWith(
        text: null,
        renote: TestData.note2,
        poll: NotePoll(
          choices: const [
            NotePollChoice(text: ":ai_yay:", votes: 1, isVoted: false),
            NotePollChoice(
              text: ":ai_yay_superfast:",
              votes: 2,
              isVoted: false,
            ),
          ],
          multiple: false,
          expiresAt: DateTime.now(),
        ),
      );
      when(misskeyNotes.featured(any)).thenAnswer((e) async => [note]);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      expect(find.text("リノートを解除する", skipOffstage: false), findsNothing);
    });

    testWidgets("他人のリノートをリノート解除できないこと", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskey.notes).thenReturn(misskeyNotes);
      final note = TestData.note3AsAnotherUser
          .copyWith(text: null, renote: TestData.note1);
      when(misskey.notes).thenReturn(misskeyNotes);
      when(misskeyNotes.featured(any)).thenAnswer((e) async => [note]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      expect(find.text("リノートを解除する", skipOffstage: false), findsNothing);
    });
  });

  group("通報", () {
    testWidgets("他人のノートを通報できること", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskeyNotes.featured(any))
          .thenAnswer((e) async => [TestData.note3AsAnotherUser]);
      final misskeyUsers = MockMisskeyUsers();
      when(misskey.notes).thenReturn(misskeyNotes);
      when(misskey.users).thenReturn(misskeyUsers);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text("通報する", skipOffstage: false));
      await tester.pumpAndSettle();
      await tester.tap(find.text("通報する"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), "このひとわるものです！");
      await tester.tap(find.byType(ElevatedButton).hitTestable());
      await tester.pump();

      expect(find.byType(Dialog), findsNWidgets(2));
      await tester.tap(find.byType(TextButton).hitTestable());
      await tester.pumpAndSettle();

      verify(
        misskeyUsers.reportAbuse(
          argThat(
            equals(
              UsersReportAbuseRequest(
                userId: TestData.note3AsAnotherUser.userId,
                comment: "このひとわるものです！",
              ),
            ),
          ),
        ),
      );
    });

    testWidgets("自分のノートを通報できないこと", (tester) async {
      final misskey = MockMisskey();
      final misskeyNotes = MockMisskeyNotes();
      when(misskeyNotes.state(any)).thenAnswer(
        (_) async =>
            const NotesStateResponse(isFavorited: false, isMutedThread: false),
      );
      when(misskeyNotes.featured(any))
          .thenAnswer((e) async => [TestData.note1]);
      when(misskey.notes).thenReturn(misskeyNotes);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [misskeyProvider.overrideWith((ref) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ExploreRoute(accountContext: TestData.accountContext),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      expect(find.text("通報する", skipOffstage: false), findsNothing);
    });
  });
}
