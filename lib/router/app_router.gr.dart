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
    NotesAfterRenoteRoute.name: (routeData) {
      final args = routeData.argsAs<NotesAfterRenoteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NotesAfterRenotePage(
          key: args.key,
          note: args.note,
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
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
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
    NoteCreateRoute.name: (routeData) {
      final args = routeData.argsAs<NoteCreateRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NoteCreatePage(
          key: args.key,
          initialAccount: args.initialAccount,
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
    AnnouncementRoute.name: (routeData) {
      final args = routeData.argsAs<AnnouncementRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AnnouncementPage(
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
    SeveralAccountGeneralSettingsRoute.name: (routeData) {
      final args = routeData.argsAs<SeveralAccountGeneralSettingsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SeveralAccountGeneralSettingsPage(
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
    WordMuteRoute.name: (routeData) {
      final args = routeData.argsAs<WordMuteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WordMutePage(
          key: args.key,
          account: args.account,
          muteType: args.muteType,
        ),
      );
    },
    CacheManagementRoute.name: (routeData) {
      final args = routeData.argsAs<CacheManagementRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CacheManagementPage(
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
    UsersListDetailRoute.name: (routeData) {
      final args = routeData.argsAs<UsersListDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UsersListDetailPage(
          key: args.key,
          account: args.account,
          listId: args.listId,
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
    FederationRoute.name: (routeData) {
      final args = routeData.argsAs<FederationRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FederationPage(
          key: args.key,
          account: args.account,
          host: args.host,
        ),
      );
    },
    NoteDetailRoute.name: (routeData) {
      final args = routeData.argsAs<NoteDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: NoteDetailPage(
          key: args.key,
          note: args.note,
          account: args.account,
        ),
      );
    },
    SearchRoute.name: (routeData) {
      final args = routeData.argsAs<SearchRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SearchPage(
          key: args.key,
          initialNoteSearchCondition: args.initialNoteSearchCondition,
          account: args.account,
        ),
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
    MisskeyRouteRoute.name: (routeData) {
      final args = routeData.argsAs<MisskeyRouteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MisskeyPagePage(
          key: args.key,
          account: args.account,
          page: args.page,
        ),
      );
    },
    MisskeyGamesRoute.name: (routeData) {
      final args = routeData.argsAs<MisskeyGamesRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: MisskeyGamesPage(
          key: args.key,
          account: args.account,
        ),
      );
    },
    ImportExportRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ImportExportPage(),
      );
    },
    GeneralSettingsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GeneralSettingsPage(),
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
    TabSettingsListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TabSettingsListPage(),
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
    AccountListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AccountListPage(),
      );
    },
    ExploreRoleUsersRoute.name: (routeData) {
      final args = routeData.argsAs<ExploreRoleUsersRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ExploreRoleUsersPage(
          key: args.key,
          item: args.item,
          account: args.account,
        ),
      );
    },
    ExploreRoute.name: (routeData) {
      final args = routeData.argsAs<ExploreRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ExplorePage(
          key: args.key,
          account: args.account,
        ),
      );
    },
    TimeLineRoute.name: (routeData) {
      final args = routeData.argsAs<TimeLineRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TimeLinePage(
          key: args.key,
          initialTabSetting: args.initialTabSetting,
        ),
      );
    },
    ShareExtensionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ShareExtensionPage(),
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
  };
}

