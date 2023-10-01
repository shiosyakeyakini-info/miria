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
import 'package:misskey_dart/misskey_dart.dart';

final clipsListNotifierProvider = AutoDisposeAsyncNotifierProviderFamily<
    ClipsListNotifier, List<Clip>, Misskey>(ClipsListNotifier.new);

class ClipsListNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Clip>, Misskey> {
  @override
  Future<List<Clip>> build(Misskey arg) async {
    final response = await _misskey.clips.list();
    return response.toList();
  }

  Misskey get _misskey => arg;

  Future<void> create(ClipSettings settings) async {
    final list = await _misskey.clips.create(
      ClipsCreateRequest(
        name: settings.name,
        description: settings.description,
        isPublic: settings.isPublic,
      ),
    );
    state = AsyncValue.data([...?state.valueOrNull, list]);
  }

  Future<void> delete(String clipId) async {
    await _misskey.clips.delete(ClipsDeleteRequest(clipId: clipId));
    state = AsyncValue.data(
      state.valueOrNull?.where((e) => e.id != clipId).toList() ?? [],
    );
  }

  Future<void> updateClip(
    String clipId,
    ClipSettings settings,
  ) async {
    final clip = await _misskey.clips.update(
      ClipsUpdateRequest(
        clipId: clipId,
        name: settings.name,
        description: settings.description,
        isPublic: settings.isPublic,
      ),
    );
    state = AsyncValue.data(
      state.valueOrNull
              ?.map(
                (e) => (e.id == clipId) ? clip : e,
              )
              .toList() ??
          [],
    );
  }
}

@RoutePage()
class ClipListPage extends ConsumerWidget {
  const ClipListPage({super.key, required this.account});
  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final clips = ref.watch(clipsListNotifierProvider(misskey));

    return Scaffold(
      appBar: AppBar(
        title: const Text("クリップ一覧"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final settings = await showDialog<ClipSettings>(
                context: context,
                builder: (context) => const ClipSettingsDialog(
                  title: Text("作成"),
                ),
              );
              if (!context.mounted) return;
              if (settings != null) {
                ref
                    .read(clipsListNotifierProvider(misskey).notifier)
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
                      message: "このクリップを削除しますか？",
                      primary: "削除する",
                      secondary: "やめる",
                    );
                    if (!context.mounted) return;
                    if (result ?? false) {
                      await ref
                          .read(
                            clipsListNotifierProvider(misskey).notifier,
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
