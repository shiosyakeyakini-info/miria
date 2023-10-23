// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AbuseRouteArgs>();
      return WrappedRoute(
        child: AbuseDialog(
          account: args.account,
          targetUser: args.targetUser,
          key: args.key,
          defaultText: args.defaultText,
        ),
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AbuseRouteArgs) return false;
    return account == other.account &&
        targetUser == other.targetUser &&
        key == other.key &&
        defaultText == other.defaultText;
  }

  @override
  int get hashCode =>
      account.hashCode ^
      targetUser.hashCode ^
      key.hashCode ^
      defaultText.hashCode;
}

/// generated route for
/// [AccountListPage]
class AccountListRoute extends PageRouteInfo<void> {
  const AccountListRoute({List<PageRouteInfo>? children})
    : super(AccountListRoute.name, initialChildren: children);

  static const String name = 'AccountListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AccountListPage();
    },
  );
}

/// generated route for
/// [AccountSelectDialog]
class AccountSelectRoute extends PageRouteInfo<AccountSelectRouteArgs> {
  AccountSelectRoute({
    Key? key,
    String? host,
    String? remoteHost,
    bool showWithoutLogin = true,
    List<PageRouteInfo>? children,
  }) : super(
         AccountSelectRoute.name,
         args: AccountSelectRouteArgs(
           key: key,
           host: host,
           remoteHost: remoteHost,
           showWithoutLogin: showWithoutLogin,
         ),
         initialChildren: children,
       );

  static const String name = 'AccountSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AccountSelectRouteArgs>(
        orElse: () => const AccountSelectRouteArgs(),
      );
      return AccountSelectDialog(
        key: args.key,
        host: args.host,
        remoteHost: args.remoteHost,
        showWithoutLogin: args.showWithoutLogin,
      );
    },
  );
}

class AccountSelectRouteArgs {
  const AccountSelectRouteArgs({
    this.key,
    this.host,
    this.remoteHost,
    this.showWithoutLogin = true,
  });

  final Key? key;

  final String? host;

  final String? remoteHost;

  final bool showWithoutLogin;

  @override
  String toString() {
    return 'AccountSelectRouteArgs{key: $key, host: $host, remoteHost: $remoteHost, showWithoutLogin: $showWithoutLogin}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AccountSelectRouteArgs) return false;
    return key == other.key &&
        host == other.host &&
        remoteHost == other.remoteHost &&
        showWithoutLogin == other.showWithoutLogin;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      host.hashCode ^
      remoteHost.hashCode ^
      showWithoutLogin.hashCode;
}

/// generated route for
/// [AnnouncementPage]
class AnnouncementRoute extends PageRouteInfo<AnnouncementRouteArgs> {
  AnnouncementRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         AnnouncementRoute.name,
         args: AnnouncementRouteArgs(accountContext: accountContext, key: key),
         initialChildren: children,
       );

  static const String name = 'AnnouncementRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AnnouncementRouteArgs>();
      return WrappedRoute(
        child: AnnouncementPage(
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class AnnouncementRouteArgs {
  const AnnouncementRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'AnnouncementRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AnnouncementRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
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
         args: AntennaModalRouteArgs(account: account, user: user, key: key),
         initialChildren: children,
       );

  static const String name = 'AntennaModalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AntennaModalRouteArgs>();
      return WrappedRoute(
        child: AntennaModalSheet(
          account: args.account,
          user: args.user,
          key: args.key,
        ),
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AntennaModalRouteArgs) return false;
    return account == other.account && user == other.user && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ user.hashCode ^ key.hashCode;
}

/// generated route for
/// [AntennaNotesPage]
class AntennaNotesRoute extends PageRouteInfo<AntennaNotesRouteArgs> {
  AntennaNotesRoute({
    required Antenna antenna,
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         AntennaNotesRoute.name,
         args: AntennaNotesRouteArgs(
           antenna: antenna,
           accountContext: accountContext,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AntennaNotesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AntennaNotesRouteArgs>();
      return WrappedRoute(
        child: AntennaNotesPage(
          antenna: args.antenna,
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class AntennaNotesRouteArgs {
  const AntennaNotesRouteArgs({
    required this.antenna,
    required this.accountContext,
    this.key,
  });

  final Antenna antenna;

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'AntennaNotesRouteArgs{antenna: $antenna, accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AntennaNotesRouteArgs) return false;
    return antenna == other.antenna &&
        accountContext == other.accountContext &&
        key == other.key;
  }

  @override
  int get hashCode => antenna.hashCode ^ accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [AntennaPage]
class AntennaRoute extends PageRouteInfo<AntennaRouteArgs> {
  AntennaRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         AntennaRoute.name,
         args: AntennaRouteArgs(accountContext: accountContext, key: key),
         initialChildren: children,
       );

  static const String name = 'AntennaRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AntennaRouteArgs>();
      return WrappedRoute(
        child: AntennaPage(accountContext: args.accountContext, key: args.key),
      );
    },
  );
}

class AntennaRouteArgs {
  const AntennaRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'AntennaRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AntennaRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [AntennaSelectDialog]
class AntennaSelectRoute extends PageRouteInfo<AntennaSelectRouteArgs> {
  AntennaSelectRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         AntennaSelectRoute.name,
         args: AntennaSelectRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'AntennaSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AntennaSelectRouteArgs>();
      return WrappedRoute(
        child: AntennaSelectDialog(account: args.account, key: args.key),
      );
    },
  );
}

class AntennaSelectRouteArgs {
  const AntennaSelectRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'AntennaSelectRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AntennaSelectRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
}

/// generated route for
/// [AntennaSettingsDialog]
class AntennaSettingsRoute extends PageRouteInfo<AntennaSettingsRouteArgs> {
  AntennaSettingsRoute({
    required Account account,
    Key? key,
    Widget? title,
    AntennaSettings initialSettings = const AntennaSettings(),
    List<PageRouteInfo>? children,
  }) : super(
         AntennaSettingsRoute.name,
         args: AntennaSettingsRouteArgs(
           account: account,
           key: key,
           title: title,
           initialSettings: initialSettings,
         ),
         initialChildren: children,
       );

  static const String name = 'AntennaSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AntennaSettingsRouteArgs>();
      return WrappedRoute(
        child: AntennaSettingsDialog(
          account: args.account,
          key: args.key,
          title: args.title,
          initialSettings: args.initialSettings,
        ),
      );
    },
  );
}

class AntennaSettingsRouteArgs {
  const AntennaSettingsRouteArgs({
    required this.account,
    this.key,
    this.title,
    this.initialSettings = const AntennaSettings(),
  });

  final Account account;

  final Key? key;

  final Widget? title;

  final AntennaSettings initialSettings;

  @override
  String toString() {
    return 'AntennaSettingsRouteArgs{account: $account, key: $key, title: $title, initialSettings: $initialSettings}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AntennaSettingsRouteArgs) return false;
    return account == other.account &&
        key == other.key &&
        title == other.title &&
        initialSettings == other.initialSettings;
  }

  @override
  int get hashCode =>
      account.hashCode ^
      key.hashCode ^
      title.hashCode ^
      initialSettings.hashCode;
}

/// generated route for
/// [AppInfoPage]
class AppInfoRoute extends PageRouteInfo<void> {
  const AppInfoRoute({List<PageRouteInfo>? children})
    : super(AppInfoRoute.name, initialChildren: children);

  static const String name = 'AppInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppInfoPage();
    },
  );
}

/// generated route for
/// [BlockedUsersPage]
class BlockedUsersRoute extends PageRouteInfo<BlockedUsersRouteArgs> {
  BlockedUsersRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         BlockedUsersRoute.name,
         args: BlockedUsersRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'BlockedUsersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BlockedUsersRouteArgs>();
      return WrappedRoute(
        child: BlockedUsersPage(account: args.account, key: args.key),
      );
    },
  );
}

class BlockedUsersRouteArgs {
  const BlockedUsersRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'BlockedUsersRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BlockedUsersRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
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
         args: CacheManagementRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'CacheManagementRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CacheManagementRouteArgs>();
      return CacheManagementPage(account: args.account, key: args.key);
    },
  );
}

class CacheManagementRouteArgs {
  const CacheManagementRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'CacheManagementRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CacheManagementRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
}

/// generated route for
/// [ChannelDescriptionDialog]
class ChannelDescriptionRoute
    extends PageRouteInfo<ChannelDescriptionRouteArgs> {
  ChannelDescriptionRoute({
    required String channelId,
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChannelDescriptionRoute.name,
         args: ChannelDescriptionRouteArgs(
           channelId: channelId,
           account: account,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ChannelDescriptionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChannelDescriptionRouteArgs>();
      return WrappedRoute(
        child: ChannelDescriptionDialog(
          channelId: args.channelId,
          account: args.account,
          key: args.key,
        ),
      );
    },
  );
}

class ChannelDescriptionRouteArgs {
  const ChannelDescriptionRouteArgs({
    required this.channelId,
    required this.account,
    this.key,
  });

  final String channelId;

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'ChannelDescriptionRouteArgs{channelId: $channelId, account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChannelDescriptionRouteArgs) return false;
    return channelId == other.channelId &&
        account == other.account &&
        key == other.key;
  }

  @override
  int get hashCode => channelId.hashCode ^ account.hashCode ^ key.hashCode;
}

