import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/users_list_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/users_list_page/users_list_settings_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UsersListModalSheet extends ConsumerWidget {
  const UsersListModalSheet({
    super.key,
    required this.account,
    required this.user,
  });

  final Account account;
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final lists = ref.watch(usersListsNotifierProvider(misskey));

    return lists.when(
      data: (lists) {
        return ListView.builder(
          itemCount: lists.length + 1,
          itemBuilder: (context, index) {
            if (index < lists.length) {
              final list = lists[index];
              return CheckboxListTile(
                value: list.userIds.contains(user.id),
                onChanged: (value) async {
                  if (value == null) {
                    return;
                  }
                  if (value) {
                    await ref
                        .read(usersListsNotifierProvider(misskey).notifier)
                        .push(list.id, user)
                        .expectFailure(context);
                  } else {
                    await ref
                        .read(usersListsNotifierProvider(misskey).notifier)
                        .pull(list.id, user)
                        .expectFailure(context);
                  }
                },
                title: Text(list.name ?? ""),
              );
            } else {
              return ListTile(
                leading: const Icon(Icons.add),
                title: Text(S.of(context).createList),
                onTap: () async {
                  final settings = await showDialog<UsersListSettings>(
                    context: context,
                    builder: (context) => UsersListSettingsDialog(
                      title: Text(S.of(context).create),
                    ),
                  );
                  if (!context.mounted) return;
                  if (settings != null) {
                    await ref
                        .read(usersListsNotifierProvider(misskey).notifier)
                        .create(settings)
                        .expectFailure(context);
                  }
                },
              );
            }
          },
        );
      },
      error: (e, st) => Center(child: ErrorDetail(error: e, stackTrace: st)),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
