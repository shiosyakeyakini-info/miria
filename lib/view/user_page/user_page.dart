import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/user_page/user_clips.dart';
import 'package:miria/view/user_page/user_detail.dart';
import 'package:miria/view/user_page/user_misskey_page.dart';
import 'package:miria/view/user_page/user_notes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/user_page/user_plays.dart';
import 'package:miria/view/user_page/user_reactions.dart';
import 'package:misskey_dart/misskey_dart.dart';

class UserInfo {
  final String userId;
  final UsersShowResponse? response;
  final String? remoteUserId;
  final UsersShowResponse? remoteResponse;

  const UserInfo({
    required this.userId,
    required this.response,
    required this.remoteUserId,
    required this.remoteResponse,
  });
}

final userInfoProvider =
    StateProvider.family.autoDispose<UserInfo?, String>((ref, userId) => null);

@RoutePage()
class UserPage extends ConsumerStatefulWidget {
  final String userId;
  final Account account;
  const UserPage({super.key, required this.userId, required this.account});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserPageState();
}

class UserPageState extends ConsumerState<UserPage> {
  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoProvider(widget.userId));
    final isReactionAvailable = userInfo?.response?.publicReactions == true ||
        (userInfo?.response?.host == null &&
            userInfo?.response?.username == widget.account.userId);
    final isRemoteUser =
        userInfo?.response?.host != null && userInfo?.remoteResponse != null;
    return AccountScope(
      account: widget.account,
      child: DefaultTabController(
        length: 5 + (isReactionAvailable ? 1 : 0) + (isRemoteUser ? 2 : 0),
        child: Scaffold(
          appBar: AppBar(
            title: SimpleMfmText(
              userInfo?.response?.name ?? userInfo?.response?.username ?? "",
              emojis: userInfo?.response?.emojis ?? {},
            ),
            actions: const [],
            bottom: TabBar(
              tabs: [
                Tab(
                  text:
                      "アカウント情報${userInfo?.remoteResponse != null ? "（ローカル）" : ""}",
                ),
                if (isRemoteUser) const Tab(text: "アカウント情報（リモート）"),
                Tab(
                  text:
                      "ノート${userInfo?.remoteResponse != null ? "（ローカル）" : ""}",
                ),
                if (isRemoteUser) const Tab(text: "ノート（リモート）"),
                const Tab(text: "クリップ"),
                if (isReactionAvailable) const Tab(text: "リアクション"),
                const Tab(text: "ページ"),
                const Tab(text: "Play"),
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
                      AccountScope(
                        account: Account.demoAccount(userInfo!.response!.host!),
                        child: SingleChildScrollView(
                          child: UserDetail(
                            response: userInfo.remoteResponse!,
                            account:
                                Account.demoAccount(userInfo.response!.host!),
                            controlAccount: widget.account,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: UserNotes(
                        userId: widget.userId,
                      ),
                    ),
                    if (isRemoteUser)
                      AccountScope(
                        account: Account.demoAccount(userInfo!.response!.host!),
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
                      AccountScope(
                        account: Account.demoAccount(userInfo!.response!.host!),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: UserMisskeyPage(
                              userId: userInfo.remoteResponse!.id),
                        ),
                      )
                    else
                      Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: UserMisskeyPage(userId: widget.userId)),

                    // Play
                    if (isRemoteUser)
                      AccountScope(
                        account: Account.demoAccount(userInfo!.response!.host!),
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
      ),
    );
  }
}

class UserDetailTab extends ConsumerStatefulWidget {
  final String userId;

  const UserDetailTab({super.key, required this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserDetailTabState();
}

class UserDetailTabState extends ConsumerState<UserDetailTab> {
  UsersShowResponse? response;
  UsersShowResponse? remoteResponse;
  (Object?, StackTrace)? error;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      try {
        final account = AccountScope.of(context);
        response = await ref
            .read(misskeyProvider(AccountScope.of(context)))
            .users
            .show(UsersShowRequest(userId: widget.userId));
        ref
            .read(notesProvider(account))
            .registerAll(response?.pinnedNotes ?? []);
        ref.read(userInfoProvider(widget.userId).notifier).state = UserInfo(
          userId: widget.userId,
          response: response,
          remoteUserId: null,
          remoteResponse: null,
        );

        final remoteHost = response?.host;
        if (remoteHost != null) {
          final remoteResponse = await ref
              .read(misskeyProvider(Account.demoAccount(remoteHost)))
              .users
              .showByName(
                UsersShowByUserNameRequest(userName: response!.username),
              );

          await ref
              .read(emojiRepositoryProvider(Account.demoAccount(remoteHost)))
              .loadFromSourceIfNeed();

          ref
              .read(notesProvider(Account.demoAccount(remoteHost)))
              .registerAll(remoteResponse.pinnedNotes ?? []);
          ref.read(userInfoProvider(widget.userId).notifier).state = UserInfo(
            userId: widget.userId,
            response: response,
            remoteUserId: remoteResponse.id,
            remoteResponse: remoteResponse,
          );
        }
      } catch (e, s) {
        setState(() {
          error = (e, s);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (response != null) {
      return SingleChildScrollView(
        child: UserDetail(
          response: response!,
          account: AccountScope.of(context),
          controlAccount: null,
        ),
      );
    }
    if (error != null) {
      return ErrorDetail(
        error: error?.$1,
        stackTrace: error?.$2,
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
