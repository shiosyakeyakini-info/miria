import "dart:async";
import "dart:math";

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/log.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/model/tab_setting.dart";
import "package:miria/providers.dart";
import "package:miria/repository/time_line_repository.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/timeline_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

class MisskeyTimeline extends HookConsumerWidget {
  final TabSetting tabSetting;
  final TimelineScrollController controller;

  MisskeyTimeline({
    required this.tabSetting,
    super.key,
    TimelineScrollController? controller,
  }) : controller = controller ?? TimelineScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineRepository = ref.read(timelineProvider(tabSetting));
    final isDownDirectionLoading = useState(false);
    final isLastLoaded = useState(false);

    useEffect(
      () {
        timelineRepository.startTimeLine();
        return () => timelineRepository.disconnect();
      },
      [tabSetting],
    );

    useMemoized(
      () {
        isDownDirectionLoading.value = false;
        isLastLoaded.value = false;
      },
      [tabSetting],
    );

    final downDirectionLoad = useCallback(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (isDownDirectionLoading.value) return;
          try {
            isDownDirectionLoading.value = true;
            final result = await timelineRepository.previousLoad();
            isDownDirectionLoading.value = false;
            isLastLoaded.value = result == 0;
          } catch (e) {
            isDownDirectionLoading.value = false;
            rethrow;
          }
        });
      },
      [isDownDirectionLoading],
    );

    if (controller.positions.isNotEmpty) {
      controller.scrollToTop();
    }
    final repository = ref.watch(timelineProvider(tabSetting));

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: TimelineListView.builder(
        reverse: true,
        controller: controller,
        itemCount:
            repository.newerNotes.length + repository.olderNotes.length + 1,
        itemBuilder: (context, index) {
          // final corecctedIndex = index - 5;
          final correctedNewer = [
            if (timelineRepository.olderNotes.isNotEmpty)
              ...timelineRepository.olderNotes
                  .slice(0, min(5, timelineRepository.olderNotes.length))
                  .reversed,
            ...timelineRepository.newerNotes,
          ];
          final correctedOlder = [
            if (timelineRepository.olderNotes.length > 5)
              ...timelineRepository.olderNotes
                  .slice(5, timelineRepository.olderNotes.length),
          ];

          if (index > 0) {
            if ((index - 1) >= correctedNewer.length) {
              return null;
            }

            return NoteWrapper(
              targetNote: correctedNewer[index - 1],
              timeline: timelineRepository,
            );
          }

          if (-index == correctedOlder.length) {
            if (isLastLoaded.value) {
              return const SizedBox.shrink();
            }

            if (isDownDirectionLoading.value &&
                repository.newerNotes.length + repository.olderNotes.length !=
                    0) {
              return const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }

            if (ref.read(
                  generalSettingsRepositoryProvider
                      .select((value) => value.settings.automaticPush),
                ) ==
                AutomaticPush.automatic) {
              unawaited(downDirectionLoad());
            }

            return Center(
              child: IconButton(
                onPressed: downDirectionLoad,
                icon: const Icon(Icons.keyboard_arrow_down),
              ),
            );
          }

          if (-index >= correctedOlder.length) {
            return null;
          }

          return NoteWrapper(
            targetNote: correctedOlder[-index],
            timeline: timelineRepository,
          );
        },
      ),
    );
  }
}

class NoteWrapper extends ConsumerStatefulWidget {
  final Note targetNote;
  final TimelineRepository timeline;

  const NoteWrapper({
    required this.targetNote,
    required this.timeline,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NoteWrapperState();
}

class NoteWrapperState extends ConsumerState<NoteWrapper> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.targetNote.renoteId != null && widget.targetNote.text == null) {
      widget.timeline.subscribe(
        SubscribeItem(
          noteId: widget.targetNote.renoteId!,
          renoteId: null,
          replyId: null,
        ),
      );
    } else {
      widget.timeline.subscribe(
        SubscribeItem(
          noteId: widget.targetNote.id,
          renoteId: widget.targetNote.renoteId,
          replyId: widget.targetNote.replyId,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.timeline.preserveDescribe(widget.targetNote.id);
  }

  @override
  Widget build(BuildContext context) {
    final note = ref.watch(
      notesWithProvider.select((note) => note.notes[widget.targetNote.id]),
    );
    if (note == null) {
      logger.info("note was not found. ${widget.targetNote}");
      return MisskeyNote(
        note: widget.targetNote,
        key: ValueKey<String>(widget.targetNote.id),
      );
    }
    return MisskeyNote(note: note, key: ValueKey<String>(note.id));
  }
}