/// generated route for
/// [ChannelDetailPage]
class ChannelDetailRoute extends PageRouteInfo<ChannelDetailRouteArgs> {
  ChannelDetailRoute({
    required AccountContext accountContext,
    required String channelId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChannelDetailRoute.name,
         args: ChannelDetailRouteArgs(
           accountContext: accountContext,
           channelId: channelId,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ChannelDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChannelDetailRouteArgs>();
      return WrappedRoute(
        child: ChannelDetailPage(
          accountContext: args.accountContext,
          channelId: args.channelId,
          key: args.key,
        ),
      );
    },
  );
}

class ChannelDetailRouteArgs {
  const ChannelDetailRouteArgs({
    required this.accountContext,
    required this.channelId,
    this.key,
  });

  final AccountContext accountContext;

  final String channelId;

  final Key? key;

  @override
  String toString() {
    return 'ChannelDetailRouteArgs{accountContext: $accountContext, channelId: $channelId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChannelDetailRouteArgs) return false;
    return accountContext == other.accountContext &&
        channelId == other.channelId &&
        key == other.key;
  }

  @override
  int get hashCode =>
      accountContext.hashCode ^ channelId.hashCode ^ key.hashCode;
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
         args: ChannelSelectRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'ChannelSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChannelSelectRouteArgs>();
      return WrappedRoute(
        child: ChannelSelectDialog(account: args.account, key: args.key),
      );
    },
  );
}

class ChannelSelectRouteArgs {
  const ChannelSelectRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'ChannelSelectRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChannelSelectRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
}

/// generated route for
/// [ChannelsPage]
class ChannelsRoute extends PageRouteInfo<ChannelsRouteArgs> {
  ChannelsRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChannelsRoute.name,
         args: ChannelsRouteArgs(accountContext: accountContext, key: key),
         initialChildren: children,
       );

  static const String name = 'ChannelsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChannelsRouteArgs>();
      return WrappedRoute(
        child: ChannelsPage(accountContext: args.accountContext, key: args.key),
      );
    },
  );
}

class ChannelsRouteArgs {
  const ChannelsRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'ChannelsRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChannelsRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [ChatHomePage]
class ChatHomeRoute extends PageRouteInfo<ChatHomeRouteArgs> {
  ChatHomeRoute({
    required AccountContext accountContext,
    int initialTab = 0,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChatHomeRoute.name,
         args: ChatHomeRouteArgs(
           accountContext: accountContext,
           initialTab: initialTab,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatHomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatHomeRouteArgs>();
      return WrappedRoute(
        child: ChatHomePage(
          accountContext: args.accountContext,
          initialTab: args.initialTab,
          key: args.key,
        ),
      );
    },
  );
}

class ChatHomeRouteArgs {
  const ChatHomeRouteArgs({
    required this.accountContext,
    this.initialTab = 0,
    this.key,
  });

  final AccountContext accountContext;

  final int initialTab;

  final Key? key;

  @override
  String toString() {
    return 'ChatHomeRouteArgs{accountContext: $accountContext, initialTab: $initialTab, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatHomeRouteArgs) return false;
    return accountContext == other.accountContext &&
        initialTab == other.initialTab &&
        key == other.key;
  }

  @override
  int get hashCode =>
      accountContext.hashCode ^ initialTab.hashCode ^ key.hashCode;
}

/// generated route for
/// [ChatMessageDetailPage]
class ChatMessageDetailRoute extends PageRouteInfo<ChatMessageDetailRouteArgs> {
  ChatMessageDetailRoute({
    required Account account,
    required String messageId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChatMessageDetailRoute.name,
         args: ChatMessageDetailRouteArgs(
           account: account,
           messageId: messageId,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatMessageDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatMessageDetailRouteArgs>();
      return WrappedRoute(
        child: ChatMessageDetailPage(
          account: args.account,
          messageId: args.messageId,
          key: args.key,
        ),
      );
    },
  );
}

class ChatMessageDetailRouteArgs {
  const ChatMessageDetailRouteArgs({
    required this.account,
    required this.messageId,
    this.key,
  });

  final Account account;

  final String messageId;

  final Key? key;

  @override
  String toString() {
    return 'ChatMessageDetailRouteArgs{account: $account, messageId: $messageId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatMessageDetailRouteArgs) return false;
    return account == other.account &&
        messageId == other.messageId &&
        key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ messageId.hashCode ^ key.hashCode;
}

/// generated route for
/// [ChatMessageMenuSheet]
class ChatMessageMenuRoute extends PageRouteInfo<ChatMessageMenuRouteArgs> {
  ChatMessageMenuRoute({
    required Account account,
    required ChatMessage message,
    required User user,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChatMessageMenuRoute.name,
         args: ChatMessageMenuRouteArgs(
           account: account,
           message: message,
           user: user,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatMessageMenuRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatMessageMenuRouteArgs>();
      return WrappedRoute(
        child: ChatMessageMenuSheet(
          account: args.account,
          message: args.message,
          user: args.user,
          key: args.key,
        ),
      );
    },
  );
}

class ChatMessageMenuRouteArgs {
  const ChatMessageMenuRouteArgs({
    required this.account,
    required this.message,
    required this.user,
    this.key,
  });

  final Account account;

  final ChatMessage message;

  final User user;

  final Key? key;

  @override
  String toString() {
    return 'ChatMessageMenuRouteArgs{account: $account, message: $message, user: $user, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatMessageMenuRouteArgs) return false;
    return account == other.account &&
        message == other.message &&
        user == other.user &&
        key == other.key;
  }

