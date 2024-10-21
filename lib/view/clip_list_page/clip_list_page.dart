import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart" hide Clip;
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/model/clip_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/clip_list_page/clips_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/clip_item.dart";
import "package:miria/view/common/error_detail.dart";

@RoutePage()
class ClipListPage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;

  const ClipListPage({required this.accountContext, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clips = ref.watch(clipsNotifierProvider);

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
              await ref.read(clipsNotifierProvider.notifier).create(settings);
            },
          ),
        ],
      ),
      body: switch (clips) {
        AsyncLoading() => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        AsyncError(:final error, :final stackTrace) =>
          Center(child: ErrorDetail(error: error, stackTrace: stackTrace)),
        AsyncData(:final value) => ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              final clip = value[index];
              return ClipItem(clip: clip, trailing: _RemoveButton(id: clip.id));
            },
          )
      },
    );
  }
}

class _RemoveButton extends HookConsumerWidget {
  final String id;

  const _RemoveButton({required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delete = useAsync(
      () async => ref.read(clipsNotifierProvider.notifier).delete(id),
    );
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: delete.executeOrNull,
    );
  }
}
