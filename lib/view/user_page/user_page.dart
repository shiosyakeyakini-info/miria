import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
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
    return DefaultTabController(
      length: 3 + (isReactionAvailable ? 1 : 0),
      child: Scaffold(
        appBar: AppBar(
          actions: [],
        ),
        body: AccountScope(
          account: widget.account,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  const Tab(text: "アカウント情報"),
                  const Tab(text: "ノート"),
                  const Tab(text: "クリップ"),
                  if (isReactionAvailable) const Tab(text: "リアクション")
                ],
                isScrollable: true,
              ),
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

class UserDetailTab extends ConsumerWidget {
  final String userId;

  const UserDetailTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref
          .read(misskeyProvider(AccountScope.of(context)))
          .users
          .show(UsersShowRequest(userId: userId)),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data != null) {
          Future(() async {
            ref
                .read(notesProvider(AccountScope.of(context)))
                .registerAll(data.pinnedNotes ?? []);
            ref.read(userInfoProvider(userId).notifier).state = data;
          });
          return SingleChildScrollView(
              child: UserDetail(
            response: data,
            account: AccountScope.of(context),
          ));
        }
        if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error);
            print(snapshot.stackTrace);
          }
          return const Center(
            child: Text("えらー"),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
