import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart" hide Clip;
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/clip_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/clip_list_page/clips_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/clip_item.dart";
import "package:miria/view/common/error_detail.dart";

@RoutePage()
class ClipListPage extends ConsumerWidget {
  const ClipListPage({required this.account, super.key});
  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final clips = ref.watch(clipsNotifierProvider(misskey));

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).clip),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final settings = await context.pushRoute<ClipSettings>(
                ClipSettingsRoute(title: Text(S.of(context).create)),
              );
              if (!context.mounted) return;
              if (settings == null) return;
              await ref
                  .read(clipsNotifierProvider(misskey).notifier)
                  .create(settings);
            },
          ),
        ],
      ),
      body: switch (clips) {
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError(:final error, :final stackTrace) =>
          Center(child: ErrorDetail(error: error, stackTrace: stackTrace)),
        AsyncData(:final value) => AccountScope(
            account: account,
            child: ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                final clip = value[index];
                return ClipItem(
                  clip: value[index],
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async => ref
                        .read(clipsNotifierProvider(misskey).notifier)
                        .delete(clip.id),
                  ),
                );
              },
            ),
          )
      },
    );
  }
}
