import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/user_extension.dart";
import "package:miria/model/account.dart";
import "package:miria/model/antenna_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "antenna_settings_dialog.g.dart";

@Riverpod(dependencies: [])
AntennaSettings _initialSettings(_InitialSettingsRef ref) =>
    throw UnimplementedError();

@Riverpod(dependencies: [_initialSettings])
class _AntennaSettingsNotifier extends _$AntennaSettingsNotifier {
  @override
  AntennaSettings build() {
    return ref.watch(_initialSettingsProvider);
  }

  void updateName(String? name) {
    if (name != null) {
      state = state.copyWith(name: name);
    }
  }

  void updateSrc(AntennaSource? src) {
    if (src != null) {
      state = state.copyWith(src: src);
    }
  }

  void updateUserList(UsersList? list) {
    if (list != null) {
      state = state.copyWith(userListId: list.id);
    }
  }

  void updateUsers(String? users) {
    if (users != null) {
      state = state.copyWith(users: users.trim().split("\n"));
    }
  }

  void updateKeywords(String? keywords) {
    if (keywords != null) {
      state = state.copyWith(
        keywords: keywords.trim().split("\n").map((e) => e.split(" ")).toList(),
      );
    }
  }

  void updateExcludeKeywords(String? excludeKeywords) {
    if (excludeKeywords != null) {
      state = state.copyWith(
        excludeKeywords: excludeKeywords
            .trim()
            .split("\n")
            .map((e) => e.split(" "))
            .toList(),
      );
    }
  }

  void updateCaseSensitive(bool? caseSensitive) {
    if (caseSensitive != null) {
      state = state.copyWith(caseSensitive: caseSensitive);
    }
  }

  void updateWithReplies(bool? withReplies) {
    if (withReplies != null) {
      state = state.copyWith(withReplies: withReplies);
    }
  }

  void updateWithFile(bool? withFile) {
    if (withFile != null) {
      state = state.copyWith(withFile: withFile);
    }
  }

  void updateLocalOnly(bool? localOnly) {
    if (localOnly != null) {
      state = state.copyWith(localOnly: localOnly);
    }
  }
}

@Riverpod(dependencies: [misskeyGetContext])
Future<List<UsersList>> _usersListList(_UsersListListRef ref) async =>
    [...await ref.read(misskeyGetContextProvider).users.list.list()];

@RoutePage<AntennaSettings>()
class AntennaSettingsDialog extends StatelessWidget {
  const AntennaSettingsDialog({
    required this.account,
    super.key,
    this.title,
    this.initialSettings = const AntennaSettings(),
  });

  final Widget? title;
  final AntennaSettings initialSettings;
  final Account account;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      scrollable: true,
      content: ProviderScope(
        overrides: [
          _initialSettingsProvider.overrideWithValue(initialSettings),
        ],
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: AntennaSettingsForm(
            account: account,
          ),
        ),
      ),
    );
  }
}

class AntennaSettingsForm extends HookConsumerWidget {
  const AntennaSettingsForm({
    required this.account,
    super.key,
  });

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useState(GlobalKey<FormState>());
    final initialSettings = ref.watch(_initialSettingsProvider);
    final settings = ref.watch(_antennaSettingsNotifierProvider);
    final list = ref.watch(_usersListListProvider);
    final controller = useTextEditingController();
    ref.listen(
      _initialSettingsProvider.select((settings) => settings.users.join("\n")),
      (_, next) => controller.text = next,
    );

