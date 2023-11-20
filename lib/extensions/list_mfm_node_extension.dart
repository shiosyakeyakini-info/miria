import 'dart:collection';

import 'package:mfm_parser/mfm_parser.dart';

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
}
