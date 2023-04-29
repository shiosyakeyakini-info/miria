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
    TimeLineRoute.name: (routeData) {
      final args = routeData.argsAs<TimeLineRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: TimeLinePage(
          key: args.key,
          currentTabSetting: args.currentTabSetting,
        ),
      );
    }
  };
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
