import "dart:typed_data";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart" hide Page;
import "package:miria/model/account.dart";
import "package:miria/model/antenna_settings.dart";
import "package:miria/model/clip_settings.dart";
import "package:miria/model/image_file.dart";
import "package:miria/model/misskey_emoji_data.dart";
import "package:miria/model/note_search_condition.dart";
import "package:miria/model/tab_setting.dart";
import "package:miria/model/users_list_settings.dart";
import "package:miria/providers.dart";
import "package:miria/view/abuse_dialog/abuse_dialog.dart";
import "package:miria/view/announcements_page/announcements_page.dart";
import "package:miria/view/antenna_page/antenna_notes_page.dart";
import "package:miria/view/antenna_page/antenna_page.dart";
import "package:miria/view/antenna_page/antenna_settings_dialog.dart";
import "package:miria/view/channel_description_dialog.dart";
import "package:miria/view/channels_page/channel_detail_page.dart";
import "package:miria/view/channels_page/channels_page.dart";
import "package:miria/view/clip_list_page/clip_detail_page.dart";
import "package:miria/view/clip_list_page/clip_list_page.dart";
import "package:miria/view/clip_list_page/clip_settings_dialog.dart";
import "package:miria/view/clip_modal_sheet/clip_modal_sheet.dart";
import "package:miria/view/common/account_select_dialog.dart";
import "package:miria/view/common/color_picker_dialog.dart";
import "package:miria/view/common/misskey_notes/reaction_user_dialog.dart";
import "package:miria/view/common/misskey_notes/renote_modal_sheet.dart";
import "package:miria/view/common/misskey_notes/renote_user_dialog.dart";
import "package:miria/view/explore_page/explore_page.dart";
import "package:miria/view/explore_page/explore_role_users_page.dart";
import "package:miria/view/favorited_note_page/favorited_note_page.dart";
import "package:miria/view/federation_page/federation_page.dart";
import "package:miria/view/games_page/misskey_games_page.dart";
import "package:miria/view/hashtag_page/hashtag_page.dart";
import "package:miria/view/login_page/login_page.dart";
import "package:miria/view/login_page/misskey_server_list_dialog.dart";
import "package:miria/view/misskey_page_page/misskey_page_page.dart";
import "package:miria/view/note_create_page/drive_file_select_dialog.dart";
import "package:miria/view/note_create_page/drive_modal_sheet.dart";
import "package:miria/view/note_create_page/note_create_page.dart";
import "package:miria/view/note_detail_page/note_detail_page.dart";
import "package:miria/view/note_modal_sheet/note_modal_sheet.dart";
import "package:miria/view/notes_after_renote_page/notes_after_renote_page.dart";
import "package:miria/view/notification_page/notification_page.dart";
import "package:miria/view/photo_edit_page/license_confirm_dialog.dart";
import "package:miria/view/photo_edit_page/photo_edit_page.dart";
import "package:miria/view/reaction_picker_dialog/reaction_picker_dialog.dart";
import "package:miria/view/search_page/search_page.dart";
import "package:miria/view/server_detail_dialog.dart";
import "package:miria/view/settings_page/account_settings_page/account_list.dart";
import "package:miria/view/settings_page/app_info_page/app_info_page.dart";
import "package:miria/view/settings_page/general_settings_page/general_settings_page.dart";
import "package:miria/view/settings_page/import_export_page/folder_select_dialog.dart";
import "package:miria/view/settings_page/import_export_page/import_export_page.dart";
import "package:miria/view/settings_page/settings_page.dart";
import "package:miria/view/settings_page/tab_settings_page/antenna_select_dialog.dart";
import "package:miria/view/settings_page/tab_settings_page/channel_select_dialog.dart";
import "package:miria/view/settings_page/tab_settings_page/role_select_dialog.dart";
import "package:miria/view/settings_page/tab_settings_page/tab_settings_list_page.dart";
import "package:miria/view/settings_page/tab_settings_page/tab_settings_page.dart";
import "package:miria/view/settings_page/tab_settings_page/user_list_select_dialog.dart";
import "package:miria/view/several_account_settings_page/cache_management_page/cache_management_page.dart";
import "package:miria/view/several_account_settings_page/instance_mute_page/instance_mute_page.dart";
import "package:miria/view/several_account_settings_page/reaction_deck_page/reaction_deck_page.dart";
import "package:miria/view/several_account_settings_page/several_account_general_settings_page/several_account_general_settings_page.dart";
import "package:miria/view/several_account_settings_page/several_account_settings_page.dart";
import "package:miria/view/several_account_settings_page/word_mute_page/word_mute_page.dart";
import "package:miria/view/share_extension_page/share_extension_page.dart";
import "package:miria/view/sharing_account_select_page/account_select_page.dart";
import "package:miria/view/splash_page/splash_page.dart";
import "package:miria/view/time_line_page/time_line_page.dart";
import "package:miria/view/user_page/antenna_modal_sheet.dart";
import "package:miria/view/user_page/update_memo_dialog.dart";
import "package:miria/view/user_page/user_control_dialog.dart";
import "package:miria/view/user_page/user_followee.dart";
import "package:miria/view/user_page/user_follower.dart";
import "package:miria/view/user_page/user_page.dart";
import "package:miria/view/user_page/users_list_modal_sheet.dart";
import "package:miria/view/user_select_dialog.dart";
import "package:miria/view/users_list_page/users_list_detail_page.dart";
import "package:miria/view/users_list_page/users_list_page.dart";
import "package:miria/view/users_list_page/users_list_settings_dialog.dart";
import "package:miria/view/users_list_page/users_list_timeline_page.dart";
import "package:misskey_dart/misskey_dart.dart";

part "app_router.gr.dart";

