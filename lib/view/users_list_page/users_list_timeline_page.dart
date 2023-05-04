import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/users_list_page/users_list_timeline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class UsersListTimelinePage extends ConsumerWidget {
  final Account account;
  final String listId;

  const UsersListTimelinePage(this.account, this.listId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: AccountScope(
          account: account,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: UsersListTimeline(listId: listId),
          )),
    );
  }
}
