import 'package:miria/model/account.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/repository/account_repository.dart';
import 'package:miria/repository/channel_time_line_repository.dart';
import 'package:miria/repository/emoji_repository.dart';
import 'package:miria/repository/favorite_repository.dart';
import 'package:miria/repository/hybrid_timeline_repository.dart';
import 'package:miria/repository/main_stream_repository.dart';
import 'package:miria/repository/global_time_line_repository.dart';
import 'package:miria/repository/home_time_line_repository.dart';
import 'package:miria/repository/local_time_line_repository.dart';
import 'package:miria/repository/note_repository.dart';
import 'package:miria/repository/tab_settings_repository.dart';
import 'package:miria/repository/time_line_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

// "Ptk6oVyZg9JrLOJpRTSzfu6iofZ9Dz2O"
final misskeyProvider = Provider.family<Misskey, Account>(
    (ref, account) => Misskey(token: account.token, host: account.host));

final localTimeLineProvider =
    ChangeNotifierProvider.family<TimelineRepository, TabSetting>(
        (ref, tabSetting) => LocalTimeLineRepository(
              ref.read(misskeyProvider(tabSetting.account)),
              ref.read(notesProvider(tabSetting.account)),
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              tabSetting,
            ));
final homeTimeLineProvider =
    ChangeNotifierProvider.family<TimelineRepository, TabSetting>(
        (ref, tabSetting) => HomeTimeLineRepository(
              ref.read(misskeyProvider(tabSetting.account)),
              ref.read(notesProvider(tabSetting.account)),
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              tabSetting,
            ));
final globalTimeLineProvider =
    ChangeNotifierProvider.family<TimelineRepository, TabSetting>(
        (ref, tabSetting) => GlobalTimeLineRepository(
              ref.read(misskeyProvider(tabSetting.account)),
              ref.read(notesProvider(tabSetting.account)),
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              tabSetting,
            ));

final hybridTimeLineProvider =
    ChangeNotifierProvider.family<TimelineRepository, TabSetting>(
        (ref, tabSetting) => HybridTimelineRepository(
              ref.read(misskeyProvider(tabSetting.account)),
              ref.read(notesProvider(tabSetting.account)),
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              tabSetting,
            ));

final channelTimelineProvider =
    ChangeNotifierProvider.family<ChannelTimelineRepository, TabSetting>(
        (ref, tabSetting) => ChannelTimelineRepository(
              ref.read(misskeyProvider(tabSetting.account)),
              ref.read(notesProvider(tabSetting.account)),
              ref.read(mainStreamRepositoryProvider(tabSetting.account)),
              tabSetting,
            ));
final mainStreamRepositoryProvider =
    ChangeNotifierProvider.family<MainStreamRepository, Account>(
        (ref, account) => MainStreamRepository(
            ref.read(misskeyProvider(account)),
            ref.read(emojiRepositoryProvider(account))));

final favoriteProvider = ChangeNotifierProvider.autoDispose
    .family<FavoriteRepository, Account>((ref, account) => FavoriteRepository(
        ref.read(misskeyProvider(account)), ref.read(notesProvider(account))));

final notesProvider = ChangeNotifierProvider.family<NoteRepository, Account>(
    (ref, account) => NoteRepository(ref.read(misskeyProvider(account))));

//TODO: アカウント毎である必要はない
final emojiRepositoryProvider = Provider.family<EmojiRepository, Account>(
    (ref, account) =>
        EmojiRepositoryImpl(misskey: ref.read(misskeyProvider(account))));

final accountRepository = Provider(
    (ref) => AccountRepository(ref.read(tabSettingsRepositoryProvider)));
final tabSettingsRepositoryProvider =
    ChangeNotifierProvider((ref) => TabSettingsRepository());
