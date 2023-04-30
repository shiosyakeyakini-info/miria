import 'package:collection/collection.dart';
import 'package:flutter_misskey_app/extensions/string_extensions.dart';
import 'package:flutter_misskey_app/repository/emoji_repository.dart';
import 'package:mfm/mfm.dart';

class MfmToFlutterHtml {
  final EmojiRepository emojiRepository;
  final MfmParser mfmParser;

  MfmToFlutterHtml(this.emojiRepository, this.mfmParser);

  String? _toHtmlColor(String? color) {
    if (color == null) {
      return null;
    } else if (color.length == 3) {
      return "#${color.substring(0, 1)}${color.substring(0, 1)}${color.substring(1, 2)}${color.substring(1, 2)}${color.substring(2, 3)}${color.substring(2, 3)}";
    } else if (color.length == 6) {
      return "#$color";
    } else if (color.length == 8) {
      return "#$color";
    } else {
      return null;
    }
  }

  String _safeAsPlain(String text) {
    return text.tight
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll(" ", "&nbsp;")
        .replaceAll("\n", "<br>");
  }

  String toHtml(List<MfmNode>? nodes) {
    if (nodes == null) return "";
    var str = "";

    for (final node in nodes) {
      if (node is MfmURL) {
        str += "<a href=\"${node.value}\">${_safeAsPlain(node.value)}</a>";
      } else if (node is MfmLink) {
        str += "<a href=\"${node.url}\">${toHtml(node.children)}</a>";
      } else if (node is MfmHashTag) {
        str += "<a href=\"${node.hashTag}\">#${_safeAsPlain(node.hashTag)}</a>";
      } else if (node is MfmMention) {
        str += "<a href=\"${node.acct}\">${node.acct}</a>";
      } else if (node is MfmText) {
        str += "<span>${_safeAsPlain(node.text)}</span>";
      } else if (node is MfmInlineCode) {
        str += "<span>${_safeAsPlain(node.code)}</span>";
      } else if (node is MfmPlain) {
        str += "<span>${_safeAsPlain(node.text)}</span>";
      } else if (node is MfmStrike) {
        str += "<s>${toHtml(node.children)}</s>";
      } else if (node is MfmItalic) {
        str += "<i>${toHtml(node.children)}</i>";
      } else if (node is MfmSmall) {
        str += "<small>${toHtml(node.children)}</small>";
      } else if (node is MfmBold) {
        str += "<b>${toHtml(node.children)}</b>";
      } else if (node is MfmCenter) {
        str +=
            "<div style=\"text-align:center\">${toHtml(node.children)}</div>";
      } else if (node is MfmCodeBlock) {
        str +=
            "<pre style=\"background-color:#000;color:#fff;font-family:monospace;padding:12px;\">${node.code}</pre>";
      } else if (node is MfmEmojiCode) {
        final found = emojiRepository.emoji
            ?.firstWhereOrNull((element) => element.name == node.name);
        if (found != null) {
          str += "<customemoji name=\"${found.name}\"></customemoji>";
        } else {
          str += ":${_safeAsPlain(node.name)}:";
        }
      } else if (node is MfmFn) {
        if (node.name == "x2") {
          str +=
              "<span style=\"font-size:2em;\">${toHtml(node.children)}</span>";
        } else if (node.name == "x3") {
          str +=
              "<span style=\"font-size:3em;\">${toHtml(node.children)}</span>";
        } else if (node.name == "x4") {
          str +=
              "<span style=\"font-size:4em;\">${toHtml(node.children)}</span>";
        } else if (node.name == "fg") {
          final htmlParsedColor = _toHtmlColor(node.args["color"]);
          if (htmlParsedColor != null) {
            str +=
                "<span style=\"color:$htmlParsedColor;\">${toHtml(node.children)}</span>";
          } else {
            return toHtml(node.children);
          }
        } else if (node.name == "bg") {
          final htmlParsedColor = _toHtmlColor(node.args["color"]);
          if (htmlParsedColor != null) {
            str +=
                "<span style=\"background-color:$htmlParsedColor;\">${toHtml(node.children)}</span>";
          } else {
            return toHtml(node.children);
          }
        } else if (node.name == "font") {
          if (node.args.containsKey("serif")) {
            str +=
                "<span style=\"font-family:'Noto Serif CJK JP Regular', 'MS P Mincho', serif;\">${toHtml(node.children)}</span>";
          }
        } else if (node.name == "rotate") {
          if (node.args.containsKey("deg")) {
            str +=
                "<rotate deg=\"${node.args["deg"]}\">${toHtml(node.children)}</rotate>";
          }
        } else {
          str += toHtml(node.children);
        }
      }
    }

    return str;
  }

  String parse(String mfmText) {
    return toHtml(mfmParser.parse(mfmText));
  }
}
