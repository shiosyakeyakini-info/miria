import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";

class VoteArea extends ConsumerWidget {
  const VoteArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expireType = ref.watch(
      noteCreateNotifierProvider.select((value) => value.voteExpireType),
    );
    final isVote =
        ref.watch(noteCreateNotifierProvider.select((value) => value.isVote));

    if (!isVote) {
      return Container();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VoteContentList(),
        ElevatedButton(
          onPressed: () {
            ref.read(noteCreateNotifierProvider.notifier).addVoteContent();
          },
          child: Text(S.of(context).addChoice),
        ),
        const MultipleVoteRadioButton(),
        const VoteDuration(),
        if (expireType == VoteExpireType.date) const VoteUntilDate(),
        if (expireType == VoteExpireType.duration) const VoteUntilDuration(),
      ],
    );
  }
}

class VoteContentList extends ConsumerWidget {
  const VoteContentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentCount = ref.watch(
      noteCreateNotifierProvider.select((value) => value.voteContentCount),
    );
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (int i = 0; i < contentCount; i++) VoteContentListItem(index: i),
      ],
    );
  }
}

class VoteContentListItem extends HookConsumerWidget {
  final int index;

  const VoteContentListItem({required this.index, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initial = useMemoized(
      () => ref.read(noteCreateNotifierProvider).voteContent[index],
    );
    final controller = useTextEditingController(text: initial);
    ref.listen(
        noteCreateNotifierProvider.select(
          (value) =>
              value.voteContent.length <= index ? "" : value.voteContent[index],
        ), (_, next) {
      controller.text = next;
    });
    useEffect(
      () {
        controller.addListener(() {
          if (ref.read(noteCreateNotifierProvider).voteContent.length <=
              index) {
            return;
          }
          ref
              .read(noteCreateNotifierProvider.notifier)
              .setVoteContent(index, controller.text);
        });
        return null;
      },
      [index],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: S.of(context).choiceNumber(index + 1),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ref
                  .read(noteCreateNotifierProvider.notifier)
                  .deleteVoteContent(index);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class MultipleVoteRadioButton extends ConsumerWidget {
  const MultipleVoteRadioButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Switch(
          value: ref.watch(
            noteCreateNotifierProvider.select((value) => value.isVoteMultiple),
          ),
          onChanged: (value) {
            ref.read(noteCreateNotifierProvider.notifier).toggleVoteMultiple();
          },
        ),
        Expanded(child: Text(S.of(context).canMultipleChoice)),
      ],
    );
  }
}

class VoteDuration extends ConsumerWidget {
  const VoteDuration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButton(
      value: ref.watch(
        noteCreateNotifierProvider.select((value) => value.voteExpireType),
      ),
      items: [
        for (final item in VoteExpireType.values)
          DropdownMenuItem(
            value: item,
            child: Text(item.displayText(context)),
          ),
      ],
      onChanged: (item) {
        if (item == null) return;
        ref.read(noteCreateNotifierProvider.notifier).setVoteExpireType(item);
      },
    );
  }
}

class VoteUntilDate extends ConsumerWidget {
  const VoteUntilDate({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(
      noteCreateNotifierProvider.select((value) => value.voteDate),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () async {
          final resultDate = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2999, 12, 31),
          ); //TODO: ｍisskeyの日付のデータピッカーどこまで行く？
          if (resultDate == null) return;
          if (!context.mounted) return;
          final resultTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
              hour: date?.hour ?? DateTime.now().hour,
              minute: date?.minute ?? DateTime.now().minute,
            ),
          );
          if (resultTime == null) return;

          ref.read(noteCreateNotifierProvider.notifier).setVoteExpireDate(
                DateTime(
                  resultDate.year,
                  resultDate.month,
                  resultDate.day,
                  resultTime.hour,
                  resultTime.minute,
                  0,
                ),
              );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(Icons.date_range),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: Text(
                    date?.formatUntilSeconds(context) ?? "",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VoteUntilDuration extends HookConsumerWidget {
  const VoteUntilDuration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(
      text: ref.read(noteCreateNotifierProvider).voteDuration?.toString() ?? "",
    );
    controller.addListener(() {
      final value = int.tryParse(controller.text);
      if (value == null) return;
      ref.read(noteCreateNotifierProvider.notifier).setVoteDuration(value);
    });

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.timer)),
            keyboardType: const TextInputType.numberWithOptions(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10),
        ),
        DropdownButton(
          items: [
            for (final item in VoteExpireDurationType.values)
              DropdownMenuItem(
                value: item,
                child: Text(item.displayText(context)),
              ),
          ],
          value: ref.watch(
            noteCreateNotifierProvider
                .select((value) => value.voteDurationType),
          ),
          onChanged: (value) {
            if (value == null) return;
            ref
                .read(noteCreateNotifierProvider.notifier)
                .setVoteDurationType(value);
          },
        ),
      ],
    );
  }
}
