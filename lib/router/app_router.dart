import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/tab_settings.dart';
import 'package:flutter_misskey_app/view/notification_page/notification_page.dart';
import 'package:flutter_misskey_app/view/time_line_page/time_line_page.dart';
import 'package:flutter_misskey_app/view/user_page/user_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: TimeLineRoute.page),
    AutoRoute(page: UserRoute.page),
    AutoRoute(page: NotificationRoute.page),
  ];
}