  @override
  int get hashCode =>
      account.hashCode ^ message.hashCode ^ user.hashCode ^ key.hashCode;
}

/// generated route for
/// [ChatRoomCreatePage]
class ChatRoomCreateRoute extends PageRouteInfo<ChatRoomCreateRouteArgs> {
  ChatRoomCreateRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChatRoomCreateRoute.name,
         args: ChatRoomCreateRouteArgs(
           accountContext: accountContext,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatRoomCreateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRoomCreateRouteArgs>();
      return WrappedRoute(
        child: ChatRoomCreatePage(
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class ChatRoomCreateRouteArgs {
  const ChatRoomCreateRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'ChatRoomCreateRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatRoomCreateRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [ChatSearchPage]
class ChatSearchRoute extends PageRouteInfo<ChatSearchRouteArgs> {
  ChatSearchRoute({
    required Account account,
    required String chatId,
    required bool isChannel,
    required String query,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChatSearchRoute.name,
         args: ChatSearchRouteArgs(
           account: account,
           chatId: chatId,
           isChannel: isChannel,
           query: query,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatSearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatSearchRouteArgs>();
      return WrappedRoute(
        child: ChatSearchPage(
          account: args.account,
          chatId: args.chatId,
          isChannel: args.isChannel,
          query: args.query,
          key: args.key,
        ),
      );
    },
  );
}

class ChatSearchRouteArgs {
  const ChatSearchRouteArgs({
    required this.account,
    required this.chatId,
    required this.isChannel,
    required this.query,
    this.key,
  });

  final Account account;

  final String chatId;

  final bool isChannel;

  final String query;

  final Key? key;

  @override
  String toString() {
    return 'ChatSearchRouteArgs{account: $account, chatId: $chatId, isChannel: $isChannel, query: $query, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatSearchRouteArgs) return false;
    return account == other.account &&
        chatId == other.chatId &&
        isChannel == other.isChannel &&
        query == other.query &&
        key == other.key;
  }

  @override
  int get hashCode =>
      account.hashCode ^
      chatId.hashCode ^
      isChannel.hashCode ^
      query.hashCode ^
      key.hashCode;
}

/// generated route for
/// [ClipDetailPage]
class ClipDetailRoute extends PageRouteInfo<ClipDetailRouteArgs> {
  ClipDetailRoute({
    required AccountContext accountContext,
    required String id,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ClipDetailRoute.name,
         args: ClipDetailRouteArgs(
           accountContext: accountContext,
           id: id,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ClipDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClipDetailRouteArgs>();
      return WrappedRoute(
        child: ClipDetailPage(
          accountContext: args.accountContext,
          id: args.id,
          key: args.key,
        ),
      );
    },
  );
}

class ClipDetailRouteArgs {
  const ClipDetailRouteArgs({
    required this.accountContext,
    required this.id,
    this.key,
  });

  final AccountContext accountContext;

  final String id;

  final Key? key;

  @override
  String toString() {
    return 'ClipDetailRouteArgs{accountContext: $accountContext, id: $id, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ClipDetailRouteArgs) return false;
    return accountContext == other.accountContext &&
        id == other.id &&
        key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ id.hashCode ^ key.hashCode;
}

/// generated route for
/// [ClipListPage]
class ClipListRoute extends PageRouteInfo<ClipListRouteArgs> {
  ClipListRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ClipListRoute.name,
         args: ClipListRouteArgs(accountContext: accountContext, key: key),
         initialChildren: children,
       );

  static const String name = 'ClipListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClipListRouteArgs>();
      return WrappedRoute(
        child: ClipListPage(accountContext: args.accountContext, key: args.key),
      );
    },
  );
}

class ClipListRouteArgs {
  const ClipListRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'ClipListRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ClipListRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [ClipModalSheet]
class ClipModalRoute extends PageRouteInfo<ClipModalRouteArgs> {
  ClipModalRoute({
    required Account account,
    required String noteId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ClipModalRoute.name,
         args: ClipModalRouteArgs(account: account, noteId: noteId, key: key),
         initialChildren: children,
       );

  static const String name = 'ClipModalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClipModalRouteArgs>();
      return WrappedRoute(
        child: ClipModalSheet(
          account: args.account,
          noteId: args.noteId,
          key: args.key,
        ),
      );
    },
  );
}

class ClipModalRouteArgs {
  const ClipModalRouteArgs({
    required this.account,
    required this.noteId,
    this.key,
  });

  final Account account;

  final String noteId;

  final Key? key;

  @override
  String toString() {
    return 'ClipModalRouteArgs{account: $account, noteId: $noteId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ClipModalRouteArgs) return false;
    return account == other.account &&
        noteId == other.noteId &&
        key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ noteId.hashCode ^ key.hashCode;
}

/// generated route for
/// [ClipSettingsDialog]
class ClipSettingsRoute extends PageRouteInfo<ClipSettingsRouteArgs> {
  ClipSettingsRoute({
    Key? key,
    Widget? title,
    ClipSettings initialSettings = const ClipSettings(),
    List<PageRouteInfo>? children,
  }) : super(
         ClipSettingsRoute.name,
         args: ClipSettingsRouteArgs(
           key: key,
           title: title,
           initialSettings: initialSettings,
         ),
         initialChildren: children,
       );

  static const String name = 'ClipSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ClipSettingsRouteArgs>(
        orElse: () => const ClipSettingsRouteArgs(),
      );
      return ClipSettingsDialog(
        key: args.key,
        title: args.title,
        initialSettings: args.initialSettings,
      );
    },
  );
}

class ClipSettingsRouteArgs {
  const ClipSettingsRouteArgs({
    this.key,
    this.title,
    this.initialSettings = const ClipSettings(),
  });

  final Key? key;

  final Widget? title;

  final ClipSettings initialSettings;

  @override
  String toString() {
    return 'ClipSettingsRouteArgs{key: $key, title: $title, initialSettings: $initialSettings}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ClipSettingsRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        initialSettings == other.initialSettings;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode ^ initialSettings.hashCode;
}

/// generated route for
/// [ColorPickerDialog]
class ColorPickerRoute extends PageRouteInfo<ColorPickerRouteArgs> {
  ColorPickerRoute({
    Key? key,
    Color? initialColor,
    List<PageRouteInfo>? children,
  }) : super(
         ColorPickerRoute.name,
         args: ColorPickerRouteArgs(key: key, initialColor: initialColor),
         initialChildren: children,
       );

  static const String name = 'ColorPickerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ColorPickerRouteArgs>(
        orElse: () => const ColorPickerRouteArgs(),
      );
      return ColorPickerDialog(key: args.key, initialColor: args.initialColor);
    },
  );
}

class ColorPickerRouteArgs {
  const ColorPickerRouteArgs({this.key, this.initialColor});

  final Key? key;

  final Color? initialColor;

  @override
  String toString() {
    return 'ColorPickerRouteArgs{key: $key, initialColor: $initialColor}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ColorPickerRouteArgs) return false;
    return key == other.key && initialColor == other.initialColor;
  }

  @override
  int get hashCode => key.hashCode ^ initialColor.hashCode;
}

/// generated route for
/// [DraftsModalDialog]
class DraftsModalRoute extends PageRouteInfo<DraftsModalRouteArgs> {
  DraftsModalRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         DraftsModalRoute.name,
         args: DraftsModalRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'DraftsModalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DraftsModalRouteArgs>();
      return WrappedRoute(
        child: DraftsModalDialog(account: args.account, key: args.key),
      );
    },
  );
}

class DraftsModalRouteArgs {
  const DraftsModalRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'DraftsModalRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DraftsModalRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
}

/// generated route for
/// [DraftsPage]
class DraftsRoute extends PageRouteInfo<DraftsRouteArgs> {
  DraftsRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         DraftsRoute.name,
         args: DraftsRouteArgs(accountContext: accountContext, key: key),
         initialChildren: children,
       );

  static const String name = 'DraftsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DraftsRouteArgs>();
      return WrappedRoute(
        child: DraftsPage(accountContext: args.accountContext, key: args.key),
      );
    },
  );
}

class DraftsRouteArgs {
  const DraftsRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'DraftsRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DraftsRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [DriveFileModalSheet]
class DriveFileModalRoute extends PageRouteInfo<DriveFileModalRouteArgs> {
  DriveFileModalRoute({
    required DriveFile file,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         DriveFileModalRoute.name,
         args: DriveFileModalRouteArgs(file: file, key: key),
         initialChildren: children,
       );

  static const String name = 'DriveFileModalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DriveFileModalRouteArgs>();
      return DriveFileModalSheet(file: args.file, key: args.key);
    },
  );
}

class DriveFileModalRouteArgs {
  const DriveFileModalRouteArgs({required this.file, this.key});

  final DriveFile file;

  final Key? key;

  @override
  String toString() {
    return 'DriveFileModalRouteArgs{file: $file, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DriveFileModalRouteArgs) return false;
    return file == other.file && key == other.key;
  }

  @override
  int get hashCode => file.hashCode ^ key.hashCode;
}

/// generated route for
/// [DriveFileSelectDialog]
class DriveFileSelectRoute extends PageRouteInfo<DriveFileSelectRouteArgs> {
  DriveFileSelectRoute({
    required Account account,
    Key? key,
    bool allowMultiple = false,
    List<PageRouteInfo>? children,
  }) : super(
         DriveFileSelectRoute.name,
         args: DriveFileSelectRouteArgs(
           account: account,
           key: key,
           allowMultiple: allowMultiple,
         ),
         initialChildren: children,
       );

  static const String name = 'DriveFileSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DriveFileSelectRouteArgs>();
      return WrappedRoute(
        child: DriveFileSelectDialog(
          account: args.account,
          key: args.key,
          allowMultiple: args.allowMultiple,
        ),
      );
    },
  );
}

class DriveFileSelectRouteArgs {
  const DriveFileSelectRouteArgs({
    required this.account,
    this.key,
    this.allowMultiple = false,
  });

  final Account account;

  final Key? key;

  final bool allowMultiple;

  @override
  String toString() {
    return 'DriveFileSelectRouteArgs{account: $account, key: $key, allowMultiple: $allowMultiple}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DriveFileSelectRouteArgs) return false;
    return account == other.account &&
        key == other.key &&
        allowMultiple == other.allowMultiple;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode ^ allowMultiple.hashCode;
}

/// generated route for
/// [DriveFolderModalSheet]
class DriveFolderModalRoute extends PageRouteInfo<DriveFolderModalRouteArgs> {
  DriveFolderModalRoute({
    required DriveFolder folder,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         DriveFolderModalRoute.name,
         args: DriveFolderModalRouteArgs(folder: folder, key: key),
         initialChildren: children,
       );

  static const String name = 'DriveFolderModalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DriveFolderModalRouteArgs>();
      return DriveFolderModalSheet(folder: args.folder, key: args.key);
    },
  );
}

class DriveFolderModalRouteArgs {
  const DriveFolderModalRouteArgs({required this.folder, this.key});

  final DriveFolder folder;

  final Key? key;

  @override
  String toString() {
    return 'DriveFolderModalRouteArgs{folder: $folder, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DriveFolderModalRouteArgs) return false;
    return folder == other.folder && key == other.key;
  }

  @override
  int get hashCode => folder.hashCode ^ key.hashCode;
}

/// generated route for
/// [DriveModalSheet]
class DriveModalRoute extends PageRouteInfo<void> {
  const DriveModalRoute({List<PageRouteInfo>? children})
    : super(DriveModalRoute.name, initialChildren: children);

  static const String name = 'DriveModalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DriveModalSheet();
    },
  );
}

/// generated route for
/// [DrivePage]
class DriveRoute extends PageRouteInfo<void> {
  const DriveRoute({List<PageRouteInfo>? children})
    : super(DriveRoute.name, initialChildren: children);

  static const String name = 'DriveRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DrivePage();
    },
  );
}

