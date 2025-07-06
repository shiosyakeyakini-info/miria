import "package:json5/json5.dart";

/// Misskeyのレジストリデータ形式を解析して絵文字ミュートリストを抽出するユーティリティクラス
class MutedReactionsParser {
  /// Misskeyのレジストリデータ形式を解析して絵文字ミュートリストを抽出
  ///
  /// サポートされる形式:
  /// 1. Misskeyレジストリ形式: `[ [ {}, [':emoji:', ':emoji@host:'] ] ]`
  /// 2. シンプルな配列形式: `[':emoji:', ':emoji@host:']` (後方互換性)
  /// 3. 改行区切りテキスト: 改行で区切られた文字列
  static List<String> parseMutedReactionsData(String input) {
    final text = input.trim();

    // JSON形式でない場合は改行区切りとして扱う
    if (!text.startsWith("[") && !text.startsWith("{")) {
      return text
          .split("\n")
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.trim())
          .toList();
    }

    try {
      final parsed = JSON5.parse(text);

      // シンプルな配列の場合（従来形式との互換性）
      if (parsed is List && parsed.isNotEmpty && parsed.first is String) {
        return parsed.map((item) => item as String).toList();
      }

      // Misskeyレジストリ形式: [ [ {}, [...] ] ]
      if (parsed is List && parsed.isNotEmpty) {
        final firstItem = parsed.first;
        if (firstItem is List && firstItem.length >= 2) {
          final mutedList = firstItem[1];
          if (mutedList is List) {
            return mutedList.map((item) => item as String).toList();
          }
        }
      }

      throw FormatException("Unsupported data format");
    } catch (e) {
      throw FormatException("Failed to parse muted reactions data: $e");
    }
  }
}
