import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/themes/app_theme.dart";

class ReplyToArea extends ConsumerWidget {
  const ReplyToArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repliesTo = ref.watch(
      noteCreateNotifierProvider.select((value) => value.replyTo),
    );

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
                        color: AppTheme.of(context).mentionStyle.color,
                      ),
                ),
                IconButton(
                  onPressed: () async => ref
                      .read(noteCreateNotifierProvider.notifier)
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
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    minimumSize: WidgetStatePropertyAll(Size(0, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
              ],
            ),
          IconButton(
            onPressed: () async =>
                ref.read(noteCreateNotifierProvider.notifier).addReplyUser(),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            style: const ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              minimumSize: WidgetStatePropertyAll(Size.zero),
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
