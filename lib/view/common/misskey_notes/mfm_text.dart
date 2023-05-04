import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_misskey_app/mfm_to_flutter_html/mfm_to_flutter_html.dart';
import 'package:flutter_misskey_app/mfm_to_flutter_html/mfm_to_widget.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/emoji_repository.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/custom_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';

Widget customEmojiRenderer(
    RenderContext context, EmojiRepository emojiRepository,
    {double fontSizeRatio = 1}) {
  final name = context.tree.element?.attributes["name"];

  final emoji =
      emojiRepository.emoji?.firstWhere((element) => element.name == name);

  final double styleFontSizeRatio;
  final double? value = context.tree.style.fontSize?.value;
  final double? defaultFontSize =
      DefaultTextStyle.of(context.buildContext).style.fontSize;
  if (value != null && defaultFontSize != null) {
    styleFontSizeRatio = value / defaultFontSize;
  } else {
    styleFontSizeRatio = 1.0;
  }

  if (emoji != null) {
    return CustomEmoji(
      emoji: emoji,
      fontSizeRatio: fontSizeRatio * styleFontSizeRatio,
    );
  }
  return Container();
}

CustomRenderMatcher emojiMatcher() =>
    (context) => context.tree.element?.localName == "customemoji";

CustomRenderMatcher rotateMatcher() =>
    (context) => context.tree.element?.localName == "rotate";

CustomRenderMatcher scaleMatcher() =>
    (context) => context.tree.element?.localName == "scale";

CustomRenderMatcher positionMatcher() =>
    (context) => context.tree.element?.localName == "position";

class MfmText extends ConsumerStatefulWidget {
  final String mfmText;
  final TextStyle? style;
  final double emojiFontSizeRatio;

  const MfmText({
    super.key,
    required this.mfmText,
    this.style,
    this.emojiFontSizeRatio = 1.0,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MfmTextState();
}

class MfmTextState extends ConsumerState<MfmText> {
  Widget? cachedWidget;

  @override
  void didUpdateWidget(covariant MfmText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mfmText != widget.mfmText) {
      cachedWidget = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    /*if (cachedWidget != null) {
      return cachedWidget!;
    }

    cachedWidget = MfmToWidget(widget.mfmText);

    return cachedWidget!;*/

    return MfmToWidget(
      widget.mfmText,
      emojiFontSizeRatio: widget.emojiFontSizeRatio,
    );

    /*final String htmlText;
    try {
      htmlText = ref
          .read(mfmToFlutterHtmlProvider(AccountScope.of(context)))
          .parse(widget.mfmText);
    } catch (e, s) {
      print(e);
      print(s);
      return Column(
        children: [
          const Text("Mfmのパースに失敗しました。"),
          Text(widget.mfmText),
        ],
      );
    }

    cachedWidget = DefaultTextStyle.merge(
      style: widget.style ?? const TextStyle(),
      child: Html(
        data: htmlText,
        customRenders: {
          emojiMatcher(): CustomRender.widget(
              widget: (context, children) => customEmojiRenderer(
                    context,
                    ref.read(emojiRepositoryProvider(
                        AccountScope.of(context.buildContext))),
                    fontSizeRatio: widget.emojiFontSizeRatio,
                  )),
          rotateMatcher(): CustomRender.widget(
            widget: (context, children) => Transform.rotate(
              angle: (double.tryParse(context.tree.attributes["deg"] ?? "") ??
                      0.0) *
                  pi /
                  180,
              child: RichText(text: TextSpan(children: children())),
            ),
          ),
          scaleMatcher(): CustomRender.widget(
              widget: (context, children) => Transform.scale(
                    scaleX:
                        (double.tryParse(context.tree.attributes["x"] ?? "")) ??
                            1,
                    scaleY:
                        (double.tryParse(context.tree.attributes["y"] ?? "")) ??
                            1,
                    child: RichText(text: TextSpan(children: children())),
                  )),
          positionMatcher(): CustomRender.widget(widget: (context, children) {
            final x = double.tryParse(context.tree.attributes["x"] ?? "") ?? 0;
            final y = double.tryParse(context.tree.attributes["y"] ?? "") ?? 0;

            final double styleFontSizeRatio;
            final double? value = context.tree.style.fontSize?.value;
            final double defaultFontSize =
                DefaultTextStyle.of(context.buildContext).style.fontSize ?? 22;
            if (value != null) {
              styleFontSizeRatio = value / defaultFontSize;
            } else {
              styleFontSizeRatio = 1.0;
            }

            return Transform.translate(
                offset: Offset(
                  x * defaultFontSize * styleFontSizeRatio,
                  y * defaultFontSize * styleFontSizeRatio,
                ),
                child: RichText(text: TextSpan(children: children())));
          }),
        },
        style: {
          "body": Style(
              color: widget.style?.color,
              fontSize: widget.style?.fontSize != null
                  ? FontSize(widget.style!.fontSize!)
                  : null,
              padding: EdgeInsets.zero,
              margin: Margins(
                  left: Margin.zero(),
                  right: Margin.zero(),
                  top: Margin.zero(),
                  bottom: Margin.zero()),
              verticalAlign: VerticalAlign.sup),
          "img": Style(
            width: Width.auto(),
            height: Height(24 * (widget.style?.fontSize ?? 2) / 2),
          ),
        },
        tagsList: Html.tags
          ..addAll(["customemoji", "rotate", "scale", "position"]),
        onLinkTap: (url, context, value, element) async {
          final uri = Uri.tryParse(url ?? "");
          if (uri != null) {
            if (await canLaunchUrl(uri)) {
              launchUrl(uri, mode: LaunchMode.inAppWebView);
            }
          }
        },
      ),
    );

    return cachedWidget!;*/
  }
}

class UserInformation extends ConsumerStatefulWidget {
  final User user;
  const UserInformation({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserInformationState();
}

class UserInformationState extends ConsumerState<UserInformation> {
  Widget? cachedWidget;

  @override
  void didUpdateWidget(covariant UserInformation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.user != widget.user) {
      cachedWidget = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = ref
        .read(mfmToFlutterHtmlProvider(AccountScope.of(context)))
        .parse(widget.user.name ?? widget.user.username);

    var htmlText = "<span style=\"font-weight: bold;\">$userName</span>";

    if (cachedWidget != null) {
      return cachedWidget!;
    }

    cachedWidget = Html(
      data: htmlText,
      customRenders: {
        emojiMatcher(): CustomRender.widget(
            widget: (context, children) => customEmojiRenderer(
                context,
                ref.read(emojiRepositoryProvider(
                    AccountScope.of(context.buildContext))))),
      },
      tagsList: Html.tags..addAll(["customemoji"]),
      style: {
        "body": Style(
          padding: EdgeInsets.zero,
          margin: Margins(
              left: Margin.zero(),
              right: Margin.zero(),
              top: Margin.zero(),
              bottom: Margin.zero()),
        ),
        "img": Style(
          width: Width.auto(),
          height: Height(18),
        )
      },
    );

    return cachedWidget!;
  }
}
