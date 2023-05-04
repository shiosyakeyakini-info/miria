import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/custom_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mfm/mfm.dart';

import '../view/common/account_scope.dart';

class MfmToWidget extends ConsumerStatefulWidget {
  final String mfmText;
  final double emojiFontSizeRatio;
  const MfmToWidget(this.mfmText,
      {super.key, required this.emojiFontSizeRatio});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MfmToWidgetState();
}

class MfmToWidgetState extends ConsumerState<MfmToWidget> {
  List<MfmNode>? nodes;

  @override
  Widget build(BuildContext context) {
    final List<MfmNode> actualNode;
    if (nodes == null) {
      actualNode = ref.read(mfmParserProvider).parse(widget.mfmText);
    } else {
      actualNode = nodes!;
    }

    return DefaultTextStyle.merge(
      style: TextStyle(color: Color.fromARGB(255, 103, 103, 103)),
      child: MfmWidgetScope(
        emojiFontSizeRatio: widget.emojiFontSizeRatio,
        child: MfmElementWidget(nodes: actualNode),
      ),
    );
  }
}

class MfmWidgetScope extends InheritedWidget {
  final double emojiFontSizeRatio;

  const MfmWidgetScope({
    super.key,
    required this.emojiFontSizeRatio,
    required super.child,
  });

  static double of(BuildContext context) {
    final mfmWidgetScope =
        context.dependOnInheritedWidgetOfExactType<MfmWidgetScope>();
    if (mfmWidgetScope == null) {
      throw Exception("has not ancestor");
    }

    return mfmWidgetScope.emojiFontSizeRatio;
  }

  @override
  bool updateShouldNotify(covariant MfmWidgetScope oldWidget) =>
      emojiFontSizeRatio != oldWidget.emojiFontSizeRatio;
}

class MfmElementWidget extends ConsumerWidget {
  final List<MfmNode>? nodes;

  const MfmElementWidget({super.key, required this.nodes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RichText(
        text: TextSpan(children: [
      for (final node in nodes ?? [])
        if (node is MfmText)
          TextSpan(style: DefaultTextStyle.of(context).style, text: node.text)
        else if (node is MfmCenter)
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Center(child: MfmElementWidget(nodes: node.children)))
        else if (node is MfmCodeBlock)
          WidgetSpan(
              child: Container(
            decoration: const BoxDecoration(color: Colors.black87),
            width: double.infinity,
            child: Text(
              node.code,
              style: const TextStyle(color: Colors.white70),
            ),
          ))
        else if (node is MfmEmojiCode)
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: CustomEmoji.fromEmojiName(
                ":${node.name}:",
                ref.read(emojiRepositoryProvider(AccountScope.of(context))),
                fontSizeRatio: MfmWidgetScope.of(context),
              ))
        else if (node is MfmBold)
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: DefaultTextStyle.merge(
                style: const TextStyle(fontWeight: FontWeight.w800),
                child: MfmElementWidget(nodes: node.children),
              ))
        else if (node is MfmSmall)
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  fontSize:
                      DefaultTextStyle.of(context).style.fontSize ?? 22 * 0.8,
                  color: Theme.of(context).disabledColor,
                ),
                child: MfmElementWidget(nodes: node.children),
              ))
        else if (node is MfmItalic)
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: DefaultTextStyle.merge(
                style: const TextStyle(fontStyle: FontStyle.italic),
                child: MfmElementWidget(nodes: node.children),
              ))
        else if (node is MfmStrike)
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: DefaultTextStyle.merge(
                style: const TextStyle(decoration: TextDecoration.lineThrough),
                child: MfmElementWidget(nodes: node.children),
              ))
        else if (node is MfmPlain)
          TextSpan(style: DefaultTextStyle.of(context).style, text: node.text)
        else if (node is MfmInlineCode)
          TextSpan(
              style: const TextStyle(
                  backgroundColor: Colors.black87, color: Colors.white70),
              text: node.code)
        else if (node is MfmMention)
          TextSpan(
              style: const TextStyle(color: Colors.deepOrangeAccent),
              text: node.acct,
              recognizer: TapGestureRecognizer()..onTap = () {})
        else if (node is MfmHashTag)
          TextSpan(
              style: const TextStyle(color: Colors.deepOrangeAccent),
              text: "#${node.hashTag}",
              recognizer: TapGestureRecognizer()..onTap = () {})
        else if (node is MfmLink)
          WidgetSpan(
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: Colors.deepOrangeAccent),
              child: GestureDetector(
                  onTap: () {}, child: MfmElementWidget(nodes: node.children)),
            ),
          )
        else if (node is MfmURL)
          TextSpan(
              style: const TextStyle(color: Colors.deepOrangeAccent),
              text: node.value,
              recognizer: TapGestureRecognizer()..onTap = () {})
        else if (node is MfmFn)
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: MfmFnElementWidget(function: node))
        else
          WidgetSpan(child: MfmElementWidget(nodes: node.children))
    ]));
  }
}

