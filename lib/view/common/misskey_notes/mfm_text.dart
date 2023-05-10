import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_misskey_app/mfm_to_flutter_html/mfm_to_widget.dart';
import 'package:flutter_misskey_app/repository/emoji_repository.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/custom_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

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
  final String? host;

  const MfmText({
    super.key,
    required this.mfmText,
    this.style,
    this.emojiFontSizeRatio = 1.0,
    this.host,
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
    return MfmToWidget(
      widget.mfmText,
      emojiFontSizeRatio: widget.emojiFontSizeRatio,
      host: widget.host,
    );
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
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          MfmToWidget("<b>${widget.user.name ?? widget.user.username} </b>",
              host: AccountScope.of(context).host, emojiFontSizeRatio: 1.0),
          for (final badge in widget.user.badgeRoles ?? [])
            Tooltip(
              message: badge.name,
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: SizedBox(
                    height: MediaQuery.of(context).textScaleFactor *
                        (Theme.of(context).textTheme.bodyMedium?.fontSize ??
                            22),
                    child: Image.network(badge.iconUrl.toString())),
              ),
            )
        ]);
  }
}
