import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';

class ChannelArea extends ConsumerWidget {
  const ChannelArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channel = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.channel));
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