/// generated route for
/// [DriveShellPage]
class DriveShellRoute extends PageRouteInfo<DriveShellRouteArgs> {
  DriveShellRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         DriveShellRoute.name,
         args: DriveShellRouteArgs(accountContext: accountContext, key: key),
         initialChildren: children,
       );

  static const String name = 'DriveShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DriveShellRouteArgs>();
      return WrappedRoute(
        child: DriveShellPage(
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class DriveShellRouteArgs {
  const DriveShellRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'DriveShellRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DriveShellRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [ExpireSelectDialog]
class ExpireSelectRoute extends PageRouteInfo<void> {
  const ExpireSelectRoute({List<PageRouteInfo>? children})
    : super(ExpireSelectRoute.name, initialChildren: children);

  static const String name = 'ExpireSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ExpireSelectDialog();
    },
  );
}

/// generated route for
/// [ExplorePage]
class ExploreRoute extends PageRouteInfo<ExploreRouteArgs> {
  ExploreRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ExploreRoute.name,
         args: ExploreRouteArgs(accountContext: accountContext, key: key),
         initialChildren: children,
       );

  static const String name = 'ExploreRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ExploreRouteArgs>();
      return WrappedRoute(
        child: ExplorePage(accountContext: args.accountContext, key: args.key),
      );
    },
  );
}

