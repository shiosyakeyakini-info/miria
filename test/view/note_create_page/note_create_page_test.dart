import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:file/memory.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/extensions/string_extensions.dart';
import 'package:miria/model/account_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/common/misskey_notes/local_only_icon.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:miria/view/common/note_create/input_completation.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';
import 'package:miria/view/note_create_page/mfm_preview.dart';
import 'package:miria/view/note_create_page/reply_to_area.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/mockito.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../test_util/default_root_widget.dart';
import '../../test_util/mock.mocks.dart';
import '../../test_util/test_datas.dart';
import '../../test_util/widget_tester_extension.dart';

void main() {
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

      testWidgets("チャンネルのノートに引用リノートをする場合、引数のチャンネル先が選択されること", (tester) async {
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
                  channel: TestData.channel2,
                  renote: TestData.note1.copyWith(
                      channelId: TestData.channel1.id,
                      channel: NoteChannelInfo(
                          id: TestData.channel1.id,
                          name: TestData.channel1.name))),
            )));
        await tester.pumpAndSettle();

        expect(find.text(TestData.channel2ExpectName), findsOneWidget);

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.channelId == TestData.channel2ExpectId)))));
      });
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

      testWidgets("ユーザーがサイレンスの場合、デフォルトの公開範囲設定がフォロワーのみの場合、デフォルトの公開範囲設定が反映されること",
          (tester) async {
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
            (arg) => arg.visibility == NoteVisibility.followers)))));
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

      group("チャンネル", () {
        testWidgets("チャンネルへのノートの場合、連合オフになること", (tester) async {
          final mockMisskey = MockMisskey();
          final mockNote = MockMisskeyNotes();
          when(mockMisskey.notes).thenReturn(mockNote);
          final accountSettings = MockAccountSettingsRepository();
          when(accountSettings.fromAccount(any)).thenReturn(AccountSettings(
              userId: TestData.account.userId, host: TestData.account.host));
          await tester.pumpWidget(ProviderScope(
              overrides: [
                misskeyProvider.overrideWith((ref, arg) => mockMisskey),
                inputComplementDelayedProvider.overrideWithValue(1),
                accountSettingsRepositoryProvider
                    .overrideWith((ref) => accountSettings)
              ],
              child: DefaultRootWidget(
                initialRoute: NoteCreateRoute(
                    initialAccount: TestData.account,
                    channel: TestData.channel1),
              )));
          await tester.pumpAndSettle();

          await tester.enterText(
              find.byType(TextField).hitTestable(), ":ai_yay:");
          await tester.tap(find.byIcon(Icons.send));
          await tester.pumpAndSettle();

          verify(mockNote.create(argThat(equals(
              predicate<NotesCreateRequest>((arg) => arg.localOnly == true)))));
        });
      });
    });

    group("リアクションの受け入れ", () {
      testWidgets("デフォルトのリアクション受け入れ設定が適用されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        final accountSettings = MockAccountSettingsRepository();
        when(accountSettings.fromAccount(any)).thenReturn(AccountSettings(
            userId: TestData.account.userId,
            host: TestData.account.host,
            defaultReactionAcceptance: ReactionAcceptance.nonSensitiveOnly));
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
            (arg) =>
                arg.reactionAcceptance ==
                ReactionAcceptance.nonSensitiveOnly)))));
      });

      testWidgets("削除されたノートを直す場合、削除されたノートのリアクション受け入れ設定が適用されること",
          (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        final accountSettings = MockAccountSettingsRepository();
        when(accountSettings.fromAccount(any)).thenReturn(AccountSettings(
            userId: TestData.account.userId, host: TestData.account.host));
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
              accountSettingsRepositoryProvider
                  .overrideWith((ref) => accountSettings)
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                  initialAccount: TestData.account,
                  deletedNote: TestData.note1.copyWith(
                      reactionAcceptance: ReactionAcceptance.likeOnly)),
            )));
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.reactionAcceptance == ReactionAcceptance.likeOnly)))));
      });

      testWidgets("引用リノートの場合、リノート元のリアクション受け入れ設定が反映され**ない**こと", (tester) async {
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
                  renote: TestData.note1.copyWith(
                      reactionAcceptance: ReactionAcceptance.likeOnly)),
            )));
        await tester.pumpAndSettle();
        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.reactionAcceptance == null)))));
      });

      testWidgets("リプライの場合、リプライ元のリアクション受け入れ設定が反映され**ない**こと", (tester) async {
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
                  reply: TestData.note1.copyWith(
                      reactionAcceptance: ReactionAcceptance.likeOnly)),
            )));
        await tester.pumpAndSettle();
        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.reactionAcceptance == null)))));
      });
    });

    group("注釈", () {
      testWidgets("初期値は空であること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(initialAccount: TestData.account),
            )));
        await tester.pumpAndSettle();

        expect(tester.textEditingController(find.byType(TextField).at(0)).text,
            "");
      });

      testWidgets("削除したノートを直す場合、削除したノートの注釈が適用されること", (tester) async {
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
                  deletedNote: TestData.note1.copyWith(cw: "えっちなやつ")),
            )));
        await tester.pumpAndSettle();

        expect(tester.textEditingController(find.byType(TextField).at(0)).text,
            "えっちなやつ");
      });

      testWidgets("リプライを送る場合で、リプライ元が注釈ありの場合、その注釈が適用されること", (tester) async {
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
                  reply: TestData.note1.copyWith(cw: "えっちなやつ")),
            )));
        await tester.pumpAndSettle();

        expect(tester.textEditingController(find.byType(TextField).at(0)).text,
            "えっちなやつ");
      });

      testWidgets("引用リノートをする場合で、リノート元が注釈ありの場合、その注釈が適用され**ない**こと",
          (tester) async {
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
                  renote: TestData.note1.copyWith(cw: "えっちなやつ")),
            )));
        await tester.pumpAndSettle();

        expect(tester.textEditingController(find.byType(TextField).at(0)).text,
            "");
      });
    });

    group("ノートのテキスト", () {
      testWidgets("初期値は空であること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(initialAccount: TestData.account),
            )));
        await tester.pumpAndSettle();

        expect(tester.textEditingController(find.byType(TextField)).text, "");
      });

      testWidgets("削除したノートを直す場合、削除したノートのテキストが適用されること", (tester) async {
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
                  deletedNote: TestData.note1),
            )));
        await tester.pumpAndSettle();

        expect(tester.textEditingController(find.byType(TextField)).text,
            TestData.note1.text);
      });

      testWidgets("テキスト共有からノート投稿をする場合、共有のテキストが適用されること", (tester) async {
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
                  initialText: ":ai_yaysuperfast:"),
            )));
        await tester.pumpAndSettle();

        expect(tester.textEditingController(find.byType(TextField)).text,
            ":ai_yaysuperfast:");
      });
    });

    group("メディア", () {
      testWidgets("初期値は空であること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);
        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(initialAccount: TestData.account),
            )));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(
                predicate<NotesCreateRequest>((arg) => arg.mediaIds == null)))))
            .called(1);
      });

      testWidgets("削除したノートを直す場合、削除したノートのメディアが適用されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);

        final mockDio = MockDio();
        when(mockDio.get(any, options: anyNamed("options")))
            .thenAnswer((_) async => await TestData.binaryImageResponse);

        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              dioProvider.overrideWith((ref) => mockDio),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                  initialAccount: TestData.account,
                  deletedNote: TestData.note1.copyWith(
                      files: [TestData.drive1], fileIds: [TestData.drive1.id])),
            )));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => const DeepCollectionEquality()
                .equals(arg.fileIds, [TestData.drive1.id])))))).called(1);
      });

      testWidgets("画像共有からノートを投稿する場合、共有の画像が適用されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        final mockDrive = MockMisskeyDrive();
        final mockDriveFiles = MockMisskeyDriveFiles();
        when(mockMisskey.notes).thenReturn(mockNote);
        when(mockMisskey.drive).thenReturn(mockDrive);
        when(mockDrive.files).thenReturn(mockDriveFiles);

        when(mockDriveFiles.createAsBinary(any, any)).thenAnswer(
            (_) async => TestData.drive1.copyWith(name: "test.png"));

        final mockDio = MockDio();
        when(mockDio.get(any, options: anyNamed("options")))
            .thenAnswer((_) async => await TestData.binaryImageResponse);

        final memoryFileSystem = MemoryFileSystem();
        final binaryImage = await TestData.binaryImage;
        memoryFileSystem.file("/test.png").writeAsBytes(binaryImage);

        await tester.pumpWidget(ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, arg) => mockMisskey),
            fileSystemProvider.overrideWith((ref) => memoryFileSystem),
            dioProvider.overrideWith((ref) => mockDio),
            inputComplementDelayedProvider.overrideWithValue(1),
          ],
          child: DefaultRootWidget(
            initialRoute: NoteCreateRoute(
                initialAccount: TestData.account,
                initialMediaFiles: const ["/test.png"]),
          ),
        ));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockDriveFiles.createAsBinary(
            argThat(equals(const DriveFilesCreateRequest(
                name: "test.png",
                force: true,
                comment: "",
                isSensitive: false))),
            argThat(equals(predicate<Uint8List>((value) =>
                const DeepCollectionEquality().equals(value, binaryImage))))));
        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => const DeepCollectionEquality()
                .equals([TestData.drive1.id], arg.fileIds))))));
      });

      testWidgets("共有したファイルが画像でない場合でも、ファイルの投稿ができること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        final mockDrive = MockMisskeyDrive();
        final mockDriveFiles = MockMisskeyDriveFiles();
        when(mockMisskey.notes).thenReturn(mockNote);
        when(mockMisskey.drive).thenReturn(mockDrive);
        when(mockDrive.files).thenReturn(mockDriveFiles);

        when(mockDriveFiles.createAsBinary(any, any)).thenAnswer(
            (_) async => TestData.drive1.copyWith(name: "test.txt"));

        final mockDio = MockDio();
        when(mockDio.get(any, options: anyNamed("options")))
            .thenAnswer((_) async => await TestData.binaryImageResponse);

        final memoryFileSystem = MemoryFileSystem();
        final binaryData =
            utf8.encode(":murakamisan_tutinoko_hasitumami_crying:");
        memoryFileSystem.file("/test.txt").writeAsBytes(binaryData);

        await tester.pumpWidget(ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, arg) => mockMisskey),
            fileSystemProvider.overrideWith((ref) => memoryFileSystem),
            dioProvider.overrideWith((ref) => mockDio),
            inputComplementDelayedProvider.overrideWithValue(1),
          ],
          child: DefaultRootWidget(
            initialRoute: NoteCreateRoute(
                initialAccount: TestData.account,
                initialMediaFiles: const ["/test.txt"]),
          ),
        ));
        await tester.pumpAndSettle();
        expect(find.text("test.txt"), findsOneWidget);

        await tester.enterText(find.byType(TextField), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockDriveFiles.createAsBinary(
            argThat(equals(const DriveFilesCreateRequest(
                name: "test.txt",
                force: true,
                comment: "",
                isSensitive: false))),
            argThat(equals(predicate<Uint8List>((value) =>
                const DeepCollectionEquality().equals(value, binaryData))))));
        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => const DeepCollectionEquality()
                .equals([TestData.drive1.id], arg.fileIds))))));
      });
    });

    group("リプライ先", () {
      testWidgets("リプライの場合、返信先が表示されていること", (tester) async {
        await tester.pumpWidget(ProviderScope(
            overrides: [
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                  initialAccount: TestData.account,
                  reply: TestData.note3AsAnotherUser),
            )));
        await tester.pumpAndSettle();
        expect(find.text("返信先："), findsOneWidget);
        expect(
            find.descendant(
                of: find.byType(ReplyToArea),
                matching: find.text(TestData.note3ExpectUserName,
                    findRichText: true)),
            findsOneWidget);
      });

      testWidgets("リプライでない場合、返信先が表示されていないこと", (tester) async {
        await tester.pumpWidget(ProviderScope(
            overrides: [
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(initialAccount: TestData.account),
            )));
        await tester.pumpAndSettle();
        expect(find.text("返信先："), findsNothing);
      });
    });

    // TODO
    group("投票", () {});
  });

  group("入力・バリデーション", () {
    group("テキスト", () {
      testWidgets("ノートの内容を編集して投稿できること", (tester) async {
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
            ))));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), ":ai_bonk:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.text == ":ai_bonk:"))))).called(1);
      });

      testWidgets("ノートの内容が空で投稿することができないこと", (tester) async {
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
            ))));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.send));
        await tester.pump();
        expect(find.byType(SimpleMessageDialog), findsOneWidget);
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(find.byType(TextField).hitTestable(), findsOneWidget);
      });

      testWidgets("画像が添付されている場合、ノートの内容が空でも投稿できること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        final mockDrive = MockMisskeyDrive();
        final mockDriveFiles = MockMisskeyDriveFiles();
        when(mockMisskey.notes).thenReturn(mockNote);
        when(mockMisskey.drive).thenReturn(mockDrive);
        when(mockDrive.files).thenReturn(mockDriveFiles);

        when(mockDriveFiles.createAsBinary(any, any)).thenAnswer(
            (_) async => TestData.drive1.copyWith(name: "test.txt"));

        final mockDio = MockDio();
        when(mockDio.get(any, options: anyNamed("options")))
            .thenAnswer((_) async => await TestData.binaryImageResponse);

        final memoryFileSystem = MemoryFileSystem();
        final binaryData =
            utf8.encode(":murakamisan_tutinoko_hasitumami_crying:");
        memoryFileSystem.file("/test.txt").writeAsBytes(binaryData);

        await tester.pumpWidget(ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, arg) => mockMisskey),
            fileSystemProvider.overrideWith((ref) => memoryFileSystem),
            dioProvider.overrideWith((ref) => mockDio),
            inputComplementDelayedProvider.overrideWithValue(1),
          ],
          child: DefaultRootWidget(
            initialRoute: NoteCreateRoute(
                initialAccount: TestData.account,
                initialMediaFiles: const ["/test.txt"]),
          ),
        ));
        await tester.pumpAndSettle();
        expect(find.text("test.txt"), findsOneWidget);

        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockDriveFiles.createAsBinary(
            argThat(equals(const DriveFilesCreateRequest(
                name: "test.txt",
                force: true,
                comment: "",
                isSensitive: false))),
            argThat(equals(predicate<Uint8List>((value) =>
                const DeepCollectionEquality().equals(value, binaryData))))));
        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => const DeepCollectionEquality()
                .equals([TestData.drive1.id], arg.fileIds))))));
      });

      group("入力補完", () {
        testWidgets("カスタム絵文字の入力補完が可能なこと", (tester) async {
          final emojiRepository = MockEmojiRepository();
          when(emojiRepository.emoji).thenReturn([
            TestData.unicodeEmojiRepositoryData1,
            TestData.customEmojiRepositoryData1
          ]);
          when(emojiRepository.searchEmojis(any)).thenAnswer(
              (_) async => [TestData.unicodeEmoji1, TestData.customEmoji1]);

          await tester.pumpWidget(ProviderScope(
              overrides: [
                emojiRepositoryProvider
                    .overrideWith((ref, arg) => emojiRepository)
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
                  widget.url == TestData.customEmoji1.url.toString()),
              findsOneWidget);
          expect(find.text(TestData.unicodeEmoji1.char), findsOneWidget);

          await tester.tap(find.byType(NetworkImageView).at(1));
          expect(
              tester
                  .textEditingController(find.byType(TextField).hitTestable())
                  .value,
              TextEditingValue(
                  text: ":${TestData.customEmoji1.baseName}:",
                  selection: TextSelection.collapsed(
                      offset: ":${TestData.customEmoji1.baseName}:".length)));
        });

        testWidgets("通常の絵文字の入力補完が可能なこと", (tester) async {
          final emojiRepository = MockEmojiRepository();
          when(emojiRepository.emoji).thenReturn([
            TestData.unicodeEmojiRepositoryData1,
            TestData.customEmojiRepositoryData1
          ]);
          when(emojiRepository.searchEmojis(any)).thenAnswer(
              (_) async => [TestData.unicodeEmoji1, TestData.customEmoji1]);

          await tester.pumpWidget(ProviderScope(
              overrides: [
                emojiRepositoryProvider
                    .overrideWith((ref, arg) => emojiRepository)
              ],
              child: DefaultRootWidget(
                initialRoute: NoteCreateRoute(initialAccount: TestData.account),
              )));
          await tester.pumpAndSettle();

          await tester.tap(find.text(":"));
          await tester.pumpAndSettle();

          await tester.tap(find.text(TestData.unicodeEmoji1.char));
          expect(
              tester
                  .textEditingController(find.byType(TextField).hitTestable())
                  .value,
              TextEditingValue(
                  text: TestData.unicodeEmoji1.char,
                  selection: TextSelection.collapsed(
                      offset: TestData.unicodeEmoji1.char.length)));
        });

        testWidgets(
            "「他のん」を押下するとリアクションピッカーが表示されること"
            "選択したカスタム絵文字が補完されること", (tester) async {
          VisibilityDetectorController.instance.updateInterval = Duration.zero;

          final emojiRepository = MockEmojiRepository();
          when(emojiRepository.emoji).thenReturn([
            TestData.unicodeEmojiRepositoryData1,
            TestData.customEmojiRepositoryData1
          ]);
          when(emojiRepository.searchEmojis(any)).thenAnswer(
              (_) async => [TestData.unicodeEmoji1, TestData.customEmoji1]);
          when(emojiRepository.defaultEmojis())
              .thenReturn([TestData.unicodeEmoji1, TestData.customEmoji1]);

          await tester.pumpWidget(ProviderScope(
              overrides: [
                emojiRepositoryProvider
                    .overrideWith((ref, arg) => emojiRepository)
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
              ":${TestData.customEmoji1.baseName}:");
        });
      });

      group("プレビュー", () {
        testWidgets("プレビューのテキストはisCatの場合nyaizeされること", (tester) async {
          await tester.pumpWidget(ProviderScope(
              overrides: [
                inputComplementDelayedProvider.overrideWithValue(1),
              ],
              child: DefaultRootWidget(
                  initialRoute: NoteCreateRoute(
                initialAccount: TestData.account
                    .copyWith(i: TestData.account.i.copyWith(isCat: true)),
              ))));
          await tester.pumpAndSettle();
          await tester.enterText(
              find.byType(TextField).hitTestable(), "は？なんなん？");
          await tester.pumpAndSettle();
          expect(find.text("は？にゃんにゃん？"), findsOneWidget);
        });

        testWidgets("プレビューのテキストはisCatでない場合nyaizeされないこと", (tester) async {
          await tester.pumpWidget(ProviderScope(
              overrides: [
                inputComplementDelayedProvider.overrideWithValue(1),
              ],
              child: DefaultRootWidget(
                  initialRoute: NoteCreateRoute(
                initialAccount: TestData.account
                    .copyWith(i: TestData.account.i.copyWith(isCat: false)),
              ))));
          await tester.pumpAndSettle();
          await tester.enterText(
              find.byType(TextField).hitTestable(), "は？なんなん？");
          await tester.pumpAndSettle();
          // 入力テキストとプレビューで2つになる
          expect(find.text("は？なんなん？"), findsNWidgets(2));
        });

        testWidgets("リプライ先がプレビューには反映されていること", (tester) async {
          await tester.pumpWidget(ProviderScope(
              overrides: [
                inputComplementDelayedProvider.overrideWithValue(1),
              ],
              child: DefaultRootWidget(
                initialRoute: NoteCreateRoute(
                    initialAccount: TestData.account,
                    reply: TestData.note3AsAnotherUser),
              )));
          await tester.pumpAndSettle();
          expect(
              find.descendant(
                  of: find.byType(MfmPreview),
                  matching: find.textContaining(
                      TestData.note3ExpectUserName.tight,
                      findRichText: true)),
              findsOneWidget);
        });
      });
    });

    group("注釈", () {
      testWidgets("注釈のアイコンのタップで表示が切り替わること", (tester) async {
        await tester.pumpWidget(ProviderScope(
            child: DefaultRootWidget(
                initialRoute: NoteCreateRoute(
          initialAccount: TestData.account,
        ))));
        await tester.pumpAndSettle();
        expect(find.byType(TextField), findsOneWidget);

        await tester.tap(find.byIcon(Icons.remove_red_eye));
        await tester.pumpAndSettle();
        expect(find.byType(TextField), findsNWidgets(2));

        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pumpAndSettle();
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets("注釈つきのノートが投稿できること", (tester) async {
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
            ))));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.remove_red_eye));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).at(0), ":nsfw:");
        await tester.enterText(find.byType(TextField).at(1), "えっちなやつ");
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(
                predicate<NotesCreateRequest>((arg) => arg.cw == ":nsfw:")))))
            .called(1);
      });

      testWidgets("内容を入力している状態で注釈を非表示にした場合、注釈なしで投稿されること", (tester) async {
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
            ))));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.remove_red_eye));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).at(0), ":nsfw:");
        await tester.enterText(find.byType(TextField).at(1), "えっちなやつ");
        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(
                predicate<NotesCreateRequest>((arg) => arg.cw == null)))))
            .called(1);
      });
    });

    group("公開範囲", () {
      final testCases = {
        "パブリック": (Icons.public, NoteVisibility.public),
        "ホーム": (Icons.home, NoteVisibility.home),
        "フォロワー": (Icons.lock_outline, NoteVisibility.followers),
        "ダイレクト": (Icons.mail, NoteVisibility.specified)
      };

      for (final testCase in testCases.entries) {
        testWidgets("公開範囲を${testCase.key}に変更して投稿できること", (tester) async {
          final mockMisskey = MockMisskey();
          final mockNote = MockMisskeyNotes();
          when(mockMisskey.notes).thenReturn(mockNote);

          await tester.pumpWidget(ProviderScope(
              overrides: [
                misskeyProvider.overrideWith((ref, arg) => mockMisskey),
                inputComplementDelayedProvider.overrideWithValue(1),
              ],
              child: DefaultRootWidget(
                  initialRoute:
                      NoteCreateRoute(initialAccount: TestData.account))));
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextField).at(0), ":ai_yay:");

          await tester.tap(find.byIcon(Icons.public));
          await tester.pumpAndSettle();
          await tester.tap(find.byIcon(testCase.value.$1).hitTestable());
          await tester.pumpAndSettle();
          expect(find.byIcon(testCase.value.$1).hitTestable(), findsOneWidget);

          await tester.tap(find.byIcon(Icons.send));
          await tester.pumpAndSettle();

          verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
              (arg) => arg.visibility == testCase.value.$2))))).called(1);
        });
      }

      testWidgets("サイレンスユーザーがパブリック投稿にできないこと", (tester) async {
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
                    initialAccount: TestData.account.copyWith(
                        i: TestData.account.i.copyWith(isSilenced: true))))));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).at(0), ":ai_yay:");

        await tester.tap(find.byIcon(Icons.home));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.public).hitTestable());
        await tester.pumpAndSettle();

        // エラーメッセージが表示されること
        expect(find.byType(SimpleMessageDialog), findsOneWidget);
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // 入力可能な状態に戻っていること
        await tester.tap(find.byIcon(Icons.home).hitTestable());
        await tester.pumpAndSettle();
        expect(find.byType(TextField).hitTestable(), findsOneWidget);
      });

      testWidgets("公開範囲がパブリックでないノートに対するリプライを、パブリック投稿にできないこと", (tester) async {
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
                  reply: TestData.note1
                      .copyWith(visibility: NoteVisibility.followers)),
            )));

        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).at(0), ":ai_yay:");

        await tester.tap(find.byIcon(Icons.lock_outline));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.public).hitTestable());
        await tester.pumpAndSettle();

        // エラーメッセージが表示されること
        expect(find.byType(SimpleMessageDialog), findsOneWidget);
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // 入力可能な状態に戻っていること
        await tester.tap(find.byIcon(Icons.home).hitTestable());
        await tester.pumpAndSettle();
        expect(find.byType(TextField).hitTestable(), findsOneWidget);
      });

      // ホームのリノートは何が正解なんだろう
    });

    group("リアクションの受け入れ", () {
      final testCases = {
        "全て": (find.byType(SvgPicture), null),
        "全て（リモートはいいねのみ）": (
          find.byIcon(Icons.add_reaction_outlined),
          ReactionAcceptance.likeOnlyForRemote
        ),
        "非センシティブのみ": (
          find.byIcon(Icons.shield_outlined),
          ReactionAcceptance.nonSensitiveOnly
        ),
        "非センシティブのみ（リモートはいいねのみ）": (
          find.byIcon(Icons.add_moderator_outlined),
          ReactionAcceptance.nonSensitiveOnlyForLocalLikeOnlyForRemote
        ),
        "いいねのみ": (
          find.byIcon(Icons.favorite_border),
          ReactionAcceptance.likeOnly
        )
      };

      for (final testCase in testCases.entries) {
        testWidgets("リアクションの受け入れを${testCase.key}に変更して投稿できること", (tester) async {
          final mockMisskey = MockMisskey();
          final mockNote = MockMisskeyNotes();
          when(mockMisskey.notes).thenReturn(mockNote);

          await tester.pumpWidget(ProviderScope(
              overrides: [
                misskeyProvider.overrideWith((ref, arg) => mockMisskey),
                inputComplementDelayedProvider.overrideWithValue(1),
              ],
              child: DefaultRootWidget(
                  initialRoute:
                      NoteCreateRoute(initialAccount: TestData.account))));
          await tester.pumpAndSettle();

          await tester.enterText(find.byType(TextField).at(0), ":ai_yay:");

          await tester.tap(find.byType(SvgPicture));
          await tester.pumpAndSettle();
          await tester.tap(testCase.value.$1.hitTestable());
          await tester.pumpAndSettle();
          expect(testCase.value.$1, findsOneWidget);

          await tester.tap(find.byIcon(Icons.send));
          await tester.pumpAndSettle();

          verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
                  (arg) => arg.reactionAcceptance == testCase.value.$2)))))
              .called(1);
        });
      }
    });

    group("連合", () {
      testWidgets("連合の表示が切り替わること", (tester) async {
        await tester.pumpWidget(ProviderScope(
            overrides: [
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
                initialRoute:
                    NoteCreateRoute(initialAccount: TestData.account))));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.rocket));
        await tester.pumpAndSettle();
        expect(find.byType(LocalOnlyIcon), findsOneWidget);

        await tester.tap(find.byType(LocalOnlyIcon));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.rocket), findsOneWidget);
      });

      testWidgets("連合がオンの場合、連合ありで投稿されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);

        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
                initialRoute:
                    NoteCreateRoute(initialAccount: TestData.account))));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.localOnly == false))))).called(1);
      });

      testWidgets("連合がオフに設定した場合、連合なしで投稿されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);

        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
                initialRoute:
                    NoteCreateRoute(initialAccount: TestData.account))));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.rocket));
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => arg.localOnly == true))))).called(1);
      });

      testWidgets("チャンネルのノートを連合オンに設定できないこと", (tester) async {
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
                    channel: TestData.channel1))));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(LocalOnlyIcon));
        await tester.pumpAndSettle();
        expect(find.byType(SimpleMessageDialog), findsOneWidget);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(LocalOnlyIcon), findsOneWidget);
      });

      testWidgets("引用リノートしようとしているノートが連合オフの場合、連合オンに設定できないこと", (tester) async {
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
                    renote: TestData.note1.copyWith(localOnly: true)))));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(LocalOnlyIcon));
        await tester.pumpAndSettle();
        expect(find.byType(SimpleMessageDialog), findsOneWidget);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(LocalOnlyIcon), findsOneWidget);
      });

      testWidgets("リプライ元のノートが連合オフの場合、連合オンに設定できないこと", (tester) async {
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
                    reply: TestData.note1.copyWith(localOnly: true)))));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(LocalOnlyIcon));
        await tester.pumpAndSettle();
        expect(find.byType(SimpleMessageDialog), findsOneWidget);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(LocalOnlyIcon), findsOneWidget);
      });
    });

    group("リアクションピッカー", () {
      testWidgets("リアクションピッカーからカスタム絵文字が入力できること", (tester) async {
        VisibilityDetectorController.instance.updateInterval = Duration.zero;
        final emojiRepository = MockEmojiRepository();
        when(emojiRepository.emoji).thenReturn([
          TestData.unicodeEmojiRepositoryData1,
          TestData.customEmojiRepositoryData1
        ]);
        when(emojiRepository.searchEmojis(any)).thenAnswer(
            (_) async => [TestData.unicodeEmoji1, TestData.customEmoji1]);
        when(emojiRepository.defaultEmojis())
            .thenReturn([TestData.unicodeEmoji1, TestData.customEmoji1]);

        await tester.pumpWidget(ProviderScope(
            overrides: [
              emojiRepositoryProvider
                  .overrideWith((ref, arg) => emojiRepository),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
                initialRoute:
                    NoteCreateRoute(initialAccount: TestData.account))));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.tag_faces));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(NetworkImageView).at(1));
        await tester.pumpAndSettle();

        expect(
            tester
                .textEditingController(find.byType(TextField).hitTestable())
                .value,
            TextEditingValue(
                text: ":${TestData.customEmoji1.baseName}:",
                selection: TextSelection.collapsed(
                    offset: ":${TestData.customEmoji1.baseName}:".length)));
      });

      testWidgets("リアクションピッカーからUnicodeの絵文字が入力できること", (tester) async {
        VisibilityDetectorController.instance.updateInterval = Duration.zero;
        final emojiRepository = MockEmojiRepository();
        when(emojiRepository.emoji).thenReturn([
          TestData.unicodeEmojiRepositoryData1,
          TestData.customEmojiRepositoryData1
        ]);
        when(emojiRepository.searchEmojis(any)).thenAnswer(
            (_) async => [TestData.unicodeEmoji1, TestData.customEmoji1]);
        when(emojiRepository.defaultEmojis())
            .thenReturn([TestData.unicodeEmoji1, TestData.customEmoji1]);

        await tester.pumpWidget(ProviderScope(
            overrides: [
              emojiRepositoryProvider
                  .overrideWith((ref, arg) => emojiRepository),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
                initialRoute:
                    NoteCreateRoute(initialAccount: TestData.account))));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.tag_faces));
        await tester.pumpAndSettle();

        await tester.tap(find.text(TestData.unicodeEmoji1.char));
        await tester.pumpAndSettle();

        expect(
            tester
                .textEditingController(find.byType(TextField).hitTestable())
                .value,
            TextEditingValue(
                text: TestData.unicodeEmoji1.char,
                selection: TextSelection.collapsed(
                    offset: TestData.unicodeEmoji1.char.length)));
      });
    });

    group("返信先", () {
      testWidgets("返信先の追加できること", (tester) async {
        final misskey = MockMisskey();
        final note = MockMisskeyNotes();
        final users = MockMisskeyUsers();
        when(misskey.notes).thenReturn(note);
        when(misskey.users).thenReturn(users);

        when(users.search(any))
            .thenAnswer((_) async => [TestData.detailedUser1]);

        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => misskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
                initialRoute:
                    NoteCreateRoute(initialAccount: TestData.account))));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.mail_outline));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).hitTestable(), "おいしいbot");
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        await tester
            .tap(find.text(TestData.detailedUser1.name!, findRichText: true));
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));

        verify(note.create(argThat(equals(predicate<NotesCreateRequest>((arg) =>
            arg.text == "@${TestData.detailedUser1.username} :ai_yay:")))));
      });

      testWidgets("複数の返信先を追加できること", (tester) async {
        final misskey = MockMisskey();
        final note = MockMisskeyNotes();
        final users = MockMisskeyUsers();
        when(misskey.notes).thenReturn(note);
        when(misskey.users).thenReturn(users);

        var count = 0;
        when(users.search(any)).thenAnswer((_) async {
          count++;
          if (count == 1) return [TestData.detailedUser1];
          return [TestData.detailedUser2];
        });

        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => misskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
                initialRoute:
                    NoteCreateRoute(initialAccount: TestData.account))));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.mail_outline));
        await tester.pumpAndSettle();

        // 1人目
        await tester.enterText(find.byType(TextField).hitTestable(), "おいしいbot");
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        await tester
            .tap(find.text(TestData.detailedUser1.name!, findRichText: true));
        await tester.pumpAndSettle();

        // 2人目
        await tester.tap(find.byIcon(Icons.mail_outline));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).hitTestable(), "藍");
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        await tester
            .tap(find.text(TestData.detailedUser2.name!, findRichText: true));
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));

        verify(note.create(argThat(equals(predicate<NotesCreateRequest>((arg) =>
            arg.text ==
            "@${TestData.detailedUser1.username} @${TestData.detailedUser2.username}@${TestData.detailedUser2.host} :ai_yay:")))));
      });

      testWidgets("追加した返信先を削除できること", (tester) async {
        final misskey = MockMisskey();
        final note = MockMisskeyNotes();
        final users = MockMisskeyUsers();
        when(misskey.notes).thenReturn(note);
        when(misskey.users).thenReturn(users);

        when(users.search(any))
            .thenAnswer((_) async => [TestData.detailedUser1]);

        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => misskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
                initialRoute:
                    NoteCreateRoute(initialAccount: TestData.account))));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.mail_outline));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).hitTestable(), "おいしいbot");
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        await tester
            .tap(find.text(TestData.detailedUser1.name!, findRichText: true));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.remove));
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));

        verify(note.create(argThat(equals(
            predicate<NotesCreateRequest>((arg) => arg.text == ":ai_yay:")))));
      });
    });

    group("メディア", () {
      testWidgets("ドライブからメディアを投稿できること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        final mockDrive = MockMisskeyDrive();
        final mockDriveFolders = MockMisskeyDriveFolders();
        final mockDriveFiles = MockMisskeyDriveFiles();
        when(mockMisskey.notes).thenReturn(mockNote);
        when(mockMisskey.drive).thenReturn(mockDrive);
        when(mockDrive.folders).thenReturn(mockDriveFolders);
        when(mockDrive.files).thenReturn(mockDriveFiles);

        when(mockDriveFolders.folders(any)).thenAnswer((_) async => []);
        when(mockDriveFiles.files(any))
            .thenAnswer((_) async => [TestData.drive1]);

        final mockDio = MockDio();
        when(mockDio.get(any, options: anyNamed("options")))
            .thenAnswer((_) async => await TestData.binaryImageResponse);

        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
              dioProvider.overrideWith((ref) => mockDio),
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                initialAccount: TestData.account,
              ),
            )));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.image));
        await tester.pumpAndSettle();

        await tester.tap(find.text("ドライブから"));
        await tester.pumpAndSettle();

        await tester.tap(find.text(TestData.drive1.name), warnIfMissed: false);
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => const DeepCollectionEquality()
                .equals([TestData.drive1.id], arg.fileIds))))));
      });

      testWidgets("単一の画像のアップロードができること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        final mockDrive = MockMisskeyDrive();
        final mockDriveFiles = MockMisskeyDriveFiles();
        when(mockMisskey.notes).thenReturn(mockNote);
        when(mockMisskey.drive).thenReturn(mockDrive);
        when(mockDrive.files).thenReturn(mockDriveFiles);

        when(mockDriveFiles.createAsBinary(any, any)).thenAnswer(
            (_) async => TestData.drive1.copyWith(name: "test.png"));

        final binaryImage = await TestData.binaryImage;
        final filePicker = MockFilePickerPlatform();
        FilePicker.platform = filePicker;
        when(filePicker.pickFiles(
          dialogTitle: anyNamed("dialogTitle"),
          initialDirectory: anyNamed("initialDirectory"),
          type: anyNamed("type"),
          allowedExtensions: anyNamed("allowedExtensions"),
          onFileLoading: anyNamed("onFileLoading"),
          allowCompression: anyNamed("allowCompression"),
          allowMultiple: anyNamed("allowMultiple"),
          withData: anyNamed("withData"),
          withReadStream: anyNamed("withReadStream"),
          lockParentWindow: anyNamed("lockParentWindow"),
        )).thenAnswer(
          (_) async => FilePickerResult([
            PlatformFile(
                path: "/test.png",
                name: "test.png",
                size: binaryImage.length,
                bytes: binaryImage)
          ]),
        );
        final fileSystem = MemoryFileSystem();
        await fileSystem.file("/test.png").writeAsBytes(binaryImage);

        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              fileSystemProvider.overrideWith((ref) => fileSystem),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                initialAccount: TestData.account,
              ),
            )));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.image));
        await tester.pumpAndSettle();

        await tester.tap(find.text("アップロード"));
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(predicate<NotesCreateRequest>(
            (arg) => const DeepCollectionEquality()
                .equals([TestData.drive1.id], arg.fileIds))))));

        verify(mockDriveFiles.createAsBinary(
            argThat(equals(const DriveFilesCreateRequest(
                name: "test.png",
                force: true,
                comment: "",
                isSensitive: false))),
            argThat(equals(predicate<Uint8List>((value) =>
                const DeepCollectionEquality().equals(value, binaryImage))))));
      });

      testWidgets("画像を何も選択しなかった場合、何もアップロードされないこと", (tester) async {
        final mockMisskey = MockMisskey();
        final mockNote = MockMisskeyNotes();
        when(mockMisskey.notes).thenReturn(mockNote);

        final filePicker = MockFilePickerPlatform();
        FilePicker.platform = filePicker;
        when(filePicker.pickFiles(
          dialogTitle: anyNamed("dialogTitle"),
          initialDirectory: anyNamed("initialDirectory"),
          type: anyNamed("type"),
          allowedExtensions: anyNamed("allowedExtensions"),
          onFileLoading: anyNamed("onFileLoading"),
          allowCompression: anyNamed("allowCompression"),
          allowMultiple: anyNamed("allowMultiple"),
          withData: anyNamed("withData"),
          withReadStream: anyNamed("withReadStream"),
          lockParentWindow: anyNamed("lockParentWindow"),
        )).thenAnswer((_) async => null);

        await tester.pumpWidget(ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, arg) => mockMisskey),
              inputComplementDelayedProvider.overrideWithValue(1),
            ],
            child: DefaultRootWidget(
              initialRoute: NoteCreateRoute(
                initialAccount: TestData.account,
              ),
            )));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.image));
        await tester.pumpAndSettle();

        await tester.tap(find.text("アップロード"));
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byType(TextField).hitTestable(), ":ai_yay:");
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        verify(mockNote.create(argThat(equals(
            predicate<NotesCreateRequest>((arg) => arg.fileIds == null)))));
      });
    });
  });
}
