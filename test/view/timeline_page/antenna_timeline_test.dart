import "package:flutter_test/flutter_test.dart";
import "package:miria/model/tab_type.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";
import "timeline_page_test_util.dart";

void main() {
  group(
    "アンテナタイムライン",
    () {
      testWidgets("アンテナタイムラインを表示できること", (tester) async {
        final timelineTester =
            TimelinePageTest(tabType: TabType.antenna, antennaId: "abcdefg");
        final mockMisskeyAntenna = MockMisskeyAntenna();
        when(mockMisskeyAntenna.notes(any))
            .thenAnswer((_) async => [TestData.note1]);
        when(timelineTester.mockMisskey.antennas)
            .thenReturn(mockMisskeyAntenna);

        await tester.pumpWidget(timelineTester.buildWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        verify(
          mockMisskeyAntenna.notes(
            argThat(
              equals(
                const AntennasNotesRequest(
                  antennaId: "abcdefg",
                  limit: 30,
                ),
              ),
            ),
          ),
        );
      });
    },
    skip: true,
  );
}
