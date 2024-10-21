import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/users_sort_type_extension.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "explore_users.g.dart";

@Riverpod(dependencies: [misskeyGetContext])
Future<List<UserDetailed>> _pinnedUser(_PinnedUserRef ref) async {
  return (await ref.read(misskeyGetContextProvider).pinnedUsers()).toList();
}

enum ExploreUserType {
  pinned,
  local,
  remote,
}

class ExploreUsers extends HookConsumerWidget {
  const ExploreUsers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exploreUserType = useState(ExploreUserType.pinned);
    final sortType = useState(UsersSortType.followerDescendant);
    final isDetailOpen = useState(false);
    final pinnedUser = ref.watch(_pinnedUserProvider);

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
                                    3,
                          ),
                          onPressed: (index) => exploreUserType.value =
                              ExploreUserType.values[index],
                          isSelected: [
                            for (final element in ExploreUserType.values)
                              element == exploreUserType.value,
                          ],
                          children: [
                            Text(S.of(context).pinnedUser),
                            Text(S.of(context).local),
                            Text(S.of(context).remote),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: exploreUserType == ExploreUserType.pinned
                        ? null
                        : () => isDetailOpen.value = !isDetailOpen.value,
                    icon: Icon(
                      isDetailOpen.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ),
                ],
              ),
              if (isDetailOpen.value) ...[
                Row(
                  children: [
                    Expanded(
                      child:
                          Text(S.of(context).sort, textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: DropdownButton<UsersSortType>(
                        items: [
                          for (final sortType in UsersSortType.values)
                            DropdownMenuItem(
                              value: sortType,
                              child: Text(sortType.displayName(context)),
                            ),
                        ],
                        value: sortType.value,
                        onChanged: (e) => sortType.value =
                            e ?? UsersSortType.followerDescendant,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          if (exploreUserType.value == ExploreUserType.pinned)
            switch (pinnedUser) {
              AsyncLoading() =>
                const Center(child: CircularProgressIndicator.adaptive()),
              AsyncError(:final error, :final stackTrace) =>
                ErrorDetail(error: error, stackTrace: stackTrace),
              AsyncData(:final value) => Expanded(
                  child: ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) => UserListItem(
                      user: value[index],
                      isDetail: true,
                    ),
                  ),
                )
            }
          else
            Expanded(
              child: PushableListView(
                listKey: Object.hashAll([sortType, exploreUserType]),
                initializeFuture: () async {
                  final response =
                      await ref.read(misskeyGetContextProvider).users.users(
                            UsersUsersRequest(
                              sort: sortType.value,
                              state: UsersState.alive,
                              origin: exploreUserType.value ==
                                      ExploreUserType.remote
                                  ? Origin.remote
                                  : Origin.local,
                            ),
                          );
                  return response.toList();
                },
                nextFuture: (_, index) async {
                  final response =
                      await ref.read(misskeyGetContextProvider).users.users(
                            UsersUsersRequest(
                              sort: sortType.value,
                              state: UsersState.alive,
                              offset: index,
                              origin: exploreUserType.value ==
                                      ExploreUserType.remote
                                  ? Origin.remote
                                  : Origin.local,
                            ),
                          );
                  return response.toList();
                },
                itemBuilder: (context, user) => UserListItem(
                  user: user,
                  isDetail: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
