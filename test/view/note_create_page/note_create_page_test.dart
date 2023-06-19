import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:mockito/mockito.dart';

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

      await tester.tap(find.text("他のん"));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(NetworkImageView).hitTestable());
      await tester.pumpAndSettle();
      expect(
          tester
              .textEditingController(find.byType(TextField).hitTestable())
              .text,
          ":${TestData.emoji2.baseName}:");
    });
  });
}
