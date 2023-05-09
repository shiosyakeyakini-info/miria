import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/tab_setting.dart';
import 'package:flutter_misskey_app/model/tab_type.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/channel_dialog.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/common_drawer.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/custom_emoji.dart';
import 'package:flutter_misskey_app/view/common/notification_icon.dart';
import 'package:flutter_misskey_app/view/common/timeline_listview.dart';
import 'package:flutter_misskey_app/view/time_line_page/misskey_time_line.dart';
import 'package:flutter_misskey_app/view/time_line_page/timeline_scroll_controller.dart';
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
  final textEditingController = TextEditingController();
  final scrollController = TimelineScrollController();

  var filteringInputEmoji = <Emoji>[];

  @override
  void initState() {
    super.initState();

    textEditingController.addListener(() {
      final position = textEditingController.selection.base.offset;
      final value = textEditingController.text;

      if (value.substring(0, position).contains(":")) {
        final startPosition = value.substring(0, position).lastIndexOf(":") + 1;
        final searchValue = value.substring(startPosition, position);
        print(value.substring(0, startPosition));
        if (RegExp(r':[a-zA-z_0-9]+?:$')
            .hasMatch(value.substring(0, startPosition))) {
          if (filteringInputEmoji.isNotEmpty) {
            setState(() {
              filteringInputEmoji = [];
            });
          }
          return;
        }

        Future(() async {
          final searchedEmojis = await (ref
              .read(emojiRepositoryProvider(widget.currentTabSetting.account))
              .searchEmojis(searchValue));

          setState(() {
            filteringInputEmoji = searchedEmojis;
          });
        });
      } else {
        if (filteringInputEmoji.isNotEmpty) {
          setState(() {
            filteringInputEmoji = [];
          });
        }
      }
    });
  }

  void note() {
    ref.read(misskeyProvider(widget.currentTabSetting.account)).notes.create(
          NotesCreateRequest(
            text: textEditingController.value.text,
            channelId: widget.currentTabSetting.channelId,
          ),
        );
    textEditingController.clear();
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

  void insertEmoji(Emoji emoji) {
    final currentPosition = textEditingController.selection.base.offset;
    final text = textEditingController.text;
    final beforeSearchText =
        text.substring(0, text.substring(0, currentPosition).lastIndexOf(":"));
    textEditingController.value = TextEditingValue(
        text:
            "$beforeSearchText:${emoji.name}:${currentPosition == text.length ? "" : text.substring(currentPosition, text.length - 1)}",
        selection: TextSelection.collapsed(
            offset: beforeSearchText.length + emoji.name.length + 2));
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
              if (filteringInputEmoji.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).primaryColor))),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final emoji in filteringInputEmoji)
                            GestureDetector(
                              onTap: () => insertEmoji(emoji),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: SizedBox(
                                    height: 32 *
                                        MediaQuery.of(context).textScaleFactor,
                                    child: CustomEmoji(
                                      emoji: emoji,
                                    )),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: textEditingController,
                      ),
                    ),
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
                    onPressed: () => context.pushRoute(NoteCreateRoute()),
                    icon: const Icon(Icons.keyboard_arrow_right),
                  )
                ],
              ),
            ],
          ),
          resizeToAvoidBottomInset: true,
          drawer: const CommonDrawer()),
    );
  }
}
