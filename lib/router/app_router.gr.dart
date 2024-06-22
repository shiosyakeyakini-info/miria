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
    AbuseRoute.name: (routeData) {
      final args = routeData.argsAs<AbuseRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(
            child: AbuseDialog(
          account: args.account,
          targetUser: args.targetUser,
          key: args.key,
          defaultText: args.defaultText,
        )),
      );
    },
    AccountListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountListPage(),
      );
    },
    AnnouncementRoute.name: (routeData) {
      final args = routeData.argsAs<AnnouncementRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AnnouncementPage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    AntennaModalRoute.name: (routeData) {
      final args = routeData.argsAs<AntennaModalRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AntennaModalSheet(
          account: args.account,
          user: args.user,
          key: args.key,
        ),
      );
    },
    AntennaNotesRoute.name: (routeData) {
      final args = routeData.argsAs<AntennaNotesRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AntennaNotesPage(
          antenna: args.antenna,
          account: args.account,
          key: args.key,
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
    AppInfoRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AppInfoPage(),
      );
    },
    CacheManagementRoute.name: (routeData) {
      final args = routeData.argsAs<CacheManagementRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CacheManagementPage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    ChannelDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ChannelDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChannelDetailPage(
          account: args.account,
          channelId: args.channelId,
          key: args.key,
        ),
      );
    },
    ChannelRoute.name: (routeData) {
      final args = routeData.argsAs<ChannelRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(
            child: ChannelDialog(
          channelId: args.channelId,
          account: args.account,
          key: args.key,
        )),
      );
    },
    ChannelSelectRoute.name: (routeData) {
      final args = routeData.argsAs<ChannelSelectRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChannelSelectDialog(
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
          account: args.account,
          key: args.key,
        ),
      );
    },
    ClipDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ClipDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClipDetailPage(
          account: args.account,
          id: args.id,
          key: args.key,
        ),
      );
    },
    ClipListRoute.name: (routeData) {
      final args = routeData.argsAs<ClipListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ClipListPage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    ExpireSelectRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ExpireSelectDialog(),
      );
    },
    ExploreRoute.name: (routeData) {
      final args = routeData.argsAs<ExploreRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ExplorePage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    ExploreRoleUsersRoute.name: (routeData) {
      final args = routeData.argsAs<ExploreRoleUsersRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ExploreRoleUsersPage(
          item: args.item,
          account: args.account,
          key: args.key,
        ),
      );
    },
    FavoritedNoteRoute.name: (routeData) {
      final args = routeData.argsAs<FavoritedNoteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FavoritedNotePage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    FederationRoute.name: (routeData) {
      final args = routeData.argsAs<FederationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FederationPage(
          account: args.account,
          host: args.host,
          key: args.key,
        ),
      );
    },
    GeneralSettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GeneralSettingsPage(),
      );
    },
    HashtagRoute.name: (routeData) {
      final args = routeData.argsAs<HashtagRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HashtagPage(
          hashtag: args.hashtag,
          account: args.account,
          key: args.key,
        ),
      );
    },
    ImportExportRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ImportExportPage(),
      );
    },
    InstanceMuteRoute.name: (routeData) {
      final args = routeData.argsAs<InstanceMuteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: InstanceMutePage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    MisskeyGamesRoute.name: (routeData) {
      final args = routeData.argsAs<MisskeyGamesRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MisskeyGamesPage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    MisskeyRouteRoute.name: (routeData) {
      final args = routeData.argsAs<MisskeyRouteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MisskeyPagePage(
          account: args.account,
          page: args.page,
          key: args.key,
        ),
      );
    },
    NoteCreateRoute.name: (routeData) {
      final args = routeData.argsAs<NoteCreateRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NoteCreatePage(
          initialAccount: args.initialAccount,
          key: args.key,
          initialText: args.initialText,
          initialMediaFiles: args.initialMediaFiles,
          exitOnNoted: args.exitOnNoted,
          channel: args.channel,
          reply: args.reply,
          renote: args.renote,
          note: args.note,
          noteCreationMode: args.noteCreationMode,
        ),
      );
    },
    NoteDetailRoute.name: (routeData) {
      final args = routeData.argsAs<NoteDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NoteDetailPage(
          note: args.note,
          account: args.account,
          key: args.key,
        ),
      );
    },
    NoteModalRoute.name: (routeData) {
      final args = routeData.argsAs<NoteModalRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NoteModalSheet(
          baseNote: args.baseNote,
          targetNote: args.targetNote,
          account: args.account,
          noteBoundaryKey: args.noteBoundaryKey,
          key: args.key,
        ),
      );
    },
    NotesAfterRenoteRoute.name: (routeData) {
      final args = routeData.argsAs<NotesAfterRenoteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NotesAfterRenotePage(
          note: args.note,
          account: args.account,
          key: args.key,
        ),
      );
    },
    NotificationRoute.name: (routeData) {
      final args = routeData.argsAs<NotificationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NotificationPage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    PhotoEditRoute.name: (routeData) {
      final args = routeData.argsAs<PhotoEditRouteArgs>();
      return AutoRoutePage<Uint8List?>(
        routeData: routeData,
        child: PhotoEditPage(
          account: args.account,
          file: args.file,
          onSubmit: args.onSubmit,
          key: args.key,
        ),
      );
    },
    ReactionDeckRoute.name: (routeData) {
      final args = routeData.argsAs<ReactionDeckRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ReactionDeckPage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    RenoteModalRoute.name: (routeData) {
      final args = routeData.argsAs<RenoteModalRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: RenoteModalSheet(
          note: args.note,
          account: args.account,
          key: args.key,
        ),
      );
    },
    RenoteUserRoute.name: (routeData) {
      final args = routeData.argsAs<RenoteUserRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(
            child: RenoteUserDialog(
          account: args.account,
          noteId: args.noteId,
          key: args.key,
        )),
      );
    },
    SearchRoute.name: (routeData) {
      final args = routeData.argsAs<SearchRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SearchPage(
          account: args.account,
          key: args.key,
          initialNoteSearchCondition: args.initialNoteSearchCondition,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    SeveralAccountGeneralSettingsRoute.name: (routeData) {
      final args = routeData.argsAs<SeveralAccountGeneralSettingsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SeveralAccountGeneralSettingsPage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    SeveralAccountSettingsRoute.name: (routeData) {
      final args = routeData.argsAs<SeveralAccountSettingsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SeveralAccountSettingsPage(
          account: args.account,
          key: args.key,
        ),
      );
    },
    ShareExtensionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ShareExtensionPage(),
      );
    },
    SharingAccountSelectRoute.name: (routeData) {
      final args = routeData.argsAs<SharingAccountSelectRouteArgs>(
          orElse: () => const SharingAccountSelectRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SharingAccountSelectPage(
          key: args.key,
          sharingText: args.sharingText,
          filePath: args.filePath,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
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
    TimeLineRoute.name: (routeData) {
      final args = routeData.argsAs<TimeLineRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TimeLinePage(
          initialTabSetting: args.initialTabSetting,
          key: args.key,
        ),
      );
    },
    UpdateMemoRoute.name: (routeData) {
      final args = routeData.argsAs<UpdateMemoRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UpdateMemoDialog(
          account: args.account,
          initialMemo: args.initialMemo,
          userId: args.userId,
          key: args.key,
        ),
      );
    },
    UserControlRoute.name: (routeData) {
      final args = routeData.argsAs<UserControlRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(
            child: UserControlDialog(
          account: args.account,
          response: args.response,
          key: args.key,
        )),
      );
    },
    UserFolloweeRoute.name: (routeData) {
      final args = routeData.argsAs<UserFolloweeRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserFolloweePage(
          userId: args.userId,
          account: args.account,
          key: args.key,
        ),
      );
    },
    UserFollowerRoute.name: (routeData) {
      final args = routeData.argsAs<UserFollowerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserFollowerPage(
          userId: args.userId,
          account: args.account,
          key: args.key,
        ),
      );
    },
    UserRoute.name: (routeData) {
      final args = routeData.argsAs<UserRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserPage(
          userId: args.userId,
          account: args.account,
          key: args.key,
        ),
      );
    },
    UsersListDetailRoute.name: (routeData) {
      final args = routeData.argsAs<UsersListDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UsersListDetailPage(
          account: args.account,
          listId: args.listId,
          key: args.key,
        ),
      );
    },
    UsersListModalRoute.name: (routeData) {
      final args = routeData.argsAs<UsersListModalRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UsersListModalSheet(
          account: args.account,
          user: args.user,
          key: args.key,
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
          args.list,
          key: args.key,
        ),
      );
    },
    WordMuteRoute.name: (routeData) {
      final args = routeData.argsAs<WordMuteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WordMutePage(
          account: args.account,
          muteType: args.muteType,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [AbuseDialog]
class AbuseRoute extends PageRouteInfo<AbuseRouteArgs> {
  AbuseRoute({
    required Account account,
    required User targetUser,
    Key? key,
    String? defaultText,
    List<PageRouteInfo>? children,
  }) : super(
          AbuseRoute.name,
          args: AbuseRouteArgs(
            account: account,
            targetUser: targetUser,
            key: key,
            defaultText: defaultText,
          ),
          initialChildren: children,
        );

  static const String name = 'AbuseRoute';

  static const PageInfo<AbuseRouteArgs> page = PageInfo<AbuseRouteArgs>(name);
}

class AbuseRouteArgs {
  const AbuseRouteArgs({
    required this.account,
    required this.targetUser,
    this.key,
    this.defaultText,
  });

  final Account account;

  final User targetUser;

  final Key? key;

  final String? defaultText;

  @override
  String toString() {
    return 'AbuseRouteArgs{account: $account, targetUser: $targetUser, key: $key, defaultText: $defaultText}';
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
/// [AnnouncementPage]
class AnnouncementRoute extends PageRouteInfo<AnnouncementRouteArgs> {
  AnnouncementRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          AnnouncementRoute.name,
          args: AnnouncementRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AnnouncementRoute';

  static const PageInfo<AnnouncementRouteArgs> page =
      PageInfo<AnnouncementRouteArgs>(name);
}

class AnnouncementRouteArgs {
  const AnnouncementRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'AnnouncementRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [AntennaModalSheet]
class AntennaModalRoute extends PageRouteInfo<AntennaModalRouteArgs> {
  AntennaModalRoute({
    required Account account,
    required User user,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          AntennaModalRoute.name,
          args: AntennaModalRouteArgs(
            account: account,
            user: user,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AntennaModalRoute';

  static const PageInfo<AntennaModalRouteArgs> page =
      PageInfo<AntennaModalRouteArgs>(name);
}

class AntennaModalRouteArgs {
  const AntennaModalRouteArgs({
    required this.account,
    required this.user,
    this.key,
  });

  final Account account;

  final User user;

  final Key? key;

  @override
  String toString() {
    return 'AntennaModalRouteArgs{account: $account, user: $user, key: $key}';
  }
}

/// generated route for
/// [AntennaNotesPage]
class AntennaNotesRoute extends PageRouteInfo<AntennaNotesRouteArgs> {
  AntennaNotesRoute({
    required Antenna antenna,
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          AntennaNotesRoute.name,
          args: AntennaNotesRouteArgs(
            antenna: antenna,
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AntennaNotesRoute';

  static const PageInfo<AntennaNotesRouteArgs> page =
      PageInfo<AntennaNotesRouteArgs>(name);
}

class AntennaNotesRouteArgs {
  const AntennaNotesRouteArgs({
    required this.antenna,
    required this.account,
    this.key,
  });

  final Antenna antenna;

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'AntennaNotesRouteArgs{antenna: $antenna, account: $account, key: $key}';
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
/// [CacheManagementPage]
class CacheManagementRoute extends PageRouteInfo<CacheManagementRouteArgs> {
  CacheManagementRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          CacheManagementRoute.name,
          args: CacheManagementRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'CacheManagementRoute';

  static const PageInfo<CacheManagementRouteArgs> page =
      PageInfo<CacheManagementRouteArgs>(name);
}

class CacheManagementRouteArgs {
  const CacheManagementRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'CacheManagementRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [ChannelDetailPage]
class ChannelDetailRoute extends PageRouteInfo<ChannelDetailRouteArgs> {
  ChannelDetailRoute({
    required Account account,
    required String channelId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ChannelDetailRoute.name,
          args: ChannelDetailRouteArgs(
            account: account,
            channelId: channelId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ChannelDetailRoute';

  static const PageInfo<ChannelDetailRouteArgs> page =
      PageInfo<ChannelDetailRouteArgs>(name);
}

class ChannelDetailRouteArgs {
  const ChannelDetailRouteArgs({
    required this.account,
    required this.channelId,
    this.key,
  });

  final Account account;

  final String channelId;

  final Key? key;

  @override
  String toString() {
    return 'ChannelDetailRouteArgs{account: $account, channelId: $channelId, key: $key}';
  }
}

/// generated route for
/// [ChannelDialog]
class ChannelRoute extends PageRouteInfo<ChannelRouteArgs> {
  ChannelRoute({
    required String channelId,
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ChannelRoute.name,
          args: ChannelRouteArgs(
            channelId: channelId,
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ChannelRoute';

  static const PageInfo<ChannelRouteArgs> page =
      PageInfo<ChannelRouteArgs>(name);
}

class ChannelRouteArgs {
  const ChannelRouteArgs({
    required this.channelId,
    required this.account,
    this.key,
  });

  final String channelId;

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'ChannelRouteArgs{channelId: $channelId, account: $account, key: $key}';
  }
}

/// generated route for
/// [ChannelSelectDialog]
class ChannelSelectRoute extends PageRouteInfo<ChannelSelectRouteArgs> {
  ChannelSelectRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ChannelSelectRoute.name,
          args: ChannelSelectRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ChannelSelectRoute';

  static const PageInfo<ChannelSelectRouteArgs> page =
      PageInfo<ChannelSelectRouteArgs>(name);
}

class ChannelSelectRouteArgs {
  const ChannelSelectRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'ChannelSelectRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [ChannelsPage]
class ChannelsRoute extends PageRouteInfo<ChannelsRouteArgs> {
  ChannelsRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ChannelsRoute.name,
          args: ChannelsRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ChannelsRoute';

  static const PageInfo<ChannelsRouteArgs> page =
      PageInfo<ChannelsRouteArgs>(name);
}

class ChannelsRouteArgs {
  const ChannelsRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'ChannelsRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [ClipDetailPage]
class ClipDetailRoute extends PageRouteInfo<ClipDetailRouteArgs> {
  ClipDetailRoute({
    required Account account,
    required String id,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ClipDetailRoute.name,
          args: ClipDetailRouteArgs(
            account: account,
            id: id,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ClipDetailRoute';

  static const PageInfo<ClipDetailRouteArgs> page =
      PageInfo<ClipDetailRouteArgs>(name);
}

class ClipDetailRouteArgs {
  const ClipDetailRouteArgs({
    required this.account,
    required this.id,
    this.key,
  });

  final Account account;

  final String id;

  final Key? key;

  @override
  String toString() {
    return 'ClipDetailRouteArgs{account: $account, id: $id, key: $key}';
  }
}

/// generated route for
/// [ClipListPage]
class ClipListRoute extends PageRouteInfo<ClipListRouteArgs> {
  ClipListRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ClipListRoute.name,
          args: ClipListRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ClipListRoute';

  static const PageInfo<ClipListRouteArgs> page =
      PageInfo<ClipListRouteArgs>(name);
}

class ClipListRouteArgs {
  const ClipListRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'ClipListRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [ExpireSelectDialog]
class ExpireSelectRoute extends PageRouteInfo<void> {
  const ExpireSelectRoute({List<PageRouteInfo>? children})
      : super(
          ExpireSelectRoute.name,
          initialChildren: children,
        );

  static const String name = 'ExpireSelectRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ExplorePage]
class ExploreRoute extends PageRouteInfo<ExploreRouteArgs> {
  ExploreRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ExploreRoute.name,
          args: ExploreRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ExploreRoute';

  static const PageInfo<ExploreRouteArgs> page =
      PageInfo<ExploreRouteArgs>(name);
}

class ExploreRouteArgs {
  const ExploreRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'ExploreRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [ExploreRoleUsersPage]
class ExploreRoleUsersRoute extends PageRouteInfo<ExploreRoleUsersRouteArgs> {
  ExploreRoleUsersRoute({
    required RolesListResponse item,
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ExploreRoleUsersRoute.name,
          args: ExploreRoleUsersRouteArgs(
            item: item,
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ExploreRoleUsersRoute';

  static const PageInfo<ExploreRoleUsersRouteArgs> page =
      PageInfo<ExploreRoleUsersRouteArgs>(name);
}

class ExploreRoleUsersRouteArgs {
  const ExploreRoleUsersRouteArgs({
    required this.item,
    required this.account,
    this.key,
  });

  final RolesListResponse item;

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'ExploreRoleUsersRouteArgs{item: $item, account: $account, key: $key}';
  }
}

/// generated route for
/// [FavoritedNotePage]
class FavoritedNoteRoute extends PageRouteInfo<FavoritedNoteRouteArgs> {
  FavoritedNoteRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          FavoritedNoteRoute.name,
          args: FavoritedNoteRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'FavoritedNoteRoute';

  static const PageInfo<FavoritedNoteRouteArgs> page =
      PageInfo<FavoritedNoteRouteArgs>(name);
}

class FavoritedNoteRouteArgs {
  const FavoritedNoteRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'FavoritedNoteRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [FederationPage]
class FederationRoute extends PageRouteInfo<FederationRouteArgs> {
  FederationRoute({
    required Account account,
    required String host,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          FederationRoute.name,
          args: FederationRouteArgs(
            account: account,
            host: host,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'FederationRoute';

  static const PageInfo<FederationRouteArgs> page =
      PageInfo<FederationRouteArgs>(name);
}

class FederationRouteArgs {
  const FederationRouteArgs({
    required this.account,
    required this.host,
    this.key,
  });

  final Account account;

  final String host;

  final Key? key;

  @override
  String toString() {
    return 'FederationRouteArgs{account: $account, host: $host, key: $key}';
  }
}

/// generated route for
/// [GeneralSettingsPage]
class GeneralSettingsRoute extends PageRouteInfo<void> {
  const GeneralSettingsRoute({List<PageRouteInfo>? children})
      : super(
          GeneralSettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'GeneralSettingsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HashtagPage]
class HashtagRoute extends PageRouteInfo<HashtagRouteArgs> {
  HashtagRoute({
    required String hashtag,
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          HashtagRoute.name,
          args: HashtagRouteArgs(
            hashtag: hashtag,
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'HashtagRoute';

  static const PageInfo<HashtagRouteArgs> page =
      PageInfo<HashtagRouteArgs>(name);
}

class HashtagRouteArgs {
  const HashtagRouteArgs({
    required this.hashtag,
    required this.account,
    this.key,
  });

  final String hashtag;

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'HashtagRouteArgs{hashtag: $hashtag, account: $account, key: $key}';
  }
}

/// generated route for
/// [ImportExportPage]
class ImportExportRoute extends PageRouteInfo<void> {
  const ImportExportRoute({List<PageRouteInfo>? children})
      : super(
          ImportExportRoute.name,
          initialChildren: children,
        );

  static const String name = 'ImportExportRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [InstanceMutePage]
class InstanceMuteRoute extends PageRouteInfo<InstanceMuteRouteArgs> {
  InstanceMuteRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          InstanceMuteRoute.name,
          args: InstanceMuteRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'InstanceMuteRoute';

  static const PageInfo<InstanceMuteRouteArgs> page =
      PageInfo<InstanceMuteRouteArgs>(name);
}

class InstanceMuteRouteArgs {
  const InstanceMuteRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'InstanceMuteRouteArgs{account: $account, key: $key}';
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
/// [MisskeyGamesPage]
class MisskeyGamesRoute extends PageRouteInfo<MisskeyGamesRouteArgs> {
  MisskeyGamesRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          MisskeyGamesRoute.name,
          args: MisskeyGamesRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'MisskeyGamesRoute';

  static const PageInfo<MisskeyGamesRouteArgs> page =
      PageInfo<MisskeyGamesRouteArgs>(name);
}

class MisskeyGamesRouteArgs {
  const MisskeyGamesRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'MisskeyGamesRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [MisskeyPagePage]
class MisskeyRouteRoute extends PageRouteInfo<MisskeyRouteRouteArgs> {
  MisskeyRouteRoute({
    required Account account,
    required Page page,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          MisskeyRouteRoute.name,
          args: MisskeyRouteRouteArgs(
            account: account,
            page: page,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'MisskeyRouteRoute';

  static const PageInfo<MisskeyRouteRouteArgs> page =
      PageInfo<MisskeyRouteRouteArgs>(name);
}

class MisskeyRouteRouteArgs {
  const MisskeyRouteRouteArgs({
    required this.account,
    required this.page,
    this.key,
  });

  final Account account;

  final Page page;

  final Key? key;

  @override
  String toString() {
    return 'MisskeyRouteRouteArgs{account: $account, page: $page, key: $key}';
  }
}

/// generated route for
/// [NoteCreatePage]
class NoteCreateRoute extends PageRouteInfo<NoteCreateRouteArgs> {
  NoteCreateRoute({
    required Account initialAccount,
    Key? key,
    String? initialText,
    List<String>? initialMediaFiles,
    bool exitOnNoted = false,
    CommunityChannel? channel,
    Note? reply,
    Note? renote,
    Note? note,
    NoteCreationMode? noteCreationMode,
    List<PageRouteInfo>? children,
  }) : super(
          NoteCreateRoute.name,
          args: NoteCreateRouteArgs(
            initialAccount: initialAccount,
            key: key,
            initialText: initialText,
            initialMediaFiles: initialMediaFiles,
            exitOnNoted: exitOnNoted,
            channel: channel,
            reply: reply,
            renote: renote,
            note: note,
            noteCreationMode: noteCreationMode,
          ),
          initialChildren: children,
        );

  static const String name = 'NoteCreateRoute';

  static const PageInfo<NoteCreateRouteArgs> page =
      PageInfo<NoteCreateRouteArgs>(name);
}

class NoteCreateRouteArgs {
  const NoteCreateRouteArgs({
    required this.initialAccount,
    this.key,
    this.initialText,
    this.initialMediaFiles,
    this.exitOnNoted = false,
    this.channel,
    this.reply,
    this.renote,
    this.note,
    this.noteCreationMode,
  });

  final Account initialAccount;

  final Key? key;

  final String? initialText;

  final List<String>? initialMediaFiles;

  final bool exitOnNoted;

  final CommunityChannel? channel;

  final Note? reply;

  final Note? renote;

  final Note? note;

  final NoteCreationMode? noteCreationMode;

  @override
  String toString() {
    return 'NoteCreateRouteArgs{initialAccount: $initialAccount, key: $key, initialText: $initialText, initialMediaFiles: $initialMediaFiles, exitOnNoted: $exitOnNoted, channel: $channel, reply: $reply, renote: $renote, note: $note, noteCreationMode: $noteCreationMode}';
  }
}

/// generated route for
/// [NoteDetailPage]
class NoteDetailRoute extends PageRouteInfo<NoteDetailRouteArgs> {
  NoteDetailRoute({
    required Note note,
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          NoteDetailRoute.name,
          args: NoteDetailRouteArgs(
            note: note,
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NoteDetailRoute';

  static const PageInfo<NoteDetailRouteArgs> page =
      PageInfo<NoteDetailRouteArgs>(name);
}

class NoteDetailRouteArgs {
  const NoteDetailRouteArgs({
    required this.note,
    required this.account,
    this.key,
  });

  final Note note;

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'NoteDetailRouteArgs{note: $note, account: $account, key: $key}';
  }
}

/// generated route for
/// [NoteModalSheet]
class NoteModalRoute extends PageRouteInfo<NoteModalRouteArgs> {
  NoteModalRoute({
    required Note baseNote,
    required Note targetNote,
    required Account account,
    required GlobalKey<State<StatefulWidget>> noteBoundaryKey,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          NoteModalRoute.name,
          args: NoteModalRouteArgs(
            baseNote: baseNote,
            targetNote: targetNote,
            account: account,
            noteBoundaryKey: noteBoundaryKey,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NoteModalRoute';

  static const PageInfo<NoteModalRouteArgs> page =
      PageInfo<NoteModalRouteArgs>(name);
}

class NoteModalRouteArgs {
  const NoteModalRouteArgs({
    required this.baseNote,
    required this.targetNote,
    required this.account,
    required this.noteBoundaryKey,
    this.key,
  });

  final Note baseNote;

  final Note targetNote;

  final Account account;

  final GlobalKey<State<StatefulWidget>> noteBoundaryKey;

  final Key? key;

  @override
  String toString() {
    return 'NoteModalRouteArgs{baseNote: $baseNote, targetNote: $targetNote, account: $account, noteBoundaryKey: $noteBoundaryKey, key: $key}';
  }
}

/// generated route for
/// [NotesAfterRenotePage]
class NotesAfterRenoteRoute extends PageRouteInfo<NotesAfterRenoteRouteArgs> {
  NotesAfterRenoteRoute({
    required Note note,
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          NotesAfterRenoteRoute.name,
          args: NotesAfterRenoteRouteArgs(
            note: note,
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NotesAfterRenoteRoute';

  static const PageInfo<NotesAfterRenoteRouteArgs> page =
      PageInfo<NotesAfterRenoteRouteArgs>(name);
}

class NotesAfterRenoteRouteArgs {
  const NotesAfterRenoteRouteArgs({
    required this.note,
    required this.account,
    this.key,
  });

  final Note note;

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'NotesAfterRenoteRouteArgs{note: $note, account: $account, key: $key}';
  }
}

/// generated route for
/// [NotificationPage]
class NotificationRoute extends PageRouteInfo<NotificationRouteArgs> {
  NotificationRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          NotificationRoute.name,
          args: NotificationRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const PageInfo<NotificationRouteArgs> page =
      PageInfo<NotificationRouteArgs>(name);
}

class NotificationRouteArgs {
  const NotificationRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'NotificationRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [PhotoEditPage]
class PhotoEditRoute extends PageRouteInfo<PhotoEditRouteArgs> {
  PhotoEditRoute({
    required Account account,
    required MisskeyPostFile file,
    required void Function(Uint8List) onSubmit,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PhotoEditRoute.name,
          args: PhotoEditRouteArgs(
            account: account,
            file: file,
            onSubmit: onSubmit,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'PhotoEditRoute';

  static const PageInfo<PhotoEditRouteArgs> page =
      PageInfo<PhotoEditRouteArgs>(name);
}

class PhotoEditRouteArgs {
  const PhotoEditRouteArgs({
    required this.account,
    required this.file,
    required this.onSubmit,
    this.key,
  });

  final Account account;

  final MisskeyPostFile file;

  final void Function(Uint8List) onSubmit;

  final Key? key;

  @override
  String toString() {
    return 'PhotoEditRouteArgs{account: $account, file: $file, onSubmit: $onSubmit, key: $key}';
  }
}

/// generated route for
/// [ReactionDeckPage]
class ReactionDeckRoute extends PageRouteInfo<ReactionDeckRouteArgs> {
  ReactionDeckRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ReactionDeckRoute.name,
          args: ReactionDeckRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ReactionDeckRoute';

  static const PageInfo<ReactionDeckRouteArgs> page =
      PageInfo<ReactionDeckRouteArgs>(name);
}

class ReactionDeckRouteArgs {
  const ReactionDeckRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'ReactionDeckRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [RenoteModalSheet]
class RenoteModalRoute extends PageRouteInfo<RenoteModalRouteArgs> {
  RenoteModalRoute({
    required Note note,
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          RenoteModalRoute.name,
          args: RenoteModalRouteArgs(
            note: note,
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'RenoteModalRoute';

  static const PageInfo<RenoteModalRouteArgs> page =
      PageInfo<RenoteModalRouteArgs>(name);
}

class RenoteModalRouteArgs {
  const RenoteModalRouteArgs({
    required this.note,
    required this.account,
    this.key,
  });

  final Note note;

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'RenoteModalRouteArgs{note: $note, account: $account, key: $key}';
  }
}

/// generated route for
/// [RenoteUserDialog]
class RenoteUserRoute extends PageRouteInfo<RenoteUserRouteArgs> {
  RenoteUserRoute({
    required Account account,
    required String noteId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          RenoteUserRoute.name,
          args: RenoteUserRouteArgs(
            account: account,
            noteId: noteId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'RenoteUserRoute';

  static const PageInfo<RenoteUserRouteArgs> page =
      PageInfo<RenoteUserRouteArgs>(name);
}

class RenoteUserRouteArgs {
  const RenoteUserRouteArgs({
    required this.account,
    required this.noteId,
    this.key,
  });

  final Account account;

  final String noteId;

  final Key? key;

  @override
  String toString() {
    return 'RenoteUserRouteArgs{account: $account, noteId: $noteId, key: $key}';
  }
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    required Account account,
    Key? key,
    NoteSearchCondition? initialNoteSearchCondition,
    List<PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            account: account,
            key: key,
            initialNoteSearchCondition: initialNoteSearchCondition,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const PageInfo<SearchRouteArgs> page = PageInfo<SearchRouteArgs>(name);
}

class SearchRouteArgs {
  const SearchRouteArgs({
    required this.account,
    this.key,
    this.initialNoteSearchCondition,
  });

  final Account account;

  final Key? key;

  final NoteSearchCondition? initialNoteSearchCondition;

  @override
  String toString() {
    return 'SearchRouteArgs{account: $account, key: $key, initialNoteSearchCondition: $initialNoteSearchCondition}';
  }
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
/// [SeveralAccountGeneralSettingsPage]
class SeveralAccountGeneralSettingsRoute
    extends PageRouteInfo<SeveralAccountGeneralSettingsRouteArgs> {
  SeveralAccountGeneralSettingsRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          SeveralAccountGeneralSettingsRoute.name,
          args: SeveralAccountGeneralSettingsRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'SeveralAccountGeneralSettingsRoute';

  static const PageInfo<SeveralAccountGeneralSettingsRouteArgs> page =
      PageInfo<SeveralAccountGeneralSettingsRouteArgs>(name);
}

class SeveralAccountGeneralSettingsRouteArgs {
  const SeveralAccountGeneralSettingsRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'SeveralAccountGeneralSettingsRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [SeveralAccountSettingsPage]
class SeveralAccountSettingsRoute
    extends PageRouteInfo<SeveralAccountSettingsRouteArgs> {
  SeveralAccountSettingsRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          SeveralAccountSettingsRoute.name,
          args: SeveralAccountSettingsRouteArgs(
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'SeveralAccountSettingsRoute';

  static const PageInfo<SeveralAccountSettingsRouteArgs> page =
      PageInfo<SeveralAccountSettingsRouteArgs>(name);
}

class SeveralAccountSettingsRouteArgs {
  const SeveralAccountSettingsRouteArgs({
    required this.account,
    this.key,
  });

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'SeveralAccountSettingsRouteArgs{account: $account, key: $key}';
  }
}

/// generated route for
/// [ShareExtensionPage]
class ShareExtensionRoute extends PageRouteInfo<void> {
  const ShareExtensionRoute({List<PageRouteInfo>? children})
      : super(
          ShareExtensionRoute.name,
          initialChildren: children,
        );

  static const String name = 'ShareExtensionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SharingAccountSelectPage]
class SharingAccountSelectRoute
    extends PageRouteInfo<SharingAccountSelectRouteArgs> {
  SharingAccountSelectRoute({
    Key? key,
    String? sharingText,
    List<String>? filePath,
    List<PageRouteInfo>? children,
  }) : super(
          SharingAccountSelectRoute.name,
          args: SharingAccountSelectRouteArgs(
            key: key,
            sharingText: sharingText,
            filePath: filePath,
          ),
          initialChildren: children,
        );

  static const String name = 'SharingAccountSelectRoute';

  static const PageInfo<SharingAccountSelectRouteArgs> page =
      PageInfo<SharingAccountSelectRouteArgs>(name);
}

class SharingAccountSelectRouteArgs {
  const SharingAccountSelectRouteArgs({
    this.key,
    this.sharingText,
    this.filePath,
  });

  final Key? key;

  final String? sharingText;

  final List<String>? filePath;

  @override
  String toString() {
    return 'SharingAccountSelectRouteArgs{key: $key, sharingText: $sharingText, filePath: $filePath}';
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
/// [TimeLinePage]
class TimeLineRoute extends PageRouteInfo<TimeLineRouteArgs> {
  TimeLineRoute({
    required TabSetting initialTabSetting,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          TimeLineRoute.name,
          args: TimeLineRouteArgs(
            initialTabSetting: initialTabSetting,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'TimeLineRoute';

  static const PageInfo<TimeLineRouteArgs> page =
      PageInfo<TimeLineRouteArgs>(name);
}

class TimeLineRouteArgs {
  const TimeLineRouteArgs({
    required this.initialTabSetting,
    this.key,
  });

  final TabSetting initialTabSetting;

  final Key? key;

  @override
  String toString() {
    return 'TimeLineRouteArgs{initialTabSetting: $initialTabSetting, key: $key}';
  }
}

/// generated route for
/// [UpdateMemoDialog]
class UpdateMemoRoute extends PageRouteInfo<UpdateMemoRouteArgs> {
  UpdateMemoRoute({
    required Account account,
    required String initialMemo,
    required String userId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UpdateMemoRoute.name,
          args: UpdateMemoRouteArgs(
            account: account,
            initialMemo: initialMemo,
            userId: userId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'UpdateMemoRoute';

  static const PageInfo<UpdateMemoRouteArgs> page =
      PageInfo<UpdateMemoRouteArgs>(name);
}

class UpdateMemoRouteArgs {
  const UpdateMemoRouteArgs({
    required this.account,
    required this.initialMemo,
    required this.userId,
    this.key,
  });

  final Account account;

  final String initialMemo;

  final String userId;

  final Key? key;

  @override
  String toString() {
    return 'UpdateMemoRouteArgs{account: $account, initialMemo: $initialMemo, userId: $userId, key: $key}';
  }
}

/// generated route for
/// [UserControlDialog]
class UserControlRoute extends PageRouteInfo<UserControlRouteArgs> {
  UserControlRoute({
    required Account account,
    required UserDetailed response,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UserControlRoute.name,
          args: UserControlRouteArgs(
            account: account,
            response: response,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'UserControlRoute';

  static const PageInfo<UserControlRouteArgs> page =
      PageInfo<UserControlRouteArgs>(name);
}

class UserControlRouteArgs {
  const UserControlRouteArgs({
    required this.account,
    required this.response,
    this.key,
  });

  final Account account;

  final UserDetailed response;

  final Key? key;

  @override
  String toString() {
    return 'UserControlRouteArgs{account: $account, response: $response, key: $key}';
  }
}

/// generated route for
/// [UserFolloweePage]
class UserFolloweeRoute extends PageRouteInfo<UserFolloweeRouteArgs> {
  UserFolloweeRoute({
    required String userId,
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UserFolloweeRoute.name,
          args: UserFolloweeRouteArgs(
            userId: userId,
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'UserFolloweeRoute';

  static const PageInfo<UserFolloweeRouteArgs> page =
      PageInfo<UserFolloweeRouteArgs>(name);
}

class UserFolloweeRouteArgs {
  const UserFolloweeRouteArgs({
    required this.userId,
    required this.account,
    this.key,
  });

  final String userId;

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'UserFolloweeRouteArgs{userId: $userId, account: $account, key: $key}';
  }
}

/// generated route for
/// [UserFollowerPage]
class UserFollowerRoute extends PageRouteInfo<UserFollowerRouteArgs> {
  UserFollowerRoute({
    required String userId,
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UserFollowerRoute.name,
          args: UserFollowerRouteArgs(
            userId: userId,
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'UserFollowerRoute';

  static const PageInfo<UserFollowerRouteArgs> page =
      PageInfo<UserFollowerRouteArgs>(name);
}

class UserFollowerRouteArgs {
  const UserFollowerRouteArgs({
    required this.userId,
    required this.account,
    this.key,
  });

  final String userId;

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'UserFollowerRouteArgs{userId: $userId, account: $account, key: $key}';
  }
}

/// generated route for
/// [UserPage]
class UserRoute extends PageRouteInfo<UserRouteArgs> {
  UserRoute({
    required String userId,
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UserRoute.name,
          args: UserRouteArgs(
            userId: userId,
            account: account,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'UserRoute';

  static const PageInfo<UserRouteArgs> page = PageInfo<UserRouteArgs>(name);
}

class UserRouteArgs {
  const UserRouteArgs({
    required this.userId,
    required this.account,
    this.key,
  });

  final String userId;

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'UserRouteArgs{userId: $userId, account: $account, key: $key}';
  }
}

/// generated route for
/// [UsersListDetailPage]
class UsersListDetailRoute extends PageRouteInfo<UsersListDetailRouteArgs> {
  UsersListDetailRoute({
    required Account account,
    required String listId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UsersListDetailRoute.name,
          args: UsersListDetailRouteArgs(
            account: account,
            listId: listId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'UsersListDetailRoute';

  static const PageInfo<UsersListDetailRouteArgs> page =
      PageInfo<UsersListDetailRouteArgs>(name);
}

class UsersListDetailRouteArgs {
  const UsersListDetailRouteArgs({
    required this.account,
    required this.listId,
    this.key,
  });

  final Account account;

  final String listId;

  final Key? key;

  @override
  String toString() {
    return 'UsersListDetailRouteArgs{account: $account, listId: $listId, key: $key}';
  }
}

/// generated route for
/// [UsersListModalSheet]
class UsersListModalRoute extends PageRouteInfo<UsersListModalRouteArgs> {
  UsersListModalRoute({
    required Account account,
    required User user,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UsersListModalRoute.name,
          args: UsersListModalRouteArgs(
            account: account,
            user: user,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'UsersListModalRoute';

  static const PageInfo<UsersListModalRouteArgs> page =
      PageInfo<UsersListModalRouteArgs>(name);
}

class UsersListModalRouteArgs {
  const UsersListModalRouteArgs({
    required this.account,
    required this.user,
    this.key,
  });

  final Account account;

  final User user;

  final Key? key;

  @override
  String toString() {
    return 'UsersListModalRouteArgs{account: $account, user: $user, key: $key}';
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
    required UsersList list,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          UsersListTimelineRoute.name,
          args: UsersListTimelineRouteArgs(
            account: account,
            list: list,
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
    required this.list,
    this.key,
  });

  final Account account;

  final UsersList list;

  final Key? key;

  @override
  String toString() {
    return 'UsersListTimelineRouteArgs{account: $account, list: $list, key: $key}';
  }
}

/// generated route for
/// [WordMutePage]
class WordMuteRoute extends PageRouteInfo<WordMuteRouteArgs> {
  WordMuteRoute({
    required Account account,
    required MuteType muteType,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          WordMuteRoute.name,
          args: WordMuteRouteArgs(
            account: account,
            muteType: muteType,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'WordMuteRoute';

  static const PageInfo<WordMuteRouteArgs> page =
      PageInfo<WordMuteRouteArgs>(name);
}

class WordMuteRouteArgs {
  const WordMuteRouteArgs({
    required this.account,
    required this.muteType,
    this.key,
  });

  final Account account;

  final MuteType muteType;

  final Key? key;

  @override
  String toString() {
    return 'WordMuteRouteArgs{account: $account, muteType: $muteType, key: $key}';
  }
}
