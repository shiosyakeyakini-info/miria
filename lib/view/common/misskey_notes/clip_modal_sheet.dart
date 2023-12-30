import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/clip_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/clip_list_page/clip_settings_dialog.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _notesClipsNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<_NotesClipsNotifier, List<Clip>, (Misskey, String)>(
  _NotesClipsNotifier.new,
);

class _NotesClipsNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Clip>, (Misskey, String)> {
  @override
  Future<List<Clip>> build((Misskey, String) arg) async {
    final response = await arg.$1.notes.clips(
      NotesClipsRequest(noteId: arg.$2),
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

final _clipModalSheetNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<_ClipModalSheetNotifier, List<(Clip, bool)>, (Misskey, String)>(
  _ClipModalSheetNotifier.new,
);

class _ClipModalSheetNotifier extends AutoDisposeFamilyAsyncNotifier<
    List<(Clip, bool)>, (Misskey, String)> {
  @override
  Future<List<(Clip, bool)>> build((Misskey, String) arg) async {
    final [userClips, noteClips] = await Future.wait([
      ref.watch(clipsNotifierProvider(_misskey).future),
      ref.watch(_notesClipsNotifierProvider(arg).future),
    ]);
    return userClips
        .map(
          (userClip) => (
            userClip,
            noteClips.any((noteClip) => noteClip.id == userClip.id)
          ),
        )
        .toList();
  }

  Misskey get _misskey => arg.$1;

  String get _noteId => arg.$2;

  Future<void> addToClip(Clip clip) async {
    await _misskey.clips.addNote(
      ClipsAddNoteRequest(
        clipId: clip.id,
        noteId: _noteId,
      ),
    );
    ref.read(_notesClipsNotifierProvider(arg).notifier).addClip(clip);
  }

  Future<void> removeFromClip(Clip clip) async {
    await _misskey.clips.removeNote(
      ClipsRemoveNoteRequest(
        clipId: clip.id,
        noteId: _noteId,
      ),
    );
    ref.read(_notesClipsNotifierProvider(arg).notifier).removeClip(clip.id);
  }
}

class ClipModalSheet extends ConsumerWidget {
  const ClipModalSheet({
    super.key,
    required this.account,
    required this.noteId,
  });

  final Account account;
  final String noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final misskey = ref.watch(misskeyProvider(account));
    final arg = (misskey, noteId);
    final state = ref.watch(_clipModalSheetNotifierProvider(arg));

    Future<void> add(Clip clip) async {
      final context = ref.context;
      try {
        await ref
            .read(_clipModalSheetNotifierProvider(arg).notifier)
            .addToClip(clip);
      } catch (e) {
        // TODO: あとでなおす
        if (e is DioException && e.response?.data != null) {
          if ((e.response?.data as Map?)?["error"]?["code"] ==
              "ALREADY_CLIPPED") {
            if (!context.mounted) return;
            final result = await SimpleConfirmDialog.show(
              context: context,
              message: S.of(context).alreadyAddedClip,
              primary: S.of(context).deleteClip,
              secondary: S.of(context).noneAction,
            );
            if (result == true) {
              await ref
                  .read(_clipModalSheetNotifierProvider(arg).notifier)
                  .removeFromClip(clip);
            }
            return;
          }
        }

        rethrow;
      }
    }

    return state.when(
      data: (data) {
        return ListView.builder(
          itemCount: data.length + 1,
          itemBuilder: (context, index) {
            if (index < data.length) {
              final (clip, isClipped) = data[index];
              return ListTile(
                leading: isClipped
                    ? const Icon(Icons.check)
                    : SizedBox(width: Theme.of(context).iconTheme.size),
                onTap: () async {
                  if (isClipped) {
                    await ref
                        .read(_clipModalSheetNotifierProvider(arg).notifier)
                        .removeFromClip(clip)
                        .expectFailure(context);
                  } else {
                    await add(clip).expectFailure(context);
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
                        .create(settings)
                        .expectFailure(context);
                  }
                },
              );
            }
          },
        );
      },
      error: (e, st) => Center(child: ErrorDetail(error: e, stackTrace: st)),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
