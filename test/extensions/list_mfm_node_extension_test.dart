import "package:flutter_test/flutter_test.dart";
import "package:mfm_parser/mfm_parser.dart";
import "package:miria/extensions/list_mfm_node_extension.dart";

void main() {
  group("ListMfmNodeExtension extractLinks", () {
    test("extracts plain url", () {
      final nodes = const MfmParser().parse("https://example.com");
      expect(nodes.extractLinks(), ["https://example.com"]);
    });

    test("does not extract silent url (?<...>)", () {
      final nodes = const MfmParser().parse("?<https://example.com>");
      expect(nodes.extractLinks(), isEmpty);
    });

    test("does not extract silent link (?[...](...))", () {
      final nodes = const MfmParser().parse("?[example](https://example.com)");
      expect(nodes.extractLinks(), isEmpty);
    });

    test("extracts non-silent url while skipping silent one", () {
      final nodes = const MfmParser().parse(
        "https://a.example.com ?<https://b.example.com>",
      );
      expect(nodes.extractLinks(), ["https://a.example.com"]);
    });

    test("deduplicates urls that differ only by hash", () {
      final nodes = const MfmParser().parse(
        "https://example.com/page#a https://example.com/page#b",
      );
      expect(nodes.extractLinks(), ["https://example.com/page#a"]);
    });
  });
}
