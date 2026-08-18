import "dart:io";

import "package:auto_route/auto_route.dart";
import "package:dio/dio.dart";
import "package:file_picker/src/platform/file_picker_platform_interface.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/repository/account_settings_repository.dart";
import "package:miria/repository/chat_room_repository.dart";
import "package:miria/repository/emoji_repository.dart";
import "package:miria/repository/general_settings_repository.dart";
import "package:miria/repository/note_repository.dart";
import "package:miria/repository/tab_settings_repository.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:misskey_dart/src/misskey_chat.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";
import "package:plugin_platform_interface/plugin_platform_interface.dart";
import "package:url_launcher_platform_interface/url_launcher_platform_interface.dart";

@GenerateNiceMocks([
  // レポジトリ
  MockSpec<TabSettingsRepository>(),
  MockSpec<AccountSettingsRepository>(),
  MockSpec<ChatRoomRepository>(),
  MockSpec<EmojiRepository>(),
  MockSpec<GeneralSettingsRepository>(),
  MockSpec<AccountRepository>(),
  MockSpec<NoteRepository>(),

  // API
  MockSpec<Misskey>(),
  MockSpec<MisskeyAntenna>(),
  MockSpec<MisskeyAp>(),
  MockSpec<MisskeyBlocking>(),
  MockSpec<MisskeyChannels>(),
  MockSpec<MisskeyClips>(),
  MockSpec<MisskeyDrive>(),
  MockSpec<MisskeyDriveFolders>(),
  MockSpec<MisskeyDriveFiles>(),
  MockSpec<MisskeyFederation>(),
  MockSpec<MisskeyFollowing>(),
  MockSpec<MisskeyHashtags>(),
  MockSpec<MisskeyI>(),
  MockSpec<MisskeyNotes>(),
  MockSpec<MisskeyNotesFavorites>(),
  MockSpec<MisskeyNotesReactions>(),
  MockSpec<MisskeyNotesPolls>(),
  MockSpec<MisskeyRenoteMute>(),
  MockSpec<MisskeyRoles>(),
  MockSpec<MisskeyBubbleGame>(),
  MockSpec<MisskeyUsers>(),

  // チャット関連
  MockSpec<MisskeyChat>(),
  MockSpec<MisskeyChatMessages>(),
  MockSpec<MisskeyChatRooms>(),
  MockSpec<MisskeyChatRoomsInvitations>(),

  // プラグインとか
  MockSpec<Dio>(),
  MockSpec<HttpClient>(),
  MockSpec<StreamingController>(),
  MockSpec<WebSocketController>(),
  MockSpec<FakeFilePickerPlatform>(as: #MockFilePickerPlatform),
  MockSpec<$MockCacheManager>(as: #MockCacheManager),
  MockSpec<$MockUrlLauncherPlatform>(as: #MockUrlLauncherPlatform),
])
// ignore: unused_import
import "mock.mocks.dart";

class $MockCacheManager extends Mock implements CacheManager {}

class FakeFilePickerPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements FilePickerPlatform {}

class $MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class MockAppRouter extends Mock implements AppRouter {
  @override
  Future<T?> push<T extends Object?>(
    PageRouteInfo<Object?> route, {
    void Function(NavigationFailure)? onFailure,
  }) => super.noSuchMethod(
    Invocation.method(#push, [route], {#onFailure: onFailure}),
    returnValue: Future<T?>.value(),
    returnValueForMissingStub: Future<T?>.value(),
  );
}
