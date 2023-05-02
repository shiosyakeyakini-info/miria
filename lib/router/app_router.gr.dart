// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    NotificationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const NotificationPage(),
      );
    },
    UserRoute.name: (routeData) {
      final args = routeData.argsAs<UserRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserPage(
          key: args.key,
          userId: args.userId,
        ),
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
    FavoritedNoteRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FavoritedNotePage(),
      );
    },
    ClipListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ClipListPage(),
      );
    },
  };
}

/// generated route for
/// [NotificationPage]
class NotificationRoute extends PageRouteInfo<void> {
  const NotificationRoute({List<PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserPage]
class UserRoute extends PageRouteInfo<UserRouteArgs> {
  UserRoute({
    Key? key,
    required String userId,
    List<PageRouteInfo>? children,
  }) : super(
          UserRoute.name,
          args: UserRouteArgs(
            key: key,
            userId: userId,
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
  });

  final Key? key;

  final String userId;

  @override
  String toString() {
    return 'UserRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [TimeLinePage]
class TimeLineRoute extends PageRouteInfo<TimeLineRouteArgs> {
  TimeLineRoute({
    Key? key,
    required TabSettings currentTabSetting,
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

  final TabSettings currentTabSetting;

  @override
  String toString() {
    return 'TimeLineRouteArgs{key: $key, currentTabSetting: $currentTabSetting}';
  }
}

/// generated route for
/// [FavoritedNotePage]
class FavoritedNoteRoute extends PageRouteInfo<void> {
  const FavoritedNoteRoute({List<PageRouteInfo>? children})
      : super(
          FavoritedNoteRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavoritedNoteRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ClipListPage]
class ClipListRoute extends PageRouteInfo<void> {
  const ClipListRoute({List<PageRouteInfo>? children})
      : super(
          ClipListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ClipListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
