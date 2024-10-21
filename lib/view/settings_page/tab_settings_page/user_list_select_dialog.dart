import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "user_list_select_dialog.g.dart";

@Riverpod(dependencies: [misskeyGetContext])
Future<List<UsersList>> _usersList(_UsersListRef ref) async =>
    (await ref.read(misskeyGetContextProvider).users.list.list()).toList();

@RoutePage<UsersList>()
class UserListSelectDialog extends ConsumerWidget implements AutoRouteWrapper {
  final Account account;

  const UserListSelectDialog({required this.account, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersList = ref.watch(_usersListProvider);

    return AlertDialog(
      title: Text(S.of(context).selectList),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        child: SingleChildScrollView(
          child: switch (usersList) {
            AsyncLoading() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            AsyncError(:final error, :final stackTrace) =>
              ErrorDetail(error: error, stackTrace: stackTrace),
            AsyncData(:final value) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).list,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).pop(value[index]);
                        },
                        title: Text(value[index].name ?? ""),
                      );
                    },
                  ),
                ],
              ),
          },
        ),
      ),
    );
  }
}
