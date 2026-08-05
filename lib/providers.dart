import "package:dio/dio.dart";
import "package:file/file.dart";
import "package:file/local.dart";
import "package:flutter/widgets.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart"
    hide FileSystem;
import "package:freezed_annotation/freezed_annotation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:hooks_riverpod/legacy.dart";
import "package:miria/model/account.dart";
import "package:miria/model/achievement.dart";
import "package:miria/model/acct.dart";
import "package:miria/model/tab_setting.dart";
import "package:miria/model/tab_type.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/repository/account_settings_repository.dart";
import "package:miria/repository/antenna_timeline_repository.dart";
import "package:miria/repository/channel_time_line_repository.dart";
import "package:miria/repository/custom_timeline_repository.dart";
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
import "package:miria/util/file_system_io.dart" as fs;
import "package:miria/util/window_listener.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod/riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "providers.freezed.dart";
part "providers.g.dart";

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio();
  dio.options.responseType = ResponseType.json;
  return dio;
}

@Riverpod(keepAlive: true)
FileSystem fileSystem(Ref ref) => const LocalFileSystem();

/// 実績名の対訳表。表示言語を変えたら引き直す。
@Riverpod(keepAlive: true)
Future<Achievements> achievements(Ref ref) async {
  final language = ref.watch(
    generalSettingsRepositoryProvider.select(
      (value) => value.settings.languages,
    ),
  );
  return Achievements.load(language);
}

/// 再認証で差し替わったアカウントのトークン。まだ差し替わっていなければ null。
///
/// [misskey] から [AccountRepository] を直接 watch すれば済みそうに見えるが、
/// [AccountRepository] 自身が [emojiRepository] 経由で [misskey] を読むため
/// 循環参照になる。トークンだけを一方通行の provider に切り出している。
@Riverpod(keepAlive: true)
class LatestAccountToken extends _$LatestAccountToken {
  @override
  String? build(Acct acct) => null;

  // ignore: use_setters_to_change_properties
  void update(String? token) => state = token;
}

@Riverpod(keepAlive: true)
@Deprecated(
  "Most case will be replace misskeyGetContext or misskeyPostContext, but will be remain",
)
Misskey misskey(Ref ref, Account account) {
  final hostWithPort = account.port != null
      ? "${account.host}:${account.port}"
      : account.host;

  final apiUrl = account.scheme == "http" ? "http://$hostWithPort/api/" : null;

  final streamingUrl = account.scheme == "http"
      ? "ws://$hostWithPort/streaming/"
      : null;

  // 引数の account が持つトークンをそのまま使わない。Account の == は host と
  // userId しか見ないため、再認証でトークンだけが変わってもこの family は同じ
  // キーと判定される。family は最初に渡された引数を保持し続けるので、あとから
  // 新しい Account で読み直しても古いトークンのままになってしまう (#776)。
  final token =
      ref.watch(latestAccountTokenProvider(account.acct)) ?? account.token;

  return Misskey(
    token: token,
    host: hostWithPort,
    apiUrl: apiUrl,
    streamingUrl: streamingUrl,
    socketConnectionTimeout: const Duration(seconds: 20),
  );
}

@Riverpod(keepAlive: true)
Raw<AppRouter> appRouter(Ref ref) => AppRouter();

@riverpod
Misskey misskeyWithoutAccount(Ref ref, String hostOrUrl) {
  // HTTP接続をサポートするためにカスタムURL指定
  final uri = Uri.parse(
    hostOrUrl.startsWith("http") ? hostOrUrl : "https://$hostOrUrl",
  );

  final hostWithPort = uri.hasPort ? "${uri.host}:${uri.port}" : uri.host;

  final apiUrl = uri.scheme == "http" ? "http://$hostWithPort/api/" : null;

  final streamingUrl = uri.scheme == "http"
      ? "ws://$hostWithPort/streaming/"
      : null;

  return Misskey(
    host: hostWithPort,
    token: null,
    apiUrl: apiUrl,
    streamingUrl: streamingUrl,
    socketConnectionTimeout: const Duration(seconds: 20),
  );
}

final favoriteProvider =
    ChangeNotifierProvider.family<FavoriteRepository, Account>(
      (ref, account) => FavoriteRepository(
        ref.watch(misskeyProvider(account)),
        ref.read(notesProvider(account)),
      ),
    );

final notesProvider = ChangeNotifierProvider.family<NoteRepository, Account>(
  (ref, account) =>
      NoteRepository(ref.watch(misskeyProvider(account)), account),
);

@Riverpod(dependencies: [accountContext])
Raw<NoteRepository> notesWith(Ref ref) {
  return ref.read(notesProvider(ref.read(accountContextProvider).getAccount));
}

@Riverpod(keepAlive: true)
EmojiRepository emojiRepository(Ref ref, Account account) =>
    EmojiRepositoryImpl(
      misskey: ref.watch(misskeyProvider(account)),
      account: account,
      accountSettingsRepository: ref.read(accountSettingsRepositoryProvider),
      sharePreferenceController: ref.read(sharedPrefenceControllerProvider),
    );

