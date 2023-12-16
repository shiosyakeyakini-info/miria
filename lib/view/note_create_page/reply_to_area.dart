import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:miria/view/themes/app_theme.dart';

class ReplyToArea extends ConsumerWidget {
  const ReplyToArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repliesTo = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.replyTo));

    if (repliesTo.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Wrap(
        children: [
          Text(
            "${S.of(context).replyTo}：",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          for (final replyTo in repliesTo)
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AvatarIcon(
                  user: replyTo,
                  height: MediaQuery.textScalerOf(context).scale(
                    Theme.of(context).textTheme.bodySmall?.fontSize ?? 22,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 5)),
                Text(
                  "@${replyTo.username}${replyTo.host == null ? "" : "@${replyTo.host}"}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.of(context).mentionStyle.color),
                ),
                IconButton(
                  onPressed: () => ref
                      .read(
                          noteCreateProvider(AccountScope.of(context)).notifier)
                      .deleteReplyUser(replyTo),
                  icon: Icon(
                    Icons.remove,
                    size: MediaQuery.textScalerOf(context).scale(
                      Theme.of(context).textTheme.bodySmall?.fontSize ?? 22,
                    ),
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    minimumSize: MaterialStatePropertyAll(Size(0, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
              ],
            ),
          IconButton(
            onPressed: () {
              ref
                  .read(noteCreateProvider(AccountScope.of(context)).notifier)
                  .addReplyUser(context);
            },
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            style: const ButtonStyle(
              padding: MaterialStatePropertyAll(EdgeInsets.zero),
              minimumSize: MaterialStatePropertyAll(Size.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: Icon(
              Icons.add,
              size: MediaQuery.textScalerOf(context)
                  .scale(Theme.of(context).textTheme.bodySmall?.fontSize ?? 22),
            ),
          ),
        ],
      ),
    );
  }
}