    return Form(
      key: formKey.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: initialSettings.name,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: S.of(context).antennaName,
              contentPadding: const EdgeInsets.fromLTRB(12, 24, 12, 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseInput;
              }
              return null;
            },
            onSaved:
                ref.read(_antennaSettingsNotifierProvider.notifier).updateName,
          ),
          const SizedBox(height: 10),
          Text(S.of(context).antennaSource),
          const SizedBox(height: 5),
          DropdownButtonFormField<AntennaSource>(
            items: AntennaSource.values
                .map(
                  (e) => DropdownMenuItem<AntennaSource>(
                    value: e,
                    child: Text(
                      switch (e) {
                        AntennaSource.home => S.of(context).antennaSourceHome,
                        AntennaSource.all => S.of(context).antennaSourceAll,
                        AntennaSource.users => S.of(context).antennaSourceUser,
                        AntennaSource.usersBlackList => "指定したユーザー以外",
                        AntennaSource.list => S.of(context).antennaSourceList,
                      },
                    ),
                  ),
                )
                .toList(),
            value: settings.src,
            hint: Text(S.of(context).selectAntennaSource),
            onChanged:
                ref.read(_antennaSettingsNotifierProvider.notifier).updateSrc,
          ),
          const SizedBox(height: 10),
          if (settings.src == AntennaSource.list)
            DropdownButtonFormField<UsersList>(
              items: list.valueOrNull
                  ?.map(
                    (list) => DropdownMenuItem(
                      value: list,
                      child: Text(list.name ?? ""),
                    ),
                  )
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return S.of(context).pleaseInput;
                }
                return null;
              },
              value: list.valueOrNull
                  ?.firstWhereOrNull((e) => e.id == settings.userListId),
              hint: Text(S.of(context).selectList),
              onChanged: ref
                  .read(_antennaSettingsNotifierProvider.notifier)
                  .updateUserList,
            ),
          if (settings.src == AntennaSource.users ||
              settings.src == AntennaSource.usersBlackList) ...[
            TextFormField(
              controller: controller,
              minLines: 2,
              maxLines: 20,
              decoration: InputDecoration(
                labelText: S.of(context).user,
                hintText: S.of(context).antennaSourceUserHintText,
                contentPadding: const EdgeInsets.fromLTRB(12, 24, 12, 16),
              ),
              onSaved: ref
                  .read(_antennaSettingsNotifierProvider.notifier)
                  .updateUsers,
            ),
            TextButton(
              onPressed: () async {
                final user = await context.pushRoute<User>(
                  UserSelectRoute(
                    accountContext: AccountContext.as(account),
                  ),
                );
                if (user == null) return;

                if (!context.mounted) return;
                if (!controller.text.endsWith("\n") &&
                    controller.text.isNotEmpty) {
                  controller.text += "\n";
                }
                controller.text += "${user.acct}\n";
              },
              child: Text(S.of(context).addUser),
            ),
          ],
          const SizedBox(height: 10),
          TextFormField(
            initialValue:
                initialSettings.keywords.map((e) => e.join(" ")).join("\n"),
            minLines: 2,
            maxLines: 20,
            decoration: InputDecoration(
              labelText: S.of(context).keywords,
              helperText: S.of(context).antennaSourceKeywordsHintText,
              helperMaxLines: 5,
              contentPadding: const EdgeInsets.fromLTRB(12, 24, 12, 16),
            ),
            // Misskey 2023.9.0 で条件が変更されるためバリデーションを行わない
            // https://github.com/misskey-dev/misskey/pull/11469
            onSaved: ref
                .read(_antennaSettingsNotifierProvider.notifier)
                .updateKeywords,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: initialSettings.excludeKeywords
                .map((e) => e.join(" "))
                .join("\n"),
            minLines: 2,
            maxLines: 20,
            decoration: InputDecoration(
              labelText: S.of(context).excludeKeywords,
              helperText: S.of(context).antennaSourceExcludeKeywordsHintText,
              helperMaxLines: 5,
              contentPadding: const EdgeInsets.fromLTRB(12, 24, 12, 16),
            ),
            onSaved: ref
                .read(_antennaSettingsNotifierProvider.notifier)
                .updateExcludeKeywords,
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
            title: Text(S.of(context).discriminateUpperLower),
            value: settings.caseSensitive,
            onChanged: ref
                .read(_antennaSettingsNotifierProvider.notifier)
                .updateCaseSensitive,
          ),
          CheckboxListTile(
            title: Text(S.of(context).receiveReplies),
            value: settings.withReplies,
            onChanged: ref
                .read(_antennaSettingsNotifierProvider.notifier)
                .updateWithReplies,
          ),
          CheckboxListTile(
            title: Text(S.of(context).receiveOnlyFiles),
            value: settings.withFile,
            onChanged: ref
                .read(_antennaSettingsNotifierProvider.notifier)
                .updateWithFile,
          ),
          CheckboxListTile(
            title: Text(S.of(context).receiveLocal),
            subtitle: Text(S.of(context).receiveLocalAvailability),
            value: settings.localOnly,
            onChanged: ref
                .read(_antennaSettingsNotifierProvider.notifier)
                .updateLocalOnly,
          ),

          // notifyは機能していない?
          Center(
            child: ElevatedButton(
              child: Text(S.of(context).done),
              onPressed: () {
                if (formKey.value.currentState!.validate()) {
                  formKey.value.currentState!.save();
                  final settings = ref.read(_antennaSettingsNotifierProvider);
                  if (settings == initialSettings) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop(settings);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
