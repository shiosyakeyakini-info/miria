import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class ExploreRoleUsersPage extends ConsumerWidget implements AutoRouteWrapper {
  final RolesListResponse item;
  final AccountContext accountContext;

  const ExploreRoleUsersPage({
    required this.item,
    required this.accountContext,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(item.name),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).user),
              Tab(text: S.of(context).timeline),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PushableListView(
              initializeFuture: () async {
                final response = await ref
                    .read(misskeyGetContextProvider)
                    .roles
                    .users(RolesUsersRequest(roleId: item.id));
                return response.toList();
              },
              nextFuture: (lastItem, _) async {
                final response =
                    await ref.read(misskeyGetContextProvider).roles.users(
                          RolesUsersRequest(
                            roleId: item.id,
                            untilId: lastItem.id,
                          ),
                        );
                return response.toList();
              },
              itemBuilder: (context, item) => UserListItem(
                user: item.user,
                isDetail: true,
              ),
            ),
            PushableListView(
              initializeFuture: () async {
                final response = await ref
                    .read(misskeyGetContextProvider)
                    .roles
                    .notes(RolesNotesRequest(roleId: item.id));
                ref.read(notesWithProvider).registerAll(response);
                return response.toList();
              },
              nextFuture: (lastItem, _) async {
                final response =
                    await ref.read(misskeyGetContextProvider).roles.notes(
                          RolesNotesRequest(
                            roleId: item.id,
                            untilId: lastItem.id,
                          ),
                        );
                ref.read(notesWithProvider).registerAll(response);
                return response.toList();
              },
              itemBuilder: (context, note) => MisskeyNote(note: note),
            ),
          ],
        ),
      ),
    );
  }
}
