import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/clip_settings.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/clip_list_page/clips_notifier.dart";
import "package:miria/view/clip_list_page/clip_settings_dialog.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/error_detail.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "clip_modal_sheet.g.dart";

@Riverpod(keepAlive: false)
class _NotesClipsNotifier extends _$NotesClipsNotifier {
  @override
  Future<List<Clip>> build(Misskey misskey, String noteId) async {
    final response = await misskey.notes.clips(
      NotesClipsRequest(noteId: noteId),
    );
    return response.toList();
  }

  void addClip(Clip clip) {
    state = AsyncValue.data([...state.valueOrNull ?? [], clip]);
  }

  void removeClip(String clipId) {
    state = AsyncValue.data(
      (state.valueOrNull ?? []).where((clip) => clip.id != clipId).toList(),
    );
  }
}

@Riverpod(keepAlive: false)
class _ClipModalSheetNotifier extends _$ClipModalSheetNotifier {
  @override
  Future<List<(Clip, bool)>> build(Misskey misskey, String noteId) async {
    final [userClips, noteClips] = await Future.wait([
      ref.watch(clipsNotifierProvider(misskey).future),
      ref.watch(_notesClipsNotifierProvider(misskey, noteId).future),
    ]);

    return [
      for (final userClip in userClips)
        (userClip, noteClips.any((noteClip) => noteClip.id == userClip.id)),
    ];
  }

  Future<void> addToClip(Clip clip) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      try {
        await this.misskey.clips.addNote(
              ClipsAddNoteRequest(clipId: clip.id, noteId: noteId),
            );
        ref
            .read(_notesClipsNotifierProvider(this.misskey, noteId).notifier)
            .addClip(clip);
      } on DioException catch (e) {
        if (e.response != null) {
          // すでにクリップに追加されている場合、削除するかどうかを確認する
          if (((e.response?.data as Map?)?["error"] as Map?)?["code"] ==
              "ALREADY_CLIPPED") {
            final confirm =
                await ref.read(dialogStateNotifierProvider.notifier).showDialog(
                      message: (context) => S.of(context).alreadyAddedClip,
                      actions: (context) =>
                          [S.of(context).deleteClip, S.of(context).noneAction],
                    );
            if (confirm == 0) {
              await ref
                  .read(
                    _clipModalSheetNotifierProvider(this.misskey, noteId)
                        .notifier,
                  )
                  .removeFromClip(clip);
            }
            return;
          }
        }
        rethrow;
      }
    });
  }

  Future<void> removeFromClip(Clip clip) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      await this.misskey.clips.removeNote(
            ClipsRemoveNoteRequest(
              clipId: clip.id,
              noteId: noteId,
            ),
          );
      ref
          .read(_notesClipsNotifierProvider(this.misskey, noteId).notifier)
          .removeClip(clip.id);
    });
  }
}

class ClipModalSheet extends ConsumerWidget {
  const ClipModalSheet({
    required this.account,
    required this.noteId,
    super.key,
  });

  final Account account;
  final String noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final state = ref.watch(_clipModalSheetNotifierProvider(misskey, noteId));
    final notifier = _clipModalSheetNotifierProvider(misskey, noteId).notifier;
    return switch (state) {
      AsyncData(:final value) => ListView.builder(
          itemCount: value.length + 1,
          itemBuilder: (context, index) {
            if (index < value.length) {
              final (clip, isClipped) = value[index];
              return ListTile(
                leading: isClipped
                    ? const Icon(Icons.check)
                    : SizedBox(width: Theme.of(context).iconTheme.size),
                onTap: () async {
                  if (isClipped) {
                    await ref.read(notifier).removeFromClip(clip);
                  } else {
                    await ref.read(notifier).addToClip(clip);
                  }
                },
                title: Text(clip.name ?? ""),
                subtitle: Text(clip.description ?? ""),
              );
            } else {
              return ListTile(
                leading: const Icon(Icons.add),
                title: Text(S.of(context).createClip),
                onTap: () async {
                  final settings = await showDialog<ClipSettings>(
                    context: context,
                    builder: (context) => ClipSettingsDialog(
                      title: Text(S.of(context).create),
                    ),
                  );
                  if (!context.mounted) return;
                  if (settings != null) {
                    await ref
                        .read(clipsNotifierProvider(misskey).notifier)
                        .create(settings);
                  }
                },
              );
            }
          },
        ),
      AsyncLoading() =>
        const Center(child: CircularProgressIndicator.adaptive()),
      AsyncError(:final error, :final stackTrace) =>
        Center(child: ErrorDetail(error: error, stackTrace: stackTrace))
    };
  }
}
