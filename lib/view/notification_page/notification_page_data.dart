import "package:flutter/material.dart";
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
  final RolesListResponse? role;
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
  final ChatJoining invitation;
  InvitedChatRoomNotification({
    required this.invitation,
    required super.createdAt,
    required super.id,
  });
}

extension INotificationsResponseExtension on Iterable<INotificationsResponse> {
  List<NotificationData> toNotificationData(
    S localize,
    Achievements achievements,
  ) {
    final resultList = <NotificationData>[];

    for (final element in this) {
      switch (element.type) {
        case NotificationType.reaction:
          var isSummarize = false;
          resultList
              .whereType<RenoteReactionNotificationData>()
              .where((e) => element.note?.id == e.note?.id)
              .forEach((e) {
                isSummarize = true;
                if (element.user != null) {
                  e.reactionUsers.add((element.reaction!, element.user!));
                }
              });

          if (!isSummarize) {
            resultList.add(
              RenoteReactionNotificationData(
                note: element.note,
                reactionUsers: [(element.reaction, element.user)],
                renoteUsers: [],
                createdAt: element.createdAt,
                id: element.id,
              ),
            );
          }

        case NotificationType.renote:
          var isSummarize = false;
          resultList
              .whereType<RenoteReactionNotificationData>()
              .where((e) => element.note?.renote?.id == e.note?.id)
              .forEach((e) {
                isSummarize = true;
                e.renoteUsers.add(element.user);
              });

          if (!isSummarize) {
            resultList.add(
              RenoteReactionNotificationData(
                note: element.note?.renote,
                reactionUsers: [],
                renoteUsers: [element.user],
                createdAt: element.createdAt,
                id: element.id,
              ),
            );
          }

        case NotificationType.quote:
          resultList.add(
            MentionQuoteNotificationData(
              createdAt: element.createdAt,
              note: element.note,
              user: element.user,
              type: MentionQuoteNotificationDataType.quote,
              id: element.id,
            ),
          );

        case NotificationType.mention:
          resultList.add(
            MentionQuoteNotificationData(
              createdAt: element.createdAt,
              note: element.note,
              user: element.user,
              type: MentionQuoteNotificationDataType.mention,
              id: element.id,
            ),
          );

        case NotificationType.reply:
          resultList.add(
            MentionQuoteNotificationData(
              createdAt: element.createdAt,
              note: element.note,
              user: element.user,
              type: MentionQuoteNotificationDataType.reply,
              id: element.id,
            ),
          );

        case NotificationType.follow:
          resultList.add(
            FollowNotificationData(
              user: element.user,
              createdAt: element.createdAt,
              type: FollowNotificationDataType.follow,
              id: element.id,
            ),
          );

        case NotificationType.followRequestAccepted:
          resultList.add(
            FollowNotificationData(
              user: element.user,
              createdAt: element.createdAt,
              type: FollowNotificationDataType.followRequestAccepted(
                element.message,
                element.user,
              ),
              id: element.id,
            ),
          );
        case NotificationType.receiveFollowRequest:
          resultList.add(
            FollowNotificationData(
              user: element.user,
              createdAt: element.createdAt,
              type: FollowNotificationDataType.receiveFollowRequest,
              id: element.id,
            ),
          );

        case NotificationType.achievementEarned:
          final achievement = element.achievement ?? "";
          resultList.add(
            SimpleNotificationData(
              text:
                  "${localize.achievementEarnedNotification}"
                  "[${achievements[achievement]?.title ?? achievement}]",
              createdAt: element.createdAt,
              id: element.id,
            ),
          );

        case NotificationType.pollVote:
          resultList.add(
            PollNotification(
              note: element.note,
              createdAt: element.createdAt,
              id: element.id,
            ),
          );
        case NotificationType.pollEnded:
          resultList.add(
            PollNotification(
              note: element.note,
              createdAt: element.createdAt,
              id: element.id,
            ),
          );
        case NotificationType.scheduledNotePosted:
          resultList.add(
            ScheduledNoteNotification(
              note: element.note,
              createdAt: element.createdAt,
              id: element.id,
            ),
          );
        case NotificationType.scheduledNotePostFailed:
          resultList.add(
            SimpleNotificationData(
              text: localize.scheduledNotePostFailedNotification,
              createdAt: element.createdAt,
              id: element.id,
            ),
          );
        case NotificationType.test:
          resultList.add(
            SimpleNotificationData(
              text: localize.testNotification,
              createdAt: element.createdAt,
              id: element.id,
            ),
          );

        case NotificationType.note:
          resultList.add(
            NoteNotification(
              note: element.note,
              createdAt: element.createdAt,
              id: element.id,
            ),
          );

        case NotificationType.roleAssigned:
          resultList.add(
            RoleNotification(
              role: element.role,
              createdAt: element.createdAt,
              id: element.id,
            ),
          );
        case NotificationType.app:
          final body = element.body;
          if (body == null || body.isEmpty) {
            // 本文がなければ従来どおり「アプリからの通知」とだけ伝える
            resultList.add(
              SimpleNotificationData(
                text: localize.appNotification,
                createdAt: element.createdAt,
                id: element.id,
              ),
            );
          } else {
            resultList.add(
              AppNotificationData(
                body: body,
                header: element.header,
                icon: element.icon,
                createdAt: element.createdAt,
                id: element.id,
              ),
            );
          }

        case NotificationType.groupInvited:
        case NotificationType.reactionGrouped:
        case NotificationType.renoteGrouped:
          break;
        case NotificationType.exportCompleted:
          resultList.add(
            SimpleNotificationData(
              text: localize.exportCompleted,
              createdAt: element.createdAt,
              id: element.id,
            ),
          );
        case NotificationType.login:
          resultList.add(
            SimpleNotificationData(
              text: localize.someoneLogined,
              createdAt: element.createdAt,
              id: element.id,
            ),
          );
        case NotificationType.createToken:
          resultList.add(
            SimpleNotificationData(
              text: localize.createTokenNotification,
              createdAt: element.createdAt,
              id: element.id,
            ),
          );
        case NotificationType.chatRoomInvitationReceived:
          if (element.invitation != null) {
            resultList.add(
              InvitedChatRoomNotification(
                invitation: element.invitation!,
                createdAt: element.createdAt,
                id: element.id,
              ),
            );
          } else {
            resultList.add(
              SimpleNotificationData(
                text: localize.chatRoomInvitationReceivedNotification,
                createdAt: element.createdAt,
                id: element.id,
              ),
            );
          }

        // case NotificationType.unknown:
        default:
          resultList.add(
            SimpleNotificationData(
              text: localize.unknownNotification,
              createdAt: element.createdAt,
              id: element.id,
            ),
          );
      }
    }

    return resultList;
  }
}
