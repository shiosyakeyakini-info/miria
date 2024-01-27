import 'package:flutter/material.dart';
import 'package:flutter_highlighting/flutter_highlighting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/note_repository.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:miria/view/common/misskey_notes/reaction_button.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/mockito.dart';

import '../../../test_util/default_root_widget.dart';
import '../../../test_util/mock.mocks.dart';
import '../../../test_util/test_datas.dart';
import '../../../test_util/widget_tester_extension.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

Widget buildTestWidget({
  List<Override> overrides = const [],
  required Note note,
}) {
  final notesRepository = NoteRepository(MockMisskey(), TestData.account);
  notesRepository.registerNote(note);
  final mockCacheManager = MockBaseCacheManager();

  return ProviderScope(
    overrides: [
      ...overrides,
      cacheManagerProvider.overrideWith((ref) => mockCacheManager),
      notesProvider.overrideWith((ref, arg) => notesRepository)
    ],
    child: DefaultRootNoRouterWidget(
      child: Scaffold(
        body: AccountScope(
          account: TestData.account,
          child: SingleChildScrollView(child: MisskeyNote(note: note)),
        ),
      ),
    ),
  );
}

void main() {
  group("ノート表示", () {
    group("ノート表示", () {
      testWidgets("ノートのテキストが表示されること", (tester) async {
        await tester.pumpWidget(buildTestWidget(note: TestData.note1));
        await tester.pumpAndSettle();
        expect(find.textContaining(TestData.note1.text!, findRichText: true),
            findsOneWidget);
      });

      testWidgets("Renoteの場合、Renoteの表示が行われること", (tester) async {
        await tester.pumpWidget(buildTestWidget(note: TestData.note6AsRenote));
        await tester.pumpAndSettle();
        expect(
            find.textContaining(TestData.note6AsRenote.renote!.text!,
                findRichText: true),
            findsOneWidget);
        expect(
            find.textContaining("がリノート", findRichText: true), findsOneWidget);
      });

      testWidgets("引用Renoteの場合、引用Renoteの表示が行われること", (tester) async {
        await tester.pumpWidget(buildTestWidget(
            note: TestData.note6AsRenote.copyWith(text: "こころがふたつある〜")));
        await tester.pumpAndSettle();
        expect(
            find.textContaining(TestData.note6AsRenote.renote!.text!,
                findRichText: true),
            findsOneWidget);
        expect(find.textContaining("こころがふたつある〜", findRichText: true),
            findsOneWidget);
        expect(
            find.textContaining("がRenote", findRichText: true), findsNothing);
      });
    });

    group("MFM", () {
      testWidgets("コードブロックがあった場合、コードブロックで表示されること", (tester) async {
        await tester
            .pumpWidget(buildTestWidget(note: TestData.note1.copyWith(text: r'''
```js
window.ai = "@ai uneune";
```
```c++
printf("@ai uneune");
```
```java
System.out.println("@ai uneune");
```
''')));
        await tester.pumpAndSettle();
        expect(find.byType(HighlightView), findsNWidgets(3));
      });

      testWidgets("検索構文の検索を謳歌すると、検索が行われること", (tester) async {
        final mockUrlLauncher = MockUrlLauncherPlatform();
        UrlLauncherPlatform.instance = mockUrlLauncher;
        await tester.pumpWidget(buildTestWidget(
            note: TestData.note1.copyWith(text: "藍ちゃんやっほー 検索")));
        await tester.pumpAndSettle();
        expect(tester.textEditingController(find.byType(TextField)).text,
            "藍ちゃんやっほー");
        await tester.tap(find.text("検索"));
        await tester.pumpAndSettle();
        verify(mockUrlLauncher.launchUrl(
                argThat(equals(
                    "https://google.com/search?q=%E8%97%8D%E3%81%A1%E3%82%83%E3%82%93%E3%82%84%E3%81%A3%E3%81%BB%E3%83%BC")),
                any))
            .called(1);
      });
    });

    group("注釈", () {
      testWidgets("注釈が設定されている場合、注釈が表示されること", (tester) async {
        await tester.pumpWidget(
            buildTestWidget(note: TestData.note1.copyWith(cw: "えっちなやつ")));
        await tester.pumpAndSettle();
        expect(
            find.textContaining("えっちなやつ", findRichText: true), findsOneWidget);
        expect(find.textContaining(TestData.note1.text!, findRichText: true),
            findsNothing);
      });

      testWidgets("続きを見るをタップすると、本文が表示されること", (tester) async {
        await tester.pumpWidget(
            buildTestWidget(note: TestData.note1.copyWith(cw: "えっちなやつ")));
        await tester.pumpAndSettle();
        await tester.tap(find.text("隠してあるのんの続きを見して"));
        await tester.pumpAndSettle();
        expect(
            find.textContaining("えっちなやつ", findRichText: true), findsOneWidget);
        expect(find.textContaining(TestData.note1.text!, findRichText: true),
            findsOneWidget);

        await tester.tap(find.text("隠す"));
        await tester.pumpAndSettle();
        expect(
            find.textContaining("えっちなやつ", findRichText: true), findsOneWidget);
        expect(find.textContaining(TestData.note1.text!, findRichText: true),
            findsNothing);
      });
    });

    group("長いノートの折りたたみ", () {
      testWidgets("長いノートの省略が有効な場合、500文字を超えるノートが折りたたまれること", (tester) async {
        final generalSettingsRepository = MockGeneralSettingsRepository();
        when(generalSettingsRepository.settings)
            .thenReturn(const GeneralSettings(enableLongTextElipsed: true));
        await tester.pumpWidget(buildTestWidget(
            overrides: [
              generalSettingsRepositoryProvider
                  .overrideWith((ref) => generalSettingsRepository)
            ],
            note: TestData.note1.copyWith(
                text: Iterable.generate(500, (index) => "あ").join(""))));
        await tester.pumpAndSettle();
        expect(find.text("続きを表示"), findsOneWidget);
      });

      testWidgets("長いノートの省略が有効な場合、続きを表示をタップすると全てが表示されること", (tester) async {
        final longText = Iterable.generate(2000, (index) => "あ").join("");
        final generalSettingsRepository = MockGeneralSettingsRepository();
        when(generalSettingsRepository.settings)
            .thenReturn(const GeneralSettings(enableLongTextElipsed: true));
        await tester.pumpWidget(buildTestWidget(
          overrides: [
            generalSettingsRepositoryProvider
                .overrideWith((ref) => generalSettingsRepository)
          ],
          note: TestData.note1.copyWith(text: longText),
        ));
        await tester.pumpAndSettle();
        expect(find.textContaining(longText, findRichText: true), findsNothing);
        await tester.tap(find.text("続きを表示"));
        await tester.pumpAndSettle();
        expect(
            find.textContaining(longText, findRichText: true), findsOneWidget);
      });
    });

    group("投票", () {
      testWidgets("投票が表示されること", (tester) async {
        await tester.pumpWidget(buildTestWidget(note: TestData.note4AsVote));
        await tester.pumpAndSettle();
        for (final choice in TestData.note4AsVote.poll!.choices) {
          expect(find.textContaining(choice.text, findRichText: true),
              findsOneWidget);
          expect(find.textContaining("${choice.votes}票", findRichText: true),
              findsOneWidget);
        }
      });
    });

    group("メディア", () {
      testWidgets("閲覧注意に設定されていない場合、画像が表示されること", (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(buildTestWidget(
              note: TestData.note1.copyWith(
                  fileIds: [TestData.drive1.id],
                  files: [TestData.drive1.copyWith(isSensitive: false)])));

          await tester.pumpAndSettle();
          await Future.delayed(const Duration(seconds: 1));
          await tester.pumpAndSettle();

          expect(
              find.byWidgetPredicate((e) =>
                  e is NetworkImageView && e.type == ImageType.imageThumbnail),
              findsOneWidget);
        });
      });

      testWidgets("閲覧注意に設定している場合、画像が表示されないこと　閲覧注意をタップすると画像が表示されること",
          (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(buildTestWidget(
              note: TestData.note1.copyWith(
                  fileIds: [TestData.drive1.id],
                  files: [TestData.drive1.copyWith(isSensitive: true)])));

          await tester.pumpAndSettle();

          expect(find.text("センシティブ"), findsOneWidget);

          expect(
              find.byWidgetPredicate((e) =>
                  e is NetworkImageView && e.type == ImageType.imageThumbnail),
              findsNothing);

          await tester.tap(find.text("センシティブ"));
          await tester.pumpAndSettle();
          await Future.delayed(const Duration(seconds: 1));
          await tester.pumpAndSettle();

          expect(
              find.byWidgetPredicate((e) =>
                  e is NetworkImageView && e.type == ImageType.imageThumbnail),
              findsOneWidget);
        });
      });
    });
  });

  group("リアクションしたユーザー一覧", () {
    testWidgets("リアクションを長押しすると、リアクションしたユーザーの一覧が表示されること", (tester) async {
      final mockMisskey = MockMisskey();
      final mockMisskeyNotes = MockMisskeyNotes();
      final mockMisskeyNotesReactions = MockMisskeyNotesReactions();
      when(mockMisskey.notes).thenReturn(mockMisskeyNotes);
      when(mockMisskeyNotes.reactions).thenReturn(mockMisskeyNotesReactions);
      when(mockMisskeyNotesReactions.reactions(any)).thenAnswer((_) async => [
            NotesReactionsResponse(
                id: "reaction1",
                createdAt: DateTime.now(),
                user: UserLite.fromJson(TestData.detailedUser2.toJson()),
                type: ":ai_yay:")
          ]);
      await tester.pumpWidget(buildTestWidget(
          overrides: [misskeyProvider.overrideWith((ref, arg) => mockMisskey)],
          note: TestData.note1));
      await tester.pumpAndSettle();
      await tester.longPress(find.byType(ReactionButton).at(1));
      await tester.pumpAndSettle();
      expect(find.text(TestData.detailedUser2.name!, findRichText: true),
          findsOneWidget);
      await tester.pageNation();

      expect(find.text(TestData.detailedUser2.name!, findRichText: true),
          findsNWidgets(2));
    });
  });

  group("Renoteしたユーザー一覧", () {
    testWidgets("Renoteを長押しすると、Renoteしたユーザーの一覧が表示されること", (tester) async {
      final mockMisskey = MockMisskey();
      final mockMisskeyNotes = MockMisskeyNotes();
      when(mockMisskey.notes).thenReturn(mockMisskeyNotes);
      when(mockMisskeyNotes.renotes(any))
          .thenAnswer((_) async => [TestData.note6AsRenote]);
      await tester.pumpWidget(buildTestWidget(
          overrides: [misskeyProvider.overrideWith((ref, arg) => mockMisskey)],
          note: TestData.note1));
      await tester.pumpAndSettle();
      await tester.longPress(find.byType(RenoteButton));
      await tester.pumpAndSettle();
      expect(
          find.textContaining(TestData.note6AsRenote.user.username,
              findRichText: true),
          findsOneWidget);
      await tester.pageNation();

      expect(
          find.textContaining(TestData.note6AsRenote.user.username,
              findRichText: true),
          findsNWidgets(2));
    });
  });
}
