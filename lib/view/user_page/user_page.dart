import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/user_page/user_clips.dart';
import 'package:miria/view/user_page/user_control_dialog.dart';
import 'package:miria/view/user_page/user_detail.dart';
import 'package:miria/view/user_page/user_misskey_page.dart';
import 'package:miria/view/user_page/user_notes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/user_page/user_plays.dart';
import 'package:miria/view/user_page/user_reactions.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class UserPage extends ConsumerWidget {
  final User user;
  final Account account;
  const UserPage({
    super.key,
    required this.user,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetailed =
        ref.watch(userDetailedNotifierProvider((account, user.id)));
    final isReactionAvailable =
        (user.host == null && user.username == account.userId) ||
            (userDetailed.value?.publicReactions ?? false);
    final isRemoteUser = user.host != null;
    return AccountScope(
      account: account,
      child: DefaultTabController(
        length: 2 + (isReactionAvailable ? 1 : 0) + (isRemoteUser ? 0 : 3),
        child: Scaffold(
          appBar: AppBar(
            title: SimpleMfmText(
              user.name ?? user.username,
              emojis: user.emojis,
            ),
            actions: [
              IconButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  builder: (context) => UserControlDialog(
                    account: account,
                    userId: user.id,
                  ),
                ),
                icon: const Icon(Icons.more_vert),
              ),
            ],
            bottom: TabBar(
              tabs: [
                const Tab(text: "アカウント情報"),
                const Tab(text: "ノート"),
                if (!isRemoteUser) const Tab(text: "クリップ"),
                if (isReactionAvailable) const Tab(text: "リアクション"),
                if (!isRemoteUser) const Tab(text: "ページ"),
                if (!isRemoteUser) const Tab(text: "Play"),
              ],
              isScrollable: true,
              tabAlignment: TabAlignment.center,
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: UserDetail(userId: user.id),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: UserNotes(userId: user.id),
              ),
              if (!isRemoteUser)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: UserClips(userId: user.id),
                ),
              if (isReactionAvailable)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: UserReactions(userId: user.id),
                ),
              // ページ
              if (!isRemoteUser)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: UserMisskeyPage(userId: user.id),
                ),
              // Play
              if (!isRemoteUser)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: UserPlays(userId: user.id),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
