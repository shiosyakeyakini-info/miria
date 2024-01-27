import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/model/tab_type.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/channel_dialog.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/common_drawer.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/notification_icon.dart';
import 'package:miria/view/common/tab_icon_view.dart';
import 'package:miria/view/server_detail_dialog.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:miria/view/timeline_page/misskey_timeline.dart';
import 'package:miria/view/timeline_page/nyanpuppu.dart';
import 'package:miria/view/timeline_page/timeline_emoji.dart';
import 'package:miria/view/timeline_page/timeline_note.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class TimelinePage extends ConsumerWidget {
  TimelinePage({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabSettings = ref.watch(
      tabSettingsRepositoryProvider.select((repo) => repo.tabSettings.toList()),
    );
    final page = ref.watch(timelinePageControllerProvider);
    final currentTabSetting = tabSettings[page.index];
    final tabPosition = ref.watch(
      generalSettingsRepositoryProvider.select(
        (repo) => repo.settings.tabPosition,
      ),
    );
    final error = ref.watch(
      timelineRepositoryProvider(currentTabSetting)
          .select((timeline) => timeline.error),
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: Column(
          children: [
            if (tabPosition == TabPosition.top)
              TimelineAppBar(scaffoldKey: scaffoldKey),
            TabHeader(tabSetting: currentTabSetting),
            Expanded(
              child: PageView.builder(
                controller: page.pageController,
                itemCount: tabSettings.length,
                onPageChanged: ref
                    .read(timelinePageControllerProvider.notifier)
                    .changePage,
                itemBuilder: (_, index) {
                  final tabSetting = tabSettings[index];
                  final account = ref.watch(accountProvider(tabSetting.acct));
                  return AccountScope(
                    account: account,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BannerArea(tabSetting: tabSetting),
                        if (error != null && page.isErrorExpanded)
                          ErrorDetail(
                            error: error.$1,
                            stackTrace: error.$2,
                          ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: ref
                                .read(timelinePageControllerProvider.notifier)
                                .reconnect,
                            child: MisskeyTimeline(tabSetting: tabSetting),
                          ),
                        ),
                        const TimelineEmoji(),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                const Expanded(
                  child: TimelineNoteField(),
                ),
                IconButton(
                  onPressed: ref
                      .read(timelinePageControllerProvider.notifier)
                      .note
                      .expectFailure(context),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => ref
                      .read(timelinePageControllerProvider.notifier)
                      .noteCreateRoute(context),
                  icon: const Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
            if (tabPosition == TabPosition.bottom &&
                !ref.watch(timelineFocusNode).hasFocus)
              TimelineAppBar(scaffoldKey: scaffoldKey),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      drawerEnableOpenDragGesture: true,
      drawer: CommonDrawer(
        initialOpenAcct: currentTabSetting.acct,
      ),
    );
  }
}

class TimelineAppBar extends ConsumerWidget {
  const TimelineAppBar({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabSettings = ref.watch(
      tabSettingsRepositoryProvider.select((repo) => repo.tabSettings.toList()),
    );
    final page = ref.watch(timelinePageControllerProvider);
    final currentTabSetting = tabSettings[page.index];
    final account = ref.watch(accountProvider(currentTabSetting.acct));

    return AppBar(
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabSettings
              .mapIndexed(
                (index, tabSetting) => Builder(
                  builder: (context) {
                    final isCurrentTab = tabSetting == currentTabSetting;
                    final account = ref.watch(accountProvider(tabSetting.acct));

                    return Ink(
                      color: isCurrentTab
                          ? AppTheme.of(context).currentDisplayTabColor
                          : Colors.transparent,
                      child: AccountScope(
                        account: account,
                        child: IconButton(
                          icon: TabIconView(
                            icon: tabSetting.icon,
                            color: isCurrentTab
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                          onPressed: () => isCurrentTab
                              ? ref
                                  .read(timelinePageControllerProvider.notifier)
                                  .forceScrollToTop()
                              : page.pageController.jumpToPage(index),
                        ),
                      ),
                    );
                  },
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        AccountScope(
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
}

class TabHeader extends ConsumerWidget {
  const TabHeader({super.key, required this.tabSetting});

  final TabSetting tabSetting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider(tabSetting.acct));
    final page = ref.watch(timelinePageControllerProvider);
    final (isLoading, hasError) = ref.watch(
      timelineRepositoryProvider(tabSetting)
          .select((timeline) => (timeline.isLoading, timeline.error != null)),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      child: Row(
        children: [
          if (hasError)
            IconButton(
              onPressed: page.isErrorExpanded
                  ? ref.read(timelinePageControllerProvider.notifier).foldError
                  : ref
                      .read(timelinePageControllerProvider.notifier)
                      .expandError,
              tooltip: "エラー",
              icon: page.isErrorExpanded
                  ? const Icon(Icons.error)
                  : const Icon(Icons.error_outline),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5,
                top: 5,
                bottom: 5,
              ),
              child: Text(
                tabSetting.name ?? tabSetting.tabType.displayName(context),
              ),
            ),
          ),
          const Nyanpuppu(),
          if (tabSetting.tabType == TabType.channel)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ChannelDialog(
                    channelId: tabSetting.channelId!,
                    account: account,
                  ),
                );
              },
              icon: const Icon(Icons.info_outline),
            )
          else if (tabSetting.tabType == TabType.userList)
            IconButton(
              onPressed: () {
                context.pushRoute(
                  UsersListDetailRoute(
                    account: account,
                    listId: tabSetting.listId!,
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
          ].contains(tabSetting.tabType)) ...[
            AnnoucementInfo(tabSetting: tabSetting),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ServerDetailDialog(
                    account: account,
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
            onPressed: isLoading
                ? null
                : ref.read(timelinePageControllerProvider.notifier).reconnect,
            icon: isLoading
                ? const CircularProgressIndicator()
                : const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class BannerArea extends ConsumerWidget {
  final TabSetting tabSetting;

  const BannerArea({super.key, required this.tabSetting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerAnnouncement = ref.watch(
      accountProvider(tabSetting.acct)
          .select((account) => account.i.unreadAnnouncements),
    );

    // ダイアログの実装が大変なので（状態管理とか）いったんバナーと一緒に扱う
    final bannerData = bannerAnnouncement
        .where(
          (element) =>
              element.display == AnnouncementDisplayType.banner ||
              element.display == AnnouncementDisplayType.dialog,
        )
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
    );
  }
}

class AnnoucementInfo extends ConsumerWidget {
  final TabSetting tabSetting;

  const AnnoucementInfo({super.key, required this.tabSetting});

  void announcementsRoute(BuildContext context, WidgetRef ref) {
    final account = ref.read(accountProvider(tabSetting.acct));
    context.pushRoute(AnnouncementRoute(account: account));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUnread = ref.watch(
      iProvider(tabSetting.acct)
          .select((i) => i.unreadAnnouncements.isNotEmpty),
    );

    if (hasUnread) {
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
