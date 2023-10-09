import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/default_root_widget.dart';
import '../../test_util/mock.mocks.dart';
import '../../test_util/test_datas.dart';

void main() {
  group("アンテナ一覧", () {
    testWidgets("アンテナ一覧が表示されること", (tester) async {
      final antennas = MockMisskeyAntenna();
      final misskey = MockMisskey();
      when(misskey.antennas).thenReturn(antennas);
      when(antennas.list()).thenAnswer((_) async => [TestData.antenna]);

      await tester.pumpWidget(ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
          child: DefaultRootWidget(
            initialRoute: AntennaRoute(account: TestData.account),
          )));
      await tester.pumpAndSettle();

      expect(find.text(TestData.antenna.name), findsOneWidget);
    });
  });
}