@AutoRouterConfig(replaceInRouteName: "Page|Dialog|Sheet,Route")
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: TimeLineRoute.page),
    AutoRoute(page: NoteDetailRoute.page),
    AutoRoute(page: UserRoute.page),
    AutoRoute(page: UserFollowerRoute.page),
    AutoRoute(page: UserFolloweeRoute.page),
    AutoRoute(page: NoteCreateRoute.page),
    AutoRoute(page: PhotoEditRoute.page),
    AutoRoute(page: NotesAfterRenoteRoute.page),
    AutoRoute(page: AntennaRoute.page),
    AutoRoute(page: AntennaNotesRoute.page),
    AutoRoute(page: UsersListRoute.page),
    AutoRoute(page: UsersListTimelineRoute.page),
    AutoRoute(page: UsersListDetailRoute.page),
    AutoRoute(page: NotificationRoute.page),
    AutoRoute(page: FavoritedNoteRoute.page),
    AutoRoute(page: ClipListRoute.page),
    AutoRoute(page: ClipDetailRoute.page),
    AutoRoute(page: ChannelsRoute.page),
    AutoRoute(page: ChannelDetailRoute.page),
    AutoRoute(page: HashtagRoute.page),
    AutoRoute(page: ExploreRoute.page),
    AutoRoute(page: ExploreRoleUsersRoute.page),
    AutoRoute(page: SearchRoute.page),
    AutoRoute(page: FederationRoute.page),
    AutoRoute(page: AnnouncementRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: GeneralSettingsRoute.page),
    AutoRoute(page: TabSettingsListRoute.page),
    AutoRoute(page: TabSettingsRoute.page),
    AutoRoute(page: ImportExportRoute.page),
    AutoRoute(page: AccountListRoute.page),
    AutoRoute(page: AppInfoRoute.page),
    AutoRoute(page: SeveralAccountSettingsRoute.page),
    AutoRoute(page: ReactionDeckRoute.page),
    AutoRoute(page: WordMuteRoute.page),
    AutoRoute(page: InstanceMuteRoute.page),
    AutoRoute(page: CacheManagementRoute.page),
    AutoRoute(page: SeveralAccountGeneralSettingsRoute.page),
    AutoRoute(page: SharingAccountSelectRoute.page),
    AutoRoute(page: MisskeyGamesRoute.page),
    // きしょ……
    AutoRoute(page: MisskeyRouteRoute.page),

    AutoRoute(path: "/share-extension", page: ShareExtensionRoute.page),

    // ダイアログ
    AutoDialogRoute(page: AbuseRoute.page),
    AutoDialogRoute(page: RenoteUserRoute.page),
    AutoDialogRoute(page: ChannelDescriptionRoute.page),
    AutoDialogRoute(page: ExpireSelectRoute.page),
    AutoDialogRoute(page: UpdateMemoRoute.page),
    AutoDialogRoute(page: LicenseConfirmRoute.page),
    AutoDialogRoute(page: ColorPickerRoute.page),
    AutoDialogRoute(page: MisskeyServerListRoute.page),
    AutoDialogRoute(page: ChannelDetailRoute.page),
    AutoDialogRoute(page: ServerDetailRoute.page),
    AutoDialogRoute(page: ReactionUserRoute.page),
    AutoDialogRoute<CommunityChannel>(page: ChannelSelectRoute.page),
    AutoDialogRoute<ClipSettings>(page: ClipSettingsRoute.page),
    AutoDialogRoute<MisskeyEmojiData>(page: ReactionPickerRoute.page),
    AutoDialogRoute<Account>(page: AccountSelectRoute.page),
    AutoDialogRoute<User>(page: UserSelectRoute.page),
    AutoDialogRoute<RolesListResponse>(page: RoleSelectRoute.page),
    AutoDialogRoute<Antenna>(page: AntennaSelectRoute.page),
    AutoDialogRoute<UsersList>(page: UserListSelectRoute.page),
    AutoDialogRoute<UsersListSettings>(page: UsersListSettingsRoute.page),
    AutoDialogRoute<AntennaSettings>(page: AntennaSettingsRoute.page),
    AutoDialogRoute<FolderResult>(page: FolderSelectRoute.page),

    // モーダルシート
    AutoModalRouteSheet(page: UserControlRoute.page),
    AutoModalRouteSheet(page: NoteModalRoute.page),
    AutoModalRouteSheet(page: RenoteModalRoute.page),
    AutoModalRouteSheet(page: AntennaModalRoute.page),
    AutoModalRouteSheet(page: ClipModalRoute.page),
    AutoModalRouteSheet(page: UsersListModalRoute.page),
    AutoModalRouteSheet<DriveModalSheetReturnValue>(page: DriveModalRoute.page),
  ];
}

/// ダイアログ
class AutoDialogRoute<ReturnT extends Object> extends CustomRoute {
  AutoDialogRoute({
    required super.page,
  }) : super(
          transitionsBuilder: TransitionsBuilders.fadeIn,
          durationInMilliseconds: 200,
          fullscreenDialog: false,
          customRouteBuilder: (context, widget, page) => DialogRoute<ReturnT>(
            context: context,
            builder: (context) => widget,
            settings: page,
          ),
        );
}

/// モーダルボトムシート
class AutoModalRouteSheet<ReturnT extends Object> extends CustomRoute {
  AutoModalRouteSheet({
    required super.page,
  }) : super(
          transitionsBuilder: TransitionsBuilders.slideBottom,
          durationInMilliseconds: 200,
          customRouteBuilder: (context, widget, page) =>
              ModalBottomSheetRoute<ReturnT>(
            builder: (context) => widget,
            isScrollControlled: false,
            settings: page,
          ),
        );
}