@riverpod
List<Account> accounts(Ref ref) => ref.watch(accountRepositoryProvider);

@riverpod
MeDetailed i(Ref ref, Acct acct) {
  final accounts = ref.watch(accountsProvider);
  final account = accounts.firstWhere((account) => account.acct == acct);
  return account.i;
}

@riverpod
Account account(Ref ref, Acct acct) => ref.watch(
  accountsProvider.select(
    (accounts) => accounts.firstWhere((account) => account.acct == acct),
  ),
);

final tabSettingsRepositoryProvider = ChangeNotifierProvider(
  (ref) => TabSettingsRepository(),
);

final accountSettingsRepositoryProvider = ChangeNotifierProvider(
  (ref) => AccountSettingsRepository(),
);

final generalSettingsRepositoryProvider = ChangeNotifierProvider(
  (ref) => GeneralSettingsRepository(),
);

final desktopSettingsRepositoryProvider = ChangeNotifierProvider(
  (ref) => DesktopSettingsRepository(),
);

final errorEventProvider =
    StateProvider<(Object? error, BuildContext? context)>(
      (ref) => (null, null),
    );

final importExportRepositoryProvider = ChangeNotifierProvider(
  (ref) => ImportExportRepository(ref),
);

@Riverpod(keepAlive: true)
CacheManager cacheManager(Ref ref) => CacheManager(
  Config(
    "libCachedImageData",
    maxNrOfCacheObjects: 10000,
    fileSystem: fs.IOFileSystem("libCachedImageData"),
  ),
);

@Riverpod(keepAlive: true)
MiriaWindowListener miriaWindowListener(Ref ref) => MiriaWindowListener(ref);

@freezed
abstract class AccountContext with _$AccountContext {
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
AccountContext accountContext(Ref ref) => throw UnimplementedError();

@Riverpod(dependencies: [accountContext])
Misskey misskeyGetContext(Ref ref) {
  final account = ref.read(
    accountContextProvider.select((value) => value.getAccount),
  );
  return ref.watch(misskeyProvider(account));
}

@Riverpod(dependencies: [accountContext])
Misskey misskeyPostContext(Ref ref) {
  final account = ref.read(
    accountContextProvider.select((value) => value.postAccount),
  );
  return ref.watch(misskeyProvider(account));
}

final timelineProvider =
    ChangeNotifierProvider.family<TimelineRepository, TabSetting>((
      ref,
      setting,
    ) {
      final account = ref.read(accountProvider(setting.acct));

      return switch (setting.tabType) {
        TabType.localTimeline => LocalTimelineRepository(
          ref.watch(misskeyProvider(account)),
          account,
          ref.read(notesProvider(account)),
          ref.read(generalSettingsRepositoryProvider),
          setting,
          ref,
        ),
        TabType.homeTimeline => HomeTimelineRepository(
          ref.watch(misskeyProvider(account)),
          account,
          ref.read(notesProvider(account)),
          ref.read(generalSettingsRepositoryProvider),
          setting,
          ref,
        ),
        TabType.globalTimeline => GlobalTimelineRepository(
          ref.watch(misskeyProvider(account)),
          account,
          ref.read(notesProvider(account)),
          ref.read(generalSettingsRepositoryProvider),
          setting,
          ref,
        ),
        TabType.hybridTimeline => HybridTimelineRepository(
          ref.watch(misskeyProvider(account)),
          account,
          ref.read(notesProvider(account)),
          ref.read(generalSettingsRepositoryProvider),
          setting,
          ref,
        ),
        TabType.roleTimeline => RoleTimelineRepository(
          ref.watch(misskeyProvider(account)),
          account,
          ref.read(notesProvider(account)),
          ref.read(generalSettingsRepositoryProvider),
          setting,
          ref,
        ),
        TabType.channel => ChannelTimelineRepository(
          ref.watch(misskeyProvider(account)),
          account,
          ref.read(notesProvider(account)),
          ref.read(generalSettingsRepositoryProvider),
          setting,
          ref,
        ),
        TabType.userList => UserListTimelineRepository(
          ref.watch(misskeyProvider(account)),
          account,
          ref.read(notesProvider(account)),
          ref.read(generalSettingsRepositoryProvider),
          setting,
          ref,
        ),
        TabType.antenna => AntennaTimelineRepository(
          ref.watch(misskeyProvider(account)),
          account,
          ref.read(notesProvider(account)),
          ref.read(generalSettingsRepositoryProvider),
          setting,
          ref,
        ),
        TabType.customTimeline => CustomTimelineRepository(
          ref.watch(misskeyProvider(account)),
          account,
          ref.read(notesProvider(account)),
          ref.read(generalSettingsRepositoryProvider),
          setting,
          ref,
        ),
      };
    });
