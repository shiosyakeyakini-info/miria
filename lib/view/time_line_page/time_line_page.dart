import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/general_settings.dart';
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
  late List<TabSetting> tabSettings;
  late int currentIndex;
  late final PageController pageController;
  late final List<TimelineScrollController> scrollControllers;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

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

  Widget buildAppbar() {
    return AppBar(
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
      leading: IconButton(
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final socketTimelineBase = ref.watch(currentTabSetting.timelineProvider);
    final socketTimeline = socketTimelineBase is SocketTimelineRepository
        ? socketTimelineBase
        : null;
    tabSettings = ref.watch(
      tabSettingsRepositoryProvider.select((repo) => repo.tabSettings.toList()),
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(
            automaticallyImplyLeading: false,
          )),
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
                  ].contains(currentTabSetting.tabType)) ...[
                    AnnoucementInfo(index: currentIndex),
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
                  ],
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        BannerArea(index: currentIndex),
                        Expanded(
                          child: MisskeyTimeline(
                            controller: scrollControllers[index],
                            timeLineRepositoryProvider:
                                tabSetting.tabType.timelineProvider(tabSetting),
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
      drawer: CommonDrawer(
        initialOpenAccount: currentTabSetting.account,
      ),
    );
  }
}

class BannerArea extends ConsumerWidget {
  final int index;

  const BannerArea({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerAnnouncement = ref.watch(accountRepository.select((value) =>
        value.account
            .where((element) =>
                element ==
                ref
                    .read(tabSettingsRepositoryProvider)
                    .tabSettings
                    .toList()[index]
                    .account)
            .firstOrNull
            ?.i
            .unreadAnnouncements));

    // ダイアログの実装が大変なので（状態管理とか）いったんバナーと一緒に扱う
    final bannerData = bannerAnnouncement
        ?.where((element) =>
            element.display == AnnouncementDisplayType.banner ||
            element.display == AnnouncementDisplayType.dialog)
        .lastOrNull;

    if (bannerData == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10, top: 3, bottom: 3),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Row(
        children: [
          if (bannerData.icon != null)
            AnnouncementIcon(iconType: bannerData.icon!),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Text(
            "${bannerData.title}　${bannerData.text}",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class AnnoucementInfo extends ConsumerWidget {
  final int index;

  const AnnoucementInfo({super.key, required this.index});

  void announcementsRoute(BuildContext context, WidgetRef ref) {
    final account = ref.read(accountRepository.select((value) => value.account
        .where((element) =>
            element ==
            ref
                .read(tabSettingsRepositoryProvider)
                .tabSettings
                .toList()[index]
                .account)
        .firstOrNull));
    if (account == null) return;
    context.pushRoute(AnnouncementRoute(account: account));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUnread = ref.watch(accountRepository.select((value) => value
        .account
        .where((element) =>
            element ==
            ref
                .read(tabSettingsRepositoryProvider)
                .tabSettings
                .toList()[index]
                .account)
        .firstOrNull
        ?.i
        .unreadAnnouncements
        .isNotEmpty));

    if (hasUnread == true) {
      return IconButton(
          onPressed: () => announcementsRoute(context, ref),
          icon: Stack(children: [
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
                )),
          ]));
    } else {
      return IconButton(
          onPressed: () => announcementsRoute(context, ref),
          icon: const Icon(Icons.campaign));
    }
  }
}

class AnnouncementIcon extends StatelessWidget {
  final AnnouncementIconType iconType;

  const AnnouncementIcon({super.key, required this.iconType});

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
