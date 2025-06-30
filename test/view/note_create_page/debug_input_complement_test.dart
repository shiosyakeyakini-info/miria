import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/note_create/basic_keyboard.dart";
import "package:miria/view/common/note_create/input_completation.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("Debug InputComplement", () {
    testWidgets("CWフィールドにフォーカス時のInputComplement表示確認", (tester) async {
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

      print("=== 初期状態 ===");
      print(
        "InputComplement数: ${find.byType(InputComplement).evaluate().length}",
      );
      print("BasicKeyboard数: ${find.byType(BasicKeyboard).evaluate().length}");
      print("TextField数: ${find.byType(TextField).evaluate().length}");

      // CWを有効化
      await tester.tap(find.byIcon(Icons.remove_red_eye));
      await tester.pumpAndSettle();

      print("=== CW有効化後 ===");
      print(
        "InputComplement数: ${find.byType(InputComplement).evaluate().length}",
      );
      print("BasicKeyboard数: ${find.byType(BasicKeyboard).evaluate().length}");
      print("TextField数: ${find.byType(TextField).evaluate().length}");

      // CWのTextFieldにフォーカスを当てる
      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();

      print("=== CWフォーカス後 ===");
      print(
        "InputComplement数: ${find.byType(InputComplement).evaluate().length}",
      );
      print("BasicKeyboard数: ${find.byType(BasicKeyboard).evaluate().length}");
      print("全角コロン「：」: ${find.text("：").evaluate().length}");
      print("半角コロン「:」: ${find.text(":").evaluate().length}");

      // BasicKeyboardのボタンを列挙
      final basicKeyboardElements = find.byType(BasicKeyboard).evaluate();
      if (basicKeyboardElements.isNotEmpty) {
        print("=== BasicKeyboard内容 ===");
        // BasicKeyboard内のテキストを全て列挙
        final textFinders = [
          find.text("あ"),
          find.text("ｱ"),
          find.text("A"),
          find.text("123"),
          find.text("："),
          find.text("#"),
          find.text("@"),
          find.text("["),
        ];
        for (final finder in textFinders) {
          final count = finder.evaluate().length;
          if (count > 0) {
            print("テキスト: $count個");
          }
        }
      }

      // 本文のTextFieldにフォーカスを当てる
      await tester.tap(find.byType(TextField).at(1));
      await tester.pumpAndSettle();

      print("=== 本文フォーカス後 ===");
      print(
        "InputComplement数: ${find.byType(InputComplement).evaluate().length}",
      );
      print("BasicKeyboard数: ${find.byType(BasicKeyboard).evaluate().length}");
      print("全角コロン「：」: ${find.text("：").evaluate().length}");
      print("半角コロン「:」: ${find.text(":").evaluate().length}");
    });
  });
}

class _TextFinder extends Finder {
  final String text;
  _TextFinder(this.text);

  @override
  String get description => 'text "$text"';

  @override
  Iterable<Element> apply(Iterable<Element> candidates) {
    return candidates.where((element) {
      final widget = element.widget;
      if (widget is Text) {
        return widget.data == text;
      }
      return false;
    });
  }
}
