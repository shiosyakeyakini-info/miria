import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:kana_kit/kana_kit.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/account_settings.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/model/unicode_emoji.dart';
import 'package:miria/repository/account_settings_repository.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class EmojiRepository {
  List<EmojiRepositoryData>? emoji;
  Future<void> loadFromSourceIfNeed();
  Future<void> loadFromSource();

  Future<void> loadFromLocalCache();
  Future<List<MisskeyEmojiData>> searchEmojis(String name, {int limit = 30});
  List<MisskeyEmojiData> defaultEmojis({int limit});
}

class EmojiRepositoryData {
  final MisskeyEmojiData emoji;
  final String category;
  final String kanaName;
  final List<String> aliases;
  final List<String> kanaAliases;

  const EmojiRepositoryData({
    required this.emoji,
    required this.category,
    required this.kanaName,
    required this.aliases,
    required this.kanaAliases,
  });
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

  bool thisLaunchLoaded = false;

  String format(String emojiName) {
    return emojiName
        .replaceAll("_", "")
        .replaceAll("+", "")
        .replaceAll("-", "");
  }

  @override
  Future<void> loadFromLocalCache() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString("emojis@${account.host}");
    if (storedData == null || storedData.isEmpty) {
      return;
    }
    await _setEmojiData(EmojisResponse.fromJson(jsonDecode(storedData)));
  }

  @override
  Future<void> loadFromSource() async {
    final serverFetchData = await misskey.emojis();
    await _setEmojiData(serverFetchData);

    if (account.token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          "emojis@${account.host}", jsonEncode(serverFetchData));
      await accountSettingsRepository.save(accountSettingsRepository
          .fromAccount(account)
          .copyWith(latestEmojiCached: DateTime.now()));
    }
    thisLaunchLoaded = true;
  }

  @override
  Future<void> loadFromSourceIfNeed() async {
    final settings = accountSettingsRepository.fromAccount(account);
    final latestUpdated = settings.latestEmojiCached;
    switch (settings.emojiCacheStrategy) {
      case CacheStrategy.whenTabChange:
        await loadFromSource();
        break;
      case CacheStrategy.whenLaunch:
        if (thisLaunchLoaded) return;
        await loadFromSource();
        break;
      case CacheStrategy.whenOneDay:
        if (latestUpdated == null || latestUpdated.day != DateTime.now().day) {
          await loadFromSource();
        }
        break;
    }
  }

  String toHiraganaSafe(String text) {
    try {
      return const KanaKit().toHiragana(text);
    } catch (e) {
      return text;
    }
  }

  Future<void> _setEmojiData(EmojisResponse response) async {
    final toH = toHiraganaSafe;

    final unicodeEmojis =
        (jsonDecode(await rootBundle.loadString("assets/emoji_list.json"))
                as List)
            .map((e) => UnicodeEmoji.fromJson(e))
            .map((e) => EmojiRepositoryData(
                  emoji: UnicodeEmojiData(char: e.char),
                  kanaName: toH(format(e.char)),
                  kanaAliases: [e.name, ...e.keywords]
                      .map((e2) => toH(format(e2)))
                      .toList(),
                  aliases: [e.name, ...e.keywords],
                  category: e.category,
                ));

    emoji = response.emojis
        .map((e) => EmojiRepositoryData(
              emoji: CustomEmojiData(
                baseName: e.name,
                hostedName: ":${e.name}@.:",
                url: e.url,
                isCurrentServer: true,
                isSensitive: e.isSensitive,
              ),
              category: e.category ?? "",
              kanaName: toH(format(e.name)),
              aliases: e.aliases,
              kanaAliases: e.aliases.map((e2) => format(toH(e2))).toList(),
            ))
        .toList();
    emoji!.addAll(unicodeEmojis);
  }

  bool emojiSearchCondition(
      String query, String convertedQuery, EmojiRepositoryData element) {
    if (query.length == 1) {
      return element.emoji.baseName == query ||
          element.aliases.any((element2) => element2 == query) ||
          element.kanaName == convertedQuery ||
          element.kanaAliases.any((element2) => element2 == convertedQuery);
    }
    return element.emoji.baseName.contains(query) ||
        element.aliases.any((element2) => element2.contains(query)) ||
        element.kanaName.contains(convertedQuery) ||
        element.kanaAliases
            .any((element2) => element2.contains(convertedQuery));
  }

  @override
  Future<List<MisskeyEmojiData>> searchEmojis(String name,
      {int limit = 30}) async {
    if (name == "") {
      return defaultEmojis(limit: limit);
    }

    final converted = format(const KanaKit().toHiragana(name));

    return emoji
            ?.where((element) => emojiSearchCondition(name, converted, element))
            .sorted((a, b) {
              final aValue = [
                if (a.emoji.baseName.contains(name)) a.emoji.baseName,
                ...a.aliases.where((e2) => e2.contains(name)),
                if (a.kanaName.contains(converted)) a.kanaName,
                ...a.kanaAliases.where((e2) => e2.contains(converted))
              ].map((e) => e.length);
              final bValue = [
                if (b.emoji.baseName.contains(name)) b.emoji.baseName,
                ...b.aliases.where((element2) => element2.contains(name)),
                if (b.kanaName.contains(converted)) b.kanaName,
                ...b.kanaAliases.where((e2) => e2.contains(converted))
              ].map((e) => e.length);

              var ret = aValue.min.compareTo(bValue.min);
              if (ret != 0) return ret;
              if (a.emoji is CustomEmojiData) return -1;
              return 0;
            })
            .take(limit)
            .map((e) => e.emoji)
            .toList() ??
        <MisskeyEmojiData>[];
  }

  @override
  List<MisskeyEmojiData> defaultEmojis({int limit = 30}) {
    final reactionDeck =
        accountSettingsRepository.fromAccount(account).reactions;
    if (reactionDeck.isEmpty) {
      return [];
    } else {
      return reactionDeck
          .map((e) =>
              emoji?.firstWhereOrNull((element) => element.emoji.baseName == e))
          .whereNotNull()
          .map((e) => e.emoji)
          .toList();
    }
  }
}
