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
import 'package:misskey_dart/misskey_dart.dart';

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [],
        ),
        body: AccountScope(
          account: widget.account,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: "アカウント情報"),
                  Tab(text: "ノート"),
                  Tab(text: "クリップ")
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
                        ))
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
