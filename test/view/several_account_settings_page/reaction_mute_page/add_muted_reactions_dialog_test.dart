import "package:flutter_test/flutter_test.dart";
import "package:miria/view/several_account_settings_page/reaction_mute_page/muted_reactions_parser.dart";

void main() {
  group("MutedReactionsParser.parseMutedReactionsData", () {
    test("parses Misskey registry format correctly", () {
      const jsonData = '''
[
    [
        {},
        [
            ":thinkhappy@misskey.io:",
            ":kanarusan_yay_superfast:"
        ]
    ]
]''';

      final result = MutedReactionsParser.parseMutedReactionsData(jsonData);

      expect(
        result,
        equals([":thinkhappy@misskey.io:", ":kanarusan_yay_superfast:"]),
      );
    });

    test("parses simple array format for backwards compatibility", () {
      const jsonData = '''[":emoji1:", ":emoji2@host:"]''';

      final result = MutedReactionsParser.parseMutedReactionsData(jsonData);

      expect(result, equals([":emoji1:", ":emoji2@host:"]));
    });

    test("handles single emoji in registry format", () {
      const jsonData = '''
[
    [
        {},
        [
            ":single_emoji:"
        ]
    ]
]''';

      final result = MutedReactionsParser.parseMutedReactionsData(jsonData);

      expect(result, equals([":single_emoji:"]));
    });

    test("handles empty registry format", () {
      const jsonData = """
[
    [
        {},
        []
    ]
]""";

      final result = MutedReactionsParser.parseMutedReactionsData(jsonData);

      expect(result, equals(<String>[]));
    });

    test("handles unicode emojis", () {
      const jsonData = '''
[
    [
        {},
        [
            "😀",
            "👍",
            ":custom@example.com:"
        ]
    ]
]''';

      final result = MutedReactionsParser.parseMutedReactionsData(jsonData);

      expect(result, equals(["😀", "👍", ":custom@example.com:"]));
    });

    test("throws FormatException for invalid format", () {
      const jsonData = '''{"invalid": "format"}''';

      expect(
        () => MutedReactionsParser.parseMutedReactionsData(jsonData),
        throwsA(isA<FormatException>()),
      );
    });

    test("throws FormatException for malformed JSON", () {
      const jsonData = """[invalid json}""";

      expect(
        () => MutedReactionsParser.parseMutedReactionsData(jsonData),
        throwsA(isA<FormatException>()),
      );
    });

    test("handles complex registry structure with multiple entries", () {
      const jsonData = '''
[
    [
        {"someKey": "someValue"},
        [
            ":thinkhappy@misskey.io:",
            "😀",
            "@banned.host",
            ":local_emoji:"
        ]
    ]
]''';

      final result = MutedReactionsParser.parseMutedReactionsData(jsonData);

      expect(
        result,
        equals([
          ":thinkhappy@misskey.io:",
          "😀",
          "@banned.host",
          ":local_emoji:",
        ]),
      );
    });
  });
}
