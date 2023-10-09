import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/default_root_widget.dart';
import '../../test_util/mock.mocks.dart';
import '../../test_util/test_datas.dart';

void main() {
  group("クリップのノート一覧", () {
    testWidgets("クリップ済みノートが表示されること", (tester) async {
      final clip = MockMisskeyClips();
      final misskey = MockMisskey();
      when(misskey.clips).thenReturn(clip);
      when(clip.notes(any)).thenAnswer((_) async => [TestData.note1]);

      await tester.pumpWidget(ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
          child: DefaultRootWidget(
            initialRoute: ClipDetailRoute(
                id: TestData.clip.id, account: TestData.account),
          )));
      await tester.pumpAndSettle();

      expect(find.text(TestData.note1.text!), findsOneWidget);
    });
  });
}
