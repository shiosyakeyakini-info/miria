import "package:auto_route/auto_route.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/model/account.dart";
import "package:miria/model/clip_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/clip_list_page/clips_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:miria/view/common/error_detail.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "clip_modal_sheet.g.dart";

@Riverpod(keepAlive: false, dependencies: [misskeyPostContext])
class _NotesClipsNotifier extends _$NotesClipsNotifier {
  @override
  Future<List<Clip>> build(String noteId) async {
    final response = await ref.read(misskeyPostContextProvider).notes.clips(
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

@Riverpod(
  keepAlive: false,
  dependencies: [
    ClipsNotifier,
    _NotesClipsNotifier,
    misskeyPostContext,
  ],
)
class _ClipModalSheetNotifier extends _$ClipModalSheetNotifier {
  @override
  Future<List<(Clip, bool)>> build(String noteId) async {
    final (userClips, noteClips) = await (
      ref.watch(clipsNotifierProvider.future),
      ref.watch(_notesClipsNotifierProvider(noteId).future),
    ).wait;

    return [
      for (final userClip in userClips)
        (userClip, noteClips.any((noteClip) => noteClip.id == userClip.id)),
    ];
  }

  Future<void> addToClip(Clip clip) async {
    await ref.read(dialogStateNotifierProvider.notifier).guard(() async {
      try {
        await ref.read(misskeyPostContextProvider).clips.addNote(
              ClipsAddNoteRequest(clipId: clip.id, noteId: noteId),
            );
        ref.read(_notesClipsNotifierProvider(noteId).notifier).addClip(clip);
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
              await removeFromClip(clip);
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
      await ref.read(misskeyPostContextProvider).clips.removeNote(
            ClipsRemoveNoteRequest(
              clipId: clip.id,
              noteId: noteId,
            ),
          );
      ref
          .read(_notesClipsNotifierProvider(noteId).notifier)
          .removeClip(clip.id);
    });
  }
}

@RoutePage()
class ClipModalSheet extends HookConsumerWidget implements AutoRouteWrapper {
  final Account account;
  final String noteId;

  const ClipModalSheet({
    required this.account,
    required this.noteId,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(_clipModalSheetNotifierProvider(noteId));
    final notifier = _clipModalSheetNotifierProvider(noteId).notifier;

    final create = useAsync(() async {
      final settings = await context.pushRoute<ClipSettings>(
        ClipSettingsRoute(title: Text(S.of(context).create)),
      );
      if (settings == null) return;
      await ref.read(clipsNotifierProvider.notifier).create(settings);
    });

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
                onTap: create.executeOrNull,
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
