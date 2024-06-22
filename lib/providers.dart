import "package:dio/dio.dart";
import "package:file/file.dart";
import "package:file/local.dart";
import "package:flutter/widgets.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/acct.dart";
import "package:miria/model/tab_setting.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/repository/account_settings_repository.dart";
import "package:miria/repository/antenna_timeline_repository.dart";
import "package:miria/repository/channel_time_line_repository.dart";
import "package:miria/repository/desktop_settings_repository.dart";
import "package:miria/repository/emoji_repository.dart";
import "package:miria/repository/favorite_repository.dart";
import "package:miria/repository/general_settings_repository.dart";
import "package:miria/repository/global_time_line_repository.dart";
import "package:miria/repository/home_time_line_repository.dart";
import "package:miria/repository/hybrid_timeline_repository.dart";
import "package:miria/repository/import_export_repository.dart";
import "package:miria/repository/local_time_line_repository.dart";
import "package:miria/repository/main_stream_repository.dart";
import "package:miria/repository/note_repository.dart";
import "package:miria/repository/role_timeline_repository.dart";
import "package:miria/repository/shared_preference_controller.dart";
import "package:miria/repository/tab_settings_repository.dart";
import "package:miria/repository/user_list_time_line_repository.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "providers.freezed.dart";
part "providers.g.dart";

@Riverpod(keepAlive: true)
Dio dio(DioRef ref) => Dio();

@Riverpod(keepAlive: true)
FileSystem fileSystem(FileSystemRef ref) => const LocalFileSystem();

@Riverpod(keepAlive: true)
Misskey misskey(MisskeyRef ref, Account account) => Misskey(
      token: account.token,
      host: account.host,
      socketConnectionTimeout: const Duration(seconds: 20),
    );

@riverpod
Misskey misskeyWithoutAccount(MisskeyWithoutAccountRef ref, String host) =>
    Misskey(
      host: host,
      token: null,
      socketConnectionTimeout: const Duration(seconds: 20),
    );

@Riverpod(keepAlive: true)
Raw<LocalTimelineRepository> localTimeline(
  LocalTimelineRef ref,
  TabSetting tabSetting,
) {
  final account = ref.read(accountProvider(tabSetting.acct));
  return LocalTimelineRepository(
    ref.read(misskeyProvider(account)),
    account,
    ref.read(notesProvider(account)),
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(generalSettingsRepositoryProvider),
    tabSetting,
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(accountRepositoryProvider.notifier),
    ref.read(emojiRepositoryProvider(account)),
  );
}

@Riverpod(keepAlive: true)
Raw<HomeTimelineRepository> homeTimeline(
  HomeTimelineRef ref,
  TabSetting tabSetting,
) {
  final account = ref.read(accountProvider(tabSetting.acct));
  return HomeTimelineRepository(
    ref.read(misskeyProvider(account)),
    account,
    ref.read(notesProvider(account)),
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(generalSettingsRepositoryProvider),
    tabSetting,
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(accountRepositoryProvider.notifier),
    ref.read(emojiRepositoryProvider(account)),
  );
}

@Riverpod(keepAlive: true)
Raw<GlobalTimelineRepository> globalTimeline(
  GlobalTimelineRef ref,
  TabSetting tabSetting,
) {
  final account = ref.read(accountProvider(tabSetting.acct));
  return GlobalTimelineRepository(
    ref.read(misskeyProvider(account)),
    ref.read(notesProvider(account)),
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(generalSettingsRepositoryProvider),
    tabSetting,
  );
}

@Riverpod(keepAlive: true)
Raw<HybridTimelineRepository> hybridTimeline(
  HybridTimelineRef ref,
  TabSetting tabSetting,
) {
  final account = ref.read(accountProvider(tabSetting.acct));
  return HybridTimelineRepository(
    ref.read(misskeyProvider(account)),
    account,
    ref.read(notesProvider(account)),
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(generalSettingsRepositoryProvider),
    tabSetting,
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(accountRepositoryProvider.notifier),
    ref.read(emojiRepositoryProvider(account)),
  );
}

@Riverpod(keepAlive: true)
Raw<RoleTimelineRepository> roleTimeline(
  RoleTimelineRef ref,
  TabSetting tabSetting,
) {
  final account = ref.read(accountProvider(tabSetting.acct));
  return RoleTimelineRepository(
    ref.read(misskeyProvider(account)),
    account,
    ref.read(notesProvider(account)),
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(generalSettingsRepositoryProvider),
    tabSetting,
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(accountRepositoryProvider.notifier),
    ref.read(emojiRepositoryProvider(account)),
  );
}

@Riverpod(keepAlive: true)
Raw<ChannelTimelineRepository> channelTimeline(
  ChannelTimelineRef ref,
  TabSetting tabSetting,
) {
  final account = ref.read(accountProvider(tabSetting.acct));
  return ChannelTimelineRepository(
    ref.read(misskeyProvider(account)),
    account,
    ref.read(notesProvider(account)),
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(generalSettingsRepositoryProvider),
    tabSetting,
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(accountRepositoryProvider.notifier),
    ref.read(emojiRepositoryProvider(account)),
  );
}

