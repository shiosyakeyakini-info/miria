import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/tab_type.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/socket_timeline_repository.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/channel_dialog.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/server_detail_dialog.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:miria/view/common/common_drawer.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:miria/view/common/notification_icon.dart';
import 'package:miria/view/common/tab_icon_view.dart';
import 'package:miria/view/common/timeline_listview.dart';
import 'package:miria/view/time_line_page/misskey_time_line.dart';
import 'package:miria/view/time_line_page/timeline_emoji.dart';
import 'package:miria/view/time_line_page/timeline_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class TimeLinePage extends ConsumerStatefulWidget {
  final TabSetting initialTabSetting;

  const TimeLinePage({super.key, required this.initialTabSetting});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TimeLinePageState();
}

class TimeLinePageState extends ConsumerState<TimeLinePage> {
  late final List<TabSetting> tabSettings;
  late int currentIndex;
  late final PageController pageController;
  late final List<TimelineScrollController> scrollControllers;

  @override
  void initState() {
    tabSettings = ref.read(
      tabSettingsRepositoryProvider.select((repo) => repo.tabSettings.toList()),
    );
    currentIndex = tabSettings.indexOf(widget.initialTabSetting);
    pageController = PageController(initialPage: currentIndex);
    scrollControllers =
        List.generate(tabSettings.length, (_) => TimelineScrollController());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  TabSetting get currentTabSetting {
    return tabSettings[currentIndex];
  }

  Future<void> note() async {
    final text = ref.read(timelineNoteProvider).value.text;
    if (text.isEmpty) return;
    try {
      final accountSettings = ref
          .read(accountSettingsRepositoryProvider)
          .fromAccount(currentTabSetting.account);
      ref.read(timelineNoteProvider).clear();
      FocusManager.instance.primaryFocus?.unfocus();

      await ref.read(misskeyProvider(currentTabSetting.account)).notes.create(
            NotesCreateRequest(
              text: text,
              channelId: currentTabSetting.channelId,
              visibility: accountSettings.defaultNoteVisibility,
              localOnly: accountSettings.defaultIsLocalOnly,
              reactionAcceptance: accountSettings.defaultReactionAcceptance,
            ),
          );
    } catch (e) {
      ref.read(timelineNoteProvider).text = text;
      rethrow;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void reload() {
    ref.read(currentTabSetting.timelineProvider).moveToOlder();
    scrollControllers[currentIndex].forceScrollToTop();
  }

  void changeTab(int index) {
    final tabSetting = tabSettings[index];
    if ([TabType.globalTimeline, TabType.homeTimeline, TabType.hybridTimeline]
        .contains(tabSetting.tabType)) {
      ref.read(tabSetting.timelineProvider).moveToOlder();
    }
    setState(() {
      currentIndex = index;
    });
  }

  void noteCreateRoute() {
    CommunityChannel? channel;
    if (currentTabSetting.channelId != null) {
      final Note? note;
      final timeline = ref.read(currentTabSetting.timelineProvider);
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
    final sendText = ref.read(timelineNoteProvider).text;
    ref.read(timelineNoteProvider).text = "";
    context.pushRoute(NoteCreateRoute(
      channel: channel,
      initialText: sendText,
      initialAccount: currentTabSetting.account,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final socketTimelineBase = ref.watch(currentTabSetting.timelineProvider);
    final socketTimeline = socketTimelineBase is SocketTimelineRepository
        ? socketTimelineBase
        : null;

    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: tabSettings
                .mapIndexed(
                  (index, tabSetting) => Ink(
                    color: tabSetting == currentTabSetting
                        ? AppTheme.of(context).currentDisplayTabColor
                        : Colors.transparent,
                    child: AccountScope(
                      account: tabSetting.account,
                      child: IconButton(
                        icon: TabIconView(
                          icon: tabSetting.icon,
                          color: tabSetting == currentTabSetting
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                        ),
                        onPressed: () => tabSetting == currentTabSetting
                            ? reload()
                            : pageController.jumpToPage(index),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          AccountScope(
            account: currentTabSetting.account,
            child: const NotificationIcon(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                        top: 5,
                        bottom: 5,
                      ),
                      child: Text(currentTabSetting.name),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                    child: NetworkImageView(
                      url:
                          "https://nos3.arkjp.net/image.webp?url=https%3A%2F%2Fs3.arkjp.net%2Fmisskey%2Fc8a26f2b-7541-4fc6-bebb-036482b53cec.gif&emoji=1",
                      type: ImageType.customEmoji,
                    ),
                  ),
                  if (currentTabSetting.tabType == TabType.channel)
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ChannelDialog(
                            channelId: currentTabSetting.channelId ?? "",
                            account: currentTabSetting.account,
                          ),
                        );
                      },
                      icon: const Icon(Icons.info_outline),
                    )
                  else if ([
                    TabType.hybridTimeline,
                    TabType.localTimeline,
                    TabType.globalTimeline,
                    TabType.homeTimeline,
                  ].contains(currentTabSetting.tabType))
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ServerDetailDialog(
                            account: currentTabSetting.account,
                          ),
                        );
                      },
                      icon: const Icon(Icons.smart_toy_outlined),
                    ),
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                  ),
                  IconButton(
                    onPressed: () => ref
                        .read(
                          currentTabSetting.tabType
                              .timelineProvider(currentTabSetting),
                        )
                        .reconnect(),
                    icon: const Icon(Icons.refresh),
                  )
                ],
              ),
            ),
            if (socketTimeline?.isLoading == true)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (socketTimeline?.error != null)
              ErrorDetail(error: socketTimeline?.error!),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: tabSettings.length,
                onPageChanged: (index) => changeTab(index),
                itemBuilder: (_, index) {
                  final tabSetting = tabSettings[index];
                  return AccountScope(
                    account: tabSetting.account,
                    child: MisskeyTimeline(
                      controller: scrollControllers[index],
                      timeLineRepositoryProvider:
                          tabSetting.tabType.timelineProvider(tabSetting),
                    ),
                  );
                },
              ),
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
                  IconButton(
                    onPressed: note.expectFailure(context),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: noteCreateRoute,
                    icon: const Icon(Icons.keyboard_arrow_right),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      drawer: CommonDrawer(
        initialOpenAccount: currentTabSetting.account,
      ),
    );
  }
}
