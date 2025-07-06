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
  group("Detailed Debug", () {
    testWidgets("InputComplementの状態詳細確認", (tester) async {
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

      final container = ProviderScope.containerOf(
        tester.element(find.byType(NoteCreatePage)),
      );

      // CWのTextFieldにフォーカスを当てる前
      print("=== CWフォーカス前 ===");
      final cwFocus1 = container.read(cwFocusProvider);
      final noteFocus1 = container.read(noteFocusProvider);
      print("cwFocus.hasFocus: ${cwFocus1.hasFocus}");
      print("noteFocus.hasFocus: ${noteFocus1.hasFocus}");

      // 明示的にCWにフォーカス
      cwFocus1.requestFocus();
      await tester.pumpAndSettle();

      print("=== CWフォーカス後 ===");
      final cwFocus2 = container.read(cwFocusProvider);
      final noteFocus2 = container.read(noteFocusProvider);
      print("cwFocus.hasFocus: ${cwFocus2.hasFocus}");
      print("noteFocus.hasFocus: ${noteFocus2.hasFocus}");

      // InputComplementの内容確認
      final inputComplementFinder = find.byType(InputComplement);
      expect(inputComplementFinder, findsOneWidget);

      final inputComplementElement = inputComplementFinder.evaluate().first;
      print("InputComplement found: ${inputComplementElement.widget}");

      // 内部のContainerが空でないか確認
      final containerFinder = find.descendant(
        of: inputComplementFinder,
        matching: find.byType(Container),
      );
      print("Container数: ${containerFinder.evaluate().length}");

      // DecoratedBoxを探す
      final decoratedBoxFinder = find.descendant(
        of: inputComplementFinder,
        matching: find.byType(DecoratedBox),
      );
      print("DecoratedBox数: ${decoratedBoxFinder.evaluate().length}");

      // 本文フィールドにフォーカス変更
      print("=== 本文フォーカス変更 ===");
      noteFocus2.requestFocus();
      await tester.pumpAndSettle();

      final cwFocus3 = container.read(cwFocusProvider);
      final noteFocus3 = container.read(noteFocusProvider);
      print("cwFocus.hasFocus: ${cwFocus3.hasFocus}");
      print("noteFocus.hasFocus: ${noteFocus3.hasFocus}");

      final decoratedBoxFinder2 = find.descendant(
        of: inputComplementFinder,
        matching: find.byType(DecoratedBox),
      );
      print(
        "DecoratedBox数（本文フォーカス後）: ${decoratedBoxFinder2.evaluate().length}",
      );
    });
  });
}
