import 'dart:math';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/extensions/string_extensions.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/custom_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mfm/mfm.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../view/common/account_scope.dart';

class MfmToWidget extends ConsumerStatefulWidget {
  final String mfmText;
  final double emojiFontSizeRatio;
  final String? host;
  final List<MfmNode> Function(String)? parser;
  final TextStyle? style;
  const MfmToWidget(
    this.mfmText, {
    super.key,
    required this.host,
    required this.emojiFontSizeRatio,
    this.parser,
    this.style,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MfmToWidgetState();
}

class MfmToWidgetState extends ConsumerState<MfmToWidget> {
  List<MfmNode>? nodes;

  @override
  Widget build(BuildContext context) {
    final List<MfmNode> actualNode;
    if (nodes == null) {
      actualNode = (widget.parser ?? ref.read(mfmParserProvider).parse)
          .call(widget.mfmText);
    } else {
      actualNode = nodes!;
    }

    return DefaultTextStyle(
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .merge(widget.style ?? const TextStyle()),
      child: MfmWidgetScope(
        emojiFontSizeRatio: widget.emojiFontSizeRatio,
        host: widget.host,
        child: Text.rich(
          WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: MfmElementWidget(nodes: actualNode)),
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
        ),
      ),
    );
  }
}

class MfmWidgetScope extends InheritedWidget {
  final double emojiFontSizeRatio;
  final String? host;

  const MfmWidgetScope({
    super.key,
    required this.emojiFontSizeRatio,
    this.host,
    required super.child,
  });

  static MfmWidgetScope of(BuildContext context) {
    final mfmWidgetScope =
        context.dependOnInheritedWidgetOfExactType<MfmWidgetScope>();
    if (mfmWidgetScope == null) {
      throw Exception("has not ancestor");
    }

    return mfmWidgetScope;
  }

  @override
  bool updateShouldNotify(covariant MfmWidgetScope oldWidget) =>
      emojiFontSizeRatio != oldWidget.emojiFontSizeRatio;
}

class MfmElementWidget extends ConsumerStatefulWidget {
  final List<MfmNode>? nodes;

  const MfmElementWidget({super.key, required this.nodes});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      MfmElementWidgetState();
}

class MfmElementWidgetState extends ConsumerState<MfmElementWidget> {
  Future<void> onTapLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return; //TODO: なおす
    }
    final account = AccountScope.of(context);

