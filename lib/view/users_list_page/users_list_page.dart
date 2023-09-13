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
import 'package:misskey_dart/misskey_dart.dart';

final _usersListListNotifierProvider = AutoDisposeAsyncNotifierProviderFamily<
    _UsersListListNotifier,
    List<UsersList>,
    Misskey>(_UsersListListNotifier.new);

class _UsersListListNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<UsersList>, Misskey> {
  @override
  Future<List<UsersList>> build(Misskey arg) async {
    final response = await _misskey.users.list.list();
    return response.toList();
  }

  Misskey get _misskey => arg;

  Future<void> create(UsersListSettings settings) async {
    final list = await _misskey.users.list.create(
      UsersListsCreateRequest(
        name: settings.name,
      ),
    );
    if (settings.isPublic) {
      await _misskey.users.list.update(
        UsersListsUpdateRequest(
          listId: list.id,
          isPublic: settings.isPublic,
        ),
      );
    }
    state = AsyncValue.data([...?state.valueOrNull, list]);
  }

  Future<void> delete(String listId) async {
    await _misskey.users.list.delete(UsersListsDeleteRequest(listId: listId));
    state = AsyncValue.data(
      state.valueOrNull?.where((e) => e.id != listId).toList() ?? [],
    );
  }
}

@RoutePage()
class UsersListPage extends ConsumerWidget {
  final Account account;

  const UsersListPage(this.account, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final list = ref.watch(_usersListListNotifierProvider(misskey));

    return Scaffold(
      appBar: AppBar(
        title: const Text("リスト"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final settings = await showDialog<UsersListSettings>(
                context: context,
                builder: (context) => const UsersListSettingsDialog(
                  title: Text("作成"),
                ),
              );
              if (!context.mounted) return;
              if (settings != null) {
                ref
                    .read(_usersListListNotifierProvider(misskey).notifier)
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
                        message: "このリストを削除しますか？",
                        primary: "削除する",
                        secondary: "やめる",
                      );
                      if (!context.mounted) return;
                      if (result ?? false) {
                        await ref
                            .read(
                              _usersListListNotifierProvider(misskey).notifier,
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
