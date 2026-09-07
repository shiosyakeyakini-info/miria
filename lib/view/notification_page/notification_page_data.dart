// Flutter にも Notification があるので隠す
import "package:flutter/material.dart" hide Notification;
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/achievement.dart";
import "package:misskey_dart/misskey_dart.dart";

sealed class NotificationData {
  final String id;
  final DateTime createdAt;

  NotificationData({required this.createdAt, required this.id});
}

class RenoteReactionNotificationData extends NotificationData {
  final Note? note;
  final List<(String?, User?)> reactionUsers;
  final List<User?> renoteUsers;

  RenoteReactionNotificationData({
    required this.note,
    required this.reactionUsers,
    required this.renoteUsers,
    required super.createdAt,
    required super.id,
  });
}

sealed class MentionQuoteNotificationDataType {
  String Function(BuildContext) get name;
  static final mention = _Mention();
  static final quote = _QuotedRenote();
  static final reply = _Reply();
}

class _Mention implements MentionQuoteNotificationDataType {
  @override
  String Function(BuildContext context) get name =>
      (context) => S.of(context).mention;
}

class _QuotedRenote implements MentionQuoteNotificationDataType {
  @override
  String Function(BuildContext context) get name =>
      (context) => S.of(context).quotedRenote;
}

class _Reply implements MentionQuoteNotificationDataType {
  @override
  String Function(BuildContext context) get name =>
      (context) => "";
}

class MentionQuoteNotificationData extends NotificationData {
  final Note? note;
  final User? user;
  final MentionQuoteNotificationDataType type;

  MentionQuoteNotificationData({
    required super.createdAt,
    required this.note,
    required this.user,
    required this.type,
    required super.id,
  });
}

sealed class FollowNotificationDataType {
  String Function(BuildContext, String) get name;
  static final follow = _Follow();
  factory FollowNotificationDataType.followRequestAccepted(
    String? message,
    User? user,
  ) => FollowRequestAccepted(message, user);
  static final receiveFollowRequest = _ReceiveFollowRequest();
}

class _Follow implements FollowNotificationDataType {
  @override
  String Function(BuildContext context, String userName) get name =>
      (context, userName) => S.of(context).followedNotification(userName);
}

class FollowRequestAccepted implements FollowNotificationDataType {
  final String? message;
  final User? user;
  FollowRequestAccepted(this.message, this.user);
  @override
  String Function(BuildContext context, String userName) get name =>
      (context, userName) =>
          S.of(context).followRequestAcceptedNotification(userName);
}

class _ReceiveFollowRequest implements FollowNotificationDataType {
  @override
  String Function(BuildContext context, String userName) get name =>
      (context, userName) =>
          S.of(context).receiveFollowRequestNotification(userName);
}

class FollowNotificationData extends NotificationData {
  final User? user;
  final FollowNotificationDataType type;
  FollowNotificationData({
    required this.user,
    required super.createdAt,
    required this.type,
    required super.id,
  });
}

class SimpleNotificationData extends NotificationData {
  final String text;

  SimpleNotificationData({
    required this.text,
    required super.createdAt,
    required super.id,
  });
}

class PollNotification extends NotificationData {
  final Note? note;

  PollNotification({
    required this.note,
    required super.createdAt,
    required super.id,
  });
}

class NoteNotification extends NotificationData {
  final Note? note;
  NoteNotification({
    required this.note,
    required super.createdAt,
    required super.id,
  });
}

/// 予約投稿がノートされたときの通知
class ScheduledNoteNotification extends NotificationData {
  final Note? note;
  ScheduledNoteNotification({
    required this.note,
    required super.createdAt,
    required super.id,
  });
}

class RoleNotification extends NotificationData {
  final Role? role;
  RoleNotification({
    required this.role,
    required super.createdAt,
    required super.id,
  });
}

/// アプリからの通知。
///
/// Misskey は `body` のみ必須で、`header` と `icon` は通知を作ったアプリの
/// 名前とアイコンで埋まる。アプリを介さず `notifications/create` を直接
/// 叩いた場合は両方 null になりうる。
class AppNotificationData extends NotificationData {
  final String body;
  final String? header;
  final Uri? icon;

