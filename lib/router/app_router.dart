import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/view/antenna_page/antenna_page.dart';
import 'package:miria/view/channels_page/channels_page.dart';
import 'package:miria/view/clip_list_page/clip_detail_page.dart';
import 'package:miria/view/clip_list_page/clip_list_page.dart';
import 'package:miria/view/favorited_note_page/favorited_note_page.dart';
import 'package:miria/view/hashtag_page/hashtag_page.dart';
import 'package:miria/view/note_create_page/note_create_page.dart';
import 'package:miria/view/note_search_page/note_search_page.dart';
import 'package:miria/view/notification_page/notification_page.dart';
import 'package:miria/view/settings_page/account_settings_page/account_list.dart';
import 'package:miria/view/settings_page/tab_settings_page/tab_settings_list_page.dart';
import 'package:miria/view/time_line_page/time_line_page.dart';
import 'package:miria/view/user_page/user_followee.dart';
import 'package:miria/view/user_page/user_follower.dart';
import 'package:miria/view/user_page/user_page.dart';
import 'package:miria/view/users_list_page/users_list_page.dart';
import 'package:miria/view/users_list_page/users_list_timeline_page.dart';
import 'package:misskey_dart/misskey_dart.dart';

import '../view/antenna_page/antenna_notes_page.dart';
import '../view/channels_page/channel_detail_page.dart';
import '../view/login_page/login_page.dart';
import '../view/settings_page/settings_page.dart';
import '../view/settings_page/tab_settings_page/tab_settings_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: AntennaRoute.page),
    AutoRoute(page: AntennaNotesRoute.page),
    AutoRoute(page: TimeLineRoute.page),
    AutoRoute(page: UserRoute.page),
    AutoRoute(page: NotificationRoute.page),
    AutoRoute(page: FavoritedNoteRoute.page),
    AutoRoute(page: ClipListRoute.page),
    AutoRoute(page: ClipDetailRoute.page),
    AutoRoute(page: NoteCreateRoute.page),
    AutoRoute(page: UsersListRoute.page),
    AutoRoute(page: UsersListTimelineRoute.page),
    AutoRoute(page: UserFollowerRoute.page),
    AutoRoute(page: UserFolloweeRoute.page),
    AutoRoute(page: ChannelsRoute.page),
    AutoRoute(page: ChannelDetailRoute.page),
    AutoRoute(page: NoteSearchRoute.page),
    AutoRoute(page: HashtagRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: TabSettingsListRoute.page),
    AutoRoute(page: TabSettingsRoute.page),
    AutoRoute(page: AccountListRoute.page),
  ];
}
