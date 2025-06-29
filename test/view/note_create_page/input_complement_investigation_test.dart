import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/note_create/input_completation.dart";
import "package:miria/view/note_create_page/note_create_page.dart";
import "package:miria/view/note_create_page/note_emoji.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("InputComplement Investigation", () {
    testWidgets("本文フィールドにフォーカスがある時にInputComplementが表示されること", (tester) async {
      final emojiRepository = MockEmojiRepository();
      when(emojiRepository.emoji).thenReturn([
        TestData.unicodeEmojiRepositoryData1,
        TestData.customEmojiRepositoryData1,
      ]);
      when(
        emojiRepository.defaultEmojis(),
      ).thenAnswer((_) => [TestData.unicodeEmoji1, TestData.customEmoji1]);
      final generalSettingsRepository = MockGeneralSettingsRepository();
      when(
        generalSettingsRepository.settings,
      ).thenReturn(const GeneralSettings(emojiType: EmojiType.system));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            emojiRepositoryProvider.overrideWith(
              (ref, account) => emojiRepository,
            ),
            generalSettingsRepositoryProvider.overrideWith(
              (ref) => generalSettingsRepository,
            ),
            inputComplementDelayedProvider.overrideWithValue(1),
          ],
          child: DefaultRootWidget(
            initialRoute: NoteCreateRoute(initialAccount: TestData.account),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 本文のTextFieldにフォーカスを当てる
      await tester.tap(find.byType(TextField).last);
      await tester.pumpAndSettle();

      // NoteEmojiが表示されていることを確認
      expect(find.byType(NoteEmoji), findsOneWidget);

      // InputComplementが表示されていることを確認
      expect(find.byType(InputComplement), findsOneWidget);

      // 適切なcontrollerとfocusNodeが使用されていることを確認
      final noteEmojiWidget = tester.widget<NoteEmoji>(find.byType(NoteEmoji));
      expect(noteEmojiWidget, isNotNull);

      // ProviderScopeからnoteFocusProviderとnoteInputTextProviderの状態を確認
      final container = ProviderScope.containerOf(
        tester.element(find.byType(NoteEmoji)),
      );
      final noteFocus = container.read(noteFocusProvider);
      final noteController = container.read(noteInputTextProvider);

      expect(noteFocus.hasFocus, isTrue);
      expect(noteController, isNotNull);
    });

    testWidgets("CWフィールドにフォーカスがある時にInputComplementが表示されること", (tester) async {
      final emojiRepository = MockEmojiRepository();
      when(emojiRepository.emoji).thenReturn([
        TestData.unicodeEmojiRepositoryData1,
        TestData.customEmojiRepositoryData1,
      ]);
      when(
        emojiRepository.defaultEmojis(),
      ).thenAnswer((_) => [TestData.unicodeEmoji1, TestData.customEmoji1]);
      final generalSettingsRepository = MockGeneralSettingsRepository();
      when(
        generalSettingsRepository.settings,
      ).thenReturn(const GeneralSettings(emojiType: EmojiType.system));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            emojiRepositoryProvider.overrideWith(
              (ref, account) => emojiRepository,
            ),
            generalSettingsRepositoryProvider.overrideWith(
              (ref) => generalSettingsRepository,
            ),
            inputComplementDelayedProvider.overrideWithValue(1),
          ],
          child: DefaultRootWidget(
            initialRoute: NoteCreateRoute(initialAccount: TestData.account),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // CWを有効化
      await tester.tap(find.byIcon(Icons.remove_red_eye));
      await tester.pumpAndSettle();

      // CWのTextFieldにフォーカスを当てる
      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();

      // NoteEmojiが表示されていることを確認
      expect(find.byType(NoteEmoji), findsOneWidget);

      // InputComplementが表示されていることを確認
      expect(find.byType(InputComplement), findsOneWidget);

      // 適切なcontrollerとfocusNodeが使用されていることを確認
      final container = ProviderScope.containerOf(
        tester.element(find.byType(NoteEmoji)),
      );
      final cwFocus = container.read(cwFocusProvider);
      final cwController = container.read(cwInputTextProvider);

      expect(cwFocus.hasFocus, isTrue);
      expect(cwController, isNotNull);
    });

    testWidgets("本文フィールドにフォーカスがある時のFocusNode状態を詳細確認", (tester) async {
      final emojiRepository = MockEmojiRepository();
      when(emojiRepository.emoji).thenReturn([]);
      when(emojiRepository.defaultEmojis()).thenAnswer((_) => []);
      final generalSettingsRepository = MockGeneralSettingsRepository();
      when(
        generalSettingsRepository.settings,
      ).thenReturn(const GeneralSettings(emojiType: EmojiType.system));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            emojiRepositoryProvider.overrideWith(
              (ref, account) => emojiRepository,
            ),
            generalSettingsRepositoryProvider.overrideWith(
              (ref) => generalSettingsRepository,
            ),
            inputComplementDelayedProvider.overrideWithValue(1),
          ],
          child: DefaultRootWidget(
            initialRoute: NoteCreateRoute(initialAccount: TestData.account),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(NoteCreatePage)),
      );
      final cwFocus = container.read(cwFocusProvider);
      final noteFocus = container.read(noteFocusProvider);

      // 初期状態
      print(
        "初期状態 - cwFocus.hasFocus: ${cwFocus.hasFocus}, noteFocus.hasFocus: ${noteFocus.hasFocus}",
      );

      // 本文のTextFieldにフォーカスを当てる
      await tester.tap(find.byType(TextField).last);
      await tester.pumpAndSettle();

      print(
        "本文フォーカス後 - cwFocus.hasFocus: ${cwFocus.hasFocus}, noteFocus.hasFocus: ${noteFocus.hasFocus}",
      );

      // NoteEmojiの条件チェック
      final useCw = cwFocus.hasFocus && !noteFocus.hasFocus;
      print("useCw判定: $useCw");
      print("期待値: false (本文フィールドを使用すべき)");

      expect(useCw, isFalse, reason: "本文フィールドにフォーカスがある時はuseCwはfalseであるべき");
    });

    testWidgets("CW有効時の本文フィールドフォーカス状態確認", (tester) async {
      final emojiRepository = MockEmojiRepository();
      when(emojiRepository.emoji).thenReturn([]);
      when(emojiRepository.defaultEmojis()).thenAnswer((_) => []);
      final generalSettingsRepository = MockGeneralSettingsRepository();
      when(
        generalSettingsRepository.settings,
      ).thenReturn(const GeneralSettings(emojiType: EmojiType.system));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            emojiRepositoryProvider.overrideWith(
              (ref, account) => emojiRepository,
            ),
            generalSettingsRepositoryProvider.overrideWith(
              (ref) => generalSettingsRepository,
            ),
            inputComplementDelayedProvider.overrideWithValue(1),
          ],
          child: DefaultRootWidget(
            initialRoute: NoteCreateRoute(initialAccount: TestData.account),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // CWを有効化
      await tester.tap(find.byIcon(Icons.remove_red_eye));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(NoteCreatePage)),
      );
      final cwFocus = container.read(cwFocusProvider);
      final noteFocus = container.read(noteFocusProvider);

      // CW有効化後の初期状態
      print(
        "CW有効化後 - cwFocus.hasFocus: ${cwFocus.hasFocus}, noteFocus.hasFocus: ${noteFocus.hasFocus}",
      );

      // 本文のTextFieldにフォーカスを当てる（CW有効時は2番目のTextField）
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      await tester.tap(textFields.at(1));
      await tester.pumpAndSettle();

      print(
        "本文フォーカス後(CW有効) - cwFocus.hasFocus: ${cwFocus.hasFocus}, noteFocus.hasFocus: ${noteFocus.hasFocus}",
      );

      // NoteEmojiの条件チェック
      final useCw = cwFocus.hasFocus && !noteFocus.hasFocus;
      print("useCw判定: $useCw");
      print("期待値: false (本文フィールドを使用すべき)");

      expect(useCw, isFalse, reason: "本文フィールドにフォーカスがある時はuseCwはfalseであるべき");
    });
  });
}