    // 他サーバーや外部サイトは別アプリで起動する
    if (uri.host != AccountScope.of(context).host) {
      if (await canLaunchUrl(uri)) {
        if (!await launchUrl(uri,
            mode: LaunchMode.externalNonBrowserApplication)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } else if (uri.pathSegments.length == 2 &&
        uri.pathSegments.first == "clips") {
      // クリップはクリップの画面で開く
      context.pushRoute(
          ClipDetailRoute(account: account, id: uri.pathSegments[1]));
    } else if (uri.pathSegments.length == 1 &&
        uri.pathSegments.first.startsWith("@")) {
      await onTapUserName(uri.pathSegments.first);
    } else {
      // 自サーバーは内部ブラウザで起動する
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    }
  }

  Future<void> onTapUserName(String userName) async {
    // 自分のインスタンスの誰か
    // 本当は向こうで呼べばいいのでいらないのだけど
    final regResult = RegExp(r'^@?(.+?)(@(.+?))?$').firstMatch(userName);

    final contextHost = AccountScope.of(context).host;
    final noteHost =
        MfmWidgetScope.of(context).host ?? AccountScope.of(context).host;
    final regResultHost = regResult?.group(3);
    final String? finalHost;

    if (regResultHost == null && noteHost == contextHost) {
      // @なし
      finalHost = null;
    } else if (regResultHost == contextHost) {
      // @自分ドメイン
      finalHost = null;
    } else if (regResultHost != null) {
      finalHost = regResultHost;
    } else {
      finalHost = noteHost;
    }

    final response = await ref
        .read(misskeyProvider(AccountScope.of(context)))
        .users
        .showByName(UsersShowByUserNameRequest(
            userName: regResult?.group(1) ?? "", host: finalHost));

    if (!mounted) return;
    context.pushRoute(
        UserRoute(userId: response.id, account: AccountScope.of(context)));
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: MfmAlignScope.of(context),
        text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
          for (final node in widget.nodes ?? [])
            if (node is MfmText)
              TextSpan(text: node.text)
            else if (node is MfmCenter)
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: SizedBox(
                    width: double.infinity,
                    child: MfmAlignScope(
                        align: TextAlign.center,
                        child: MfmElementWidget(nodes: node.children)),
                  ))
            else if (node is MfmCodeBlock)
              WidgetSpan(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black87),
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Text(
                    node.code,
                    style: const TextStyle(
                        color: Colors.white70, fontFamily: "Monaco"),
                  ),
                ),
              ))
            else if (node is MfmEmojiCode)
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: CustomEmoji.fromEmojiName(
                    ":${node.name}:",
                    ref.read(emojiRepositoryProvider(AccountScope.of(context))),
                    fontSizeRatio:
                        MfmWidgetScope.of(context).emojiFontSizeRatio *
                            MediaQuery.of(context).textScaleFactor,
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
                          (DefaultTextStyle.of(context).style.fontSize ?? 22) *
                              0.8,
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
                    style:
                        const TextStyle(decoration: TextDecoration.lineThrough),
                    child: MfmElementWidget(nodes: node.children),
                  ))
            else if (node is MfmPlain)
              TextSpan(
                  style: DefaultTextStyle.of(context).style, text: node.text)
            else if (node is MfmInlineCode)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black87),
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text.rich(
                    textAlign: MfmAlignScope.of(context),
                    TextSpan(
                        style: const TextStyle(
                            color: Colors.white70, fontFamily: "Monaco"),
                        text: node.code),
                  ),
                ),
              )
            else if (node is MfmQuote)
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 3)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: DefaultTextStyle.merge(
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color),
                          child: MfmElementWidget(nodes: node.children),
                        ),
                      ),
                    ),
                  ))
            else if (node is MfmMention)
              TextSpan(
                  style: DefaultTextStyle.of(context)
                      .style
                      .merge(const TextStyle(color: Colors.deepOrangeAccent)),
                  text: node.acct.tight,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => onTapUserName(node.acct))
            else if (node is MfmHashTag)
              TextSpan(
                  style: DefaultTextStyle.of(context)
                      .style
                      .merge(const TextStyle(color: Colors.deepOrangeAccent)),
                  text: "#${node.hashTag.tight}",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.pushRoute(HashtagRoute(
                          account: AccountScope.of(context),
                          hashtag: node.hashTag));
                    })
            else if (node is MfmLink)
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(color: Colors.deepOrangeAccent),
                    child: GestureDetector(
                        onTap: () => onTapLink(node.url),
                        child: MfmElementWidget(nodes: node.children)),
                  ))
            else if (node is MfmURL)
              TextSpan(
                  style: DefaultTextStyle.of(context)
                      .style
                      .merge(const TextStyle(color: Colors.deepOrangeAccent)),
                  text: node.value.tight,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => onTapLink(node.value))
            else if (node is MfmFn)
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: MfmFnElementWidget(function: node))
            else
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: MfmElementWidget(nodes: node.children))
        ]));
  }
}

class MfmFnElementWidget extends StatelessWidget {
  const MfmFnElementWidget({super.key, required this.function});

  final MfmFn function;

  Color? _toColor(String? color) {
    if (color == null) {
      return const Color(0xFFFF0000);
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
                  (DefaultTextStyle.of(context).style.fontSize ?? 22) * 4),
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
      final x = double.tryParse(function.args["x"] ?? "") ?? 1.0;
      final y = double.tryParse(function.args["y"] ?? "") ?? 1.0;

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
          (DefaultTextStyle.of(context).style.fontSize ?? 22) *
              MediaQuery.of(context).textScaleFactor;

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

    if (function.name == "flip") {
      final isVertical = function.args.containsKey("v");
      final isHorizontal = function.args.containsKey("h");

      if ((!isVertical && !isHorizontal) || (isHorizontal && !isVertical)) {
        return Transform(
          transform: Matrix4.rotationY(pi),
          alignment: Alignment.center,
          child: MfmElementWidget(nodes: function.children),
        );
      }

      if (isVertical && !isHorizontal) {
        return Transform(
          transform: Matrix4.rotationX(pi),
          alignment: Alignment.center,
          child: MfmElementWidget(nodes: function.children),
        );
      }

      return Transform(
        transform: Matrix4.rotationZ(pi),
        alignment: Alignment.center,
        child: MfmElementWidget(nodes: function.children),
      );
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

class MfmAlignScope extends InheritedWidget {
  final TextAlign align;

  const MfmAlignScope({
    super.key,
    required super.child,
    required this.align,
  });

  static TextAlign of(BuildContext context) {
    final mfmWidgetScope =
        context.dependOnInheritedWidgetOfExactType<MfmAlignScope>();
    if (mfmWidgetScope == null) {
      return TextAlign.start;
    }

    return mfmWidgetScope.align;
  }

  @override
  bool updateShouldNotify(covariant MfmAlignScope oldWidget) =>
      oldWidget.align != align;
}
