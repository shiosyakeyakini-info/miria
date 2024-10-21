import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/antenna_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/antenna_page/antenna_list.dart";
import "package:miria/view/antenna_page/antennas_notifier.dart";
import "package:miria/view/common/account_scope.dart";

@RoutePage()
class AntennaPage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;

  const AntennaPage({required this.accountContext, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).antenna),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final settings = await context.pushRoute<AntennaSettings>(
                AntennaSettingsRoute(
                  title: Text(S.of(context).create),
                  account: accountContext.postAccount,
                ),
              );
              if (!context.mounted) return;
              if (settings == null) return;
              await ref
                  .read(antennasNotifierProvider.notifier)
                  .create(settings);
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: AntennaList(),
      ),
    );
  }
}
