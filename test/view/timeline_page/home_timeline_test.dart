import "package:flutter_test/flutter_test.dart";
import "package:miria/model/tab_type.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";
import "../../test_util/test_datas.dart";
import "timeline_page_test_util.dart";

void main() {
  group(
    "ホームタイムライン",
    () {
      testWidgets("ホームタイムラインを表示できること", (tester) async {
        final timelineTester = TimelinePageTest(tabType: TabType.homeTimeline);
        when(timelineTester.mockMisskeyNotes.homeTimeline(any))
            .thenAnswer((_) async => [TestData.note1]);

        await tester.pumpWidget(timelineTester.buildWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        verify(
          timelineTester.mockMisskeyNotes.homeTimeline(
            argThat(
              equals(
                const NotesTimelineRequest(
                  limit: 30,
                  withFiles: false,
                  withRenotes: false,
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
