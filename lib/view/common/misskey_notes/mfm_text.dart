import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/mfm_to_flutter_html/mfm_to_widget.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

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
          MfmToWidget(
            widget.user.name ?? widget.user.username,
            host: AccountScope.of(context).host,
            emojiFontSizeRatio: 1.0,
            parser: ref.read(mfmParserProvider).parseSimple,
            style: const TextStyle(fontWeight: FontWeight.bold, height: 1),
          ),
          for (final badge in widget.user.badgeRoles ?? [])
            Tooltip(
              message: badge.name,
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
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
