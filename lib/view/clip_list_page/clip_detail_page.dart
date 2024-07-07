import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/clip_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/clip_list_page/clips_notifier.dart";
import "package:miria/view/clip_list_page/clip_detail_note_list.dart";
import "package:miria/view/common/account_scope.dart";

@RoutePage()
class ClipDetailPage extends ConsumerWidget implements AutoRouteWrapper {
  final AccountContext accountContext;
  final String id;

  const ClipDetailPage(
      {required this.accountContext, required this.id, super.key});
  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(accountContext.getAccount));
    final clip = ref.watch(
      clipsNotifierProvider(misskey).select(
        (clips) => clips.valueOrNull?.firstWhereOrNull((e) => e.id == id),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(clip?.name ?? ""),
        actions: [
          if (clip != null)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                final settings = await context.pushRoute<ClipSettings>(
                  ClipSettingsRoute(
                    title: Text(S.of(context).edit),
                    initialSettings: ClipSettings.fromClip(clip),
                  ),
                );
                if (!context.mounted) return;
                if (settings == null) return;
                await ref
                    .read(clipsNotifierProvider(misskey).notifier)
                    .updateClip(clip.id, settings);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: ClipDetailNoteList(id: id),
      ),
    );
  }
}
