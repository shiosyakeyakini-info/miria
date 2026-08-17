import "package:flutter/widgets.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/bubble_game/mono.dart";

extension BubbleGameModeExtension on BubbleGameMode {
  String displayName(BuildContext context) => switch (this) {
    BubbleGameMode.normal => S.of(context).bubbleGameModeNormal,
    BubbleGameMode.yen => S.of(context).bubbleGameModeYen,
    BubbleGameMode.square => S.of(context).bubbleGameModeSquare,
    BubbleGameMode.sweets => S.of(context).bubbleGameModeSweets,
    BubbleGameMode.space => S.of(context).bubbleGameModeSpace,
  };
}
