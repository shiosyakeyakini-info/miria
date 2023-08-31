import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:miria/extensions/users_lists_show_response_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/tab_icon.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/tab_type.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';
import 'package:miria/view/common/tab_icon_view.dart';
import 'package:miria/view/settings_page/tab_settings_page/role_select_dialog.dart';
import 'package:miria/view/settings_page/tab_settings_page/antenna_select_dialog.dart';
import 'package:miria/view/settings_page/tab_settings_page/channel_select_dialog.dart';
import 'package:miria/view/settings_page/tab_settings_page/icon_select_dialog.dart';
import 'package:miria/view/settings_page/tab_settings_page/user_list_select_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class TabSettingsPage extends ConsumerStatefulWidget {
  const TabSettingsPage({super.key, this.tabIndex});

  final int? tabIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      TabSettingsAddDialogState();
}

class TabSettingsAddDialogState extends ConsumerState<TabSettingsPage> {
  late Account? selectedAccount = ref.read(accountsProvider).first;
  TabType? selectedTabType = TabType.localTimeline;
  RolesListResponse? selectedRole;
  CommunityChannel? selectedChannel;
  UsersList? selectedUserList;
  Antenna? selectedAntenna;
  TextEditingController nameController = TextEditingController();
  TabIcon? selectedIcon;
  bool renoteDisplay = true;
  bool isSubscribe = true;
  bool isMediaOnly = false;
  bool isIncludeReply = false;