@Riverpod(keepAlive: true)
Raw<UserListTimelineRepository> userListTimeline(
  UserListTimelineRef ref,
  TabSetting tabSetting,
) {
  final account = ref.read(accountProvider(tabSetting.acct));
  return UserListTimelineRepository(
    ref.read(misskeyProvider(account)),
    account,
    ref.read(notesProvider(account)),
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(generalSettingsRepositoryProvider),
    tabSetting,
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(accountRepositoryProvider.notifier),
    ref.read(emojiRepositoryProvider(account)),
  );
}

@Riverpod(keepAlive: true)
Raw<AntennaTimelineRepository> antennaTimeline(
  AntennaTimelineRef ref,
  TabSetting tabSetting,
) {
  final account = ref.read(accountProvider(tabSetting.acct));
  return AntennaTimelineRepository(
    ref.read(misskeyProvider(account)),
    account,
    ref.read(notesProvider(account)),
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(generalSettingsRepositoryProvider),
    tabSetting,
    ref.read(mainStreamRepositoryProvider(account)),
    ref.read(accountRepositoryProvider.notifier),
    ref.read(emojiRepositoryProvider(account)),
  );
}

@Riverpod(keepAlive: true)
Raw<MainStreamRepository> mainStreamRepository(
  MainStreamRepositoryRef ref,
  Account account,
) {
  return MainStreamRepository(
    ref.read(misskeyProvider(account)),
    ref.read(emojiRepositoryProvider(account)),
    account,
    ref.read(accountRepositoryProvider.notifier),
  );
}

@riverpod
Raw<FavoriteRepository> favorite(FavoriteRef ref, Account account) {
  return FavoriteRepository(
    ref.read(misskeyProvider(account)),
    ref.read(notesProvider(account)),
  );
}

@Riverpod(keepAlive: true)
Raw<NoteRepository> notes(NotesRef ref, Account account) =>
    NoteRepository(ref.read(misskeyProvider(account)), account);

@Riverpod(keepAlive: true)
Raw<EmojiRepository> emojiRepository(EmojiRepositoryRef ref, Account account) {
  return EmojiRepositoryImpl(
    misskey: ref.read(misskeyProvider(account)),
    account: account,
    accountSettingsRepository: ref.read(accountSettingsRepositoryProvider),
    sharePreferenceController: ref.read(sharedPrefenceControllerProvider),
  );
}

@riverpod
List<Account> accounts(AccountsRef ref) => ref.watch(accountRepositoryProvider);

@riverpod
MeDetailed i(IRef ref, Acct acct) {
  final accounts = ref.watch(accountsProvider);
  final account = accounts.firstWhere((account) => account.acct == acct);
  return account.i;
}

@riverpod
Account account(AccountRef ref, Acct acct) => ref.watch(
      accountsProvider.select(
        (accounts) => accounts.firstWhere((account) => account.acct == acct),
      ),
    );

@Riverpod(keepAlive: true)
Raw<TabSettingsRepository> tabSettingsRepository(
  TabSettingsRepositoryRef ref,
) {
  return TabSettingsRepository();
}

@Riverpod(keepAlive: true)
Raw<AccountSettingsRepository> accountSettingsRepository(
  AccountSettingsRepositoryRef ref,
) {
  return AccountSettingsRepository();
}

@Riverpod(keepAlive: true)
Raw<GeneralSettingsRepository> generalSettingsRepository(
  GeneralSettingsRepositoryRef ref,
) {
  return GeneralSettingsRepository();
}

@Riverpod(keepAlive: true)
Raw<DesktopSettingsRepository> desktopSettingsRepository(
  DesktopSettingsRepositoryRef ref,
) {
  return DesktopSettingsRepository();
}

final errorEventProvider =
    StateProvider<(Object? error, BuildContext? context)>(
  (ref) => (null, null),
);

@Riverpod(keepAlive: true)
Raw<ImportExportRepository> importExportRepository(
  ImportExportRepositoryRef ref,
) {
  return ImportExportRepository(ref.read);
}

@Riverpod(keepAlive: true)
BaseCacheManager? cacheManager(CacheManagerRef ref) => null;

@freezed
class AccountContext with _$AccountContext {
  const factory AccountContext({
    /// 他鯖を取得するなどの目的で、非ログイン状態として使用されるアカウント
    required Account getAccount,
    required Account postAccount,
  }) = _AccountContext;

  factory AccountContext.as(Account account) =>
      AccountContext(getAccount: account, postAccount: account);
}

@Riverpod(dependencies: [])
AccountContext accountContext(AccountContextRef ref) =>
    throw UnimplementedError();
