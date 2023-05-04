import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/model/tab_setting.dart';
import 'package:flutter_misskey_app/view/channels_page/channels_page.dart';
import 'package:flutter_misskey_app/view/clip_list_page/clip_detail_page.dart';
import 'package:flutter_misskey_app/view/clip_list_page/clip_list_page.dart';
import 'package:flutter_misskey_app/view/favorited_note_page/favorited_note_page.dart';
import 'package:flutter_misskey_app/view/note_create_page/note_create_page.dart';
import 'package:flutter_misskey_app/view/notification_page/notification_page.dart';
import 'package:flutter_misskey_app/view/settings_page/tab_settings_page/tab_settings_list_page.dart';
import 'package:flutter_misskey_app/view/time_line_page/time_line_page.dart';
import 'package:flutter_misskey_app/view/user_page/user_page.dart';
import 'package:flutter_misskey_app/view/users_list_page/users_list_page.dart';
import 'package:flutter_misskey_app/view/users_list_page/users_list_timeline.dart';
import 'package:flutter_misskey_app/view/users_list_page/users_list_timeline_page.dart';

import '../view/channels_page/channel_detail_page.dart';
import '../view/login_page/login_page.dart';
import '../view/settings_page/settings_page.dart';
import '../view/settings_page/tab_settings_page/tab_settings_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: TimeLineRoute.page),
    AutoRoute(page: UserRoute.page),
    AutoRoute(page: NotificationRoute.page),
    AutoRoute(page: FavoritedNoteRoute.page),
    AutoRoute(page: ClipListRoute.page),
    AutoRoute(page: ClipDetailRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: TabSettingsListRoute.page),
    AutoRoute(page: TabSettingsRoute.page),
    AutoRoute(page: NoteCreateRoute.page),
    AutoRoute(page: UsersListRoute.page),
    AutoRoute(page: UsersListTimelineRoute.page),
    AutoRoute(page: ChannelsRoute.page),
    AutoRoute(page: ChannelDetailRoute.page),
  ];
}
