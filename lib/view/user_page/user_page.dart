import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/user_page/user_clips.dart';
import 'package:miria/view/user_page/user_detail.dart';
import 'package:miria/view/user_page/user_notes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/user_page/user_reactions.dart';
import 'package:misskey_dart/misskey_dart.dart';

final userInfoProvider = StateProvider.family
    .autoDispose<UsersShowResponse?, String>((ref, userId) => null);

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
    final isReactionAvailable = userInfo?.publicReactions == true ||
        (userInfo?.host == null && userInfo?.username == widget.account.userId);
    return AccountScope(
      account: widget.account,
      child: DefaultTabController(
        length: 3 + (isReactionAvailable ? 1 : 0),
        child: Scaffold(
          appBar: AppBar(
            title: SimpleMfmText(userInfo?.name ?? userInfo?.username ?? ""),
            actions: [],
            bottom: TabBar(
              tabs: [
                const Tab(text: "アカウント情報"),
                const Tab(text: "ノート"),
                const Tab(text: "クリップ"),
                if (isReactionAvailable) const Tab(text: "リアクション")
              ],
              isScrollable: true,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    UserDetailTab(userId: widget.userId),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: UserNotes(userId: widget.userId),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: UserClips(
                          userId: widget.userId,
                        )),
                    if (isReactionAvailable)
                      Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: UserReactions(userId: widget.userId)),
                  ],
                ),
              )
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
  Object? error;

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
        ref.read(userInfoProvider(widget.userId).notifier).state = response;
      } catch (e) {
        setState(() {
          error = e;
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
      ));
    }
    if (error != null) {
      return ErrorDetail(error: error);
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