  bool get availableIncludeReply =>
      selectedTabType == TabType.localTimeline ||
      selectedTabType == TabType.hybridTimeline;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final tab = widget.tabIndex;
    if (tab != null) {
      final tabSetting =
          ref.read(tabSettingsRepositoryProvider).tabSettings.toList()[tab];
      selectedAccount = ref.read(accountProvider(tabSetting.acct));
      selectedTabType = tabSetting.tabType;
      final roleId = tabSetting.roleId;
      final channelId = tabSetting.channelId;
      final listId = tabSetting.listId;
      final antennaId = tabSetting.antennaId;
      nameController.text = tabSetting.name;
      selectedIcon = tabSetting.icon;
      renoteDisplay = tabSetting.renoteDisplay;
      isSubscribe = tabSetting.isSubscribe;
      isMediaOnly = tabSetting.isMediaOnly;
      isIncludeReply = tabSetting.isIncludeReplies;
      if (roleId != null) {
        Future(() async {
          selectedRole = await ref
              .read(misskeyProvider(selectedAccount!))
              .roles
              .show(RolesShowRequest(roleId: roleId));
          setState(() {});
        });
      }
      if (channelId != null) {
        Future(() async {
          selectedChannel = await ref
              .read(misskeyProvider(selectedAccount!))
              .channels
              .show(ChannelsShowRequest(channelId: channelId));
          setState(() {});
        });
      }
      if (listId != null) {
        Future(() async {
          final response = await ref
              .read(misskeyProvider(selectedAccount!))
              .users
              .list
              .show(UsersListsShowRequest(listId: listId));
          selectedUserList = response.toUsersList();
          setState(() {});
        });
      }
      if (antennaId != null) {
        Future(() async {
          selectedAntenna = await ref
              .read(misskeyProvider(selectedAccount!))
              .antennas
              .show(AntennasShowRequest(antennaId: antennaId));
          setState(() {});
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("タブ設定"),
        actions: [
          if (widget.tabIndex != null)
            IconButton(
                onPressed: () {
                  ref.read(tabSettingsRepositoryProvider).save(ref
                      .read(tabSettingsRepositoryProvider)
                      .tabSettings
                      .toList()
                    ..removeAt(widget.tabIndex!));

                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.delete_outline_outlined))
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
              const Text("アカウント"),
              DropdownButton<Account>(
                items: [
                  for (final account in accounts)
                    DropdownMenuItem(
                      value: account,
                      child: Text(account.acct.toString()),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedAccount = value;
                    selectedAntenna = null;
                    selectedUserList = null;
                    selectedChannel = null;
                    if (selectedIcon?.customEmojiName != null) {
                      selectedIcon = null;
                    }
                  });
                },
                value: selectedAccount,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              const Text("タブの種類"),
              DropdownButton<TabType>(
                items: [
                  for (final tabType in TabType.values)
                    DropdownMenuItem(
                      value: tabType,
                      child: Text(tabType.displayName),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedTabType = value;
                  });
                },
                value: selectedTabType,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              if (selectedTabType == TabType.roleTimeline) ...[
                const Text("ロールタイムライン"),
                Row(
                  children: [
                    Expanded(child: Text(selectedRole?.name ?? "")),
                    IconButton(
                        onPressed: () async {
                          final selected = selectedAccount;
                          if (selected == null) return;

                          selectedRole = await showDialog<RolesListResponse>(
                              context: context,
                              builder: (context) =>
                                  RoleSelectDialog(account: selected));
                          setState(() {
                            nameController.text =
                                selectedRole?.name ?? nameController.text;
                          });
                        },
                        icon: const Icon(Icons.navigate_next))
                  ],
                )
              ],
              if (selectedTabType == TabType.channel) ...[
                const Text("チャンネル"),
                Row(
                  children: [
                    Expanded(child: Text(selectedChannel?.name ?? "")),
                    IconButton(
                        onPressed: () async {
                          final selected = selectedAccount;
                          if (selected == null) return;

                          selectedChannel = await showDialog<CommunityChannel>(
                              context: context,
                              builder: (context) =>
                                  ChannelSelectDialog(account: selected));
                          setState(() {
                            nameController.text =
                                selectedChannel?.name ?? nameController.text;
                          });
                        },
                        icon: const Icon(Icons.navigate_next))
                  ],
                )
              ],
              if (selectedTabType == TabType.userList) ...[
                const Text("リスト"),
                Row(
                  children: [
                    Expanded(child: Text(selectedUserList?.name ?? "")),
                    IconButton(
                        onPressed: () async {
                          final selected = selectedAccount;
                          if (selected == null) return;

                          selectedUserList = await showDialog<UsersList>(
                              context: context,
                              builder: (context) =>
                                  UserListSelectDialog(account: selected));
                          setState(() {
                            nameController.text =
                                selectedUserList?.name ?? nameController.text;
                          });
                        },
                        icon: const Icon(Icons.navigate_next))
                  ],
                )
              ],
              if (selectedTabType == TabType.antenna) ...[
                const Text("アンテナ"),
                Row(
                  children: [
                    Expanded(child: Text(selectedAntenna?.name ?? "")),
                    IconButton(
                        onPressed: () async {
                          final selected = selectedAccount;
                          if (selected == null) return;

                          selectedAntenna = await showDialog<Antenna>(
                              context: context,
                              builder: (context) =>
                                  AntennaSelectDialog(account: selected));
                          setState(() {
                            nameController.text =
                                selectedAntenna?.name ?? nameController.text;
                          });
                        },
                        icon: const Icon(Icons.navigate_next))
                  ],
                )
              ],
              const Padding(padding: EdgeInsets.all(10)),
              const Text("タブの名前"),
              TextField(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.edit)),
                controller: nameController,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              const Text("アイコン"),
              Row(
                children: [
                  Expanded(
                      child: selectedAccount == null
                          ? Container()
                          : AccountScope(
                              account: selectedAccount!,
                              child: SizedBox(
                                height: 32,
                                child: TabIconView(
                                    icon: selectedIcon,
                                    size: IconTheme.of(context).size),
                              ))),
                  IconButton(
                      onPressed: () async {
                        if (selectedAccount == null) return;
                        selectedIcon = await showDialog<TabIcon>(
                            context: context,
                            builder: (context) => IconSelectDialog(
                                  account: selectedAccount!,
                                ));
                        setState(() {});
                      },
                      icon: const Icon(Icons.navigate_next))
                ],
              ),
              CheckboxListTile(
                title: const Text("リノートを表示する"),
                value: renoteDisplay,
                onChanged: (value) =>
                    setState(() => renoteDisplay = !renoteDisplay),
              ),
              if (availableIncludeReply)
                CheckboxListTile(
                  title: const Text("返信も入れる"),
                  subtitle: const Text("Misskey v2023.10.1以降の機能です。"),
                  value: isIncludeReply,
                  onChanged: (value) =>
                      setState(() => isIncludeReply = !isIncludeReply),
                ),
              CheckboxListTile(
                title: const Text("ファイルのみにする"),
                value: isMediaOnly,
                onChanged: (value) =>
                    setState(() => isMediaOnly = !isMediaOnly),
              ),
              CheckboxListTile(
                title: const Text("リアクションや投票数を自動更新する"),
                subtitle: const Text(
                    "オフにすると、リアクションや投票数が自動更新されませんが、バッテリー消費を抑えられることがあります。"),
                value: isSubscribe,
                onChanged: (value) =>
                    setState(() => isSubscribe = !isSubscribe),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final account = selectedAccount;
                    if (account == null) {
                      SimpleMessageDialog.show(context, "アカウントを選択してください。");
                      return;
                    }

                    final tabType = selectedTabType;
                    if (tabType == null) {
                      SimpleMessageDialog.show(context, "タブの種類を選択してください。");
                      return;
                    }

                    final icon = selectedIcon;
                    if (icon == null) {
                      SimpleMessageDialog.show(context, "アイコンを選択してください。");
                      return;
                    }

                    if (tabType == TabType.channel && selectedChannel == null) {
                      SimpleMessageDialog.show(context, "チャンネルを指定してください。");
                      return;
                    }

                    if (tabType == TabType.userList &&
                        selectedUserList == null) {
                      SimpleMessageDialog.show(context, "リストを指定してください。");
                      return;
                    }

                    if (tabType == TabType.antenna && selectedAntenna == null) {
                      SimpleMessageDialog.show(context, "アンテナを指定してください。");
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
                      roleId: selectedRole?.id,
                      channelId: selectedChannel?.id,
                      listId: selectedUserList?.id,
                      antennaId: selectedAntenna?.id,
                      renoteDisplay: renoteDisplay,
                      isSubscribe: isSubscribe,
                      isIncludeReplies: isIncludeReply,
                      isMediaOnly: isMediaOnly,
                    );
                    if (widget.tabIndex == null) {
                      await ref
                          .read(tabSettingsRepositoryProvider)
                          .save([...list, newTabSetting]);
                    } else {
                      list[widget.tabIndex!] = newTabSetting;
                      await ref.read(tabSettingsRepositoryProvider).save(list);
                    }

                    if (!mounted) return;
                    Navigator.of(context).pop();
                  },
                  child: const Text("ほい"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
