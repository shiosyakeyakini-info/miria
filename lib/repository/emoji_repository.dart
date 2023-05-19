import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:miria/model/account.dart';
import 'package:miria/repository/account_settings_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract class EmojiRepository {
  List<Emoji>? emoji;
  Future<void> loadFromSource();
  Future<File> requestEmoji(Emoji emoji);
  Future<List<Emoji>> searchEmojis(String name, {int limit = 30});
  List<Emoji> defaultEmojis({int limit});
}

class EmojiWrap {
  final Emoji emoji;
  final String kanaName;
  final Iterable<String> kanaAliases;

  const EmojiWrap(this.emoji, this.kanaName, this.kanaAliases);
}

class EmojiRepositoryImpl extends EmojiRepository {
  final Misskey misskey;
  final Account account;
  final AccountSettingsRepository accountSettingsRepository;
  EmojiRepositoryImpl({
    required this.misskey,
    required this.account,
    required this.accountSettingsRepository,
  });

  final List<EmojiWrap> _emojiWrap = [];

  String format(String emojiName) {
    return emojiName
        .replaceAll("_", "")
        .replaceAll("+", "")
        .replaceAll("-", "");
  }

  @override
  Future<void> loadFromSource() async {
    emoji = (await misskey.emojis()).emojis;

    final toH = const KanaKit().toHiragana;
    _emojiWrap
      ..clear()
      ..addAll(emoji?.map((e) => EmojiWrap(e, format(toH(e.name)),
              e.aliases.map((e2) => format(toH(e2))))) ??
          []);
  }

  @override
  Future<File> requestEmoji(Emoji emoji) async {
    final directory = Directory(
        "${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}emoji_caches");
    if (!await directory.exists()) {
      await directory.create();
    }

    final files = directory.listSync().whereType<File>();

    final found = files.firstWhereOrNull((file) =>
        file.path.endsWith("${Platform.pathSeparator}${emoji.name}.png"));
    if (found != null) {
      return found;
    }

    final dio = Dio();
    final response = await dio.getUri<List<int>>(emoji.url,
        options: Options(responseType: ResponseType.bytes));

    final data = response.data;
    if (data == null) {
      throw Exception("data is null");
    }

    final filePath = p.join(directory.path, "${emoji.name}.png");
    await File(filePath).create();
    await File(filePath).writeAsBytes(data);

    return File(filePath);
  }

  Future<void> downloadAllEmojis() async {}

  bool emojiSearchCondition(
      String query, String convertedQuery, EmojiWrap element) {
    if (query.length == 1) {
      return element.emoji.name == query ||
          element.emoji.aliases.any((element2) => element2 == query) ||
          element.kanaName == convertedQuery ||
          element.kanaAliases.any((element2) => element2 == convertedQuery);
    }
    return element.emoji.name.contains(query) ||
        element.emoji.aliases.any((element2) => element2.contains(query)) ||
        element.kanaName.contains(convertedQuery) ||
        element.kanaAliases
            .any((element2) => element2.contains(convertedQuery));
  }

  @override
  Future<List<Emoji>> searchEmojis(String name, {int limit = 30}) async {
    if (name == "") {
      return defaultEmojis(limit: limit);
    }

    final converted = format(const KanaKit().toHiragana(name));

    return _emojiWrap
        .where((element) => emojiSearchCondition(name, converted, element))
        .sorted((a, b) {
          final aValue = [
            if (a.emoji.name.contains(name)) a.emoji.name,
            ...a.emoji.aliases.where((e2) => e2.contains(name)),
            if (a.kanaName.contains(converted)) a.kanaName,
            ...a.kanaAliases.where((e2) => e2.contains(converted))
          ].map((e) => e.length);
          final bValue = [
            if (b.emoji.name.contains(name)) b.emoji.name,
            ...b.emoji.aliases.where((element2) => element2.contains(name)),
            if (b.kanaName.contains(converted)) b.kanaName,
            ...b.kanaAliases.where((e2) => e2.contains(converted))
          ].map((e) => e.length);

          return aValue.min.compareTo(bValue.min);
        })
        .take(limit)
        .map((e) => e.emoji)
        .toList();
  }

  @override
  List<Emoji> defaultEmojis({int limit = 30}) {
    final reactionDeck =
        accountSettingsRepository.fromAccount(account).reactions;
    if (reactionDeck.isEmpty) {
      return emoji?.take(limit).toList() ?? [];
    } else {
      return reactionDeck
          .map((e) => emoji?.firstWhereOrNull((element) => element.name == e))
          .whereNotNull()
          .toList();
    }
  }
}
