import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:misskey_dart/misskey_dart.dart';

import '../../model/account.dart';

class FederationTimeline extends ConsumerStatefulWidget {
  final String host;

  const FederationTimeline({super.key, required this.host});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FederationTimelineState();
}

class FederationTimelineState extends ConsumerState<FederationTimeline> {
  @override
  Widget build(BuildContext context) {
    //TODO: どうにかする
    final demoAccount = Account(
        host: widget.host,
        userId: "",
        token: null,
        i: IResponse(
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
            ffVisibility: "",
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

    return AccountScope(
      account: demoAccount,
      child: PushableListView(
          initializeFuture: () async {
            await ref
                .read(emojiRepositoryProvider(demoAccount))
                .loadFromSource();
            final result = await ref
                .read(misskeyProvider(demoAccount))
                .notes
                .localTimeline(const NotesLocalTimelineRequest());
            ref.read(notesProvider(demoAccount)).registerAll(result);
            return result.toList();
          },
          nextFuture: (lastItem, _) async {
            final result = await ref
                .read(misskeyProvider(demoAccount))
                .notes
                .localTimeline(NotesLocalTimelineRequest(untilId: lastItem.id));
            ref.read(notesProvider(demoAccount)).registerAll(result);
            return result.toList();
          },
          itemBuilder: (context2, item) => Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: MisskeyNote(
                note: item,
                loginAs: AccountScope.of(context),
              ))),
    );
  }
}
