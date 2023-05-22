import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/tab_icon.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';

class TabIconView extends ConsumerWidget {
  final TabIcon? icon;
  final Color? color;

  const TabIconView({
    super.key,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codePoint = icon?.codePoint;
    if (codePoint != null) {
      return Icon(
        IconData(codePoint, fontFamily: "MaterialIcons"),
        color: color,
      );
    }
    final customEmoji = icon?.customEmojiName;
    if (customEmoji != null) {
      return CustomEmoji.fromEmojiName(":$customEmoji:",
          ref.read(emojiRepositoryProvider(AccountScope.of(context))));
    }
    return const SizedBox.shrink();
  }
}
