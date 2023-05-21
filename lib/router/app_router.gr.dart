// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AntennaNotesRoute.name: (routeData) {
      final args = routeData.argsAs<AntennaNotesRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AntennaNotesPage(
          key: args.key,
          antenna: args.antenna,
          account: args.account,
        ),
      );
    },
    AntennaRoute.name: (routeData) {
      final args = routeData.argsAs<AntennaRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AntennaPage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    ChannelsRoute.name: (routeData) {
      final args = routeData.argsAs<ChannelsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChannelsPage(
          key: args.key,
          account: args.account,
        ),
      );
    },
    ChannelDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ChannelDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChannelDetailPage(
          key: args.key,
          account: args.account,
          channelId: args.channelId,
        ),
      );
    },
    ClipDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ClipDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClipDetailPage(
          key: args.key,
          account: args.account,
          id: args.id,
        ),
      );
    },
    ClipListRoute.name: (routeData) {
      final args = routeData.argsAs<ClipListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClipListPage(
          key: args.key,
          account: args.account,
        ),
      );
    },
    FavoritedNoteRoute.name: (routeData) {
      final args = routeData.argsAs<FavoritedNoteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FavoritedNotePage(
          key: args.key,
          account: args.account,
        ),
      );
    },
    HashtagRoute.name: (routeData) {
      final args = routeData.argsAs<HashtagRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HashtagPage(
          key: args.key,
          hashtag: args.hashtag,
          account: args.account,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    NoteCreateRoute.name: (routeData) {
      final args = routeData.argsAs<NoteCreateRouteArgs>(
          orElse: () => const NoteCreateRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NoteCreatePage(
          key: args.key,
          initialAccount: args.initialAccount,
          channel: args.channel,
          reply: args.reply,
          renote: args.renote,
        ),
      );
    },
    NoteSearchRoute.name: (routeData) {
      final args = routeData.argsAs<NoteSearchRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NoteSearchPage(
          key: args.key,
          initialSearchText: args.initialSearchText,
          account: args.account,
        ),
      );
    },
    NotificationRoute.name: (routeData) {
      final args = routeData.argsAs<NotificationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NotificationPage(
          key: args.key,
          account: args.account,
        ),
      );
    },
    AccountListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountListPage(),
      );
    },
    AppInfoRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AppInfoPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    TabSettingsListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TabSettingsListPage(),
      );
    },
    TabSettingsRoute.name: (routeData) {
      final args = routeData.argsAs<TabSettingsRouteArgs>(
          orElse: () => const TabSettingsRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TabSettingsPage(
          key: args.key,
          tabIndex: args.tabIndex,
        ),
      );
    },
    HardMuteRoute.name: (routeData) {
      final args = routeData.argsAs<HardMuteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HardMutePage(
          key: args.key,
          account: args.account,
        ),
      );
    },
    InstanceMuteRoute.name: (routeData) {
      final args = routeData.argsAs<InstanceMuteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: InstanceMutePage(
          key: args.key,
          account: args.account,
        ),
      );
    },
    ReactionDeckRoute.name: (routeData) {
      final args = routeData.argsAs<ReactionDeckRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ReactionDeckPage(
          key: args.key,
          account: args.account,
        ),
      );
    },
    SeveralAccountSettingsRoute.name: (routeData) {
      final args = routeData.argsAs<SeveralAccountSettingsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SeveralAccountSettingsPage(
          key: args.key,
          account: args.account,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    TimeLineRoute.name: (routeData) {
      final args = routeData.argsAs<TimeLineRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TimeLinePage(
          key: args.key,
          currentTabSetting: args.currentTabSetting,
        ),
      );
    },
    UsersListRoute.name: (routeData) {
      final args = routeData.argsAs<UsersListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UsersListPage(
          args.account,
          key: args.key,
        ),
      );
    },
    UsersListTimelineRoute.name: (routeData) {
      final args = routeData.argsAs<UsersListTimelineRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UsersListTimelinePage(
          args.account,
          args.listId,
          key: args.key,
        ),
      );
    },
    UserFolloweeRoute.name: (routeData) {
      final args = routeData.argsAs<UserFolloweeRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserFolloweePage(
          key: args.key,
          userId: args.userId,
          account: args.account,
        ),
      );
    },
    UserFollowerRoute.name: (routeData) {
      final args = routeData.argsAs<UserFollowerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserFollowerPage(
          key: args.key,
          userId: args.userId,
          account: args.account,
        ),
      );
    },
    UserRoute.name: (routeData) {
      final args = routeData.argsAs<UserRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserPage(
          key: args.key,
          userId: args.userId,
          account: args.account,
        ),
      );
    },
  };
}

