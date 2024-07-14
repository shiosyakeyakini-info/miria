import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/origin_extension.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:miria/view/user_page/user_list_item.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage<User>()
class UserSelectDialog extends StatelessWidget implements AutoRouteWrapper {
  final AccountContext accountContext;

  const UserSelectDialog({required this.accountContext, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: UserSelectContent(
          onSelected: (item) async => context.maybePop(item),
        ),
      ),
    );
  }
}

class UserSelectContent extends HookConsumerWidget {
  final void Function(User) onSelected;
  final FocusNode? focusNode;
  final bool isDetail;

  const UserSelectContent({
    required this.onSelected,
    super.key,
    this.focusNode,
    this.isDetail = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryController = useTextEditingController();
    final origin = useState(Origin.combined);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextField(
          controller: queryController,
          focusNode: focusNode,
          autofocus: true,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        LayoutBuilder(
          builder: (context, constraints) {
            return ToggleButtons(
              isSelected: [
                for (final element in Origin.values) element == origin.value,
              ],
              constraints: BoxConstraints.expand(
                width: constraints.maxWidth / Origin.values.length -
                    Theme.of(context).toggleButtonsTheme.borderWidth!.toInt() *
                        Origin.values.length,
              ),
              onPressed: (index) => origin.value = Origin.values[index],
              children: [
                for (final element in Origin.values)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(element.displayName(context)),
                  ),
              ],
            );
          },
        ),
        Expanded(
          child: UsersSelectContentList(
            onSelected: onSelected,
            isDetail: isDetail,
            query: queryController.text,
            origin: origin.value,
          ),
        ),
      ],
    );
  }
}

class UsersSelectContentList extends ConsumerWidget {
  const UsersSelectContentList({
    required this.onSelected,
    required this.isDetail,
    required this.query,
    required this.origin,
    super.key,
  });
  final void Function(User) onSelected;
  final bool isDetail;
  final String query;
  final Origin origin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView(
      listKey: ObjectKey(Object.hashAll([query, origin])),
      initializeFuture: () async {
        if (query.isEmpty) {
          final response = await ref
              .read(misskeyGetContextProvider)
              .users
              .getFrequentlyRepliedUsers(
                UsersGetFrequentlyRepliedUsersRequest(
                  userId: ref.read(accountContextProvider).getAccount.i.id,
                ),
              );
          return response.map((e) => e.user).toList();
        }

        final response = await ref
            .read(misskeyGetContextProvider)
            .users
            .search(UsersSearchRequest(query: query, origin: origin));
        return response.toList();
      },
      nextFuture: (lastItem, length) async {
        if (query.isEmpty) return [];

        final response = await ref.read(misskeyGetContextProvider).users.search(
              UsersSearchRequest(
                query: query,
                origin: origin,
                offset: length,
              ),
            );
        return response.toList();
      },
      itemBuilder: (context2, item) => UserListItem(
        user: item,
        isDetail: isDetail,
        onTap: () => onSelected.call(item),
      ),
    );
  }
}
