import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:miria/view/common/account_scope.dart";

class ChannelArea extends ConsumerWidget {
  const ChannelArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channel = ref.watch(
      noteCreateNotifierProvider(AccountScope.of(context))
          .select((value) => value.channel),
    );
    if (channel == null) return Container();

    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Icon(
            Icons.tv,
            size: MediaQuery.textScalerOf(context)
                .scale(Theme.of(context).textTheme.bodySmall!.fontSize!),
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          Text(
            channel.name,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
