import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/account_settings.dart';
import 'package:miria/providers.dart';

@RoutePage()
class CacheManagementPage extends ConsumerStatefulWidget {
  final Account account;

  const CacheManagementPage({super.key, required this.account});

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final setting =
        ref.read(accountSettingsRepositoryProvider).fromAccount(widget.account);
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
    await ref.read(accountSettingsRepositoryProvider).save(ref
        .read(accountSettingsRepositoryProvider)
        .fromAccount(widget.account)
        .copyWith(
          iCacheStrategy: iCacheStrategy,
          metaChacheStrategy: metaCacheStrategy,
          emojiCacheStrategy: emojisCacheStrategy,
        ));
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
              ],
            )),
      ),
    );
  }
}