class ExploreRouteArgs {
  const ExploreRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'ExploreRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ExploreRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [ExploreRoleUsersPage]
class ExploreRoleUsersRoute extends PageRouteInfo<ExploreRoleUsersRouteArgs> {
  ExploreRoleUsersRoute({
    required RolesListResponse item,
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ExploreRoleUsersRoute.name,
         args: ExploreRoleUsersRouteArgs(
           item: item,
           accountContext: accountContext,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ExploreRoleUsersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ExploreRoleUsersRouteArgs>();
      return WrappedRoute(
        child: ExploreRoleUsersPage(
          item: args.item,
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class ExploreRoleUsersRouteArgs {
  const ExploreRoleUsersRouteArgs({
    required this.item,
    required this.accountContext,
    this.key,
  });

  final RolesListResponse item;

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'ExploreRoleUsersRouteArgs{item: $item, accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ExploreRoleUsersRouteArgs) return false;
    return item == other.item &&
        accountContext == other.accountContext &&
        key == other.key;
  }

  @override
  int get hashCode => item.hashCode ^ accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [FavoritedNotePage]
class FavoritedNoteRoute extends PageRouteInfo<FavoritedNoteRouteArgs> {
  FavoritedNoteRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         FavoritedNoteRoute.name,
         args: FavoritedNoteRouteArgs(accountContext: accountContext, key: key),
         initialChildren: children,
       );

  static const String name = 'FavoritedNoteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FavoritedNoteRouteArgs>();
      return WrappedRoute(
        child: FavoritedNotePage(
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class FavoritedNoteRouteArgs {
  const FavoritedNoteRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'FavoritedNoteRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FavoritedNoteRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [FederationPage]
class FederationRoute extends PageRouteInfo<FederationRouteArgs> {
  FederationRoute({
    required AccountContext accountContext,
    required String host,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         FederationRoute.name,
         args: FederationRouteArgs(
           accountContext: accountContext,
           host: host,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'FederationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FederationRouteArgs>();
      return WrappedRoute(
        child: FederationPage(
          accountContext: args.accountContext,
          host: args.host,
          key: args.key,
        ),
      );
    },
  );
}

class FederationRouteArgs {
  const FederationRouteArgs({
    required this.accountContext,
    required this.host,
    this.key,
  });

  final AccountContext accountContext;

  final String host;

  final Key? key;

  @override
  String toString() {
    return 'FederationRouteArgs{accountContext: $accountContext, host: $host, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FederationRouteArgs) return false;
    return accountContext == other.accountContext &&
        host == other.host &&
        key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ host.hashCode ^ key.hashCode;
}

/// generated route for
/// [FolderSelectDialog]
class FolderSelectRoute extends PageRouteInfo<FolderSelectRouteArgs> {
  FolderSelectRoute({
    required Account account,
    required List<String>? fileShowTarget,
    required String confirmationText,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         FolderSelectRoute.name,
         args: FolderSelectRouteArgs(
           account: account,
           fileShowTarget: fileShowTarget,
           confirmationText: confirmationText,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'FolderSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FolderSelectRouteArgs>();
      return FolderSelectDialog(
        account: args.account,
        fileShowTarget: args.fileShowTarget,
        confirmationText: args.confirmationText,
        key: args.key,
      );
    },
  );
}

class FolderSelectRouteArgs {
  const FolderSelectRouteArgs({
    required this.account,
    required this.fileShowTarget,
    required this.confirmationText,
    this.key,
  });

  final Account account;

  final List<String>? fileShowTarget;

  final String confirmationText;

  final Key? key;

  @override
  String toString() {
    return 'FolderSelectRouteArgs{account: $account, fileShowTarget: $fileShowTarget, confirmationText: $confirmationText, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FolderSelectRouteArgs) return false;
    return account == other.account &&
        const ListEquality().equals(fileShowTarget, other.fileShowTarget) &&
        confirmationText == other.confirmationText &&
        key == other.key;
  }

  @override
  int get hashCode =>
      account.hashCode ^
      const ListEquality().hash(fileShowTarget) ^
      confirmationText.hashCode ^
      key.hashCode;
}

/// generated route for
/// [GeneralSettingsPage]
class GeneralSettingsRoute extends PageRouteInfo<void> {
  const GeneralSettingsRoute({List<PageRouteInfo>? children})
    : super(GeneralSettingsRoute.name, initialChildren: children);

  static const String name = 'GeneralSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GeneralSettingsPage();
    },
  );
}

/// generated route for
/// [HashtagPage]
class HashtagRoute extends PageRouteInfo<HashtagRouteArgs> {
  HashtagRoute({
    required String hashtag,
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         HashtagRoute.name,
         args: HashtagRouteArgs(
           hashtag: hashtag,
           accountContext: accountContext,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'HashtagRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HashtagRouteArgs>();
      return WrappedRoute(
        child: HashtagPage(
          hashtag: args.hashtag,
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class HashtagRouteArgs {
  const HashtagRouteArgs({
    required this.hashtag,
    required this.accountContext,
    this.key,
  });

  final String hashtag;

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'HashtagRouteArgs{hashtag: $hashtag, accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HashtagRouteArgs) return false;
    return hashtag == other.hashtag &&
        accountContext == other.accountContext &&
        key == other.key;
  }

  @override
  int get hashCode => hashtag.hashCode ^ accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [ImportExportPage]
class ImportExportRoute extends PageRouteInfo<void> {
  const ImportExportRoute({List<PageRouteInfo>? children})
    : super(ImportExportRoute.name, initialChildren: children);

  static const String name = 'ImportExportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ImportExportPage();
    },
  );
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
         args: InstanceMuteRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'InstanceMuteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InstanceMuteRouteArgs>();
      return WrappedRoute(
        child: InstanceMutePage(account: args.account, key: args.key),
      );
    },
  );
}

class InstanceMuteRouteArgs {
  const InstanceMuteRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'InstanceMuteRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InstanceMuteRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
}

/// generated route for
/// [LicenseConfirmDialog]
class LicenseConfirmRoute extends PageRouteInfo<LicenseConfirmRouteArgs> {
  LicenseConfirmRoute({
    required String emoji,
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         LicenseConfirmRoute.name,
         args: LicenseConfirmRouteArgs(
           emoji: emoji,
           account: account,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'LicenseConfirmRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LicenseConfirmRouteArgs>();
      return WrappedRoute(
        child: LicenseConfirmDialog(
          emoji: args.emoji,
          account: args.account,
          key: args.key,
        ),
      );
    },
  );
}

class LicenseConfirmRouteArgs {
  const LicenseConfirmRouteArgs({
    required this.emoji,
    required this.account,
    this.key,
  });

  final String emoji;

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'LicenseConfirmRouteArgs{emoji: $emoji, account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LicenseConfirmRouteArgs) return false;
    return emoji == other.emoji && account == other.account && key == other.key;
  }

  @override
  int get hashCode => emoji.hashCode ^ account.hashCode ^ key.hashCode;
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [MisskeyGamesPage]
class MisskeyGamesRoute extends PageRouteInfo<MisskeyGamesRouteArgs> {
  MisskeyGamesRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MisskeyGamesRoute.name,
         args: MisskeyGamesRouteArgs(accountContext: accountContext, key: key),
         initialChildren: children,
       );

  static const String name = 'MisskeyGamesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MisskeyGamesRouteArgs>();
      return WrappedRoute(
        child: MisskeyGamesPage(
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class MisskeyGamesRouteArgs {
  const MisskeyGamesRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'MisskeyGamesRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MisskeyGamesRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [MisskeyPagePage]
class MisskeyRouteRoute extends PageRouteInfo<MisskeyRouteRouteArgs> {
  MisskeyRouteRoute({
    required AccountContext accountContext,
    required Page page,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MisskeyRouteRoute.name,
         args: MisskeyRouteRouteArgs(
           accountContext: accountContext,
           page: page,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'MisskeyRouteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MisskeyRouteRouteArgs>();
      return WrappedRoute(
        child: MisskeyPagePage(
          accountContext: args.accountContext,
          page: args.page,
          key: args.key,
        ),
      );
    },
  );
}

class MisskeyRouteRouteArgs {
  const MisskeyRouteRouteArgs({
    required this.accountContext,
    required this.page,
    this.key,
  });

  final AccountContext accountContext;

  final Page page;

  final Key? key;

  @override
  String toString() {
    return 'MisskeyRouteRouteArgs{accountContext: $accountContext, page: $page, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MisskeyRouteRouteArgs) return false;
    return accountContext == other.accountContext &&
        page == other.page &&
        key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ page.hashCode ^ key.hashCode;
}

/// generated route for
/// [MisskeyServerListDialog]
class MisskeyServerListRoute extends PageRouteInfo<void> {
  const MisskeyServerListRoute({List<PageRouteInfo>? children})
    : super(MisskeyServerListRoute.name, initialChildren: children);

  static const String name = 'MisskeyServerListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MisskeyServerListDialog();
    },
  );
}

/// generated route for
/// [MutedUsersPage]
class MutedUsersRoute extends PageRouteInfo<MutedUsersRouteArgs> {
  MutedUsersRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MutedUsersRoute.name,
         args: MutedUsersRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'MutedUsersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MutedUsersRouteArgs>();
      return WrappedRoute(
        child: MutedUsersPage(account: args.account, key: args.key),
      );
    },
  );
}

class MutedUsersRouteArgs {
  const MutedUsersRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'MutedUsersRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MutedUsersRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
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
    String? draftId,
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
           draftId: draftId,
         ),
         initialChildren: children,
       );

  static const String name = 'NoteCreateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NoteCreateRouteArgs>();
      return WrappedRoute(
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
          draftId: args.draftId,
        ),
      );
    },
  );
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
    this.draftId,
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

  final String? draftId;

  @override
  String toString() {
    return 'NoteCreateRouteArgs{initialAccount: $initialAccount, key: $key, initialText: $initialText, initialMediaFiles: $initialMediaFiles, exitOnNoted: $exitOnNoted, channel: $channel, reply: $reply, renote: $renote, note: $note, noteCreationMode: $noteCreationMode, draftId: $draftId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NoteCreateRouteArgs) return false;
    return initialAccount == other.initialAccount &&
        key == other.key &&
        initialText == other.initialText &&
        const ListEquality().equals(
          initialMediaFiles,
          other.initialMediaFiles,
        ) &&
        exitOnNoted == other.exitOnNoted &&
        channel == other.channel &&
        reply == other.reply &&
        renote == other.renote &&
        note == other.note &&
        noteCreationMode == other.noteCreationMode &&
        draftId == other.draftId;
  }

  @override
  int get hashCode =>
      initialAccount.hashCode ^
      key.hashCode ^
      initialText.hashCode ^
      const ListEquality().hash(initialMediaFiles) ^
      exitOnNoted.hashCode ^
      channel.hashCode ^
      reply.hashCode ^
      renote.hashCode ^
      note.hashCode ^
      noteCreationMode.hashCode ^
      draftId.hashCode;
}

/// generated route for
/// [NoteDetailPage]
class NoteDetailRoute extends PageRouteInfo<NoteDetailRouteArgs> {
  NoteDetailRoute({
    required Note note,
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         NoteDetailRoute.name,
         args: NoteDetailRouteArgs(
           note: note,
           accountContext: accountContext,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'NoteDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NoteDetailRouteArgs>();
      return WrappedRoute(
        child: NoteDetailPage(
          note: args.note,
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class NoteDetailRouteArgs {
  const NoteDetailRouteArgs({
    required this.note,
    required this.accountContext,
    this.key,
  });

  final Note note;

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'NoteDetailRouteArgs{note: $note, accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NoteDetailRouteArgs) return false;
    return note == other.note &&
        accountContext == other.accountContext &&
        key == other.key;
  }

  @override
  int get hashCode => note.hashCode ^ accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [NoteModalSheet]
class NoteModalRoute extends PageRouteInfo<NoteModalRouteArgs> {
  NoteModalRoute({
    required Note baseNote,
    required Note targetNote,
    required AccountContext accountContext,
    required GlobalKey<State<StatefulWidget>> noteBoundaryKey,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         NoteModalRoute.name,
         args: NoteModalRouteArgs(
           baseNote: baseNote,
           targetNote: targetNote,
           accountContext: accountContext,
           noteBoundaryKey: noteBoundaryKey,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'NoteModalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NoteModalRouteArgs>();
      return WrappedRoute(
        child: NoteModalSheet(
          baseNote: args.baseNote,
          targetNote: args.targetNote,
          accountContext: args.accountContext,
          noteBoundaryKey: args.noteBoundaryKey,
          key: args.key,
        ),
      );
    },
  );
}

class NoteModalRouteArgs {
  const NoteModalRouteArgs({
    required this.baseNote,
    required this.targetNote,
    required this.accountContext,
    required this.noteBoundaryKey,
    this.key,
  });

  final Note baseNote;

  final Note targetNote;

  final AccountContext accountContext;

  final GlobalKey<State<StatefulWidget>> noteBoundaryKey;

  final Key? key;

  @override
  String toString() {
    return 'NoteModalRouteArgs{baseNote: $baseNote, targetNote: $targetNote, accountContext: $accountContext, noteBoundaryKey: $noteBoundaryKey, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NoteModalRouteArgs) return false;
    return baseNote == other.baseNote &&
        targetNote == other.targetNote &&
        accountContext == other.accountContext &&
        noteBoundaryKey == other.noteBoundaryKey &&
        key == other.key;
  }

  @override
  int get hashCode =>
      baseNote.hashCode ^
      targetNote.hashCode ^
      accountContext.hashCode ^
      noteBoundaryKey.hashCode ^
      key.hashCode;
}

/// generated route for
/// [NotesAfterRenotePage]
class NotesAfterRenoteRoute extends PageRouteInfo<NotesAfterRenoteRouteArgs> {
  NotesAfterRenoteRoute({
    required Note note,
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         NotesAfterRenoteRoute.name,
         args: NotesAfterRenoteRouteArgs(
           note: note,
           accountContext: accountContext,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'NotesAfterRenoteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NotesAfterRenoteRouteArgs>();
      return WrappedRoute(
        child: NotesAfterRenotePage(
          note: args.note,
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class NotesAfterRenoteRouteArgs {
  const NotesAfterRenoteRouteArgs({
    required this.note,
    required this.accountContext,
    this.key,
  });

  final Note note;

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'NotesAfterRenoteRouteArgs{note: $note, accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NotesAfterRenoteRouteArgs) return false;
    return note == other.note &&
        accountContext == other.accountContext &&
        key == other.key;
  }

  @override
  int get hashCode => note.hashCode ^ accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [NotificationPage]
class NotificationRoute extends PageRouteInfo<NotificationRouteArgs> {
  NotificationRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         NotificationRoute.name,
         args: NotificationRouteArgs(accountContext: accountContext, key: key),
         initialChildren: children,
       );

  static const String name = 'NotificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NotificationRouteArgs>();
      return WrappedRoute(
        child: NotificationPage(
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class NotificationRouteArgs {
  const NotificationRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'NotificationRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NotificationRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [PhotoEditPage]
class PhotoEditRoute extends PageRouteInfo<PhotoEditRouteArgs> {
  PhotoEditRoute({
    required AccountContext accountContext,
    required MisskeyPostFile file,
    required void Function(Uint8List) onSubmit,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         PhotoEditRoute.name,
         args: PhotoEditRouteArgs(
           accountContext: accountContext,
           file: file,
           onSubmit: onSubmit,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'PhotoEditRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PhotoEditRouteArgs>();
      return WrappedRoute(
        child: PhotoEditPage(
          accountContext: args.accountContext,
          file: args.file,
          onSubmit: args.onSubmit,
          key: args.key,
        ),
      );
    },
  );
}

class PhotoEditRouteArgs {
  const PhotoEditRouteArgs({
    required this.accountContext,
    required this.file,
    required this.onSubmit,
    this.key,
  });

  final AccountContext accountContext;

  final MisskeyPostFile file;

  final void Function(Uint8List) onSubmit;

  final Key? key;

  @override
  String toString() {
    return 'PhotoEditRouteArgs{accountContext: $accountContext, file: $file, onSubmit: $onSubmit, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PhotoEditRouteArgs) return false;
    return accountContext == other.accountContext &&
        file == other.file &&
        key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ file.hashCode ^ key.hashCode;
}

/// generated route for
/// [ProfileEditPage]
class ProfileEditRoute extends PageRouteInfo<ProfileEditRouteArgs> {
  ProfileEditRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ProfileEditRoute.name,
         args: ProfileEditRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'ProfileEditRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProfileEditRouteArgs>();
      return WrappedRoute(
        child: ProfileEditPage(account: args.account, key: args.key),
      );
    },
  );
}

class ProfileEditRouteArgs {
  const ProfileEditRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'ProfileEditRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProfileEditRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
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
         args: ReactionDeckRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'ReactionDeckRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReactionDeckRouteArgs>();
      return ReactionDeckPage(account: args.account, key: args.key);
    },
  );
}

class ReactionDeckRouteArgs {
  const ReactionDeckRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'ReactionDeckRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ReactionDeckRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
}

/// generated route for
/// [ReactionMutePage]
class ReactionMuteRoute extends PageRouteInfo<ReactionMuteRouteArgs> {
  ReactionMuteRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ReactionMuteRoute.name,
         args: ReactionMuteRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'ReactionMuteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReactionMuteRouteArgs>();
      return WrappedRoute(
        child: ReactionMutePage(account: args.account, key: args.key),
      );
    },
  );
}

class ReactionMuteRouteArgs {
  const ReactionMuteRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'ReactionMuteRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ReactionMuteRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
}

/// generated route for
/// [ReactionPickerDialog]
class ReactionPickerRoute extends PageRouteInfo<ReactionPickerRouteArgs> {
  ReactionPickerRoute({
    required Account account,
    required bool isAcceptSensitive,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ReactionPickerRoute.name,
         args: ReactionPickerRouteArgs(
           account: account,
           isAcceptSensitive: isAcceptSensitive,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ReactionPickerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReactionPickerRouteArgs>();
      return WrappedRoute(
        child: ReactionPickerDialog(
          account: args.account,
          isAcceptSensitive: args.isAcceptSensitive,
          key: args.key,
        ),
      );
    },
  );
}

class ReactionPickerRouteArgs {
  const ReactionPickerRouteArgs({
    required this.account,
    required this.isAcceptSensitive,
    this.key,
  });

  final Account account;

  final bool isAcceptSensitive;

  final Key? key;

  @override
  String toString() {
    return 'ReactionPickerRouteArgs{account: $account, isAcceptSensitive: $isAcceptSensitive, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ReactionPickerRouteArgs) return false;
    return account == other.account &&
        isAcceptSensitive == other.isAcceptSensitive &&
        key == other.key;
  }

  @override
  int get hashCode =>
      account.hashCode ^ isAcceptSensitive.hashCode ^ key.hashCode;
}

/// generated route for
/// [ReactionUserDialog]
class ReactionUserRoute extends PageRouteInfo<ReactionUserRouteArgs> {
  ReactionUserRoute({
    required AccountContext accountContext,
    required MisskeyEmojiData emojiData,
    required String noteId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ReactionUserRoute.name,
         args: ReactionUserRouteArgs(
           accountContext: accountContext,
           emojiData: emojiData,
           noteId: noteId,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ReactionUserRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReactionUserRouteArgs>();
      return WrappedRoute(
        child: ReactionUserDialog(
          accountContext: args.accountContext,
          emojiData: args.emojiData,
          noteId: args.noteId,
          key: args.key,
        ),
      );
    },
  );
}

class ReactionUserRouteArgs {
  const ReactionUserRouteArgs({
    required this.accountContext,
    required this.emojiData,
    required this.noteId,
    this.key,
  });

  final AccountContext accountContext;

  final MisskeyEmojiData emojiData;

  final String noteId;

  final Key? key;

  @override
  String toString() {
    return 'ReactionUserRouteArgs{accountContext: $accountContext, emojiData: $emojiData, noteId: $noteId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ReactionUserRouteArgs) return false;
    return accountContext == other.accountContext &&
        emojiData == other.emojiData &&
        noteId == other.noteId &&
        key == other.key;
  }

  @override
  int get hashCode =>
      accountContext.hashCode ^
      emojiData.hashCode ^
      noteId.hashCode ^
      key.hashCode;
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
         args: RenoteModalRouteArgs(note: note, account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'RenoteModalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RenoteModalRouteArgs>();
      return WrappedRoute(
        child: RenoteModalSheet(
          note: args.note,
          account: args.account,
          key: args.key,
        ),
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RenoteModalRouteArgs) return false;
    return note == other.note && account == other.account && key == other.key;
  }

  @override
  int get hashCode => note.hashCode ^ account.hashCode ^ key.hashCode;
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
         args: RenoteUserRouteArgs(account: account, noteId: noteId, key: key),
         initialChildren: children,
       );

  static const String name = 'RenoteUserRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RenoteUserRouteArgs>();
      return WrappedRoute(
        child: RenoteUserDialog(
          account: args.account,
          noteId: args.noteId,
          key: args.key,
        ),
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RenoteUserRouteArgs) return false;
    return account == other.account &&
        noteId == other.noteId &&
        key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ noteId.hashCode ^ key.hashCode;
}

/// generated route for
/// [RoleSelectDialog]
class RoleSelectRoute extends PageRouteInfo<RoleSelectRouteArgs> {
  RoleSelectRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         RoleSelectRoute.name,
         args: RoleSelectRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'RoleSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RoleSelectRouteArgs>();
      return WrappedRoute(
        child: RoleSelectDialog(account: args.account, key: args.key),
      );
    },
  );
}

class RoleSelectRouteArgs {
  const RoleSelectRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'RoleSelectRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RoleSelectRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
}

/// generated route for
/// [RoomChatPage]
class RoomChatRoute extends PageRouteInfo<RoomChatRouteArgs> {
  RoomChatRoute({
    required ChatRoom room,
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         RoomChatRoute.name,
         args: RoomChatRouteArgs(
           room: room,
           accountContext: accountContext,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'RoomChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RoomChatRouteArgs>();
      return WrappedRoute(
        child: RoomChatPage(
          room: args.room,
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class RoomChatRouteArgs {
  const RoomChatRouteArgs({
    required this.room,
    required this.accountContext,
    this.key,
  });

  final ChatRoom room;

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'RoomChatRouteArgs{room: $room, accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RoomChatRouteArgs) return false;
    return room == other.room &&
        accountContext == other.accountContext &&
        key == other.key;
  }

  @override
  int get hashCode => room.hashCode ^ accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    required AccountContext accountContext,
    Key? key,
    NoteSearchCondition? initialNoteSearchCondition,
    List<PageRouteInfo>? children,
  }) : super(
         SearchRoute.name,
         args: SearchRouteArgs(
           accountContext: accountContext,
           key: key,
           initialNoteSearchCondition: initialNoteSearchCondition,
         ),
         initialChildren: children,
       );

  static const String name = 'SearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SearchRouteArgs>();
      return WrappedRoute(
        child: SearchPage(
          accountContext: args.accountContext,
          key: args.key,
          initialNoteSearchCondition: args.initialNoteSearchCondition,
        ),
      );
    },
  );
}

class SearchRouteArgs {
  const SearchRouteArgs({
    required this.accountContext,
    this.key,
    this.initialNoteSearchCondition,
  });

  final AccountContext accountContext;

  final Key? key;

  final NoteSearchCondition? initialNoteSearchCondition;

  @override
  String toString() {
    return 'SearchRouteArgs{accountContext: $accountContext, key: $key, initialNoteSearchCondition: $initialNoteSearchCondition}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SearchRouteArgs) return false;
    return accountContext == other.accountContext &&
        key == other.key &&
        initialNoteSearchCondition == other.initialNoteSearchCondition;
  }

  @override
  int get hashCode =>
      accountContext.hashCode ^
      key.hashCode ^
      initialNoteSearchCondition.hashCode;
}

/// generated route for
/// [ServerDetailDialog]
class ServerDetailRoute extends PageRouteInfo<ServerDetailRouteArgs> {
  ServerDetailRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ServerDetailRoute.name,
         args: ServerDetailRouteArgs(accountContext: accountContext, key: key),
         initialChildren: children,
       );

  static const String name = 'ServerDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ServerDetailRouteArgs>();
      return WrappedRoute(
        child: ServerDetailDialog(
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class ServerDetailRouteArgs {
  const ServerDetailRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'ServerDetailRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServerDetailRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SeveralAccountGeneralSettingsRouteArgs>();
      return SeveralAccountGeneralSettingsPage(
        account: args.account,
        key: args.key,
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SeveralAccountGeneralSettingsRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
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
         args: SeveralAccountSettingsRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'SeveralAccountSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SeveralAccountSettingsRouteArgs>();
      return SeveralAccountSettingsPage(account: args.account, key: args.key);
    },
  );
}

class SeveralAccountSettingsRouteArgs {
  const SeveralAccountSettingsRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'SeveralAccountSettingsRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SeveralAccountSettingsRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
}

/// generated route for
/// [ShareExtensionPage]
class ShareExtensionRoute extends PageRouteInfo<void> {
  const ShareExtensionRoute({List<PageRouteInfo>? children})
    : super(ShareExtensionRoute.name, initialChildren: children);

  static const String name = 'ShareExtensionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ShareExtensionPage();
    },
  );
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SharingAccountSelectRouteArgs>(
        orElse: () => const SharingAccountSelectRouteArgs(),
      );
      return SharingAccountSelectPage(
        key: args.key,
        sharingText: args.sharingText,
        filePath: args.filePath,
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SharingAccountSelectRouteArgs) return false;
    return key == other.key &&
        sharingText == other.sharingText &&
        const ListEquality().equals(filePath, other.filePath);
  }

  @override
  int get hashCode =>
      key.hashCode ^ sharingText.hashCode ^ const ListEquality().hash(filePath);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [TabSettingsListPage]
class TabSettingsListRoute extends PageRouteInfo<void> {
  const TabSettingsListRoute({List<PageRouteInfo>? children})
    : super(TabSettingsListRoute.name, initialChildren: children);

  static const String name = 'TabSettingsListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TabSettingsListPage();
    },
  );
}

/// generated route for
/// [TabSettingsPage]
class TabSettingsRoute extends PageRouteInfo<TabSettingsRouteArgs> {
  TabSettingsRoute({Key? key, int? tabIndex, List<PageRouteInfo>? children})
    : super(
        TabSettingsRoute.name,
        args: TabSettingsRouteArgs(key: key, tabIndex: tabIndex),
        initialChildren: children,
      );

  static const String name = 'TabSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TabSettingsRouteArgs>(
        orElse: () => const TabSettingsRouteArgs(),
      );
      return TabSettingsPage(key: args.key, tabIndex: args.tabIndex);
    },
  );
}

class TabSettingsRouteArgs {
  const TabSettingsRouteArgs({this.key, this.tabIndex});

  final Key? key;

  final int? tabIndex;

  @override
  String toString() {
    return 'TabSettingsRouteArgs{key: $key, tabIndex: $tabIndex}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TabSettingsRouteArgs) return false;
    return key == other.key && tabIndex == other.tabIndex;
  }

  @override
  int get hashCode => key.hashCode ^ tabIndex.hashCode;
}

/// generated route for
/// [TextFormFieldDialog]
class TextFormFieldRoute extends PageRouteInfo<TextFormFieldRouteArgs> {
  TextFormFieldRoute({
    Key? key,
    Widget? title,
    String? labelText,
    String? buttonText,
    String? initialValue,
    String? Function(String?)? validator,
    List<PageRouteInfo>? children,
  }) : super(
         TextFormFieldRoute.name,
         args: TextFormFieldRouteArgs(
           key: key,
           title: title,
           labelText: labelText,
           buttonText: buttonText,
           initialValue: initialValue,
           validator: validator,
         ),
         initialChildren: children,
       );

  static const String name = 'TextFormFieldRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TextFormFieldRouteArgs>(
        orElse: () => const TextFormFieldRouteArgs(),
      );
      return TextFormFieldDialog(
        key: args.key,
        title: args.title,
        labelText: args.labelText,
        buttonText: args.buttonText,
        initialValue: args.initialValue,
        validator: args.validator,
      );
    },
  );
}

class TextFormFieldRouteArgs {
  const TextFormFieldRouteArgs({
    this.key,
    this.title,
    this.labelText,
    this.buttonText,
    this.initialValue,
    this.validator,
  });

  final Key? key;

  final Widget? title;

  final String? labelText;

  final String? buttonText;

  final String? initialValue;

  final String? Function(String?)? validator;

  @override
  String toString() {
    return 'TextFormFieldRouteArgs{key: $key, title: $title, labelText: $labelText, buttonText: $buttonText, initialValue: $initialValue, validator: $validator}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TextFormFieldRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        labelText == other.labelText &&
        buttonText == other.buttonText &&
        initialValue == other.initialValue;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      title.hashCode ^
      labelText.hashCode ^
      buttonText.hashCode ^
      initialValue.hashCode;
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TimeLineRouteArgs>();
      return TimeLinePage(
        initialTabSetting: args.initialTabSetting,
        key: args.key,
      );
    },
  );
}

class TimeLineRouteArgs {
  const TimeLineRouteArgs({required this.initialTabSetting, this.key});

  final TabSetting initialTabSetting;

  final Key? key;

  @override
  String toString() {
    return 'TimeLineRouteArgs{initialTabSetting: $initialTabSetting, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TimeLineRouteArgs) return false;
    return initialTabSetting == other.initialTabSetting && key == other.key;
  }

  @override
  int get hashCode => initialTabSetting.hashCode ^ key.hashCode;
}

/// generated route for
/// [TimelinePresetDialog]
class TimelinePresetRoute extends PageRouteInfo<void> {
  const TimelinePresetRoute({List<PageRouteInfo>? children})
    : super(TimelinePresetRoute.name, initialChildren: children);

  static const String name = 'TimelinePresetRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TimelinePresetDialog();
    },
  );
}

/// generated route for
/// [UpdateMemoDialog]
class UpdateMemoRoute extends PageRouteInfo<UpdateMemoRouteArgs> {
  UpdateMemoRoute({
    required AccountContext accountContext,
    required String initialMemo,
    required String userId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         UpdateMemoRoute.name,
         args: UpdateMemoRouteArgs(
           accountContext: accountContext,
           initialMemo: initialMemo,
           userId: userId,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'UpdateMemoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UpdateMemoRouteArgs>();
      return WrappedRoute(
        child: UpdateMemoDialog(
          accountContext: args.accountContext,
          initialMemo: args.initialMemo,
          userId: args.userId,
          key: args.key,
        ),
      );
    },
  );
}

class UpdateMemoRouteArgs {
  const UpdateMemoRouteArgs({
    required this.accountContext,
    required this.initialMemo,
    required this.userId,
    this.key,
  });

  final AccountContext accountContext;

  final String initialMemo;

  final String userId;

  final Key? key;

  @override
  String toString() {
    return 'UpdateMemoRouteArgs{accountContext: $accountContext, initialMemo: $initialMemo, userId: $userId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UpdateMemoRouteArgs) return false;
    return accountContext == other.accountContext &&
        initialMemo == other.initialMemo &&
        userId == other.userId &&
        key == other.key;
  }

  @override
  int get hashCode =>
      accountContext.hashCode ^
      initialMemo.hashCode ^
      userId.hashCode ^
      key.hashCode;
}

/// generated route for
/// [UserChatPage]
class UserChatRoute extends PageRouteInfo<UserChatRouteArgs> {
  UserChatRoute({
    required User user,
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         UserChatRoute.name,
         args: UserChatRouteArgs(
           user: user,
           accountContext: accountContext,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'UserChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserChatRouteArgs>();
      return WrappedRoute(
        child: UserChatPage(
          user: args.user,
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class UserChatRouteArgs {
  const UserChatRouteArgs({
    required this.user,
    required this.accountContext,
    this.key,
  });

  final User user;

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'UserChatRouteArgs{user: $user, accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserChatRouteArgs) return false;
    return user == other.user &&
        accountContext == other.accountContext &&
        key == other.key;
  }

  @override
  int get hashCode => user.hashCode ^ accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [UserControlDialog]
class UserControlRoute extends PageRouteInfo<UserControlRouteArgs> {
  UserControlRoute({
    required Account account,
    required UserDetailed response,
    String? host,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         UserControlRoute.name,
         args: UserControlRouteArgs(
           account: account,
           response: response,
           host: host,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'UserControlRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserControlRouteArgs>();
      return WrappedRoute(
        child: UserControlDialog(
          account: args.account,
          response: args.response,
          host: args.host,
          key: args.key,
        ),
      );
    },
  );
}

class UserControlRouteArgs {
  const UserControlRouteArgs({
    required this.account,
    required this.response,
    this.host,
    this.key,
  });

  final Account account;

  final UserDetailed response;

  final String? host;

  final Key? key;

  @override
  String toString() {
    return 'UserControlRouteArgs{account: $account, response: $response, host: $host, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserControlRouteArgs) return false;
    return account == other.account &&
        response == other.response &&
        host == other.host &&
        key == other.key;
  }

  @override
  int get hashCode =>
      account.hashCode ^ response.hashCode ^ host.hashCode ^ key.hashCode;
}

/// generated route for
/// [UserFolloweePage]
class UserFolloweeRoute extends PageRouteInfo<UserFolloweeRouteArgs> {
  UserFolloweeRoute({
    required String userId,
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         UserFolloweeRoute.name,
         args: UserFolloweeRouteArgs(
           userId: userId,
           accountContext: accountContext,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'UserFolloweeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserFolloweeRouteArgs>();
      return WrappedRoute(
        child: UserFolloweePage(
          userId: args.userId,
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class UserFolloweeRouteArgs {
  const UserFolloweeRouteArgs({
    required this.userId,
    required this.accountContext,
    this.key,
  });

  final String userId;

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'UserFolloweeRouteArgs{userId: $userId, accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserFolloweeRouteArgs) return false;
    return userId == other.userId &&
        accountContext == other.accountContext &&
        key == other.key;
  }

  @override
  int get hashCode => userId.hashCode ^ accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [UserFollowerPage]
class UserFollowerRoute extends PageRouteInfo<UserFollowerRouteArgs> {
  UserFollowerRoute({
    required String userId,
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         UserFollowerRoute.name,
         args: UserFollowerRouteArgs(
           userId: userId,
           accountContext: accountContext,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'UserFollowerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserFollowerRouteArgs>();
      return WrappedRoute(
        child: UserFollowerPage(
          userId: args.userId,
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class UserFollowerRouteArgs {
  const UserFollowerRouteArgs({
    required this.userId,
    required this.accountContext,
    this.key,
  });

  final String userId;

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'UserFollowerRouteArgs{userId: $userId, accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserFollowerRouteArgs) return false;
    return userId == other.userId &&
        accountContext == other.accountContext &&
        key == other.key;
  }

  @override
  int get hashCode => userId.hashCode ^ accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [UserListSelectDialog]
class UserListSelectRoute extends PageRouteInfo<UserListSelectRouteArgs> {
  UserListSelectRoute({
    required Account account,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         UserListSelectRoute.name,
         args: UserListSelectRouteArgs(account: account, key: key),
         initialChildren: children,
       );

  static const String name = 'UserListSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserListSelectRouteArgs>();
      return WrappedRoute(
        child: UserListSelectDialog(account: args.account, key: args.key),
      );
    },
  );
}

class UserListSelectRouteArgs {
  const UserListSelectRouteArgs({required this.account, this.key});

  final Account account;

  final Key? key;

  @override
  String toString() {
    return 'UserListSelectRouteArgs{account: $account, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserListSelectRouteArgs) return false;
    return account == other.account && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ key.hashCode;
}

/// generated route for
/// [UserPage]
class UserRoute extends PageRouteInfo<UserRouteArgs> {
  UserRoute({
    required String userId,
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         UserRoute.name,
         args: UserRouteArgs(
           userId: userId,
           accountContext: accountContext,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'UserRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserRouteArgs>();
      return WrappedRoute(
        child: UserPage(
          userId: args.userId,
          accountContext: args.accountContext,
          key: args.key,
        ),
      );
    },
  );
}

class UserRouteArgs {
  const UserRouteArgs({
    required this.userId,
    required this.accountContext,
    this.key,
  });

  final String userId;

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'UserRouteArgs{userId: $userId, accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserRouteArgs) return false;
    return userId == other.userId &&
        accountContext == other.accountContext &&
        key == other.key;
  }

  @override
  int get hashCode => userId.hashCode ^ accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [UserSelectDialog]
class UserSelectRoute extends PageRouteInfo<UserSelectRouteArgs> {
  UserSelectRoute({
    required AccountContext accountContext,
    bool isLocalOnly = false,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         UserSelectRoute.name,
         args: UserSelectRouteArgs(
           accountContext: accountContext,
           isLocalOnly: isLocalOnly,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'UserSelectRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserSelectRouteArgs>();
      return WrappedRoute(
        child: UserSelectDialog(
          accountContext: args.accountContext,
          isLocalOnly: args.isLocalOnly,
          key: args.key,
        ),
      );
    },
  );
}

class UserSelectRouteArgs {
  const UserSelectRouteArgs({
    required this.accountContext,
    this.isLocalOnly = false,
    this.key,
  });

  final AccountContext accountContext;

  final bool isLocalOnly;

  final Key? key;

  @override
  String toString() {
    return 'UserSelectRouteArgs{accountContext: $accountContext, isLocalOnly: $isLocalOnly, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UserSelectRouteArgs) return false;
    return accountContext == other.accountContext &&
        isLocalOnly == other.isLocalOnly &&
        key == other.key;
  }

  @override
  int get hashCode =>
      accountContext.hashCode ^ isLocalOnly.hashCode ^ key.hashCode;
}

/// generated route for
/// [UsersListDetailPage]
class UsersListDetailRoute extends PageRouteInfo<UsersListDetailRouteArgs> {
  UsersListDetailRoute({
    required AccountContext accountContext,
    required String listId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         UsersListDetailRoute.name,
         args: UsersListDetailRouteArgs(
           accountContext: accountContext,
           listId: listId,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'UsersListDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UsersListDetailRouteArgs>();
      return WrappedRoute(
        child: UsersListDetailPage(
          accountContext: args.accountContext,
          listId: args.listId,
          key: args.key,
        ),
      );
    },
  );
}

class UsersListDetailRouteArgs {
  const UsersListDetailRouteArgs({
    required this.accountContext,
    required this.listId,
    this.key,
  });

  final AccountContext accountContext;

  final String listId;

  final Key? key;

  @override
  String toString() {
    return 'UsersListDetailRouteArgs{accountContext: $accountContext, listId: $listId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UsersListDetailRouteArgs) return false;
    return accountContext == other.accountContext &&
        listId == other.listId &&
        key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ listId.hashCode ^ key.hashCode;
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
         args: UsersListModalRouteArgs(account: account, user: user, key: key),
         initialChildren: children,
       );

  static const String name = 'UsersListModalRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UsersListModalRouteArgs>();
      return WrappedRoute(
        child: UsersListModalSheet(
          account: args.account,
          user: args.user,
          key: args.key,
        ),
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UsersListModalRouteArgs) return false;
    return account == other.account && user == other.user && key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ user.hashCode ^ key.hashCode;
}

/// generated route for
/// [UsersListPage]
class UsersListRoute extends PageRouteInfo<UsersListRouteArgs> {
  UsersListRoute({
    required AccountContext accountContext,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         UsersListRoute.name,
         args: UsersListRouteArgs(accountContext: accountContext, key: key),
         initialChildren: children,
       );

  static const String name = 'UsersListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UsersListRouteArgs>();
      return WrappedRoute(
        child: UsersListPage(args.accountContext, key: args.key),
      );
    },
  );
}

class UsersListRouteArgs {
  const UsersListRouteArgs({required this.accountContext, this.key});

  final AccountContext accountContext;

  final Key? key;

  @override
  String toString() {
    return 'UsersListRouteArgs{accountContext: $accountContext, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UsersListRouteArgs) return false;
    return accountContext == other.accountContext && key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ key.hashCode;
}

/// generated route for
/// [UsersListSettingsDialog]
class UsersListSettingsRoute extends PageRouteInfo<UsersListSettingsRouteArgs> {
  UsersListSettingsRoute({
    Key? key,
    Widget? title,
    UsersListSettings initialSettings = const UsersListSettings(),
    List<PageRouteInfo>? children,
  }) : super(
         UsersListSettingsRoute.name,
         args: UsersListSettingsRouteArgs(
           key: key,
           title: title,
           initialSettings: initialSettings,
         ),
         initialChildren: children,
       );

  static const String name = 'UsersListSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UsersListSettingsRouteArgs>(
        orElse: () => const UsersListSettingsRouteArgs(),
      );
      return WrappedRoute(
        child: UsersListSettingsDialog(
          key: args.key,
          title: args.title,
          initialSettings: args.initialSettings,
        ),
      );
    },
  );
}

class UsersListSettingsRouteArgs {
  const UsersListSettingsRouteArgs({
    this.key,
    this.title,
    this.initialSettings = const UsersListSettings(),
  });

  final Key? key;

  final Widget? title;

  final UsersListSettings initialSettings;

  @override
  String toString() {
    return 'UsersListSettingsRouteArgs{key: $key, title: $title, initialSettings: $initialSettings}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UsersListSettingsRouteArgs) return false;
    return key == other.key &&
        title == other.title &&
        initialSettings == other.initialSettings;
  }

  @override
  int get hashCode => key.hashCode ^ title.hashCode ^ initialSettings.hashCode;
}

/// generated route for
/// [UsersListTimelinePage]
class UsersListTimelineRoute extends PageRouteInfo<UsersListTimelineRouteArgs> {
  UsersListTimelineRoute({
    required AccountContext accountContext,
    required UsersList list,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         UsersListTimelineRoute.name,
         args: UsersListTimelineRouteArgs(
           accountContext: accountContext,
           list: list,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'UsersListTimelineRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UsersListTimelineRouteArgs>();
      return WrappedRoute(
        child: UsersListTimelinePage(
          args.accountContext,
          args.list,
          key: args.key,
        ),
      );
    },
  );
}

class UsersListTimelineRouteArgs {
  const UsersListTimelineRouteArgs({
    required this.accountContext,
    required this.list,
    this.key,
  });

  final AccountContext accountContext;

  final UsersList list;

  final Key? key;

  @override
  String toString() {
    return 'UsersListTimelineRouteArgs{accountContext: $accountContext, list: $list, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UsersListTimelineRouteArgs) return false;
    return accountContext == other.accountContext &&
        list == other.list &&
        key == other.key;
  }

  @override
  int get hashCode => accountContext.hashCode ^ list.hashCode ^ key.hashCode;
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

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WordMuteRouteArgs>();
      return WrappedRoute(
        child: WordMutePage(
          account: args.account,
          muteType: args.muteType,
          key: args.key,
        ),
      );
    },
  );
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WordMuteRouteArgs) return false;
    return account == other.account &&
        muteType == other.muteType &&
        key == other.key;
  }

  @override
  int get hashCode => account.hashCode ^ muteType.hashCode ^ key.hashCode;
}
