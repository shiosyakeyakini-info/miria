import "dart:collection";

import "package:mfm_parser/mfm_parser.dart";

extension ListMfmNodeExtension on List<MfmNode> {
  // https://github.com/misskey-dev/misskey/blob/2023.9.2/packages/frontend/src/scripts/extract-url-from-mfm.ts
  List<String> extractLinks() {
    String removeHash(String link) {
      final hashIndex = link.lastIndexOf("#");
      if (hashIndex < 0) {
        return link;
      } else {
        return link.substring(0, hashIndex);
      }
    }

    // # より前の部分が重複しているものを取り除く
    final links = LinkedHashSet<String>(
      equals: (link, other) => removeHash(link) == removeHash(other),
      hashCode: (link) => removeHash(link).hashCode,
    );
    for (final node in this) {
      final children = node.children;
      if (children != null) {
        links.addAll(children.extractLinks());
      }
      if (node is MfmURL) {
        links.add(node.value);
      } else if (node is MfmLink) {
        if (!node.silent) {
          links.add(node.url);
        }
      }
    }
    return links.toList();
  }

  /// 連合でカスタム絵文字の両脇に挟まったゼロ幅スペースを落とす。
  ///
  /// Misskeyは ActivityPub の `content` を組むとき、カスタム絵文字を
  /// `\u200B:name:\u200B` とゼロ幅スペースで包む
  /// （`MfmService.toHtml` の `emojiCode`）。そのうえ、本文が
  /// text / unicodeEmoji / emojiCode / mention / hashtag / url だけで
  /// できているノートは `noMisskeyContent` と判定されて `source` も
  /// `_misskey_content` も送られない（`ApMfmService.getNoteHtml`）。
  /// 受け手はHTMLから起こし直すしかなく、`MfmService.fromHtml` は
  /// テキストノードをそのまま連結するので、ゼロ幅スペースが本文に残る。
  /// つまり `:a::b:` は連合先で `\u200B:a:\u200B\u200B:b:\u200B` になる。
  ///
  /// ゼロ幅スペースは幅ゼロで描かれるとは限らず、プレースホルダの位置が
  /// 丸められて絵文字と絵文字のあいだに隙間が入る。並びの幅も伸びるので、
  /// 折り返しの位置までずれる。
  ///
  /// パースした後に落としているので、`:name:` が絵文字として読まれるか
  /// どうかは変わらない。文字列の段階で落とすと、たとえば `a\u200B:x:` の
  /// ように区切りとして効いているゼロ幅スペースまで消えて、絵文字が
  /// 絵文字でなくなる。
  ///
  /// 上記の判定は入れ子のない本文でしか成立しない（装飾がひとつでもあれば
  /// `source` が付く）ので、直下だけを見る。
  List<MfmNode> withoutEmojiPadding() {
    if (!any((node) => node is MfmText && node.text.contains(zeroWidthSpace))) {
      return this;
    }

    final nodes = <MfmNode>[];
    for (var i = 0; i < length; i++) {
      final node = this[i];
      if (node is! MfmText) {
        nodes.add(node);
        continue;
      }

      var text = node.text;
      if (i > 0 && this[i - 1] is MfmEmojiCode) {
        text = text.replaceFirst(_leadingZeroWidthSpaces, "");
      }
      if (i < length - 1 && this[i + 1] is MfmEmojiCode) {
        text = text.replaceFirst(_trailingZeroWidthSpaces, "");
      }

      if (text.isNotEmpty) {
        nodes.add(MfmText(text));
      }
    }
    return nodes;
  }
}

/// Misskeyが連合させるときカスタム絵文字の両脇に入れるゼロ幅スペース。
const zeroWidthSpace = "\u200B";
final _leadingZeroWidthSpaces = RegExp("^$zeroWidthSpace+");
final _trailingZeroWidthSpaces = RegExp("$zeroWidthSpace+\$");
