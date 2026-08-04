import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/view/notification_page/notification_page_data.dart";
import "package:misskey_dart/misskey_dart.dart";

import "../../test_util/test_datas.dart";

void main() {
  group("予約投稿の通知", () {
    late S localize;

    setUp(() async {
      localize = await S.delegate.load(const Locale("ja"));
    });

    INotificationsResponse notification(NotificationType type, {Note? note}) =>
        INotificationsResponse(
          id: "notification1",
          createdAt: DateTime(2026, 7, 19),
          type: type,
          note: note,
        );

    // #851: 予約投稿に関する通知がunknownNotificationとして扱われていた
    test("予約投稿がノートされた通知がノートつきで表示されること", () {
      final result = [
        notification(
          NotificationType.scheduledNotePosted,
          note: TestData.note1,
        ),
      ].toNotificationData(localize);

      expect(result, hasLength(1));
      final data = result.first;
      expect(data, isA<ScheduledNoteNotification>());
      expect((data as ScheduledNoteNotification).note?.id, TestData.note1.id);
    });

    test("予約投稿に失敗した通知が専用のメッセージで表示されること", () {
      final result = [
        notification(NotificationType.scheduledNotePostFailed),
      ].toNotificationData(localize);

      expect(result, hasLength(1));
      final data = result.first;
      expect(data, isA<SimpleNotificationData>());
      expect(
        (data as SimpleNotificationData).text,
        localize.scheduledNotePostFailedNotification,
      );
      expect(data.text, isNot(localize.unknownNotification));
    });
  });
}
