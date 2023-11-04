import 'package:flutter_test/flutter_test.dart';
import 'package:miria/model/tab_type.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/mockito.dart';
import '../../test_util/test_datas.dart';
import 'timeline_page_test_util.dart';

void main() {
  group("リストタイムライン", () {
    testWidgets("リストタイムラインを表示できること", (tester) async {
      final timelineTester =
          TimelinePageTest(tabType: TabType.userList, listId: "abcdefg");
      when(
        timelineTester.mockMisskey.userListStream(
          listId: anyNamed("listId"),
          onNoteReceived: anyNamed("onNoteReceived"),
          onReacted: anyNamed("onReacted"),
          onUnreacted: anyNamed("onUnreacted"),
          onDeleted: anyNamed("onDeleted"),
          onVoted: anyNamed("onVoted"),
          onUpdated: anyNamed("onUpdated"),
        ),
      ).thenReturn(timelineTester.mockSocketController);
      when(timelineTester.mockMisskeyNotes.userListTimeline(any))
          .thenAnswer((_) async => [TestData.note1]);

      await tester.pumpWidget(timelineTester.buildWidget());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      verify(timelineTester.mockMisskeyNotes
          .userListTimeline(argThat(equals(const UserListTimelineRequest(
        listId: "abcdefg",
        withRenotes: false,
        withFiles: false,
      )))));
    });
  });
}
