import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/tab_icon_view.dart';

@RoutePage()
class TabSettingsListPage extends ConsumerStatefulWidget {
  const TabSettingsListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      TabSettingsListPageState();
}

class TabSettingsListPageState extends ConsumerState<TabSettingsListPage> {
  void save(List<TabSetting> newTabSetting) {
    ref.read(tabSettingsRepositoryProvider).save(newTabSetting);
  }

  @override
  Widget build(BuildContext context) {
    final tabSettings = ref
        .watch(tabSettingsRepositoryProvider
            .select((repository) => repository.tabSettings))
        .toList();
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text("タブ設定"),
        actions: [
          IconButton(
              onPressed: () {
                context.pushRoute(TabSettingsRoute());
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ReorderableListView.builder(
                itemBuilder: (context, index) {
                  final tabSetting = tabSettings[index];
                  final account = ref.watch(accountProvider(tabSetting.acct));
                  return ListTile(
                    key: Key("$index"),
                    leading: AccountScope(
                      account: account,
                      child: TabIconView(icon: tabSettings[index].icon),
                    ),
                    title: Text(tabSettings[index].name),
                    subtitle: Text(
                      "${tabSetting.tabType.displayName} / ${account.acct}",
                    ),
                    onTap: () =>
                        context.pushRoute(TabSettingsRoute(tabIndex: index)),
                  );
                },
                itemCount: tabSettings.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = tabSettings.removeAt(oldIndex);
                    tabSettings.insert(newIndex, item);
                    save(tabSettings);
                  });
                }),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () {
                    context.router
                      ..removeWhere((route) => true)
                      ..push(const SplashRoute());
                  },
                  child: const Text("反映する")),
            ),
          )
        ],
      ),
    );
  }
}
