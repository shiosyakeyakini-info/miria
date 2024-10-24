import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/model/tab_setting.dart";
import "package:miria/model/tab_type.dart";
import "package:miria/providers.dart";
import "package:miria/repository/socket_timeline_repository.dart";
import "package:miria/repository/time_line_repository.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/common_drawer.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/error_dialog_handler.dart";
import "package:miria/view/common/notification_icon.dart";
import "package:miria/view/common/tab_icon_view.dart";
import "package:miria/view/common/timeline_listview.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:miria/view/time_line_page/misskey_time_line.dart";
import "package:miria/view/time_line_page/nyanpuppu.dart";
import "package:miria/view/time_line_page/timeline_emoji.dart";
import "package:miria/view/time_line_page/timeline_note.dart";
import "package:miria/view/time_line_page/timeline_tablet_ui.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class TimeLinePage extends ConsumerStatefulWidget {
  final TabSetting initialTabSetting;

  const TimeLinePage({required this.initialTabSetting, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TimeLinePageState();
}

class TimeLinePageState extends ConsumerState<TimeLinePage> {
  late List<TabSetting> tabSettings;
  late int currentIndex;
  late final PageController pageController;
  late final List<TimelineScrollController> scrollControllers;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  TimelineRepository? timelineRepository;

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
          .fromAcct(currentTabSetting.acct);
      ref.read(timelineNoteProvider).clear();
      FocusManager.instance.primaryFocus?.unfocus();

      final account = ref.read(accountProvider(currentTabSetting.acct));
      await ref.read(misskeyProvider(account)).notes.create(
            NotesCreateRequest(
              text: text,
              channelId: currentTabSetting.channelId,
              visibility: accountSettings.defaultNoteVisibility,
              localOnly: currentTabSetting.channelId != null ||
                  accountSettings.defaultIsLocalOnly,
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
    ref.read(timelineProvider(currentTabSetting)).moveToOlder();
    scrollControllers[currentIndex].forceScrollToTop();
  }

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future<void> noteCreateRoute() async {
    CommunityChannel? channel;
    if (currentTabSetting.channelId != null) {
      final Note? note;
      final timeline = ref.read(timelineProvider(currentTabSetting));
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
    final account = ref.read(accountProvider(currentTabSetting.acct));
    await context.pushRoute(
      NoteCreateRoute(
        channel: channel,
        initialText: sendText,
        initialAccount: account,
      ),
    );
  }

  Widget buildAppbar() {
    final account = ref.watch(accountProvider(currentTabSetting.acct));
    return AppBar(
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabSettings.mapIndexed(
            (index, tabSetting) {
              final account = ref.watch(accountProvider(tabSetting.acct));
              return Ink(
                color: tabSetting == currentTabSetting
                    ? AppTheme.of(context).currentDisplayTabColor
                    : Colors.transparent,
                child: AccountContextScope.as(
                  account: account,
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
              );
            },
          ).toList(),
        ),
      ),
      actions: [
        AccountContextScope.as(
          account: account,
          child: const NotificationIcon(),
        ),
      ],
      leading: IconButton(
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
        icon: const Icon(Icons.menu),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deckMode = ref.watch(
      generalSettingsRepositoryProvider
          .select((value) => value.settings.isDeckMode),
    );
    if (deckMode) return const TimelineTablet();

    timelineRepository = ref.watch(timelineProvider(currentTabSetting));
    final socketTimeline = timelineRepository is SocketTimelineRepository
        ? timelineRepository as SocketTimelineRepository?
        : null;
    tabSettings = ref.watch(
      tabSettingsRepositoryProvider.select((repo) => repo.tabSettings.toList()),
    );
    final account = ref.watch(accountProvider(currentTabSetting.acct));

    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          automaticallyImplyLeading: false,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (ref
                    .read(generalSettingsRepositoryProvider)
                    .settings
                    .tabPosition ==
                TabPosition.top)
              buildAppbar(),
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
                      child: Text(
                        currentTabSetting.name ??
                            currentTabSetting.tabType.displayName(context),
                      ),
                    ),
                  ),
                  const Nyanpuppu(),
                  if (currentTabSetting.tabType == TabType.channel)
                    IconButton(
                      onPressed: () async {
                        await context.pushRoute(
                          ChannelDescriptionRoute(
                            account: account,
                            channelId: currentTabSetting.channelId ?? "",
                          ),
                        );
                      },
                      icon: const Icon(Icons.info_outline),
                    )
                  else if (currentTabSetting.tabType == TabType.userList)
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () async {
                        await context.pushRoute(
                          UsersListDetailRoute(
                            accountContext: AccountContext.as(account),
                            listId: currentTabSetting.listId!,
                          ),
                        );
                      },
                    )
                  else if ([
                    TabType.hybridTimeline,
                    TabType.localTimeline,
                    TabType.globalTimeline,
                    TabType.homeTimeline,
                  ].contains(currentTabSetting.tabType)) ...[
                    AnnoucementInfo(tabSetting: currentTabSetting),
                    IconButton(
                      onPressed: () async {
                        await context.pushRoute(
                          ServerDetailRoute(
                            accountContext: AccountContext.as(account),
                          ),
                        );
                      },
                      icon: const Icon(Icons.smart_toy_outlined),
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                  ),
                  IconButton(
                    onPressed: () async => ref
                        .read(timelineProvider(currentTabSetting))
                        .reconnect(),
                    icon:
                        socketTimeline != null && socketTimeline.isReconnecting
                            ? const CircularProgressIndicator.adaptive()
                            : const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            if (socketTimeline?.isLoading == true)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
            if (socketTimeline?.error != null)
              ErrorDetail(
                error: socketTimeline?.error?.$1,
                stackTrace: socketTimeline?.error?.$2,
              ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: tabSettings.length,
                onPageChanged: (index) => changeTab(index),
                itemBuilder: (_, index) {
                  final tabSetting = tabSettings[index];
                  final account = ref.watch(accountProvider(tabSetting.acct));
                  return AccountContextScope.as(
                    account: account,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        BannerArea(tabSetting: currentTabSetting),
                        Expanded(
                          child: MisskeyTimeline(
                            controller: scrollControllers[index],
                            tabSetting: tabSetting,
                          ),
                        ),
                        const TimelineEmoji(),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              // decoration: filteringInputEmoji.isEmpty
              //     ? BoxDecoration(
              //         border: Border(
              //             top: BorderSide(
              //                 color: Theme.of(context).primaryColor)))
              //     : null,
              child: Row(
                children: [
                  Expanded(
                    child: Focus(
                      onKeyEvent: (node, event) {
                        if (event is KeyDownEvent) {
                          if (event.logicalKey == LogicalKeyboardKey.enter &&
                              HardwareKeyboard.instance.isControlPressed) {
                            note().expectFailure(context);
                            return KeyEventResult.handled;
                          }
                        }
                        return KeyEventResult.ignored;
                      },
                      child: const TimelineNoteField(),
                    ),
                  ),
                  IconButton(
                    onPressed: note.expectFailure(context),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: noteCreateRoute,
                    icon: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
            if (ref
                        .read(generalSettingsRepositoryProvider)
                        .settings
                        .tabPosition ==
                    TabPosition.bottom &&
                !ref.watch(timelineFocusNode).hasFocus)
              buildAppbar(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      drawerEnableOpenDragGesture: true,
      drawer: CommonDrawer(initialOpenAcct: currentTabSetting.acct),
    );
  }
}

class BannerArea extends ConsumerWidget {
  final TabSetting tabSetting;

  const BannerArea({required this.tabSetting, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerAnnouncement = ref.watch(
      iProvider(tabSetting.acct)
          .select((account) => account.unreadAnnouncements),
    );

    // ダイアログの実装が大変なので（状態管理とか）いったんバナーと一緒に扱う
    final bannerDatas = bannerAnnouncement.where(
      (element) =>
          element.display == AnnouncementDisplayType.banner ||
          element.display == AnnouncementDisplayType.dialog,
    );

    if (bannerDatas.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10, top: 3, bottom: 3),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          for (final bannerData in bannerDatas)
            Row(
              children: [
                if (bannerData.icon != null)
                  AnnouncementIcon(iconType: bannerData.icon!),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: Text(
                    "${bannerData.title}　${bannerData.text.replaceAll("\n", "　")}",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class AnnoucementInfo extends ConsumerWidget {
  final TabSetting tabSetting;

  const AnnoucementInfo({required this.tabSetting, super.key});

  Future<void> announcementsRoute(BuildContext context, WidgetRef ref) async {
    final account = ref.read(accountProvider(tabSetting.acct));
    await context.pushRoute(
      AnnouncementRoute(accountContext: AccountContext.as(account)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUnread = ref.watch(
      iProvider(tabSetting.acct)
          .select((i) => i.unreadAnnouncements.isNotEmpty),
    );

    if (hasUnread) {
      return IconButton(
        onPressed: () async => announcementsRoute(context, ref),
        icon: Stack(
          children: [
            const Icon(Icons.campaign),
            Transform.translate(
              offset: const Offset(12, 12),
              child: SizedBox(
                width: 14,
                height: 14,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return IconButton(
        onPressed: () async => announcementsRoute(context, ref),
        icon: const Icon(Icons.campaign),
      );
    }
  }
}

class AnnouncementIcon extends StatelessWidget {
  final AnnouncementIconType iconType;

  const AnnouncementIcon({required this.iconType, super.key});

  @override
  Widget build(BuildContext context) {
    switch (iconType) {
      case AnnouncementIconType.info:
        return const Icon(Icons.info, color: Colors.white);
      case AnnouncementIconType.warning:
        return const Icon(Icons.warning, color: Colors.white);
      case AnnouncementIconType.error:
        return const Icon(Icons.error, color: Colors.white);
      case AnnouncementIconType.success:
        return const Icon(Icons.check, color: Colors.white);
      default:
        return const SizedBox.shrink();
    }
  }
}
