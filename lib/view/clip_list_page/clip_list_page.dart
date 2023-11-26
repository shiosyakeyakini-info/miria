import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Clip;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/clip_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/clip_list_page/clip_settings_dialog.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/clip_item.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class ClipListPage extends ConsumerWidget {
  const ClipListPage({super.key, required this.account});
  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final clips = ref.watch(clipsNotifierProvider(misskey));

    return Scaffold(
      appBar: AppBar(
        title:  Text(S.of(context).clip),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final settings = await showDialog<ClipSettings>(
                context: context,
                builder: (context) =>  ClipSettingsDialog(
                  title: Text(S.of(context).create),
                ),
              );
              if (!context.mounted) return;
              if (settings != null) {
                ref
                    .read(clipsNotifierProvider(misskey).notifier)
                    .create(settings)
                    .expectFailure(context);
              }
            },
          ),
        ],
      ),
      body: clips.when(
        data: (clips) => AccountScope(
          account: account,
          child: ListView.builder(
            itemCount: clips.length,
            itemBuilder: (context, index) {
              final clip = clips[index];
              return ClipItem(
                clip: clips[index],
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final result = await SimpleConfirmDialog.show(
                      context: context,
                      message: S.of(context).confirmDeleteClip,
                      primary: S.of(context).willDelete,
                      secondary: S.of(context).cancel,
                    );
                    if (!context.mounted) return;
                    if (result ?? false) {
                      await ref
                          .read(
                            clipsNotifierProvider(misskey).notifier,
                          )
                          .delete(clip.id)
                          .expectFailure(context);
                    }
                  },
                ),
              );
            },
          ),
        ),
        error: (e, st) => Center(child: ErrorDetail(error: e, stackTrace: st)),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
