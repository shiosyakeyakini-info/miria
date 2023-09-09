import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/widgets.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/repository/account_repository.dart';
import 'package:miria/repository/account_settings_repository.dart';
import 'package:miria/repository/antenna_timeline_repository.dart';
import 'package:miria/repository/channel_time_line_repository.dart';
import 'package:miria/repository/emoji_repository.dart';
import 'package:miria/repository/favorite_repository.dart';
import 'package:miria/repository/general_settings_repository.dart';
import 'package:miria/repository/hybrid_timeline_repository.dart';
import 'package:miria/repository/import_export_repository.dart';
import 'package:miria/repository/main_stream_repository.dart';
import 'package:miria/repository/global_time_line_repository.dart';
import 'package:miria/repository/home_time_line_repository.dart';
import 'package:miria/repository/local_time_line_repository.dart';
import 'package:miria/repository/note_repository.dart';
import 'package:miria/repository/tab_settings_repository.dart';
import 'package:miria/repository/time_line_repository.dart';
import 'package:miria/repository/user_list_time_line_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/state_notifier/note_create_page/note_create_state_notifier.dart';
import 'package:miria/state_notifier/photo_edit_page/photo_edit_state_notifier.dart';
import 'package:misskey_dart/misskey_dart.dart';

final dioProvider = Provider((ref) => Dio());
final fileSystemProvider =
    Provider<FileSystem>((ref) => const LocalFileSystem());
final misskeyProvider = Provider.family<Misskey, Account>(
    (ref, account) => Misskey(token: account.token, host: account.host));

final localTimeLineProvider =
    ChangeNotifierProvider.family<TimelineRepository, TabSetting>(
        (ref, tabSetting) => LocalTimeLineRepository(
              ref.read(misskeyProvider(tabSetting.account)),
              ref.read(notesProvider(tabSetting.account)),
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(generalSettingsRepositoryProvider),
              tabSetting,
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(accountRepository),
              ref.read(emojiRepositoryProvider(tabSetting.account)),
            ));
final homeTimeLineProvider =
    ChangeNotifierProvider.family<TimelineRepository, TabSetting>(
        (ref, tabSetting) => HomeTimeLineRepository(
              ref.read(misskeyProvider(tabSetting.account)),
              ref.read(notesProvider(tabSetting.account)),
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(generalSettingsRepositoryProvider),
              tabSetting,
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(accountRepository),
              ref.read(emojiRepositoryProvider(tabSetting.account)),
            ));
final globalTimeLineProvider =
    ChangeNotifierProvider.family<TimelineRepository, TabSetting>(
        (ref, tabSetting) => GlobalTimeLineRepository(
              ref.read(misskeyProvider(tabSetting.account)),
              ref.read(notesProvider(tabSetting.account)),
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(generalSettingsRepositoryProvider),
              tabSetting,
            ));

final hybridTimeLineProvider =
    ChangeNotifierProvider.family<TimelineRepository, TabSetting>(
        (ref, tabSetting) => HybridTimelineRepository(
              ref.read(misskeyProvider(tabSetting.account)),
              ref.read(notesProvider(tabSetting.account)),
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(generalSettingsRepositoryProvider),
              tabSetting,
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(accountRepository),
              ref.read(emojiRepositoryProvider(tabSetting.account)),
            ));

final channelTimelineProvider =
    ChangeNotifierProvider.family<ChannelTimelineRepository, TabSetting>(
        (ref, tabSetting) => ChannelTimelineRepository(
              ref.read(misskeyProvider(tabSetting.account)),
              ref.read(notesProvider(tabSetting.account)),
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(generalSettingsRepositoryProvider),
              tabSetting,
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(accountRepository),
              ref.read(emojiRepositoryProvider(tabSetting.account)),
            ));

final userListTimelineProvider =
    ChangeNotifierProvider.family<UserListTimelineRepository, TabSetting>(
        (ref, tabSetting) => UserListTimelineRepository(
              ref.read(misskeyProvider(tabSetting.account)),
              ref.read(notesProvider(tabSetting.account)),
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(generalSettingsRepositoryProvider),
              tabSetting,
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(accountRepository),
              ref.read(emojiRepositoryProvider(tabSetting.account)),
            ));

final antennaTimelineProvider =
    ChangeNotifierProvider.family<AntennaTimelineRepository, TabSetting>(
        (ref, tabSetting) => AntennaTimelineRepository(
              ref.read(misskeyProvider(tabSetting.account)),
              ref.read(notesProvider(tabSetting.account)),
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(generalSettingsRepositoryProvider),
              tabSetting,
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              ref.read(accountRepository),
              ref.read(emojiRepositoryProvider(tabSetting.account)),
            ));

final mainStreamRepositoryProvider =
    ChangeNotifierProvider.family<MainStreamRepository, Account>(
        (ref, account) => MainStreamRepository(
            ref.read(misskeyProvider(account)),
            ref.read(emojiRepositoryProvider(account)),
            account,
            ref.read(accountRepository)));

final favoriteProvider = ChangeNotifierProvider.autoDispose
    .family<FavoriteRepository, Account>((ref, account) => FavoriteRepository(
        ref.read(misskeyProvider(account)), ref.read(notesProvider(account))));

final notesProvider = ChangeNotifierProvider.family<NoteRepository, Account>(
    (ref, account) => NoteRepository(ref.read(misskeyProvider(account))));

//TODO: アカウント毎である必要はない ホスト毎
//TODO: のつもりだったけど、絵文字にロールが関係するようになるとアカウント毎になる
final emojiRepositoryProvider = Provider.family<EmojiRepository, Account>(
    (ref, account) => EmojiRepositoryImpl(
        misskey: ref.read(misskeyProvider(account)),
        account: account,
        accountSettingsRepository:
            ref.read(accountSettingsRepositoryProvider)));

final accountRepository = ChangeNotifierProvider((ref) => AccountRepository(
    ref.read(tabSettingsRepositoryProvider),
    ref.read(accountSettingsRepositoryProvider),
    ref.read));
final tabSettingsRepositoryProvider =
    ChangeNotifierProvider((ref) => TabSettingsRepository());

final accountSettingsRepositoryProvider =
    ChangeNotifierProvider((ref) => AccountSettingsRepository());

final generalSettingsRepositoryProvider =
    ChangeNotifierProvider((ref) => GeneralSettingsRepository());

final errorEventProvider =
    StateProvider<(Object? error, BuildContext? context)>(
        (ref) => (null, null));

final photoEditProvider =
    StateNotifierProvider.autoDispose<PhotoEditStateNotifier, PhotoEdit>(
  (ref) => PhotoEditStateNotifier(const PhotoEdit()),
);

final importExportRepository =
    ChangeNotifierProvider((ref) => ImportExportRepository(ref.read));

// TODO: 下書きの機能かんがえるときにfamilyの引数みなおす
final noteCreateProvider = StateNotifierProvider.family
    .autoDispose<NoteCreateNotifier, NoteCreate, Account>(
  (ref, account) => NoteCreateNotifier(
      NoteCreate(
          account: account,
          noteVisibility: ref
              .read(accountSettingsRepositoryProvider)
              .fromAccount(account)
              .defaultNoteVisibility,
          localOnly: ref
              .read(accountSettingsRepositoryProvider)
              .fromAccount(account)
              .defaultIsLocalOnly,
          reactionAcceptance: ref
              .read(accountSettingsRepositoryProvider)
              .fromAccount(account)
              .defaultReactionAcceptance),
      ref.read(fileSystemProvider),
      ref.read(dioProvider),
      ref.read(misskeyProvider(account)),
      ref.read(errorEventProvider.notifier)),
);
