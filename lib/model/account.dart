import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miria/model/acct.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@Freezed(equal: false)
class Account with _$Account {
  const Account._();

  const factory Account({
    required String host,
    required String userId,
    String? token,
    required MeDetailed i,
    MetaResponse? meta,
  }) = _Account;

  factory Account.fromJson(Map<String, Object?> json) =>
      _$AccountFromJson(json);

  @override
  bool operator ==(Object other) {
    return other is Account &&
        other.runtimeType == runtimeType &&
        other.host == host &&
        other.userId == userId;
  }

  @override
  int get hashCode => Object.hash(runtimeType, host, userId);

  Acct get acct {
    return Acct(
      host: host,
      username: userId,
    );
  }

  factory Account.demoAccount(String host, MetaResponse? meta) => Account(
      host: host,
      userId: "",
      token: null,
      meta: meta,
      i: MeDetailed(
          id: "",
          username: "",
          createdAt: DateTime.now(),
          avatarUrl: Uri.parse("https://example.com/"),
          isBot: false,
          isCat: false,
          badgeRoles: [],
          isLocked: false,
          isSuspended: false,
          isSilenced: false,
          followingCount: 0,
          followersCount: 0,
          notesCount: 0,
          publicReactions: false,
          twoFactorEnabled: false,
          usePasswordLessLogin: false,
          securityKeys: false,
          isModerator: false,
          isAdmin: false,
          injectFeaturedNote: false,
          receiveAnnouncementEmail: false,
          alwaysMarkNsfw: false,
          autoSensitive: false,
          carefulBot: false,
          autoAcceptFollowed: false,
          noCrawle: false,
          isExplorable: false,
          isDeleted: false,
          hideOnlineStatus: false,
          hasUnreadAnnouncement: false,
          hasPendingReceivedFollowRequest: false,
          hasUnreadAntenna: false,
          hasUnreadChannel: false,
          hasUnreadMentions: false,
          hasUnreadNotification: false,
          hasUnreadSpecifiedNotes: false,
          mutedWords: [],
          mutedInstances: [],
          mutingNotificationTypes: [],
          emailNotificationTypes: [],
          achievements: [],
          loggedInDays: 0,
          policies: const UserPolicies(
              gtlAvailable: false,
              ltlAvailable: false,
              canPublicNote: false,
              canInvite: false,
              canManageCustomEmojis: false,
              canHideAds: false,
              driveCapacityMb: 0,
              pinLimit: 0,
              antennaLimit: 0,
              wordMuteLimit: 0,
              webhookLimit: 0,
              clipLimit: 0,
              noteEachClipsLimit: 0,
              userListLimit: 0,
              userEachUserListsLimit: 0,
              rateLimitFactor: 0)));
}
