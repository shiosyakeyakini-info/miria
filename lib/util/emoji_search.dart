import 'package:kana_kit/kana_kit.dart';

final RegExp _romajiPattern = RegExp(r'^[A-Za-z0-9_+-]+$');
final RegExp _splitPattern = RegExp('[_+-]');

String formatEmojiName(String emojiName) {
  return emojiName.replaceAll('_', '').replaceAll('+', '').replaceAll('-', '');
}

String toHiraganaSafe(String text) {
  try {
    if (_romajiPattern.hasMatch(text)) {
      return text
          .split(_splitPattern)
          .map((e) => const KanaKit().toHiragana(e))
          .join();
    }
    return const KanaKit().toHiragana(formatEmojiName(text));
  } catch (_) {
    return text;
  }
}

bool emojiSearchCondition(
  String query,
  String convertedQuery, {
  required String baseName,
  required List<String> aliases,
  String? kanaName,
  List<String>? kanaAliases,
}) {
  if (query.length == 1) {
    return baseName == query ||
        aliases.any((e) => e == query) ||
        (kanaName != null && kanaName == convertedQuery) ||
        (kanaAliases != null && kanaAliases.any((e) => e == convertedQuery));
  }
  return baseName.contains(query) ||
      aliases.any((e) => e.contains(query)) ||
      (kanaName != null && kanaName.contains(convertedQuery)) ||
      (kanaAliases != null &&
          kanaAliases.any((e) => e.contains(convertedQuery)));
}
