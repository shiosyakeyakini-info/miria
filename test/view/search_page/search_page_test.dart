import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/model/note_search_condition.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/default_root_widget.dart';
import '../../test_util/mock.mocks.dart';
import '../../test_util/test_datas.dart';

void main() {
  group("ノート検索", () {
    testWidgets(
        "確定でノートの検索ができること、"
        "検索結果のノートが表示されること", (tester) async {
      final mockMisskey = MockMisskey();
      final mockNote = MockMisskeyNotes();
      when(mockMisskey.notes).thenReturn(mockNote);
      when(mockNote.search(any)).thenAnswer((_) async => [TestData.note1]);

      await tester.pumpWidget(ProviderScope(
        overrides: [misskeyProvider.overrideWith((ref, arg) => mockMisskey)],
        child: DefaultRootWidget(
          initialRoute: SearchRoute(account: TestData.account),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), "Misskey");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(mockNote.search(
              argThat(equals(const NotesSearchRequest(query: "Misskey")))))
          .called(1);
      expect(find.text(TestData.note1.text!), findsOneWidget);

      when(mockNote.search(any)).thenAnswer((_) async => [TestData.note2]);
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down).at(1));
      await tester.pumpAndSettle();

      verify(mockNote.search(argThat(equals(NotesSearchRequest(
              query: "Misskey", untilId: TestData.note1.id)))))
          .called(1);
      expect(find.text(TestData.note2.text!), findsOneWidget);
    });

    testWidgets("ユーザー指定ができること", (tester) async {
      final mockMisskey = MockMisskey();
      final mockNote = MockMisskeyNotes();
      final mockUsers = MockMisskeyUsers();
      when(mockMisskey.notes).thenReturn(mockNote);
      when(mockMisskey.users).thenReturn(mockUsers);
      when(mockNote.search(any)).thenAnswer((_) async => [TestData.note1]);
      when(mockUsers.search(any)).thenAnswer((_) async => [TestData.user1]);

      await tester.pumpWidget(ProviderScope(
        overrides: [misskeyProvider.overrideWith((ref, arg) => mockMisskey)],
        child: DefaultRootWidget(
          initialRoute: SearchRoute(account: TestData.account),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.keyboard_arrow_right).at(0));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).hitTestable(), "常駐AI");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.tap(find.text("藍"));
      await tester.pumpAndSettle();

      // 指定したユーザーが表示されていること
      expect(find.descendant(of: find.byType(Card), matching: find.text("@ai")),
          findsOneWidget);

      // ノートが表示されていること
      expect(find.text(TestData.note1.text!), findsOneWidget);
      verify(mockNote.search(argThat(equals(
              NotesSearchRequest(query: "", userId: TestData.user1ExpectId)))))
          .called(1);
    });

    testWidgets("チャンネル指定ができること", (tester) async {
      final mockMisskey = MockMisskey();
      final mockNote = MockMisskeyNotes();
      final mockChannel = MockMisskeyChannels();
      when(mockMisskey.notes).thenReturn(mockNote);
      when(mockMisskey.channels).thenReturn(mockChannel);
      when(mockNote.search(any)).thenAnswer((_) async => [TestData.note1]);
      when(mockChannel.followed(any))
          .thenAnswer((_) async => [TestData.channel1]);
      when(mockChannel.myFavorite(any))
          .thenAnswer((_) async => [TestData.channel2]);

      await tester.pumpWidget(ProviderScope(
        overrides: [misskeyProvider.overrideWith((ref, arg) => mockMisskey)],
        child: DefaultRootWidget(
          initialRoute: SearchRoute(account: TestData.account),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.keyboard_arrow_right).at(1));
      await tester.pumpAndSettle();

      await tester.tap(find.text(TestData.channel2.name));
      await tester.pumpAndSettle();

      // 指定したチャンネルが表示されていること
      expect(
          find.descendant(
            of: find.byType(Card),
            matching: find.text(TestData.channel2.name),
          ),
          findsOneWidget);

      // ノートが表示されていること
      expect(find.text(TestData.note1.text!), findsOneWidget);
      verify(mockNote.search(argThat(equals(
              NotesSearchRequest(query: "", channelId: TestData.channel2.id)))))
          .called(1);
    });

    testWidgets("ハッシュタグを検索した場合、ハッシュタグのエンドポイントで検索されること", (tester) async {
      final mockMisskey = MockMisskey();
      final mockNote = MockMisskeyNotes();
      when(mockMisskey.notes).thenReturn(mockNote);
      when(mockNote.searchByTag(any)).thenAnswer((_) async => [TestData.note1]);

      await tester.pumpWidget(ProviderScope(
        overrides: [misskeyProvider.overrideWith((ref, arg) => mockMisskey)],
        child: DefaultRootWidget(
          initialRoute: SearchRoute(account: TestData.account),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), "#藍ちゃん大食いチャレンジ");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(mockNote.searchByTag(argThat(
              equals(const NotesSearchByTagRequest(tag: "藍ちゃん大食いチャレンジ")))))
          .called(1);
      expect(find.text(TestData.note1.text!), findsOneWidget);

      when(mockNote.searchByTag(any)).thenAnswer((_) async => [TestData.note2]);
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down).at(1));
      await tester.pumpAndSettle();

      verify(mockNote.searchByTag(argThat(equals(NotesSearchByTagRequest(
              tag: "藍ちゃん大食いチャレンジ", untilId: TestData.note1.id)))))
          .called(1);
      expect(find.text(TestData.note2.text!), findsOneWidget);
    });
  });

  group("ユーザー検索", () {
    testWidgets(
        "確定でユーザー検索ができること、"
        "検索結果のユーザーが表示されること", (tester) async {
      final mockMisskey = MockMisskey();
      final mockUser = MockMisskeyUsers();
      when(mockMisskey.users).thenReturn(mockUser);
      when(mockUser.search(any)).thenAnswer((_) async => [TestData.user1]);

      await tester.pumpWidget(ProviderScope(
        overrides: [misskeyProvider.overrideWith((ref, arg) => mockMisskey)],
        child: DefaultRootWidget(
          initialRoute: SearchRoute(account: TestData.account),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text("ユーザー"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), "常駐AI");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(mockUser.search(argThat(equals(const UsersSearchRequest(
              query: "常駐AI", origin: Origin.combined)))))
          .called(1);
      expect(find.text("藍"), findsOneWidget);
    });

    testWidgets("ローカルの場合、ローカルで検索されること", (tester) async {
      final mockMisskey = MockMisskey();
      final mockUser = MockMisskeyUsers();
      when(mockMisskey.users).thenReturn(mockUser);
      when(mockUser.search(any)).thenAnswer((_) async => [TestData.user1]);

      await tester.pumpWidget(ProviderScope(
        overrides: [misskeyProvider.overrideWith((ref, arg) => mockMisskey)],
        child: DefaultRootWidget(
          initialRoute: SearchRoute(account: TestData.account),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text("ユーザー"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("ローカル"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), "常駐AI");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(mockUser.search(argThat(equals(
              const UsersSearchRequest(query: "常駐AI", origin: Origin.local)))))
          .called(1);
    });

    testWidgets("リモートの場合、リモートで検索されること", (tester) async {
      final mockMisskey = MockMisskey();
      final mockUser = MockMisskeyUsers();
      when(mockMisskey.users).thenReturn(mockUser);
      when(mockUser.search(any)).thenAnswer((_) async => [TestData.user1]);

      await tester.pumpWidget(ProviderScope(
        overrides: [misskeyProvider.overrideWith((ref, arg) => mockMisskey)],
        child: DefaultRootWidget(
          initialRoute: SearchRoute(account: TestData.account),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text("ユーザー"));
      await tester.pumpAndSettle();

      await tester.tap(find.text("リモート"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), "常駐AI");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      verify(mockUser.search(argThat(equals(
              const UsersSearchRequest(query: "常駐AI", origin: Origin.remote)))))
          .called(1);
    });
  });

  group("その他", () {
    testWidgets("ノートとチャンネルの表示が折り畳めること", (tester) async {
      await tester.pumpWidget(ProviderScope(
        child: DefaultRootWidget(
          initialRoute: SearchRoute(account: TestData.account),
        ),
      ));
      await tester.pumpAndSettle();
      expect(
          find.descendant(
              of: find.byType(Card), matching: find.text("ユーザー").hitTestable()),
          findsNothing);
      expect(find.text("チャンネル").hitTestable(), findsNothing);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byType(Card), matching: find.text("ユーザー").hitTestable()),
          findsOneWidget);
      expect(find.text("チャンネル").hitTestable(), findsOneWidget);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_up));
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byType(Card), matching: find.text("ユーザー").hitTestable()),
          findsNothing);
      expect(find.text("チャンネル").hitTestable(), findsNothing);
    });

    testWidgets("引数で初期値が与えられたとき、その内容の検索結果が初期表示されること", (tester) async {
      final mockMisskey = MockMisskey();
      final mockNote = MockMisskeyNotes();
      when(mockMisskey.notes).thenReturn(mockNote);
      when(mockNote.search(any)).thenAnswer((_) async => [TestData.note1]);

      await tester.pumpWidget(ProviderScope(
        overrides: [misskeyProvider.overrideWith((ref, arg) => mockMisskey)],
        child: DefaultRootWidget(
          initialRoute: SearchRoute(
            account: TestData.account,
            initialNoteSearchCondition:
                const NoteSearchCondition(query: "Misskey"),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text(TestData.note1.text!), findsOneWidget);
      verify(mockNote.search(
              argThat(equals(const NotesSearchRequest(query: "Misskey")))))
          .called(1);
    });
  });
}