class MfmFnElementWidget extends StatelessWidget {
  const MfmFnElementWidget({super.key, required this.function});

  final MfmFn function;

  Color? _toColor(String? color) {
    if (color == null) {
      return null;
    }

    if (!RegExp(r'^[0-9a-fA-F]+?$').hasMatch(color)) {
      return null;
    }

    final String htmlColor;
    if (color.length == 3) {
      htmlColor =
          "FF${color.substring(0, 1)}${color.substring(0, 1)}${color.substring(1, 2)}${color.substring(1, 2)}${color.substring(2, 3)}${color.substring(2, 3)}";
    } else if (color.length == 6) {
      htmlColor = "FF$color";
    } else if (color.length == 8) {
      htmlColor = color;
    } else {
      return null;
    }
    final intValue = int.tryParse(htmlColor, radix: 16);
    if (intValue == null) return null;
    return Color(intValue);
  }

  @override
  Widget build(BuildContext context) {
    if (function.name == "x2") {
      return DefaultTextStyle.merge(
          style: TextStyle(
              fontSize:
                  (DefaultTextStyle.of(context).style.fontSize ?? 22) * 2),
          child: MfmElementWidget(nodes: function.children));
    }
    if (function.name == "x3") {
      return DefaultTextStyle.merge(
          style: TextStyle(
              fontSize:
                  (DefaultTextStyle.of(context).style.fontSize ?? 22) * 3),
          child: MfmElementWidget(nodes: function.children));
    }

    if (function.name == "x4") {
      return DefaultTextStyle.merge(
          style: TextStyle(
              fontSize:
                  (DefaultTextStyle.of(context).style.fontSize ?? 22) * 3),
          child: MfmElementWidget(nodes: function.children));
    }

    if (function.name == "fg") {
      return DefaultTextStyle.merge(
          style: TextStyle(color: _toColor(function.args["color"])),
          child: MfmElementWidget(nodes: function.children));
    }

    if (function.name == "bg") {
      return Container(
        decoration: BoxDecoration(color: _toColor(function.args["color"])),
        child: MfmElementWidget(nodes: function.children),
      );
      // return DefaultTextStyle.merge(
      //     style: TextStyle(
      //       background: Paint()
      //         ..style = PaintingStyle.fill
      //         ..color = _toColor(function.args["color"]) ?? Colors.transparent,
      //     ),
      //     child: MfmElementWidget(nodes: function.children));
    }

    if (function.name == "font") {
      if (function.args.containsKey("serif")) {
        return DefaultTextStyle.merge(
            style: const TextStyle(fontFamily: "Hiragino Mincho ProN"), //FIXME
            child: MfmElementWidget(nodes: function.children));
      } else if (function.args.containsKey("monospace")) {
        return DefaultTextStyle.merge(
            style: const TextStyle(fontFamily: "Monaco"), //FIXME
            child: MfmElementWidget(nodes: function.children));
      } else {
        return MfmElementWidget(nodes: function.children);
      }
    }

    if (function.name == "rotate") {
      final deg = double.tryParse(function.args["deg"] ?? "") ?? 90.0;
      return Transform.rotate(
          angle: deg * pi / 180,
          child: MfmElementWidget(nodes: function.children));
    }

    if (function.name == "scale") {
      final x = double.tryParse(function.args["x"] ?? "");
      final y = double.tryParse(function.args["y"] ?? "");

      // scale.x=0, scale.y=0は表示しない
      if (x == 0 || y == 0) {
        return Container();
      }

      return Transform.scale(
        scaleX: x,
        scaleY: y,
        child: MfmElementWidget(nodes: function.children),
      );
    }

    if (function.name == "position") {
      final x = double.tryParse(function.args["x"] ?? "") ?? 0;
      final y = double.tryParse(function.args["y"] ?? "") ?? 0;
      final double defaultFontSize =
          DefaultTextStyle.of(context).style.fontSize ?? 22;
      return Transform.translate(
        offset: Offset(x * defaultFontSize, y * defaultFontSize),
        child: MfmElementWidget(nodes: function.children),
      );
    }

    if (function.name == "tada") {
      return DefaultTextStyle.merge(
          style: TextStyle(
              fontSize:
                  (DefaultTextStyle.of(context).style.fontSize ?? 22) * 2),
          child: MfmElementWidget(nodes: function.children));
    }

    if (function.name == "blur") {
      return MfmFnBlur(child: MfmElementWidget(nodes: function.children));
    }

    print("ignored function: ${function.name}");

    return MfmElementWidget(nodes: function.children);
  }
}

class MfmFnBlur extends StatefulWidget {
  final Widget child;

  const MfmFnBlur({super.key, required this.child});
  @override
  State<StatefulWidget> createState() => MfmFnBlurState();
}

class MfmFnBlurState extends State<MfmFnBlur> {
  bool isBlur = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => isBlur = !isBlur);
      },
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
            sigmaX: isBlur ? 10.0 : 0, sigmaY: isBlur ? 10.0 : 0),
        child: widget.child,
      ),
    );
  }
}
