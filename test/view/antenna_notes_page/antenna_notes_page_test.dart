import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/mockito.dart';

import '../../test_util/default_root_widget.dart';
import '../../test_util/mock.mocks.dart';
import '../../test_util/test_datas.dart';
import '../../test_util/widget_tester_extension.dart';

void main() {
  group("アンテナノート一覧", () {
    testWidgets("アンテナのノート一覧が表示されること", (tester) async {
      final antennas = MockMisskeyAntenna();
      final misskey = MockMisskey();
      when(misskey.antennas).thenReturn(antennas);
      when(antennas.notes(any)).thenAnswer((_) async => [TestData.note1]);

      await tester.pumpWidget(ProviderScope(
          overrides: [misskeyProvider.overrideWith((_, __) => misskey)],
          child: DefaultRootWidget(
            initialRoute: AntennaNotesRoute(
                account: TestData.account, antenna: TestData.antenna),
          )));
      await tester.pumpAndSettle();

      expect(find.text(TestData.note1.text!), findsOneWidget);
      verify(antennas.notes(argThat(
          equals(AntennasNotesRequest(antennaId: TestData.antenna.id)))));

      await tester.pageNation();
      verify(antennas.notes(argThat(equals(AntennasNotesRequest(
          antennaId: TestData.antenna.id, untilId: TestData.note1.id)))));
    });
  });
}
