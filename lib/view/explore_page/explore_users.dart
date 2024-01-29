import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/users_sort_type_extension.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:miria/view/user_page/user_list_item.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExploreUsers extends ConsumerStatefulWidget {
  const ExploreUsers({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ExploreUsersState();
}

enum ExploreUserType {
  pinned,
  local,
  remote,
}

class ExploreUsersState extends ConsumerState<ExploreUsers> {
  final List<User> pinnedUser = [];
  var exploreUserType = ExploreUserType.pinned;
  var sortType = UsersSortType.followerDescendant;
  var isDetailOpen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      final response = await ref
          .read(misskeyProvider(AccountScope.of(context)))
          .pinnedUsers();
      if (!mounted) return;
      setState(() {
        pinnedUser
          ..clear()
          ..addAll(response);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 3),
                      child: LayoutBuilder(
                        builder: (context, constraints) => ToggleButtons(
                            constraints: BoxConstraints.expand(
                                width: constraints.maxWidth / 3 -
                                    Theme.of(context)
                                            .toggleButtonsTheme
                                            .borderWidth!
                                            .toInt() *
                                        3),
                            onPressed: (index) => setState(() {
                                  exploreUserType =
                                      ExploreUserType.values[index];
                                }),
                            isSelected: [
                              for (final element in ExploreUserType.values)
                                element == exploreUserType
                            ],
                            children: [
                              Text(S.of(context).pinnedUser),
                              Text(S.of(context).local),
                              Text(S.of(context).remote),
                            ]),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: exploreUserType == ExploreUserType.pinned
                          ? null
                          : () {
                              setState(() {
                                isDetailOpen = !isDetailOpen;
                              });
                            },
                      icon: Icon(isDetailOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down)),
                ],
              ),
              if (isDetailOpen) ...[
                Row(
                  children: [
                    Expanded(
                        child: Text(S.of(context).sort,
                            textAlign: TextAlign.center)),
                    Expanded(
                      child: DropdownButton<UsersSortType>(
                          items: [
                            for (final sortType in UsersSortType.values)
                              DropdownMenuItem(
                                value: sortType,
                                child: Text(sortType.displayName(context)),
                              ),
                          ],
                          value: sortType,
                          onChanged: (e) {
                            setState(() {
                              sortType = e ?? UsersSortType.followerDescendant;
                            });
                          }),
                    )
                  ],
                ),
              ],
            ],
          ),
          if (exploreUserType == ExploreUserType.pinned)
            Expanded(
              child: ListView.builder(
                itemCount: pinnedUser.length,
                itemBuilder: (context, index) => UserListItem(
                  user: pinnedUser[index],
                  isDetail: true,
                ),
              ),
            )
          else
            Expanded(
              child: PushableListView(
                listKey: Object.hashAll([sortType, exploreUserType]),
                initializeFuture: () async {
                  final response = await ref
                      .read(misskeyProvider(AccountScope.of(context)))
                      .users
                      .users(UsersUsersRequest(
                        sort: sortType,
                        state: UsersState.alive,
                        origin: exploreUserType == ExploreUserType.remote
                            ? Origin.remote
                            : Origin.local,
                      ));
                  return response.toList();
                },
                nextFuture: (_, index) async {
                  final response = await ref
                      .read(misskeyProvider(AccountScope.of(context)))
                      .users
                      .users(UsersUsersRequest(
                        sort: sortType,
                        state: UsersState.alive,
                        offset: index,
                        origin: exploreUserType == ExploreUserType.remote
                            ? Origin.remote
                            : Origin.local,
                      ));
                  return response.toList();
                },
                itemBuilder: (context, user) => UserListItem(
                  user: user,
                  isDetail: true,
                ),
              ),
            )
        ],
      ),
    );
  }
}
