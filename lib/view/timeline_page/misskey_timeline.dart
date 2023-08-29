import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/timeline_page/note_wrapper.dart';

final _centerKeyProvider = Provider.autoDispose<UniqueKey>((ref) {
  return UniqueKey();
});

class MisskeyTimeline extends ConsumerWidget {
  const MisskeyTimeline({super.key, required this.tabSetting});

  final TabSetting tabSetting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(timelineRepositoryProvider(tabSetting));
    final controller = ref.watch(timelineControllerProvider(tabSetting));
    final centerKey = ref.watch(_centerKeyProvider);

    if (timeline.isLoading && timeline.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return CustomScrollView(
      center: centerKey,
      controller: controller.scrollController,
      slivers: [
        SliverAnimatedList(
          key: controller.listKey,
          initialItemCount: timeline.newerNotes.length,
          itemBuilder: (context, index, animation) {
            return SizeTransition(
              sizeFactor: animation,
              child: NoteWrapper(
                targetNote: timeline.newerNotes[index],
                tabSetting: tabSetting,
              ),
            );
          },
        ),
        SliverList.builder(
          key: centerKey,
          itemCount: timeline.olderNotes.length + 1,
          itemBuilder: (context, index) {
            if (index < timeline.olderNotes.length) {
              return NoteWrapper(
                targetNote: timeline.olderNotes[index],
                tabSetting: tabSetting,
              );
            }
            return TimelineBottomItem(tabSetting: tabSetting);
          },
        ),
      ],
    );
  }
}

class TimelineBottomItem extends ConsumerWidget {
  const TimelineBottomItem({super.key, required this.tabSetting});

  final TabSetting tabSetting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeline = ref.watch(timelineRepositoryProvider(tabSetting));
    if (timeline.isLastLoaded) {
      return const SizedBox.shrink();
    }

    if (timeline.isDownDirectionLoading) {
      if (timeline.newerNotes.isNotEmpty || timeline.olderNotes.isNotEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(child: CircularProgressIndicator()),
        );
      } else {
        return const SizedBox.shrink();
      }
    }

    if (ref.read(generalSettingsRepositoryProvider).settings.automaticPush ==
        AutomaticPush.automatic) {
      Future(() {
        ref
            .read(timelineRepositoryProvider(tabSetting).notifier)
            .downDirectionLoad();
      });
    }

    return Center(
      child: IconButton(
        onPressed: ref
            .read(timelineRepositoryProvider(tabSetting).notifier)
            .downDirectionLoad
            .expectFailure(context),
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }
}
