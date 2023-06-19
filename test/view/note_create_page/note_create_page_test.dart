import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/model/account_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:miria/view/common/note_create/input_completation.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/mockito.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../test_util/default_root_widget.dart';
import '../../test_util/mock.mocks.dart';
import '../../test_util/test_datas.dart';
import '../../test_util/widget_tester_extension.dart';

void main() {
  group("入力補完", () {
    testWidgets("カスタム絵文字の入力補完が可能なこと", (tester) async {
      final emojiRepository = MockEmojiRepository();
      when(emojiRepository.emoji).thenReturn(
          [TestData.emojiRepositoryData1, TestData.emojiRepositoryData2]);
      when(emojiRepository.searchEmojis(any))
          .thenAnswer((_) async => [TestData.emoji1, TestData.emoji2]);

      await tester.pumpWidget(ProviderScope(
          overrides: [
            emojiRepositoryProvider.overrideWith((ref, arg) => emojiRepository)
          ],
          child: DefaultRootWidget(
            initialRoute: NoteCreateRoute(initialAccount: TestData.account),
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.text(":"));
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate((widget) =>
              widget is NetworkImageView &&
              widget.url == TestData.emoji2.url.toString()),
          findsOneWidget);
      expect(find.text(TestData.emoji1.char), findsOneWidget);

      await tester.tap(find.byType(NetworkImageView).at(1));
      expect(
          tester
              .textEditingController(find.byType(TextField).hitTestable())
              .text,
          ":${TestData.emoji2.baseName}:");
    });

    testWidgets(
        "「他のん」を押下するとリアクションピッカーが表示されること"
        "選択したカスタム絵文字が補完されること", (tester) async {
      VisibilityDetectorController.instance.updateInterval = Duration.zero;

      final emojiRepository = MockEmojiRepository();
      when(emojiRepository.emoji).thenReturn(
          [TestData.emojiRepositoryData1, TestData.emojiRepositoryData2]);
      when(emojiRepository.searchEmojis(any))
          .thenAnswer((_) async => [TestData.emoji1, TestData.emoji2]);
      when(emojiRepository.defaultEmojis())
          .thenReturn([TestData.emoji1, TestData.emoji2]);

      await tester.pumpWidget(ProviderScope(
          overrides: [
            emojiRepositoryProvider.overrideWith((ref, arg) => emojiRepository)
          ],
          child: DefaultRootWidget(
            initialRoute: NoteCreateRoute(initialAccount: TestData.account),
          )));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).hitTestable(), ":");
      await tester.pumpAndSettle();

      await tester.tap(find.text("他のん"));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CustomEmoji).at(1));
      await tester.pumpAndSettle();
      expect(
          tester
              .textEditingController(find.byType(TextField).hitTestable())
              .text,
          ":${TestData.emoji2.baseName}:");
    });
  });

  group("初期値", () {
    group("チャンネル", () {
      testWidgets("チャンネルからノートする場合、チャンネルのノートになること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1)
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                  initialAccount: TestData.account, channel: TestData.channel1),
            )));
        await tester.pumpAndSettle();

        expect(find.text(TestData.channel1ExpectName), findsOneWidget);

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.channelId == TestData.channel1ExpectId)))));
      });

      testWidgets("削除されたノートを直す場合で、そのノートがチャンネルのノートの場合、チャンネルのノートになること",
          (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1)
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                  initialAccount: TestData.account,
                  deletedNote: TestData.note1.copyWith(
                      channelId: TestData.channel1.id,
                      channel: NoteChannelInfo(
                          id: TestData.channel1.id,
                          name: TestData.channel1.name))),
            )));
        await tester.pumpAndSettle();

        expect(find.text(TestData.channel1ExpectName), findsOneWidget);

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.channelId == TestData.channel1ExpectId)))));
      });

      testWidgets("チャンネルのノートにリプライをする場合、そのノートもチャンネルのノートになること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1)
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                  initialAccount: TestData.account,
                  reply: TestData.note1.copyWith(
                      channelId: TestData.channel1.id,
                      channel: NoteChannelInfo(
                          id: TestData.channel1.id,
                          name: TestData.channel1.name))),
            )));
        await tester.pumpAndSettle();

        expect(find.text(TestData.channel1ExpectName), findsOneWidget);

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.channelId == TestData.channel1ExpectId)))));
      });

      // 引用リノートはどうなんだっけ
    });

    group("公開範囲", () {
      testWidgets("デフォルトの公開範囲設定が適用されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        final accountSettings = MockAccountSettingsRepository();
        when(accountSettings.fromAccount(any)).thenReturn(AccountSettings(
            userId: TestData.account.userId,
            host: TestData.account.host,
            defaultNoteVisibility: NoteVisibility.followers));
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
              accountSettingsRepositoryProvider
                  .overrideWith((ref) => accountSettings)
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(initialAccount: TestData.account),
            )));
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.visibility == NoteVisibility.followers)))));
      });

      testWidgets("削除されたノートを直す場合、削除されたノートの公開範囲設定が適用されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                  initialAccount: TestData.account,
                  deletedNote: TestData.note1
                      .copyWith(visibility: NoteVisibility.specified)),
            )));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.visibility == NoteVisibility.specified)))));
      });

      testWidgets("引用リノートの場合、リノート元の公開範囲設定が適用されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
                initialRoute: NoteCreateRoute(
              initialAccount: TestData.account,
              renote: TestData.note1.copyWith(visibility: NoteVisibility.home),
            ))));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.visibility == NoteVisibility.home)))));
      });

      testWidgets("リプライの場合、リプライ元の公開範囲設定が適用されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
                initialRoute: NoteCreateRoute(
              initialAccount: TestData.account,
              reply: TestData.note1.copyWith(visibility: NoteVisibility.home),
            ))));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.visibility == NoteVisibility.home)))));
      });

      testWidgets("ユーザーがサイレンスの場合で、デフォルトの公開範囲設定がパブリックの場合、強制ホームになること",
          (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        final accountSettings = MockAccountSettingsRepository();
        when(accountSettings.fromAccount(any)).thenReturn(AccountSettings(
            userId: TestData.account.userId,
            host: TestData.account.host,
            defaultNoteVisibility: NoteVisibility.public));
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
              accountSettingsRepositoryProvider
                  .overrideWith((ref) => accountSettings)
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                  initialAccount: TestData.account.copyWith(
                      i: TestData.account.i.copyWith(isSilenced: true))),
            )));
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.visibility == NoteVisibility.home)))));
      });
    });

    group("連合オン・オフ", () {
      testWidgets("デフォルトの連合範囲設定が適用されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        final accountSettings = MockAccountSettingsRepository();
        when(accountSettings.fromAccount(any)).thenReturn(AccountSettings(
            userId: TestData.account.userId,
            host: TestData.account.host,
            defaultIsLocalOnly: true));
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
              accountSettingsRepositoryProvider
                  .overrideWith((ref) => accountSettings)
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(initialAccount: TestData.account),
            )));
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(
            predicate<NotesCreateRequest>((arg) => arg.localOnly == true)))));
      });

      testWidgets("削除されたノートを直す場合、削除されたノートの連合範囲が適用されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                  initialAccount: TestData.account,
                  deletedNote: TestData.note1.copyWith(localOnly: true)),
            )));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(
            predicate<NotesCreateRequest>((arg) => arg.localOnly == true)))));
      });

      testWidgets("引用リノートの場合、リノート元の連合範囲が適用されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                  initialAccount: TestData.account,
                  renote: TestData.note1.copyWith(localOnly: true)),
            )));
        await tester.pumpAndSettle();
        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(
            predicate<NotesCreateRequest>((arg) => arg.localOnly == true)))));
      });

      testWidgets("リプライの場合、リプライ元の連合範囲が適用されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
                initialRoute: NoteCreateRoute(
              initialAccount: TestData.account,
              reply: TestData.note1.copyWith(localOnly: true),
            ))));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(
            predicate<NotesCreateRequest>((arg) => arg.localOnly == true)))));
      });
    });

    group("リアクションの受け入れ", () {});

    group("注釈", () {});

    group("ノートのテキスト", () {});
  });
}
