import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/note_create/input_completation.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";
import "../../test_util/widget_tester_extension.dart";

void main() {
  group("下書き保存の確認ダイアログ", () {
    // #834: 確認ダイアログはNavigatorのルートを積まないオーバーレイ方式のため、
    // 表示中でもAndroidの戻るキーはノート作成ページに届いてしまう。
    // 再入ガードがないと戻るキーを連打した数だけダイアログが積み重なっていた。
    testWidgets("戻るキーを連打してもダイアログが重ねて表示されないこと", (tester) async {
      final mockMisskey = MockMisskey();
      final mockNote = MockMisskeyNotes();
      when(mockMisskey.notes).thenReturn(mockNote);

      // 下書き機能が有効なアカウントでないと確認ダイアログが出ない
      final account = TestData.account.copyWith(
        i: TestData.account.i.copyWith(
          policies: TestData.account.i.policies.copyWith(noteDraftLimit: 10),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            inputComplementDelayedProvider.overrideWithValue(1),
          ],
          child: DefaultRootWidget(
            initialRoute: NoteCreateRoute(initialAccount: account),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 下書きに保存する内容がないとダイアログが出ない
      await tester.enterText(find.byType(TextField).hitTestable(), "ぬるぽ");
      await tester.pumpAndSettle();

      // 戻るキーを連打する
      await tester.binding.handlePopRoute();
      await tester.binding.handlePopRoute();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text("下書きに保存しとく？"), findsOneWidget);
    });
  });
}
