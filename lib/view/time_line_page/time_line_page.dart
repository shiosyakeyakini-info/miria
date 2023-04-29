import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/tab_settings.dart';
import 'package:flutter_misskey_app/model/tab_settings_repository.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/time_line_page/misskey_time_line.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class TimeLinePage extends ConsumerStatefulWidget {
  final TabSettings currentTabSetting;

  const TimeLinePage({super.key, required this.currentTabSetting});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TimeLinePageState();
}

class TimeLinePageState extends ConsumerState<TimeLinePage> {
  final textEditingController = TextEditingController();
  final scrollController = ScrollController();

  void note() {
    ref.read(misskeyProvider).notes.create(NotesCreateRequest(
          text: textEditingController.value.text,
        ));
    textEditingController.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref.read(emojiRepositoryProvider).loadFromSource();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          for (final tabSetting
              in ref.read(tabSettingsRepositoryProvider).tabSettings)
            IconButton(
                icon: Icon(tabSetting.icon),
                onPressed: () {
                  if (tabSetting == widget.currentTabSetting) {
                    scrollController
                        .jumpTo(scrollController.position.maxScrollExtent);
                  } else {
                    context.replaceRoute(
                        TimeLineRoute(currentTabSetting: tabSetting));
                  }
                })
        ]),
        actions: [
          IconButton(
              onPressed: () => ref
                  .read(widget.currentTabSetting.tabType
                      .timelineProvider(widget.currentTabSetting))
                  .reconnect(),
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MisskeyTimeline(
                controller: scrollController,
                timeLineRepositoryProvider: widget.currentTabSetting.tabType
                    .timelineProvider(widget.currentTabSetting)),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: TextField(
                    controller: textEditingController,
                  ),
                ),
              ),
              IconButton(onPressed: note, icon: const Icon(Icons.edit)),
            ],
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
