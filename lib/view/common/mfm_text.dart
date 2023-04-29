import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_misskey_app/extensions/string_extensions.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/emoji_repository.dart';
import 'package:flutter_misskey_app/view/common/custom_emoji.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';

Widget customEmojiRenderer(
    RenderContext context, EmojiRepository emojiRepository) {
  final name = context.tree.element?.attributes["name"];

  final emoji =
      emojiRepository.emoji?.firstWhere((element) => element.name == name);

  if (emoji != null) {
    return CustomEmoji(emoji: emoji);
  }
  return Container();
}

CustomRenderMatcher emojiMatcher() =>
    (context) => context.tree.element?.localName == "customemoji";

CustomRenderMatcher rotateMatcher() =>
    (context) => context.tree.element?.localName == "rotate";

class MfmText extends ConsumerStatefulWidget {
  final String mfmText;
  final TextStyle? style;

  const MfmText({super.key, required this.mfmText, this.style});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MfmTextState();
}

class MfmTextState extends ConsumerState<MfmText> {
  Widget? cachedWidget;

  @override
  Widget build(BuildContext context) {
    final htmlText = ref.read(mfmToFlutterHtmlProvider).parse(widget.mfmText);

    if (cachedWidget != null) {
      return cachedWidget!;
    }

    cachedWidget = Html(
      data: htmlText,
      customRenders: {
        emojiMatcher(): CustomRender.widget(
            widget: (context, children) => customEmojiRenderer(
                context, ref.read(emojiRepositoryProvider))),
        rotateMatcher(): CustomRender.widget(
          widget: (context, children) => Transform.rotate(
            angle:
                (double.tryParse(context.tree.attributes["deg"] ?? "") ?? 0.0) *
                    pi /
                    180,
            child: RichText(
              text: TextSpan(
                children: children(),
              ),
            ),
          ),
        )
      },
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
          height: Height(24),
        ),
      },
      tagsList: Html.tags..addAll(["customemoji", "rotate"]),
      onLinkTap: (url, context, value, element) async {
        final uri = Uri.tryParse(url ?? "");
        print(uri);
        if (uri != null) {
          if (await canLaunchUrl(uri)) {
            launchUrl(uri, mode: LaunchMode.inAppWebView);
          }
        }
      },
    );

    return cachedWidget!;
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
  Widget build(BuildContext context) {
    final userName = ref
        .read(mfmToFlutterHtmlProvider)
        .parse(widget.user.name ?? widget.user.username);
    final htmlText =
        "<span style=\"font-weight: bold;\">$userName</span>&nbsp;&nbsp;&nbsp;<span style=\"color:#888888\">@${widget.user.username.tight}</span>";

    if (cachedWidget != null) {
      return cachedWidget!;
    }

    cachedWidget = Html(
      data: htmlText,
      customRenders: {
        emojiMatcher(): CustomRender.widget(
            widget: (context, children) => customEmojiRenderer(
                context, ref.read(emojiRepositoryProvider))),
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