  AppNotificationData({
    required this.body,
    required this.header,
    required this.icon,
    required super.createdAt,
    required super.id,
  });
}

class InvitedChatRoomNotification extends NotificationData {
  final ChatRoomInvitation invitation;
  InvitedChatRoomNotification({
    required this.invitation,
    required super.createdAt,
    required super.id,
  });
}

/// 通知の種類にかかわらずノートを取り出す。
///
/// misskey_dart の [Notification] は sealed class になったので、
/// 素朴に `.note` とは書けない。
extension NotificationNoteExtension on Notification {
  Note? get note => switch (this) {
    NotificationNote(:final note) => note,
    NotificationMention(:final note) => note,
    NotificationReply(:final note) => note,
    NotificationRenote(:final note) => note,
    NotificationQuote(:final note) => note,
    NotificationReaction(:final note) => note,
    NotificationPollEnded(:final note) => note,
    NotificationScheduledNotePosted(:final note) => note,
    NotificationReactionGrouped(:final note) => note,
    NotificationRenoteGrouped(:final note) => note,
    _ => null,
  };
}

extension NotificationExtension on Iterable<Notification> {
  List<NotificationData> toNotificationData(
    S localize,
    Achievements achievements,
  ) {
    final resultList = <NotificationData>[];

    for (final element in this) {
      switch (element) {
        case NotificationReaction(
          :final id,
          :final createdAt,
          :final user,
          :final note,
          :final reaction,
        ):
          var isSummarize = false;
          resultList
              .whereType<RenoteReactionNotificationData>()
              .where((e) => note.id == e.note?.id)
              .forEach((e) {
                isSummarize = true;
                e.reactionUsers.add((reaction, user));
              });

          if (!isSummarize) {
            resultList.add(
              RenoteReactionNotificationData(
                note: note,
                reactionUsers: [(reaction, user)],
                renoteUsers: [],
                createdAt: createdAt,
                id: id,
              ),
            );
          }

        case NotificationRenote(
          :final id,
          :final createdAt,
          :final user,
          :final note,
        ):
          var isSummarize = false;
          resultList
              .whereType<RenoteReactionNotificationData>()
              .where((e) => note.renote?.id == e.note?.id)
              .forEach((e) {
                isSummarize = true;
                e.renoteUsers.add(user);
              });

          if (!isSummarize) {
            resultList.add(
              RenoteReactionNotificationData(
                note: note.renote,
                reactionUsers: [],
                renoteUsers: [user],
                createdAt: createdAt,
                id: id,
              ),
            );
          }

        case NotificationRenoteGrouped(
          :final id,
          :final createdAt,
          :final note,
          :final users,
        ):
          resultList.add(
            RenoteReactionNotificationData(
              note: note,
              reactionUsers: [],
              renoteUsers: users.toList(),
              createdAt: createdAt,
              id: id,
            ),
          );

        case NotificationReactionGrouped(
          :final id,
          :final createdAt,
          :final note,
          :final reactions,
        ):
          resultList.add(
            RenoteReactionNotificationData(
              note: note,
              reactionUsers: [for (final e in reactions) (e.reaction, e.user)],
              renoteUsers: [],
              createdAt: createdAt,
              id: id,
            ),
          );

        case NotificationQuote(
          :final id,
          :final createdAt,
          :final user,
          :final note,
        ):
          resultList.add(
            MentionQuoteNotificationData(
              createdAt: createdAt,
              note: note,
              user: user,
              type: MentionQuoteNotificationDataType.quote,
              id: id,
            ),
          );

        case NotificationMention(
          :final id,
          :final createdAt,
          :final user,
          :final note,
        ):
          resultList.add(
            MentionQuoteNotificationData(
              createdAt: createdAt,
              note: note,
              user: user,
              type: MentionQuoteNotificationDataType.mention,
              id: id,
            ),
          );

        case NotificationReply(
          :final id,
          :final createdAt,
          :final user,
          :final note,
        ):
          resultList.add(
            MentionQuoteNotificationData(
              createdAt: createdAt,
              note: note,
              user: user,
              type: MentionQuoteNotificationDataType.reply,
              id: id,
            ),
          );

        case NotificationFollow(:final id, :final createdAt, :final user):
          resultList.add(
            FollowNotificationData(
              user: user,
              createdAt: createdAt,
              type: FollowNotificationDataType.follow,
              id: id,
            ),
          );

        case NotificationFollowRequestAccepted(
          :final id,
          :final createdAt,
          :final user,
          :final message,
        ):
          resultList.add(
            FollowNotificationData(
              user: user,
              createdAt: createdAt,
              type: FollowNotificationDataType.followRequestAccepted(
                message,
                user,
              ),
              id: id,
            ),
          );

        case NotificationReceiveFollowRequest(
          :final id,
          :final createdAt,
          :final user,
        ):
          resultList.add(
            FollowNotificationData(
              user: user,
              createdAt: createdAt,
              type: FollowNotificationDataType.receiveFollowRequest,
              id: id,
            ),
          );

        case NotificationAchievementEarned(
          :final id,
          :final createdAt,
          :final achievement,
        ):
          final name = achievement?.toString() ?? "";
          resultList.add(
            SimpleNotificationData(
              text:
                  "${localize.achievementEarnedNotification}"
                  "[${achievements[name]?.title ?? name}]",
              createdAt: createdAt,
              id: id,
            ),
          );

        case NotificationScheduledNotePosted(
          :final id,
          :final createdAt,
          :final note,
        ):
          resultList.add(
            ScheduledNoteNotification(note: note, createdAt: createdAt, id: id),
          );

        case NotificationScheduledNotePostFailed(:final id, :final createdAt):
          resultList.add(
            SimpleNotificationData(
              text: localize.scheduledNotePostFailedNotification,
              createdAt: createdAt,
              id: id,
            ),
          );

        case NotificationPollEnded(:final id, :final createdAt, :final note):
          resultList.add(
            PollNotification(note: note, createdAt: createdAt, id: id),
          );

        case NotificationTest(:final id, :final createdAt):
          resultList.add(
            SimpleNotificationData(
              text: localize.testNotification,
              createdAt: createdAt,
              id: id,
            ),
          );

        case NotificationNote(:final id, :final createdAt, :final note):
          resultList.add(
            NoteNotification(note: note, createdAt: createdAt, id: id),
          );

        case NotificationRoleAssigned(:final id, :final createdAt, :final role):
          resultList.add(
            RoleNotification(role: role, createdAt: createdAt, id: id),
          );

        case NotificationApp(
          :final id,
          :final createdAt,
          :final body,
          :final header,
          :final icon,
        ):
          if (body.isEmpty) {
            // 本文がなければ従来どおり「アプリからの通知」とだけ伝える
            resultList.add(
              SimpleNotificationData(
                text: localize.appNotification,
                createdAt: createdAt,
                id: id,
              ),
            );
          } else {
            resultList.add(
              AppNotificationData(
                body: body,
                header: header,
                icon: icon == null ? null : Uri.tryParse(icon),
                createdAt: createdAt,
                id: id,
              ),
            );
          }

        case NotificationExportCompleted(:final id, :final createdAt):
          resultList.add(
            SimpleNotificationData(
              text: localize.exportCompleted,
              createdAt: createdAt,
              id: id,
            ),
          );

        case NotificationLogin(:final id, :final createdAt):
          resultList.add(
            SimpleNotificationData(
              text: localize.someoneLogined,
              createdAt: createdAt,
              id: id,
            ),
          );

        case NotificationCreateToken(:final id, :final createdAt):
          resultList.add(
            SimpleNotificationData(
              text: localize.createTokenNotification,
              createdAt: createdAt,
              id: id,
            ),
          );

        case NotificationChatRoomInvitationReceived(
          :final id,
          :final createdAt,
          :final invitation,
        ):
          resultList.add(
            InvitedChatRoomNotification(
              invitation: invitation,
              createdAt: createdAt,
              id: id,
            ),
          );

        case NotificationUnknown(:final id, :final createdAt):
          resultList.add(
            SimpleNotificationData(
              text: localize.unknownNotification,
              createdAt: createdAt ?? DateTime.now(),
              id: id ?? "",
            ),
          );
      }
    }

    return resultList;
  }
}
