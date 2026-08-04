import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/view/notification_page/notification_page_data.dart";
import "package:misskey_dart/misskey_dart.dart";

import "../../test_util/test_datas.dart";

INotificationsResponse appNotification({
  String? body,
  String? header,
  Uri? icon,
}) => INotificationsResponse(
  id: "1",
  createdAt: DateTime(2026),
  type: NotificationType.app,
  body: body,
  header: header,
  icon: icon,
);

Future<S> localize() => S.delegate.load(const Locale("ja", "JP"));

void main() {
  group("アプリからの通知", () {
    test("本文・ヘッダ・アイコンが保たれること", () async {
      final result = [
        appNotification(
          body: "ビルドが通ったで",
          header: "みりあ CI",
          icon: Uri.parse("https://example.test/icon.png"),
        ),
      ].toNotificationData(await localize());

      expect(result, hasLength(1));
      final data = result.single as AppNotificationData;
      expect(data.body, "ビルドが通ったで");
      expect(data.header, "みりあ CI");
      expect(data.icon, Uri.parse("https://example.test/icon.png"));
    });

    test("ヘッダとアイコンがなくても本文があれば保たれること", () async {
      final result = [
        appNotification(body: "本文だけ"),
      ].toNotificationData(await localize());

      final data = result.single as AppNotificationData;
      expect(data.body, "本文だけ");
      expect(data.header, isNull);
      expect(data.icon, isNull);
    });

    test("本文がなければ従来の固定文言にフォールバックすること", () async {
      final s = await localize();
      final result = [appNotification(header: "みりあ CI")].toNotificationData(s);

      final data = result.single as SimpleNotificationData;
      expect(data.text, s.appNotification);
    });

    test("本文が空文字でもフォールバックすること", () async {
      final s = await localize();
      final result = [appNotification(body: "")].toNotificationData(s);

      expect(result.single, isA<SimpleNotificationData>());
    });
  });

  group("予約投稿の通知", () {
    late S s;

    setUp(() async {
      s = await S.delegate.load(const Locale("ja"));
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
      ].toNotificationData(s);

      expect(result, hasLength(1));
      final data = result.first;
      expect(data, isA<ScheduledNoteNotification>());
      expect((data as ScheduledNoteNotification).note?.id, TestData.note1.id);
    });

    test("予約投稿に失敗した通知が専用のメッセージで表示されること", () {
      final result = [
        notification(NotificationType.scheduledNotePostFailed),
      ].toNotificationData(s);

      expect(result, hasLength(1));
      final data = result.first;
      expect(data, isA<SimpleNotificationData>());
      expect(
        (data as SimpleNotificationData).text,
        s.scheduledNotePostFailedNotification,
      );
      expect(data.text, isNot(s.unknownNotification));
    });
  });
}
