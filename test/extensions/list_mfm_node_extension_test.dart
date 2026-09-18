import "package:flutter_test/flutter_test.dart";
import "package:mfm_parser/mfm_parser.dart";
import "package:miria/extensions/list_mfm_node_extension.dart";

/// 連合してきたノートに入っているゼロ幅スペース。
const zwsp = "​";

List<MfmNode> parse(String text) => const MfmParser().parse(text);

void main() {
  group("withoutEmojiPadding", () {
    test("連続するカスタム絵文字の間のゼロ幅スペースが落ちる", () {
      // Misskeyが `:a::b::c:` を連合させるとこの形になる
      final federated = parse(
        "$zwsp:a:$zwsp$zwsp:b:$zwsp$zwsp:c:$zwsp",
      ).withoutEmojiPadding();

      expect(federated, parse(":a::b::c:"));
    });

    test("絵文字に隣り合うゼロ幅スペースだけを落とし、本文は残す", () {
      final federated = parse(
        "$zwsp:a:$zwspおはよう$zwsp:b:$zwsp",
      ).withoutEmojiPadding();

      expect(federated, parse(":a:おはよう:b:"));
    });

    test("絵文字に隣り合わないゼロ幅スペースは残す", () {
      // `.tight` のように意図して入れたものまで消さない
      final nodes = parse("あ$zwspい").withoutEmojiPadding();

      expect(nodes, [MfmText("あ$zwspい")]);
    });

    test("ゼロ幅スペースがなければ同じリストを返す", () {
      final nodes = parse(":a::b:");

      expect(identical(nodes.withoutEmojiPadding(), nodes), isTrue);
    });

    test("絵文字として読まれるかどうかは変えない", () {
      // `a:x:` は前が英数字なので絵文字にならない。ゼロ幅スペースが
      // 区切りとして効いてこそ絵文字なので、パース結果は絵文字のまま。
      final nodes = parse("a$zwsp:x:").withoutEmojiPadding();

      expect(nodes, [MfmText("a"), MfmEmojiCode("x")]);
    });
  });
}
