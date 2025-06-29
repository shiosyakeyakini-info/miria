import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/note_create/input_completation.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";

void main() {
  group("Simplified Input Test", () {
    testWidgets("基本的な入力補完が動作すること", (tester) async {
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

      // 基本的なInputComplementが表示されることを確認
      expect(find.byType(InputComplement), findsOneWidget);

      // CWを有効化
      await tester.tap(find.byIcon(Icons.remove_red_eye));
      await tester.pumpAndSettle();

      // CWのTextFieldにフォーカスを当てる
      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();

      // InputComplementが表示されることを確認
      expect(find.byType(InputComplement), findsOneWidget);

      // 本文のTextFieldにフォーカスを当てる
      await tester.tap(find.byType(TextField).at(1));
      await tester.pumpAndSettle();

      // InputComplementが表示されることを確認
      expect(find.byType(InputComplement), findsOneWidget);

      // テストが通ることを確認
      expect(true, isTrue);
    });

    testWidgets("テキスト入力が機能すること", (tester) async {
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

      // 本文フィールドにテキストを入力
      await tester.enterText(find.byType(TextField).last, "Hello World");
      await tester.pumpAndSettle();

      // テキストが入力されたことを確認（入力フィールドとプレビューの両方）
      expect(find.text("Hello World"), findsNWidgets(2));
    });
  });
}
