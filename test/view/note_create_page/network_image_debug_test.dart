import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:miria/view/common/note_create/input_completation.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("NetworkImageView Debug", () {
    testWidgets("NetworkImageViewの表示数確認", (tester) async {
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
      final networkImageViews1 = find.byType(NetworkImageView);
      print("NetworkImageView数: ${networkImageViews1.evaluate().length}");

      // CWを有効化
      await tester.tap(find.byIcon(Icons.remove_red_eye));
      await tester.pumpAndSettle();

      print("=== CW有効化後 ===");
      final networkImageViews2 = find.byType(NetworkImageView);
      print("NetworkImageView数: ${networkImageViews2.evaluate().length}");

      // CWのTextFieldにフォーカスを当てる
      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();

      print("=== CWフォーカス後 ===");
      final networkImageViews3 = find.byType(NetworkImageView);
      print("NetworkImageView数: ${networkImageViews3.evaluate().length}");

      // 全角コロンをタップ
      final colonFinder = find.text("：");
      print("全角コロン数: ${colonFinder.evaluate().length}");

      if (colonFinder.evaluate().isNotEmpty) {
        await tester.tap(colonFinder);
        await tester.pumpAndSettle();

        print("=== コロンタップ後 ===");
        final networkImageViews4 = find.byType(NetworkImageView);
        print("NetworkImageView数: ${networkImageViews4.evaluate().length}");

        // 各NetworkImageViewの情報を出力
        for (var i = 0; i < networkImageViews4.evaluate().length; i++) {
          print("NetworkImageView[$i]: 存在");
        }

        // EmojiKeyboardが表示されているかも確認
        try {
          final emojiKeyboard = find.byWidgetPredicate(
            (widget) => widget.toString().contains("EmojiKeyboard"),
          );
          print("EmojiKeyboard関連ウィジェット数: ${emojiKeyboard.evaluate().length}");
        } catch (e) {
          print("EmojiKeyboard検索エラー: $e");
        }

        // BasicKeyboardの状態も確認
        final basicKeyboard = find.text("：");
        print("BasicKeyboard の コロン数: ${basicKeyboard.evaluate().length}");
      }
    });
  });
}
