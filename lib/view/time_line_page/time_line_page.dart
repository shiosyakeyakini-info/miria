import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miria/extensions/text_editing_controller_extension.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/tab_type.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/channel_dialog.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/app_theme.dart';
import 'package:miria/view/common/common_drawer.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:miria/view/common/notification_icon.dart';
import 'package:miria/view/common/timeline_listview.dart';
import 'package:miria/view/time_line_page/misskey_time_line.dart';
import 'package:miria/view/time_line_page/timeline_emoji.dart';
import 'package:miria/view/time_line_page/timeline_note.dart';
import 'package:miria/view/time_line_page/timeline_scroll_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class TimeLinePage extends ConsumerStatefulWidget {
  final TabSetting currentTabSetting;

  const TimeLinePage({super.key, required this.currentTabSetting});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TimeLinePageState();
}

class TimeLinePageState extends ConsumerState<TimeLinePage> {
  final scrollController = TimelineScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(timelineNoteProvider).addListener(() {
      if (ref.read(timelineNoteProvider).isIncludeBeforeColon) {
        if (ref.read(timelineNoteProvider).isEmojiScope) {
          if (ref.read(filteredInputEmojiProvider).isNotEmpty) {
            ref.read(filteredInputEmojiProvider.notifier).state = [];
          }
          return;
        }

        Future(() async {
          final searchedEmojis = await (ref
              .read(emojiRepositoryProvider(widget.currentTabSetting.account))
              .searchEmojis(ref.read(timelineNoteProvider).emojiSearchValue));
          ref.read(filteredInputEmojiProvider.notifier).state = searchedEmojis;
        });
      } else {
        if (ref.read(filteredInputEmojiProvider).isNotEmpty) {
          ref.read(filteredInputEmojiProvider.notifier).state = [];
        }
      }
    });
  }

  void note() {
    ref.read(misskeyProvider(widget.currentTabSetting.account)).notes.create(
          NotesCreateRequest(
            text: ref.read(timelineNoteProvider).value.text,
            channelId: widget.currentTabSetting.channelId,
          ),
        );
    ref.read(timelineNoteProvider).clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref
        .read(emojiRepositoryProvider(widget.currentTabSetting.account))
        .loadFromSource();
  }

  void changeTabOrReload(TabSetting tabSetting) {
    if (tabSetting == widget.currentTabSetting) {
      ref.read(tabSetting.timelineProvider).moveToOlder();
      scrollController.forceScrollToTop();
    } else {
      if (tabSetting.tabType == TabType.globalTimeline ||
          tabSetting.tabType == TabType.homeTimeline ||
          tabSetting.tabType == TabType.hybridTimeline) {
        ref.read(tabSetting.timelineProvider).moveToOlder();
      }
      context.replaceRoute(TimeLineRoute(currentTabSetting: tabSetting));
    }
  }

  void noteCreateRoute() {
    CommunityChannel? channel;
    if (widget.currentTabSetting.channelId != null) {
      final Note? note;
      final timeline = ref.read(widget.currentTabSetting.timelineProvider);
      if (timeline.olderNotes.isNotEmpty) {
        note = timeline.olderNotes.first;
      } else if (timeline.newerNotes.isNotEmpty) {
        note = timeline.newerNotes.first;
      } else {
        //TODO: チャンネルにノートがないとき
        note = null;
      }
      final noteChannel = note?.channel;

      if (noteChannel != null) {
        channel = CommunityChannel(
          id: noteChannel.id,
          createdAt: DateTime.now(),
          name: noteChannel.name,
          pinnedNoteIds: [],
          usersCount: 0,
          notesCount: 0,
          isFollowing: false,
          isFavorited: false,
          hasUnreadNote: false,
          pinnedNotes: [],
        );
      }
    }
    context.pushRoute(NoteCreateRoute(
      channel: channel,
      initialAccount: widget.currentTabSetting.account,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AccountScope(
      account: widget.currentTabSetting.account,
      child: Scaffold(
          appBar: AppBar(
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                for (final tabSetting
                    in ref.read(tabSettingsRepositoryProvider).tabSettings)
                  Ink(
                    color: tabSetting == widget.currentTabSetting
                        ? Colors.white
                        : Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        tabSetting.icon,
                        color: tabSetting == widget.currentTabSetting
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                      onPressed: () => changeTabOrReload(tabSetting),
                    ),
                  )
              ]),
            ),
            actions: [const NotificationIcon()],
          ),
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Theme.of(context).primaryColor))),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, top: 5, bottom: 5),
                            child: Text(widget.currentTabSetting.name))),
                    const SizedBox(
                      height: 24,
                      child: NetworkImageView(
                        url:
                            "https://nos3.arkjp.net/image.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fc8a26f2b-7541-4fc6-bebb-036482b53cec.gif&emoji=1",
                        type: ImageType.customEmoji,
                      ),
                    ),
                    if (widget.currentTabSetting.tabType == TabType.channel)
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => ChannelDialog(
                                      channelId:
                                          widget.currentTabSetting.channelId ??
                                              "",
                                      account: widget.currentTabSetting.account,
                                    ));
                          },
                          icon: const Icon(Icons.info_outline)),
                    const Padding(
                      padding: EdgeInsets.only(right: 5),
                    ),
                    IconButton(
                        onPressed: () => ref
                            .read(widget.currentTabSetting.tabType
                                .timelineProvider(widget.currentTabSetting))
                            .reconnect(),
                        icon: const Icon(Icons.refresh))
                  ],
                ),
              ),
              Expanded(
                child: MisskeyTimeline(
                    controller: scrollController,
                    timeLineRepositoryProvider: widget.currentTabSetting.tabType
                        .timelineProvider(widget.currentTabSetting)),
              ),
              const TimelineEmoji(),
              Container(
                // decoration: filteringInputEmoji.isEmpty
                //     ? BoxDecoration(
                //         border: Border(
                //             top: BorderSide(
                //                 color: Theme.of(context).primaryColor)))
                //     : null,
                child: Row(
                  children: [
                    const Expanded(
                      child: TimelineNoteField(),
                    ),
                    IconButton(onPressed: note, icon: const Icon(Icons.edit)),
                    if (defaultTargetPlatform == TargetPlatform.android ||
                        defaultTargetPlatform == TargetPlatform.iOS)
                      IconButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          icon: const Icon(Icons.keyboard_arrow_down)),
                    IconButton(
                      onPressed: noteCreateRoute,
                      icon: const Icon(Icons.keyboard_arrow_right),
                    )
                  ],
                ),
              ),
            ],
          ),
          resizeToAvoidBottomInset: true,
          drawer: CommonDrawer(
            initialOpenAccount: widget.currentTabSetting.account,
          )),
    );
  }
}
