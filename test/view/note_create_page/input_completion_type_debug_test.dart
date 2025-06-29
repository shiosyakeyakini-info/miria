import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:miria/view/common/note_create/input_completation.dart";
import "package:miria/view/note_create_page/note_create_page.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("InputCompletionType Debug", () {
    testWidgets("InputCompletionTypeの遷移確認", (tester) async {
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

      final container = ProviderScope.containerOf(
        tester.element(find.byType(NoteCreatePage)),
      );

      // CWを有効化
      await tester.tap(find.byIcon(Icons.remove_red_eye));
      await tester.pumpAndSettle();

      // CWのTextFieldにフォーカスを当てる
      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();

      print("=== CWフォーカス後 ===");
      final inputCompletionType1 = container.read(inputCompletionTypeProvider);
      print("InputCompletionType: ${inputCompletionType1.runtimeType}");

      // コントローラーに":"を入力
      final cwController = container.read(cwInputTextProvider);
      print("CWコントローラー取得完了");

      // 手動でテキストを設定してリスナーを発火
      cwController.text = ":";
      cwController.selection = TextSelection.fromPosition(
        const TextPosition(offset: 1),
      );
      await tester.pumpAndSettle();

      print("=== コロン入力後 ===");
      final inputCompletionType2 = container.read(inputCompletionTypeProvider);
      print("InputCompletionType: ${inputCompletionType2.runtimeType}");

      // 全角コロンをタップ（UI操作）
      final colonFinder = find.text("：");
      if (colonFinder.evaluate().isNotEmpty) {
        await tester.tap(colonFinder);
        await tester.pumpAndSettle();

        print("=== コロンタップ後 ===");
        final inputCompletionType3 = container.read(
          inputCompletionTypeProvider,
        );
        print("InputCompletionType: ${inputCompletionType3.runtimeType}");

        final networkImageViews = find.byType(NetworkImageView);
        print("NetworkImageView数: ${networkImageViews.evaluate().length}");
      }
    });
  });
}
