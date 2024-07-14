import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/users_lists_show_response_extension.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/model/account.dart";
import "package:miria/model/tab_icon.dart";
import "package:miria/model/tab_setting.dart";
import "package:miria/model/tab_type.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/tab_icon_view.dart";
import "package:miria/view/dialogs/simple_message_dialog.dart";
import "package:miria/view/settings_page/tab_settings_page/icon_select_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class TabSettingsPage extends HookConsumerWidget {
  const TabSettingsPage({super.key, this.tabIndex});

  final int? tabIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialTabSetting = tabIndex != null
        ? ref
            .read(tabSettingsRepositoryProvider)
            .tabSettings
            .toList()[tabIndex!]
        : null;

    final selectedAccount = useState<Account?>(
      initialTabSetting != null
          ? ref.read(accountProvider(initialTabSetting.acct))
          : ref.read(accountsProvider).first,
    );

    final isTabTypeAvailable = useCallback<bool Function(TabType)>(
      (tabType) => switch (tabType) {
        TabType.localTimeline =>
          selectedAccount.value?.i.policies.ltlAvailable ?? false,
        TabType.globalTimeline =>
          selectedAccount.value?.i.policies.gtlAvailable ?? false,
        _ => true,
      },
      [selectedAccount.value],
    );

    final selectedTabType = useState<TabType?>(
      initialTabSetting != null && isTabTypeAvailable(initialTabSetting.tabType)
          ? initialTabSetting.tabType
          : TabType.localTimeline,
    );

    final selectedRole = useState<RolesListResponse?>(null);
    final selectedChannel = useState<CommunityChannel?>(null);
    final selectedUserList = useState<UsersList?>(null);
    final selectedAntenna = useState<Antenna?>(null);

    final nameController = useTextEditingController(
      text: initialTabSetting != null
          ? initialTabSetting.name ??
              initialTabSetting.tabType.displayName(context)
          : "",
    );

    final availableIncludeReply =
        selectedTabType.value == TabType.localTimeline ||
            selectedTabType.value == TabType.hybridTimeline;

    final selectedIcon = useState<TabIcon?>(initialTabSetting?.icon);
    final renoteDisplay = useState(initialTabSetting?.renoteDisplay ?? true);
    final isSubscribe = useState(initialTabSetting?.isSubscribe ?? true);
    final isMediaOnly = useState(initialTabSetting?.isMediaOnly ?? false);
    final isIncludeReply =
        useState(initialTabSetting?.isIncludeReplies ?? false);

    final initialize = useAsync(() async {
      if (initialTabSetting == null) return;

      final roleId = initialTabSetting.roleId;
      final channelId = initialTabSetting.channelId;
      final listId = initialTabSetting.listId;
      final antennaId = initialTabSetting.antennaId;

      if (roleId != null) {
        selectedRole.value = await ref
            .read(misskeyProvider(selectedAccount.value!))
            .roles
            .show(RolesShowRequest(roleId: roleId));
      }
      if (channelId != null) {
        selectedChannel.value = await ref
            .read(misskeyProvider(selectedAccount.value!))
            .channels
            .show(ChannelsShowRequest(channelId: channelId));
      }
      if (listId != null) {
        selectedUserList.value = (await ref
                .read(misskeyProvider(selectedAccount.value!))
                .users
                .list
                .show(UsersListsShowRequest(listId: listId)))
            .toUsersList();
      }
      if (antennaId != null) {
        selectedAntenna.value = await ref
            .read(misskeyProvider(selectedAccount.value!))
            .antennas
            .show(AntennasShowRequest(antennaId: antennaId));
      }
    });
    useMemoized(() => unawaited(initialize.execute()));

    final accounts = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).tabSettings),
        actions: [
          if (tabIndex != null)
            IconButton(
              onPressed: () async {
                await ref.read(tabSettingsRepositoryProvider).save(
                      ref
                          .read(tabSettingsRepositoryProvider)
                          .tabSettings
                          .toList()
                        ..removeAt(tabIndex!),
                    );

                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete_outline_outlined),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(S.of(context).account),
              DropdownButton<Account>(
                items: [
                  for (final account in accounts)
                    DropdownMenuItem(
                      value: account,
                      child: Text(account.acct.toString()),
                    ),
                ],
                onChanged: (value) {
                  final tabType = selectedTabType.value;
                  selectedAccount.value = value;
                  selectedTabType.value =
                      tabType != null && isTabTypeAvailable(tabType)
                          ? tabType
                          : null;
                  selectedAntenna.value = null;
                  selectedUserList.value = null;
                  selectedChannel.value = null;
                  if (selectedIcon.value?.customEmojiName != null) {
                    selectedIcon.value = null;
                  }
                },
                value: selectedAccount.value,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Text(S.of(context).tabType),
              DropdownButton<TabType>(
                items: [
                  for (final tabType in TabType.values)
                    if (isTabTypeAvailable(tabType))
                      DropdownMenuItem(
                        value: tabType,
                        child: Text(tabType.displayName(context)),
                      ),
                ],
                onChanged: (value) {
                  selectedTabType.value = value;
                },
                value: selectedTabType.value,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              if (selectedTabType.value == TabType.roleTimeline) ...[
                Text(S.of(context).roleTimeline),
                switch (initialize.value) {
                  AsyncData() => Row(
                      children: [
                        Expanded(child: Text(selectedRole.value?.name ?? "")),
                        IconButton(
                          onPressed: () async {
                            final selected = selectedAccount.value;
                            if (selected == null) return;

                            selectedRole.value =
                                await context.pushRoute<RolesListResponse>(
                              RoleSelectRoute(account: selected),
                            );
                            nameController.text =
                                selectedRole.value?.name ?? nameController.text;
                          },
                          icon: const Icon(Icons.navigate_next),
                        ),
                      ],
                    ),
                  _ => const CircularProgressIndicator.adaptive(),
                },
              ],
              if (selectedTabType.value == TabType.channel) ...[
                Text(S.of(context).channel),
                switch (initialize.value) {
                  AsyncData() => Row(
                      children: [
                        Expanded(
                          child: Text(selectedChannel.value?.name ?? ""),
                        ),
                        IconButton(
                          onPressed: () async {
                            final selected = selectedAccount.value;
                            if (selected == null) return;

                            selectedChannel.value = await context.pushRoute(
                              ChannelSelectRoute(account: selected),
                            );
                            nameController.text = selectedChannel.value?.name ??
                                nameController.text;
                          },
                          icon: const Icon(Icons.navigate_next),
                        ),
                      ],
                    ),
                  _ => const CircularProgressIndicator.adaptive(),
                },
              ],
              if (selectedTabType.value == TabType.userList) ...[
                Text(S.of(context).list),
                switch (initialize.value) {
                  AsyncData() => Row(
                      children: [
                        Expanded(
                          child: Text(selectedUserList.value?.name ?? ""),
                        ),
                        IconButton(
                          onPressed: () async {
                            final selected = selectedAccount.value;
                            if (selected == null) return;

                            selectedUserList.value = await context.pushRoute(
                              UserListSelectRoute(account: selected),
                            );
                            nameController.text =
                                selectedUserList.value?.name ??
                                    nameController.text;
                          },
                          icon: const Icon(Icons.navigate_next),
                        ),
                      ],
                    ),
                  _ => const CircularProgressIndicator.adaptive(),
                },
              ],
              if (selectedTabType.value == TabType.antenna) ...[
                Text(S.of(context).antenna),
                Row(
                  children: [
                    Expanded(child: Text(selectedAntenna.value?.name ?? "")),
                    switch (initialize.value) {
                      AsyncData() => IconButton(
                          onPressed: () async {
                            final selected = selectedAccount.value;
                            if (selected == null) return;

                            selectedAntenna.value = await context.pushRoute(
                              AntennaSelectRoute(account: selected),
                            );
                            nameController.text = selectedAntenna.value?.name ??
                                nameController.text;
                          },
                          icon: const Icon(Icons.navigate_next),
                        ),
                      _ => const CircularProgressIndicator.adaptive(),
                    },
                  ],
                ),
              ],
              const Padding(padding: EdgeInsets.all(10)),
              Text(S.of(context).tabName),
              TextField(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.edit)),
                controller: nameController,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Text(S.of(context).icon),
              Row(
                children: [
                  Expanded(
                    child: selectedAccount.value == null
                        ? Container()
                        : AccountContextScope.as(
                            account: selectedAccount.value!,
                            child: SizedBox(
                              height: 32,
                              child: TabIconView(
                                icon: selectedIcon.value,
                                size: IconTheme.of(context).size,
                              ),
                            ),
                          ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (selectedAccount.value == null) return;
                      selectedIcon.value = await showDialog<TabIcon>(
                        context: context,
                        builder: (context) => IconSelectDialog(
                          account: selectedAccount.value!,
                        ),
                      );
                    },
                    icon: const Icon(Icons.navigate_next),
                  ),
                ],
              ),
              CheckboxListTile(
                title: Text(S.of(context).displayRenotes),
                value: renoteDisplay.value,
                onChanged: (value) =>
                    renoteDisplay.value = !renoteDisplay.value,
              ),
              if (availableIncludeReply)
                CheckboxListTile(
                  title: Text(S.of(context).includeReplies),
                  subtitle: Text(S.of(context).includeRepliesAvailability),
                  value: isIncludeReply.value,
                  enabled: !isMediaOnly.value,
                  onChanged: (value) {
                    isIncludeReply.value = !isIncludeReply.value;
                    if (value ?? false) {
                      isMediaOnly.value = false;
                    }
                  },
                ),
              CheckboxListTile(
                title: Text(S.of(context).mediaOnly),
                value: isMediaOnly.value,
                enabled: !isIncludeReply.value,
                onChanged: (value) {
                  isMediaOnly.value = !isMediaOnly.value;
                  if (value ?? false) {
                    isIncludeReply.value = false;
                  }
                },
              ),
              CheckboxListTile(
                title: Text(S.of(context).subscribeNotes),
                subtitle: Text(S.of(context).subscribeNotesDescription),
                value: isSubscribe.value,
                onChanged: (value) => isSubscribe.value = !isSubscribe.value,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final account = selectedAccount.value;
                    if (account == null) {
                      await SimpleMessageDialog.show(
                        context,
                        S.of(context).pleaseSelectAccount,
                      );
                      return;
                    }

                    final tabType = selectedTabType.value;
                    if (tabType == null) {
                      await SimpleMessageDialog.show(
                        context,
                        S.of(context).pleaseSelectTabType,
                      );
                      return;
                    }

                    final icon = selectedIcon.value;
                    if (icon == null) {
                      await SimpleMessageDialog.show(
                        context,
                        S.of(context).pleaseSelectIcon,
                      );
                      return;
                    }

                    if (tabType == TabType.channel &&
                        selectedChannel.value == null) {
                      await SimpleMessageDialog.show(
                        context,
                        S.of(context).pleaseSelectChannel,
                      );
                      return;
                    }

                    if (tabType == TabType.userList &&
                        selectedUserList.value == null) {
                      await SimpleMessageDialog.show(
                        context,
                        S.of(context).pleaseSelectList,
                      );
                      return;
                    }

                    if (tabType == TabType.antenna &&
                        selectedAntenna.value == null) {
                      await SimpleMessageDialog.show(
                        context,
                        S.of(context).pleaseSelectAntenna,
                      );
                      return;
                    }
                    if (tabType == TabType.roleTimeline &&
                        selectedRole.value == null) {
                      await SimpleMessageDialog.show(
                        context,
                        S.of(context).pleaseSelectRole,
                      );
                      return;
                    }

                    final list = ref
                        .read(tabSettingsRepositoryProvider)
                        .tabSettings
                        .toList();
                    final newTabSetting = TabSetting(
                      icon: icon,
                      tabType: tabType,
                      name: nameController.text,
                      acct: account.acct,
                      roleId: selectedRole.value?.id,
                      channelId: selectedChannel.value?.id,
                      listId: selectedUserList.value?.id,
                      antennaId: selectedAntenna.value?.id,
                      renoteDisplay: renoteDisplay.value,
                      isSubscribe: isSubscribe.value,
                      isIncludeReplies: isIncludeReply.value,
                      isMediaOnly: isMediaOnly.value,
                    );
                    if (tabIndex == null) {
                      await ref
                          .read(tabSettingsRepositoryProvider)
                          .save([...list, newTabSetting]);
                    } else {
                      list[tabIndex!] = newTabSetting;
                      await ref.read(tabSettingsRepositoryProvider).save(list);
                    }

                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).done),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