/// generated route for
/// [NotesAfterRenotePage]
class NotesAfterRenoteRoute extends PageRouteInfo<NotesAfterRenoteRouteArgs> {
  NotesAfterRenoteRoute({
    Key? key,
    required Note note,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          NotesAfterRenoteRoute.name,
          args: NotesAfterRenoteRouteArgs(
            key: key,
            note: note,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'NotesAfterRenoteRoute';

  static const PageInfo<NotesAfterRenoteRouteArgs> page =
      PageInfo<NotesAfterRenoteRouteArgs>(name);
}

class NotesAfterRenoteRouteArgs {
  const NotesAfterRenoteRouteArgs({
    this.key,
    required this.note,
    required this.account,
  });

  final Key? key;

  final Note note;

  final Account account;

  @override
  String toString() {
    return 'NotesAfterRenoteRouteArgs{key: $key, note: $note, account: $account}';
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
/// [NoteCreatePage]
class NoteCreateRoute extends PageRouteInfo<NoteCreateRouteArgs> {
  NoteCreateRoute({
    Key? key,
    required Account initialAccount,
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
            key: key,
            initialAccount: initialAccount,
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
    this.key,
    required this.initialAccount,
    this.initialText,
    this.initialMediaFiles,
    this.exitOnNoted = false,
    this.channel,
    this.reply,
    this.renote,
    this.note,
    this.noteCreationMode,
  });

  final Key? key;

  final Account initialAccount;

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
    return 'NoteCreateRouteArgs{key: $key, initialAccount: $initialAccount, initialText: $initialText, initialMediaFiles: $initialMediaFiles, exitOnNoted: $exitOnNoted, channel: $channel, reply: $reply, renote: $renote, note: $note, noteCreationMode: $noteCreationMode}';
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
/// [AnnouncementPage]
class AnnouncementRoute extends PageRouteInfo<AnnouncementRouteArgs> {
  AnnouncementRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          AnnouncementRoute.name,
          args: AnnouncementRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'AnnouncementRoute';

  static const PageInfo<AnnouncementRouteArgs> page =
      PageInfo<AnnouncementRouteArgs>(name);
}

class AnnouncementRouteArgs {
  const AnnouncementRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'AnnouncementRouteArgs{key: $key, account: $account}';
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
/// [SeveralAccountGeneralSettingsPage]
class SeveralAccountGeneralSettingsRoute
    extends PageRouteInfo<SeveralAccountGeneralSettingsRouteArgs> {
  SeveralAccountGeneralSettingsRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          SeveralAccountGeneralSettingsRoute.name,
          args: SeveralAccountGeneralSettingsRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'SeveralAccountGeneralSettingsRoute';

  static const PageInfo<SeveralAccountGeneralSettingsRouteArgs> page =
      PageInfo<SeveralAccountGeneralSettingsRouteArgs>(name);
}

class SeveralAccountGeneralSettingsRouteArgs {
  const SeveralAccountGeneralSettingsRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'SeveralAccountGeneralSettingsRouteArgs{key: $key, account: $account}';
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
/// [WordMutePage]
class WordMuteRoute extends PageRouteInfo<WordMuteRouteArgs> {
  WordMuteRoute({
    Key? key,
    required Account account,
    required MuteType muteType,
    List<PageRouteInfo>? children,
  }) : super(
          WordMuteRoute.name,
          args: WordMuteRouteArgs(
            key: key,
            account: account,
            muteType: muteType,
          ),
          initialChildren: children,
        );

  static const String name = 'WordMuteRoute';

  static const PageInfo<WordMuteRouteArgs> page =
      PageInfo<WordMuteRouteArgs>(name);
}

class WordMuteRouteArgs {
  const WordMuteRouteArgs({
    this.key,
    required this.account,
    required this.muteType,
  });

  final Key? key;

  final Account account;

  final MuteType muteType;

  @override
  String toString() {
    return 'WordMuteRouteArgs{key: $key, account: $account, muteType: $muteType}';
  }
}

/// generated route for
/// [CacheManagementPage]
class CacheManagementRoute extends PageRouteInfo<CacheManagementRouteArgs> {
  CacheManagementRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          CacheManagementRoute.name,
          args: CacheManagementRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'CacheManagementRoute';

  static const PageInfo<CacheManagementRouteArgs> page =
      PageInfo<CacheManagementRouteArgs>(name);
}

class CacheManagementRouteArgs {
  const CacheManagementRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'CacheManagementRouteArgs{key: $key, account: $account}';
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
/// [UsersListDetailPage]
class UsersListDetailRoute extends PageRouteInfo<UsersListDetailRouteArgs> {
  UsersListDetailRoute({
    Key? key,
    required Account account,
    required String listId,
    List<PageRouteInfo>? children,
  }) : super(
          UsersListDetailRoute.name,
          args: UsersListDetailRouteArgs(
            key: key,
            account: account,
            listId: listId,
          ),
          initialChildren: children,
        );

  static const String name = 'UsersListDetailRoute';

  static const PageInfo<UsersListDetailRouteArgs> page =
      PageInfo<UsersListDetailRouteArgs>(name);
}

class UsersListDetailRouteArgs {
  const UsersListDetailRouteArgs({
    this.key,
    required this.account,
    required this.listId,
  });

  final Key? key;

  final Account account;

  final String listId;

  @override
  String toString() {
    return 'UsersListDetailRouteArgs{key: $key, account: $account, listId: $listId}';
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
/// [FederationPage]
class FederationRoute extends PageRouteInfo<FederationRouteArgs> {
  FederationRoute({
    Key? key,
    required Account account,
    required String host,
    List<PageRouteInfo>? children,
  }) : super(
          FederationRoute.name,
          args: FederationRouteArgs(
            key: key,
            account: account,
            host: host,
          ),
          initialChildren: children,
        );

  static const String name = 'FederationRoute';

  static const PageInfo<FederationRouteArgs> page =
      PageInfo<FederationRouteArgs>(name);
}

class FederationRouteArgs {
  const FederationRouteArgs({
    this.key,
    required this.account,
    required this.host,
  });

  final Key? key;

  final Account account;

  final String host;

  @override
  String toString() {
    return 'FederationRouteArgs{key: $key, account: $account, host: $host}';
  }
}

/// generated route for
/// [NoteDetailPage]
class NoteDetailRoute extends PageRouteInfo<NoteDetailRouteArgs> {
  NoteDetailRoute({
    Key? key,
    required Note note,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          NoteDetailRoute.name,
          args: NoteDetailRouteArgs(
            key: key,
            note: note,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'NoteDetailRoute';

  static const PageInfo<NoteDetailRouteArgs> page =
      PageInfo<NoteDetailRouteArgs>(name);
}

class NoteDetailRouteArgs {
  const NoteDetailRouteArgs({
    this.key,
    required this.note,
    required this.account,
  });

  final Key? key;

  final Note note;

  final Account account;

  @override
  String toString() {
    return 'NoteDetailRouteArgs{key: $key, note: $note, account: $account}';
  }
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    Key? key,
    NoteSearchCondition? initialNoteSearchCondition,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            initialNoteSearchCondition: initialNoteSearchCondition,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const PageInfo<SearchRouteArgs> page = PageInfo<SearchRouteArgs>(name);
}

class SearchRouteArgs {
  const SearchRouteArgs({
    this.key,
    this.initialNoteSearchCondition,
    required this.account,
  });

  final Key? key;

  final NoteSearchCondition? initialNoteSearchCondition;

  final Account account;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, initialNoteSearchCondition: $initialNoteSearchCondition, account: $account}';
  }
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
/// [MisskeyPagePage]
class MisskeyRouteRoute extends PageRouteInfo<MisskeyRouteRouteArgs> {
  MisskeyRouteRoute({
    Key? key,
    required Account account,
    required Page page,
    List<PageRouteInfo>? children,
  }) : super(
          MisskeyRouteRoute.name,
          args: MisskeyRouteRouteArgs(
            key: key,
            account: account,
            page: page,
          ),
          initialChildren: children,
        );

  static const String name = 'MisskeyRouteRoute';

  static const PageInfo<MisskeyRouteRouteArgs> page =
      PageInfo<MisskeyRouteRouteArgs>(name);
}

class MisskeyRouteRouteArgs {
  const MisskeyRouteRouteArgs({
    this.key,
    required this.account,
    required this.page,
  });

  final Key? key;

  final Account account;

  final Page page;

  @override
  String toString() {
    return 'MisskeyRouteRouteArgs{key: $key, account: $account, page: $page}';
  }
}

/// generated route for
/// [MisskeyGamesPage]
class MisskeyGamesRoute extends PageRouteInfo<MisskeyGamesRouteArgs> {
  MisskeyGamesRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          MisskeyGamesRoute.name,
          args: MisskeyGamesRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'MisskeyGamesRoute';

  static const PageInfo<MisskeyGamesRouteArgs> page =
      PageInfo<MisskeyGamesRouteArgs>(name);
}

class MisskeyGamesRouteArgs {
  const MisskeyGamesRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'MisskeyGamesRouteArgs{key: $key, account: $account}';
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
/// [ExploreRoleUsersPage]
class ExploreRoleUsersRoute extends PageRouteInfo<ExploreRoleUsersRouteArgs> {
  ExploreRoleUsersRoute({
    Key? key,
    required RolesListResponse item,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          ExploreRoleUsersRoute.name,
          args: ExploreRoleUsersRouteArgs(
            key: key,
            item: item,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'ExploreRoleUsersRoute';

  static const PageInfo<ExploreRoleUsersRouteArgs> page =
      PageInfo<ExploreRoleUsersRouteArgs>(name);
}

class ExploreRoleUsersRouteArgs {
  const ExploreRoleUsersRouteArgs({
    this.key,
    required this.item,
    required this.account,
  });

  final Key? key;

  final RolesListResponse item;

  final Account account;

  @override
  String toString() {
    return 'ExploreRoleUsersRouteArgs{key: $key, item: $item, account: $account}';
  }
}

/// generated route for
/// [ExplorePage]
class ExploreRoute extends PageRouteInfo<ExploreRouteArgs> {
  ExploreRoute({
    Key? key,
    required Account account,
    List<PageRouteInfo>? children,
  }) : super(
          ExploreRoute.name,
          args: ExploreRouteArgs(
            key: key,
            account: account,
          ),
          initialChildren: children,
        );

  static const String name = 'ExploreRoute';

  static const PageInfo<ExploreRouteArgs> page =
      PageInfo<ExploreRouteArgs>(name);
}

class ExploreRouteArgs {
  const ExploreRouteArgs({
    this.key,
    required this.account,
  });

  final Key? key;

  final Account account;

  @override
  String toString() {
    return 'ExploreRouteArgs{key: $key, account: $account}';
  }
}

/// generated route for
/// [TimeLinePage]
class TimeLineRoute extends PageRouteInfo<TimeLineRouteArgs> {
  TimeLineRoute({
    Key? key,
    required TabSetting initialTabSetting,
    List<PageRouteInfo>? children,
  }) : super(
          TimeLineRoute.name,
          args: TimeLineRouteArgs(
            key: key,
            initialTabSetting: initialTabSetting,
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
    required this.initialTabSetting,
  });

  final Key? key;

  final TabSetting initialTabSetting;

  @override
  String toString() {
    return 'TimeLineRouteArgs{key: $key, initialTabSetting: $initialTabSetting}';
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
