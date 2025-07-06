import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/note_create/input_completation.dart";
import "package:miria/view/note_create_page/note_create_page.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("Focus Debug", () {
    testWidgets("フォーカス状態の詳細確認", (tester) async {
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

      print("=== 初期状態 ===");
      final noteFocus1 = container.read(noteFocusProvider);
      final cwFocus1 = container.read(cwFocusProvider);
      print("noteFocus.hasFocus: ${noteFocus1.hasFocus}");
      print("cwFocus.hasFocus: ${cwFocus1.hasFocus}");

      // CWを有効化
      await tester.tap(find.byIcon(Icons.remove_red_eye));
      await tester.pumpAndSettle();

      print("=== CW有効化後 ===");
      final noteFocus2 = container.read(noteFocusProvider);
      final cwFocus2 = container.read(cwFocusProvider);
      print("noteFocus.hasFocus: ${noteFocus2.hasFocus}");
      print("cwFocus.hasFocus: ${cwFocus2.hasFocus}");

      // CWのTextFieldにフォーカスを当てる前の状態
      print("=== CWフィールドタップ前 ===");
      final textFields = find.byType(TextField);
      print("TextField数: ${textFields.evaluate().length}");

      // 明示的にCWのFocusNodeにフォーカス要求
      container.read(cwFocusProvider).requestFocus();
      await tester.pumpAndSettle();

      print("=== CW明示的フォーカス後 ===");
      final noteFocus3 = container.read(noteFocusProvider);
      final cwFocus3 = container.read(cwFocusProvider);
      print("noteFocus.hasFocus: ${noteFocus3.hasFocus}");
      print("cwFocus.hasFocus: ${cwFocus3.hasFocus}");

      // 本文のFocusNodeにフォーカス要求
      container.read(noteFocusProvider).requestFocus();
      await tester.pumpAndSettle();

      print("=== 本文明示的フォーカス後 ===");
      final noteFocus4 = container.read(noteFocusProvider);
      final cwFocus4 = container.read(cwFocusProvider);
      print("noteFocus.hasFocus: ${noteFocus4.hasFocus}");
      print("cwFocus.hasFocus: ${cwFocus4.hasFocus}");
    });
  });
}
