import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/drive_page/drive_file_notes_page/attached_notes_notifier.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pagination_bottom_widget.dart";
import "package:misskey_dart/misskey_dart.dart";

class DriveFileNotes extends HookConsumerWidget {
  const DriveFileNotes({required this.file, super.key});

  final DriveFile file;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(attachedNotesNotifierProvider(file.id));
    final enableInfiniteScroll = ref.watch(
      generalSettingsRepositoryProvider.select(
        (repository) =>
            repository.settings.automaticPush == AutomaticPush.automatic,
      ),
    );
    final controller = useScrollController();
    final isAtBottom = useState(false);
    useEffect(() {
      Future<void> callback() async {
        if (controller.position.extentAfter < 100) {
          if (!isAtBottom.value) {
            isAtBottom.value = true;
            await ref
                .read(attachedNotesNotifierProvider(file.id).notifier)
                .loadMore();
          }
        } else {
          isAtBottom.value = false;
        }
      }

      if (enableInfiniteScroll) {
        controller.addListener(callback);
      }
      return () => controller.removeListener(callback);
    }, [enableInfiniteScroll]);

    return RefreshIndicator(
      onRefresh: () async =>
          await ref.refresh(attachedNotesNotifierProvider(file.id).future),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          controller: controller,
          children: [
            ...?notes.value?.items.map((note) => MisskeyNote(note: note)),
            PaginationBottomWidget(
              paginationState: notes,
              noItemsLabel: S.of(context).nothingHere,
              loadMore: () async => await ref
                  .read(attachedNotesNotifierProvider(file.id).notifier)
                  .loadMore(skipError: true),
            ),
          ],
        ),
      ),
    );
  }
}
