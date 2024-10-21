import "package:flutter_test/flutter_test.dart";
import "package:miria/model/tab_type.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";
import "../../test_util/test_datas.dart";
import "timeline_page_test_util.dart";

void main() {
  group(
    "ソーシャルタイムライン",
    () {
      testWidgets("ソーシャルタイムラインを表示できること", (tester) async {
        final timelineTester =
            TimelinePageTest(tabType: TabType.hybridTimeline);
        when(timelineTester.mockMisskeyNotes.hybridTimeline(any))
            .thenAnswer((_) async => [TestData.note1]);

        await tester.pumpWidget(timelineTester.buildWidget());
        await tester.pumpAndSettle(const Duration(seconds: 1));

        verify(
          timelineTester.mockMisskeyNotes.hybridTimeline(
            argThat(
              equals(
                const NotesHybridTimelineRequest(
                  withFiles: false,
                  withRenotes: false,
                  withReplies: false,
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
