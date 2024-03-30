import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/users_list_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/users_list_page/users_list_settings_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class UsersListPage extends ConsumerWidget {
  final Account account;

  const UsersListPage(this.account, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final list = ref.watch(usersListsNotifierProvider(misskey));

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).list),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final settings = await showDialog<UsersListSettings>(
                context: context,
                builder: (context) => UsersListSettingsDialog(
                  title: Text(S.of(context).create),
                ),
              );
              if (!context.mounted) return;
              if (settings != null) {
                ref
                    .read(usersListsNotifierProvider(misskey).notifier)
                    .create(settings)
                    .expectFailure(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: list.when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final list = data[index];
                return ListTile(
                  title: Text(list.name ?? ""),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final result = await SimpleConfirmDialog.show(
                        context: context,
                        message: S.of(context).confirmDeleteList,
                        primary: S.of(context).doDeleting,
                        secondary: S.of(context).cancel,
                      );
                      if (!context.mounted) return;
                      if (result ?? false) {
                        await ref
                            .read(
                              usersListsNotifierProvider(misskey).notifier,
                            )
                            .delete(list.id)
                            .expectFailure(context);
                      }
                    },
                  ),
                  onTap: () => context.pushRoute(
                    UsersListTimelineRoute(
                      account: account,
                      list: list,
                    ),
                  ),
                );
              },
            );
          },
          error: (e, st) =>
              Center(child: ErrorDetail(error: e, stackTrace: st)),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
