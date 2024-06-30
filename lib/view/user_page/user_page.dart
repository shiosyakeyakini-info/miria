import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/user_page/user_clips.dart";
import "package:miria/view/user_page/user_detail.dart";
import "package:miria/view/user_page/user_info_notifier.dart";
import "package:miria/view/user_page/user_misskey_page.dart";
import "package:miria/view/user_page/user_notes.dart";
import "package:miria/view/user_page/user_plays.dart";
import "package:miria/view/user_page/user_reactions.dart";

@RoutePage()
class UserPage extends ConsumerStatefulWidget implements AutoRouteWrapper {
  final String userId;
  final Account account;
  const UserPage({required this.userId, required this.account, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserPageState();

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);
}

class UserPageState extends ConsumerState<UserPage> {
  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(
      userInfoNotifierProvider(widget.userId)
          .select((value) => value.valueOrNull),
    );
    final isReactionAvailable = userInfo?.response.publicReactions == true ||
        (userInfo?.response.host == null &&
            userInfo?.response.username == widget.account.userId);
    final isRemoteUser =
        userInfo?.response.host != null && userInfo?.remoteResponse != null;

    return DefaultTabController(
      length: 5 + (isReactionAvailable ? 1 : 0) + (isRemoteUser ? 2 : 0),
      child: Scaffold(
        appBar: AppBar(
          title: SimpleMfmText(
            userInfo?.response.name ?? userInfo?.response.username ?? "",
            emojis: userInfo?.response.emojis ?? {},
          ),
          actions: const [],
          bottom: TabBar(
            tabs: [
              if (!isRemoteUser) ...[
                Tab(text: S.of(context).userInfomation),
                Tab(text: S.of(context).userNotes),
              ] else ...[
                Tab(text: S.of(context).userInfomationLocal),
                Tab(text: S.of(context).userInfomationRemote),
                Tab(text: S.of(context).userNotesLocal),
                Tab(text: S.of(context).userNotesRemote),
              ],
              Tab(text: S.of(context).clip),
              if (isReactionAvailable) Tab(text: S.of(context).userReactions),
              Tab(text: S.of(context).userPages),
              Tab(text: S.of(context).userPlays),
            ],
            isScrollable: true,
            tabAlignment: TabAlignment.center,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  UserDetailTab(userId: widget.userId),
                  if (isRemoteUser)
                    AccountContextScope(
                      context: AccountContext(
                        getAccount: Account.demoAccount(
                          userInfo!.response.host!,
                          userInfo.metaResponse,
                        ),
                        postAccount:
                            ref.read(accountContextProvider).postAccount,
                      ),
                      child: UserDetail(response: userInfo.remoteResponse!),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: UserNotes(
                      userId: widget.userId,
                    ),
                  ),
                  if (isRemoteUser)
                    AccountContextScope(
                      context: AccountContext(
                        getAccount: Account.demoAccount(
                          userInfo!.response.host!,
                          userInfo.metaResponse,
                        ),
                        postAccount:
                            ref.read(accountContextProvider).postAccount,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: UserNotes(
                          userId: widget.userId,
                          remoteUserId: userInfo.remoteResponse!.id,
                          actualAccount: widget.account,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: UserClips(
                      userId: widget.userId,
                    ),
                  ),
                  if (isReactionAvailable)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: UserReactions(userId: widget.userId),
                    ),

                  // ページ
                  if (isRemoteUser)
                    AccountContextScope(
                      context: AccountContext(
                        getAccount: Account.demoAccount(
                          userInfo!.response.host!,
                          userInfo.metaResponse,
                        ),
                        postAccount:
                            ref.read(accountContextProvider).postAccount,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: UserMisskeyPage(
                          userId: userInfo.remoteResponse!.id,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: UserMisskeyPage(userId: widget.userId),
                    ),

                  // Play
                  if (isRemoteUser)
                    AccountContextScope(
                      context: AccountContext(
                        getAccount: Account.demoAccount(
                          userInfo!.response.host!,
                          userInfo.metaResponse,
                        ),
                        postAccount:
                            ref.read(accountContextProvider).postAccount,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: UserPlays(userId: userInfo.remoteResponse!.id),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: UserPlays(userId: widget.userId),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailTab extends ConsumerWidget {
  final String userId;

  const UserDetailTab({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetail = ref.watch(userInfoNotifierProvider(userId));

    return switch (userDetail) {
      AsyncLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
      AsyncError(:final error, :final stackTrace) => ErrorDetail(
          error: error,
          stackTrace: stackTrace,
        ),
      AsyncData(:final value) => UserDetail(
          response: value.response,
        )
    };
  }
}
