import 'package:misskey_dart/misskey_dart.dart';

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

enum MentionQuoteNotificationDataType {
  mention(name: "メンション"),
  quote(name: "引用リノート"),
  reply(name: "");

  final String name;
  const MentionQuoteNotificationDataType({required this.name});
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

enum FollowNotificationDataType {
  follow("フォローされたで"),
  followRequestAccepted("フォローしてもええでってなったで"),
  receiveFollowRequest("フォローさせてほしそうにしてるで");

  final String name;
  const FollowNotificationDataType(this.name);
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

class RoleNotification extends NotificationData {
  final RolesListResponse? role;
  RoleNotification({
    required this.role,
    required super.createdAt,
    required super.id,
  });
}

extension INotificationsResponseExtension on Iterable<INotificationsResponse> {
  List<NotificationData> toNotificationData() {
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
            resultList.add(RenoteReactionNotificationData(
                note: element.note,
                reactionUsers: [(element.reaction, element.user)],
                renoteUsers: [],
                createdAt: element.createdAt,
                id: element.id));
          }

          break;
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
            resultList.add(RenoteReactionNotificationData(
                note: element.note?.renote,
                reactionUsers: [],
                renoteUsers: [element.user],
                createdAt: element.createdAt,
                id: element.id));
          }

          break;

        case NotificationType.quote:
          resultList.add(MentionQuoteNotificationData(
              createdAt: element.createdAt,
              note: element.note,
              user: element.user,
              type: MentionQuoteNotificationDataType.quote,
              id: element.id));

          break;
        case NotificationType.mention:
          resultList.add(MentionQuoteNotificationData(
              createdAt: element.createdAt,
              note: element.note,
              user: element.user,
              type: MentionQuoteNotificationDataType.mention,
              id: element.id));

          break;
        case NotificationType.reply:
          resultList.add(MentionQuoteNotificationData(
              createdAt: element.createdAt,
              note: element.note,
              user: element.user,
              type: MentionQuoteNotificationDataType.reply,
              id: element.id));
          break;

        case NotificationType.follow:
          resultList.add(FollowNotificationData(
              user: element.user,
              createdAt: element.createdAt,
              type: FollowNotificationDataType.follow,
              id: element.id));

          break;
        case NotificationType.followRequestAccepted:
          resultList.add(FollowNotificationData(
              user: element.user,
              createdAt: element.createdAt,
              type: FollowNotificationDataType.followRequestAccepted,
              id: element.id));
          break;
        case NotificationType.receiveFollowRequest:
          resultList.add(FollowNotificationData(
              user: element.user,
              createdAt: element.createdAt,
              type: FollowNotificationDataType.receiveFollowRequest,
              id: element.id));
          break;

        case NotificationType.achievementEarned:
          resultList.add(SimpleNotificationData(
              text: "実績を解除しました。[${element.achievement}]",
              createdAt: element.createdAt,
              id: element.id));
          break;

        case NotificationType.pollVote:
          resultList.add(PollNotification(
              note: element.note,
              createdAt: element.createdAt,
              id: element.id));
          break;
        case NotificationType.pollEnded:
          resultList.add(PollNotification(
              note: element.note,
              createdAt: element.createdAt,
              id: element.id));
          break;
        case NotificationType.test:
          resultList.add(SimpleNotificationData(
              text: "テストやで", createdAt: element.createdAt, id: element.id));
          break;

        case NotificationType.note:
          resultList.add(NoteNotification(
              note: element.note,
              createdAt: element.createdAt,
              id: element.id));
          break;

        case NotificationType.roleAssigned:
          resultList.add(RoleNotification(
              role: element.role,
              createdAt: element.createdAt,
              id: element.id));
          break;

        default:
          break;
      }
    }

    return resultList;
  }
}
