import "package:dio/dio.dart";
import "package:file/file.dart";
import "package:file/local.dart";
import "package:flutter/widgets.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart"
    hide FileSystem;
import "package:freezed_annotation/freezed_annotation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/acct.dart";
import "package:miria/model/tab_setting.dart";
import "package:miria/model/tab_type.dart";
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
import "package:miria/repository/note_repository.dart";
import "package:miria/repository/role_timeline_repository.dart";
import "package:miria/repository/shared_preference_controller.dart";
import "package:miria/repository/tab_settings_repository.dart";
import "package:miria/repository/time_line_repository.dart";
import "package:miria/repository/user_list_time_line_repository.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "providers.freezed.dart";
part "providers.g.dart";

@Riverpod(keepAlive: true)
Dio dio(DioRef ref) => Dio();

@Riverpod(keepAlive: true)
FileSystem fileSystem(FileSystemRef ref) => const LocalFileSystem();

@Riverpod(keepAlive: true)
@Deprecated(
  "Most case will be replace misskeyGetContext or misskeyPostContext, but will be remain",
)
Misskey misskey(MisskeyRef ref, Account account) => Misskey(
      token: account.token,
      host: account.host,
      socketConnectionTimeout: const Duration(seconds: 20),
    );

@Riverpod(keepAlive: true)
Raw<AppRouter> appRouter(AppRouterRef ref) => AppRouter();

@riverpod
Misskey misskeyWithoutAccount(MisskeyWithoutAccountRef ref, String host) =>
    Misskey(
      host: host,
      token: null,
      socketConnectionTimeout: const Duration(seconds: 20),
    );

final favoriteProvider =
    ChangeNotifierProvider.family<FavoriteRepository, Account>(
  (ref, account) => FavoriteRepository(
    ref.read(misskeyProvider(account)),
    ref.read(notesProvider(account)),
  ),
);

final notesProvider = ChangeNotifierProvider.family<NoteRepository, Account>(
  (ref, account) => NoteRepository(ref.read(misskeyProvider(account)), account),
);

@Riverpod(dependencies: [accountContext])
Raw<NoteRepository> notesWith(NotesWithRef ref) {
  return ref.read(notesProvider(ref.read(accountContextProvider).getAccount));
}

@Riverpod(keepAlive: true)
EmojiRepository emojiRepository(EmojiRepositoryRef ref, Account account) =>
    EmojiRepositoryImpl(
      misskey: ref.read(misskeyProvider(account)),
      account: account,
      accountSettingsRepository: ref.read(accountSettingsRepositoryProvider),
      sharePreferenceController: ref.read(sharedPrefenceControllerProvider),
    );

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

final tabSettingsRepositoryProvider =
    ChangeNotifierProvider((ref) => TabSettingsRepository());

final accountSettingsRepositoryProvider =
    ChangeNotifierProvider((ref) => AccountSettingsRepository());

final generalSettingsRepositoryProvider =
    ChangeNotifierProvider((ref) => GeneralSettingsRepository());

final desktopSettingsRepositoryProvider =
    ChangeNotifierProvider((ref) => DesktopSettingsRepository());

final errorEventProvider =
    StateProvider<(Object? error, BuildContext? context)>(
  (ref) => (null, null),
);

final importExportRepositoryProvider =
    ChangeNotifierProvider((ref) => ImportExportRepository(ref.read));

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

  const AccountContext._();

  bool get isSame => getAccount == postAccount;
}

@Riverpod(dependencies: [])
AccountContext accountContext(AccountContextRef ref) =>
    throw UnimplementedError();

@Riverpod(dependencies: [accountContext])
Misskey misskeyGetContext(MisskeyGetContextRef ref) {
  final account =
      ref.read(accountContextProvider.select((value) => value.getAccount));
  return ref.read(misskeyProvider(account));
}

@Riverpod(dependencies: [accountContext])
Misskey misskeyPostContext(MisskeyPostContextRef ref) {
  final account =
      ref.read(accountContextProvider.select((value) => value.postAccount));
  return ref.read(misskeyProvider(account));
}

final timelineProvider =
    ChangeNotifierProvider.family<TimelineRepository, TabSetting>(
        (ref, setting) {
  final account = ref.read(accountProvider(setting.acct));

  return switch (setting.tabType) {
    TabType.localTimeline => LocalTimelineRepository(
        ref.read(misskeyProvider(account)),
        account,
        ref.read(notesProvider(account)),
        ref.read(generalSettingsRepositoryProvider),
        setting,
        ref,
      ),
    TabType.homeTimeline => HomeTimelineRepository(
        ref.read(misskeyProvider(account)),
        account,
        ref.read(notesProvider(account)),
        ref.read(generalSettingsRepositoryProvider),
        setting,
        ref,
      ),
    TabType.globalTimeline => GlobalTimelineRepository(
        ref.read(misskeyProvider(account)),
        account,
        ref.read(notesProvider(account)),
        ref.read(generalSettingsRepositoryProvider),
        setting,
        ref,
      ),
    TabType.hybridTimeline => HybridTimelineRepository(
        ref.read(misskeyProvider(account)),
        account,
        ref.read(notesProvider(account)),
        ref.read(generalSettingsRepositoryProvider),
        setting,
        ref,
      ),
    TabType.roleTimeline => RoleTimelineRepository(
        ref.read(misskeyProvider(account)),
        account,
        ref.read(notesProvider(account)),
        ref.read(generalSettingsRepositoryProvider),
        setting,
        ref,
      ),
    TabType.channel => ChannelTimelineRepository(
        ref.read(misskeyProvider(account)),
        account,
        ref.read(notesProvider(account)),
        ref.read(generalSettingsRepositoryProvider),
        setting,
        ref,
      ),
    TabType.userList => UserListTimelineRepository(
        ref.read(misskeyProvider(account)),
        account,
        ref.read(notesProvider(account)),
        ref.read(generalSettingsRepositoryProvider),
        setting,
        ref,
      ),
    TabType.antenna => AntennaTimelineRepository(
        ref.read(misskeyProvider(account)),
        account,
        ref.read(notesProvider(account)),
        ref.read(generalSettingsRepositoryProvider),
        setting,
        ref,
      )
  };
});
