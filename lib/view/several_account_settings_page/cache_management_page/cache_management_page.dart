import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/model/account_settings.dart";
import "package:miria/providers.dart";
import "package:miria/repository/account_repository.dart";

@RoutePage()
class CacheManagementPage extends ConsumerStatefulWidget {
  final Account account;

  const CacheManagementPage({required this.account, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      CacheManagementPageState();
}

class CacheManagementPageState extends ConsumerState<CacheManagementPage> {
  @override
  void dispose() {
    super.dispose();
  }

  CacheStrategy iCacheStrategy = CacheStrategy.whenTabChange;
  CacheStrategy emojisCacheStrategy = CacheStrategy.whenLaunch;
  CacheStrategy metaCacheStrategy = CacheStrategy.whenOneDay;

  bool isRefreshing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final setting = ref
        .read(accountSettingsRepositoryProvider)
        .fromAccount(widget.account);
    iCacheStrategy = setting.iCacheStrategy;
    emojisCacheStrategy = setting.emojiCacheStrategy;
    metaCacheStrategy = setting.metaChacheStrategy;
  }

  List<DropdownMenuItem> get buildCacheStrategyItems => [
    DropdownMenuItem(
      value: CacheStrategy.whenTabChange,
      child: Text(S.of(context).refreshOnTabChange),
    ),
    DropdownMenuItem(
      value: CacheStrategy.whenLaunch,
      child: Text(S.of(context).refreshOnLaunch),
    ),
    DropdownMenuItem(
      value: CacheStrategy.whenOneDay,
      child: Text(S.of(context).refreshOnceADay),
    ),
  ];
  Future<void> save() async {
    await ref
        .read(accountSettingsRepositoryProvider)
        .save(
          ref
              .read(accountSettingsRepositoryProvider)
              .fromAccount(widget.account)
              .copyWith(
                iCacheStrategy: iCacheStrategy,
                metaChacheStrategy: metaCacheStrategy,
                emojiCacheStrategy: emojisCacheStrategy,
              ),
        );
  }

  Future<void> refresh() async {
    setState(() {
      isRefreshing = true;
    });
    await ref.read(emojiRepositoryProvider(widget.account)).loadFromSource();
    await ref.read(accountRepositoryProvider.notifier).updateI(widget.account);
    await ref
        .read(accountRepositoryProvider.notifier)
        .updateMeta(widget.account);
    if (!context.mounted) return;
    setState(() {
      isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).cacheManualUpdateCompleted)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).cacheSettings)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).userCache,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                items: buildCacheStrategyItems,
                value: iCacheStrategy,
                isExpanded: true,
                onChanged: (value) => setState(() {
                  iCacheStrategy = value;
                  save();
                }),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(
                S.of(context).emojiCache,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                items: buildCacheStrategyItems,
                value: emojisCacheStrategy,
                isExpanded: true,
                onChanged: (value) => setState(() {
                  emojisCacheStrategy = value;
                  save();
                }),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(
                S.of(context).serverCache,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                items: buildCacheStrategyItems,
                value: metaCacheStrategy,
                isExpanded: true,
                onChanged: (value) => setState(() {
                  metaCacheStrategy = value;
                  save();
                }),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              if (isRefreshing)
                OutlinedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    minimumSize: const Size(double.infinity, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width:
                            Theme.of(context).textTheme.bodyMedium?.fontSize ??
                            22,
                        height:
                            Theme.of(context).textTheme.bodyMedium?.fontSize ??
                            22,
                        child: const CircularProgressIndicator(),
                      ),
                      const SizedBox(width: 10),
                      Text(S.of(context).refreshing),
                    ],
                  ),
                )
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: refresh,
                  label: Text(S.of(context).refresh),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    minimumSize: const Size(double.infinity, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
