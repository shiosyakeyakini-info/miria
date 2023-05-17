import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/tab_type.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/settings_page/tab_settings_page/channel_select_dialog.dart';
import 'package:miria/view/settings_page/tab_settings_page/icon_select_dialog.dart';
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
  late Account? selectedAccount = ref.read(accountRepository).account.first;
  TabType? selectedTabType = TabType.localTimeline;
  CommunityChannel? selectedChannel;
  TextEditingController nameController = TextEditingController();
  IconData? selectedIcon;
  bool renoteDisplay = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final tab = widget.tabIndex;
    if (tab != null) {
      final tabSetting =
          ref.read(tabSettingsRepositoryProvider).tabSettings.toList()[tab];
      selectedAccount = tabSetting.account;
      selectedTabType = tabSetting.tabType;
      final channelId = tabSetting.channelId;
      nameController.text = tabSetting.name;
      selectedIcon = tabSetting.icon;
      renoteDisplay = tabSetting.renoteDisplay;
      if (channelId != null) {
        Future(() async {
          selectedChannel = await ref
              .read(misskeyProvider(tabSetting.account))
              .channels
              .show(ChannelsShowRequest(channelId: channelId));
          setState(() {});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  for (final account in ref.read(accountRepository).account)
                    DropdownMenuItem(
                      value: account,
                      child: Text("${account.userId}@${account.host}"),
                    )
                ],
                onChanged: (value) {
                  setState(() {
                    selectedAccount = value;
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
              const Padding(padding: EdgeInsets.all(10)),
              const Text("タブの名前"),
              TextField(
                controller: nameController,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              const Text("アイコン"),
              Row(
                children: [
                  Expanded(
                      child: selectedIcon == null
                          ? Container()
                          : Icon(selectedIcon!)),
                  IconButton(
                      onPressed: () async {
                        selectedIcon = await showDialog<IconData>(
                            context: context,
                            builder: (context) => IconSelectDialog());
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
              ElevatedButton(
                onPressed: () async {
                  final account = selectedAccount;
                  if (account == null) {
                    return;
                  }

                  final tabType = selectedTabType;
                  if (tabType == null) {
                    return;
                  }

                  final icon = selectedIcon;
                  if (icon == null) {
                    return;
                  }

                  if (tabType == TabType.channel && selectedChannel == null) {
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
                      account: account,
                      channelId: selectedChannel?.id,
                      renoteDisplay: renoteDisplay);
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