/// generated route for
/// [AntennaNotesPage]
class AntennaNotesRoute extends PageRouteInfo<AntennaNotesRouteArgs> {
  AntennaNotesRoute({
    Key? key,
    required Antenna antenna,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          AntennaNotesRoute.name,
          args: AntennaNotesRouteArgs(
            key: key,
            antenna: antenna,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'AntennaNotesRoute';

  static const PageInfo<AntennaNotesRouteArgs> page =
      PageInfo<AntennaNotesRouteArgs>(name);
}

class AntennaNotesRouteArgs {
  const AntennaNotesRouteArgs({
    this.key,
    required this.antenna,
    required this.account,
  });

  final Key? key;

  final Antenna antenna;

  final Account account;

  @override
  String toString() {
    return 'AntennaNotesRouteArgs{key: $key, antenna: $antenna, account: $account}';
  }
}

/// generated route for
/// [AntennaPage]
class AntennaRoute extends PageRouteInfo<AntennaRouteArgs> {
  AntennaRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          AntennaRoute.name,
          args: AntennaRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AntennaRoute';

  static const PageInfo<AntennaRouteArgs> page =
      PageInfo<AntennaRouteArgs>(name);
}

class AntennaRouteArgs {
  const AntennaRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'AntennaRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [ChannelsPage]
class ChannelsRoute extends PageRouteInfo<ChannelsRouteArgs> {
  ChannelsRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          ChannelsRoute.name,
          args: ChannelsRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'ChannelsRoute';

  static const PageInfo<ChannelsRouteArgs> page =
      PageInfo<ChannelsRouteArgs>(name);
}

class ChannelsRouteArgs {
  const ChannelsRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'ChannelsRouteArgs{key: $key, account: $account}';
  }
}

/// generated route for
/// [ChannelDetailPage]
class ChannelDetailRoute extends PageRouteInfo<ChannelDetailRouteArgs> {
  ChannelDetailRoute({
    Key? key,
    required Account account,
    required String channelId,
    List<PageRouteInfo>? children,
  }) : super(
          ChannelDetailRoute.name,
          args: ChannelDetailRouteArgs(
            key: key,
            account: account,
            channelId: channelId,
          ),
          initialChildren: children,
        );

  static const String name = 'ChannelDetailRoute';

  static const PageInfo<ChannelDetailRouteArgs> page =
      PageInfo<ChannelDetailRouteArgs>(name);
}

class ChannelDetailRouteArgs {
  const ChannelDetailRouteArgs({
    this.key,
    required this.account,
    required this.channelId,
  });

  final Key? key;

  final Account account;

  final String channelId;

  @override
  String toString() {
    return 'ChannelDetailRouteArgs{key: $key, account: $account, channelId: $channelId}';
  }
}

/// generated route for
/// [ClipDetailPage]
class ClipDetailRoute extends PageRouteInfo<ClipDetailRouteArgs> {
  ClipDetailRoute({
    Key? key,
    required Account account,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          ClipDetailRoute.name,
          args: ClipDetailRouteArgs(
            key: key,
            account: account,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'ClipDetailRoute';

  static const PageInfo<ClipDetailRouteArgs> page =
      PageInfo<ClipDetailRouteArgs>(name);
}

class ClipDetailRouteArgs {
  const ClipDetailRouteArgs({
    this.key,
    required this.account,
    required this.id,
  });

  final Key? key;

  final Account account;

  final String id;

  @override
  String toString() {
    return 'ClipDetailRouteArgs{key: $key, account: $account, id: $id}';
  }
}

/// generated route for
/// [ClipListPage]
class ClipListRoute extends PageRouteInfo<ClipListRouteArgs> {
  ClipListRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          ClipListRoute.name,
          args: ClipListRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'ClipListRoute';

  static const PageInfo<ClipListRouteArgs> page =
      PageInfo<ClipListRouteArgs>(name);
}

class ClipListRouteArgs {
  const ClipListRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'ClipListRouteArgs{key: $key, account: $account}';
  }
}

/// generated route for
/// [FavoritedNotePage]
class FavoritedNoteRoute extends PageRouteInfo<FavoritedNoteRouteArgs> {
  FavoritedNoteRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          FavoritedNoteRoute.name,
          args: FavoritedNoteRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'FavoritedNoteRoute';

  static const PageInfo<FavoritedNoteRouteArgs> page =
      PageInfo<FavoritedNoteRouteArgs>(name);
}

class FavoritedNoteRouteArgs {
  const FavoritedNoteRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'FavoritedNoteRouteArgs{key: $key, account: $account}';
  }
}

/// generated route for
/// [HashtagPage]
class HashtagRoute extends PageRouteInfo<HashtagRouteArgs> {
  HashtagRoute({
    Key? key,
    required String hashtag,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          HashtagRoute.name,
          args: HashtagRouteArgs(
            key: key,
            hashtag: hashtag,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'HashtagRoute';

  static const PageInfo<HashtagRouteArgs> page =
      PageInfo<HashtagRouteArgs>(name);
}

class HashtagRouteArgs {
  const HashtagRouteArgs({
    this.key,
    required this.hashtag,
    required this.account,
  });

  final Key? key;

  final String hashtag;

  final Account account;

  @override
  String toString() {
    return 'HashtagRouteArgs{key: $key, hashtag: $hashtag, account: $account}';
  }
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [NoteCreatePage]
class NoteCreateRoute extends PageRouteInfo<NoteCreateRouteArgs> {
  NoteCreateRoute({
    Key? key,
    Account? initialAccount,
    CommunityChannel? channel,
    Note? reply,
    Note? renote,
    List<PageRouteInfo>? children,
  }) : super(
          NoteCreateRoute.name,
          args: NoteCreateRouteArgs(
            key: key,
            initialAccount: initialAccount,
            channel: channel,
            reply: reply,
            renote: renote,
          ),
          initialChildren: children,
        );

  static const String name = 'NoteCreateRoute';

  static const PageInfo<NoteCreateRouteArgs> page =
      PageInfo<NoteCreateRouteArgs>(name);
}

class NoteCreateRouteArgs {
  const NoteCreateRouteArgs({
    this.key,
    this.initialAccount,
    this.channel,
    this.reply,
    this.renote,
  });

  final Key? key;

  final Account? initialAccount;

  final CommunityChannel? channel;

  final Note? reply;

  final Note? renote;

  @override
  String toString() {
    return 'NoteCreateRouteArgs{key: $key, initialAccount: $initialAccount, channel: $channel, reply: $reply, renote: $renote}';
  }
}

/// generated route for
/// [NoteSearchPage]
class NoteSearchRoute extends PageRouteInfo<NoteSearchRouteArgs> {
  NoteSearchRoute({
    Key? key,
    String? initialSearchText,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          NoteSearchRoute.name,
          args: NoteSearchRouteArgs(
            key: key,
            initialSearchText: initialSearchText,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'NoteSearchRoute';

  static const PageInfo<NoteSearchRouteArgs> page =
      PageInfo<NoteSearchRouteArgs>(name);
}

class NoteSearchRouteArgs {
  const NoteSearchRouteArgs({
    this.key,
    this.initialSearchText,
    required this.account,
  });

  final Key? key;

  final String? initialSearchText;

  final Account account;

  @override
  String toString() {
    return 'NoteSearchRouteArgs{key: $key, initialSearchText: $initialSearchText, account: $account}';
  }
}

/// generated route for
/// [NotificationPage]
class NotificationRoute extends PageRouteInfo<NotificationRouteArgs> {
  NotificationRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          NotificationRoute.name,
          args: NotificationRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const PageInfo<NotificationRouteArgs> page =
      PageInfo<NotificationRouteArgs>(name);
}

class NotificationRouteArgs {
  const NotificationRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'NotificationRouteArgs{key: $key, account: $account}';
  }
}

/// generated route for
/// [AccountListPage]
class AccountListRoute extends PageRouteInfo<void> {
  const AccountListRoute({List<PageRouteInfo>? children})
      : super(
          AccountListRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AppInfoPage]
class AppInfoRoute extends PageRouteInfo<void> {
  const AppInfoRoute({List<PageRouteInfo>? children})
      : super(
          AppInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppInfoRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TabSettingsListPage]
class TabSettingsListRoute extends PageRouteInfo<void> {
  const TabSettingsListRoute({List<PageRouteInfo>? children})
      : super(
          TabSettingsListRoute.name,
          initialChildren: children,
        );

  static const String name = 'TabSettingsListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TabSettingsPage]
class TabSettingsRoute extends PageRouteInfo<TabSettingsRouteArgs> {
  TabSettingsRoute({
    Key? key,
    int? tabIndex,
    List<PageRouteInfo>? children,
  }) : super(
          TabSettingsRoute.name,
          args: TabSettingsRouteArgs(
            key: key,
            tabIndex: tabIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'TabSettingsRoute';

  static const PageInfo<TabSettingsRouteArgs> page =
      PageInfo<TabSettingsRouteArgs>(name);
}

class TabSettingsRouteArgs {
  const TabSettingsRouteArgs({
    this.key,
    this.tabIndex,
  });

  final Key? key;

  final int? tabIndex;

  @override
  String toString() {
    return 'TabSettingsRouteArgs{key: $key, tabIndex: $tabIndex}';
  }
}

/// generated route for
/// [HardMutePage]
class HardMuteRoute extends PageRouteInfo<HardMuteRouteArgs> {
  HardMuteRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          HardMuteRoute.name,
          args: HardMuteRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'HardMuteRoute';

  static const PageInfo<HardMuteRouteArgs> page =
      PageInfo<HardMuteRouteArgs>(name);
}

class HardMuteRouteArgs {
  const HardMuteRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'HardMuteRouteArgs{key: $key, account: $account}';
  }
}

/// generated route for
/// [InstanceMutePage]
class InstanceMuteRoute extends PageRouteInfo<InstanceMuteRouteArgs> {
  InstanceMuteRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          InstanceMuteRoute.name,
          args: InstanceMuteRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'InstanceMuteRoute';

  static const PageInfo<InstanceMuteRouteArgs> page =
      PageInfo<InstanceMuteRouteArgs>(name);
}

class InstanceMuteRouteArgs {
  const InstanceMuteRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'InstanceMuteRouteArgs{key: $key, account: $account}';
  }
}

/// generated route for
/// [ReactionDeckPage]
class ReactionDeckRoute extends PageRouteInfo<ReactionDeckRouteArgs> {
  ReactionDeckRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          ReactionDeckRoute.name,
          args: ReactionDeckRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'ReactionDeckRoute';

  static const PageInfo<ReactionDeckRouteArgs> page =
      PageInfo<ReactionDeckRouteArgs>(name);
}

class ReactionDeckRouteArgs {
  const ReactionDeckRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'ReactionDeckRouteArgs{key: $key, account: $account}';
  }
}

/// generated route for
/// [SeveralAccountSettingsPage]
class SeveralAccountSettingsRoute
    extends PageRouteInfo<SeveralAccountSettingsRouteArgs> {
  SeveralAccountSettingsRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          SeveralAccountSettingsRoute.name,
          args: SeveralAccountSettingsRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'SeveralAccountSettingsRoute';

  static const PageInfo<SeveralAccountSettingsRouteArgs> page =
      PageInfo<SeveralAccountSettingsRouteArgs>(name);
}

class SeveralAccountSettingsRouteArgs {
  const SeveralAccountSettingsRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'SeveralAccountSettingsRouteArgs{key: $key, account: $account}';
  }
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TimeLinePage]
class TimeLineRoute extends PageRouteInfo<TimeLineRouteArgs> {
  TimeLineRoute({
    Key? key,
    required TabSetting currentTabSetting,
    List<PageRouteInfo>? children,
  }) : super(
          TimeLineRoute.name,
          args: TimeLineRouteArgs(
            key: key,
            currentTabSetting: currentTabSetting,
          ),
          initialChildren: children,
        );

  static const String name = 'TimeLineRoute';

  static const PageInfo<TimeLineRouteArgs> page =
      PageInfo<TimeLineRouteArgs>(name);
}

class TimeLineRouteArgs {
  const TimeLineRouteArgs({
    this.key,
    required this.currentTabSetting,
  });

  final Key? key;

  final TabSetting currentTabSetting;

  @override
  String toString() {
    return 'TimeLineRouteArgs{key: $key, currentTabSetting: $currentTabSetting}';
  }
}

/// generated route for
/// [UsersListPage]
class UsersListRoute extends PageRouteInfo<UsersListRouteArgs> {
  UsersListRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UsersListRoute.name,
          args: UsersListRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'UsersListRoute';

  static const PageInfo<UsersListRouteArgs> page =
      PageInfo<UsersListRouteArgs>(name);
}

class UsersListRouteArgs {
  const UsersListRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'UsersListRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [UsersListTimelinePage]
class UsersListTimelineRoute extends PageRouteInfo<UsersListTimelineRouteArgs> {
  UsersListTimelineRoute({
    required Account account,
    required String listId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UsersListTimelineRoute.name,
          args: UsersListTimelineRouteArgs(
            account: account,
            listId: listId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'UsersListTimelineRoute';

  static const PageInfo<UsersListTimelineRouteArgs> page =
      PageInfo<UsersListTimelineRouteArgs>(name);
}

class UsersListTimelineRouteArgs {
  const UsersListTimelineRouteArgs({
    required this.account,
    required this.listId,
    this.key,
  });

  final Account account;

  final String listId;

  final Key? key;

  @override
  String toString() {
    return 'UsersListTimelineRouteArgs{account: $account, listId: $listId, key: $key}';
  }
}

/// generated route for
/// [UserFolloweePage]
class UserFolloweeRoute extends PageRouteInfo<UserFolloweeRouteArgs> {
  UserFolloweeRoute({
    Key? key,
    required String userId,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          UserFolloweeRoute.name,
          args: UserFolloweeRouteArgs(
            key: key,
            userId: userId,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'UserFolloweeRoute';

  static const PageInfo<UserFolloweeRouteArgs> page =
      PageInfo<UserFolloweeRouteArgs>(name);
}

class UserFolloweeRouteArgs {
  const UserFolloweeRouteArgs({
    this.key,
    required this.userId,
    required this.account,
  });

  final Key? key;

  final String userId;

  final Account account;

  @override
  String toString() {
    return 'UserFolloweeRouteArgs{key: $key, userId: $userId, account: $account}';
  }
}

/// generated route for
/// [UserFollowerPage]
class UserFollowerRoute extends PageRouteInfo<UserFollowerRouteArgs> {
  UserFollowerRoute({
    Key? key,
    required String userId,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          UserFollowerRoute.name,
          args: UserFollowerRouteArgs(
            key: key,
            userId: userId,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'UserFollowerRoute';

  static const PageInfo<UserFollowerRouteArgs> page =
      PageInfo<UserFollowerRouteArgs>(name);
}

class UserFollowerRouteArgs {
  const UserFollowerRouteArgs({
    this.key,
    required this.userId,
    required this.account,
  });

  final Key? key;

  final String userId;

  final Account account;

  @override
  String toString() {
    return 'UserFollowerRouteArgs{key: $key, userId: $userId, account: $account}';
  }
}

/// generated route for
/// [UserPage]
class UserRoute extends PageRouteInfo<UserRouteArgs> {
  UserRoute({
    Key? key,
    required String userId,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          UserRoute.name,
          args: UserRouteArgs(
            key: key,
            userId: userId,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'UserRoute';

  static const PageInfo<UserRouteArgs> page = PageInfo<UserRouteArgs>(name);
}

class UserRouteArgs {
  const UserRouteArgs({
    this.key,
    required this.userId,
    required this.account,
  });

  final Key? key;

  final String userId;

  final Account account;

  @override
  String toString() {
    return 'UserRouteArgs{key: $key, userId: $userId, account: $account}';
  }
}
