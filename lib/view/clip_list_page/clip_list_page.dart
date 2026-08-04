import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart" hide Clip;
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/clip_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/clip_list_page/clips_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/clip_item.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class ClipListPage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;

  const ClipListPage({required this.accountContext, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(clipsProvider, (_, _) {});

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
              await ref.read(clipsProvider.notifier).create(settings);
            },
          ),
        ],
      ),
      body: PushableListView<Clip>(
        listKey: "clips_list",
        initializeFuture: () async {
          return await ref.read(clipsProvider.future);
        },
        nextFuture: (lastItem, _) async {
          final clips = await ref.read(clipsProvider.future);
          // Misskey 2025.8.0以前では `clips/list` のページネーションが実装されておらず、
          // クリップがソートされずに返ってくる。そのような場合は次のページを読み込まない。
          final isSorted = clips.isSorted((a, b) => b.id.compareTo(a.id));
          if (!isSorted) {
            return [];
          }
          return await ref
              .read(clipsProvider.notifier)
              .loadClips(untilId: lastItem.id);
        },
        itemBuilder: (context, clip) => ClipItem(
          clip: clip,
          trailing: _RemoveButton(id: clip.id),
        ),
      ),
    );
  }
}

class _RemoveButton extends HookConsumerWidget {
  final String id;

  const _RemoveButton({required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delete = useAsync(
      () async => ref.read(clipsProvider.notifier).delete(id),
    );
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: delete.executeOrNull,
    );
  }
}
