import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/providers.dart';
import 'package:miria/state_notifier/note_create_page/note_create_state_notifier.dart';

import '../common/account_scope.dart';

class VoteArea extends ConsumerStatefulWidget {
  const VoteArea({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => VoteAreaState();
}

class VoteAreaState extends ConsumerState<VoteArea> {
  @override
  Widget build(BuildContext context) {
    final expireType = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.voteExpireType));
    final isVote = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.isVote));

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
            ref
                .read(noteCreateProvider(AccountScope.of(context)).notifier)
                .addVoteContent();
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

class VoteContentList extends ConsumerStatefulWidget {
  const VoteContentList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => VoteContentListState();
}

class VoteContentListState extends ConsumerState<VoteContentList> {
  @override
  Widget build(BuildContext context) {
    final contentCount = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.voteContentCount));
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (int i = 0; i < contentCount; i++) VoteContentListItem(index: i),
      ],
    );
  }
}

class VoteContentListItem extends ConsumerStatefulWidget {
  final int index;

  const VoteContentListItem({super.key, required this.index});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      VoteContentListItemState();
}

class VoteContentListItemState extends ConsumerState<VoteContentListItem> {
  final controller = TextEditingController();
  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      ref
          .read(noteCreateProvider(AccountScope.of(context)).notifier)
          .setVoteContent(widget.index, controller.text);
    });
  }

  @override
  void didUpdateWidget(covariant VoteContentListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.text = ref
          .read(noteCreateProvider(AccountScope.of(context)))
          .voteContent[widget.index];
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.text = ref
          .read(noteCreateProvider(AccountScope.of(context)))
          .voteContent[widget.index];
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: S.of(context).choiceNumber(widget.index + 1),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                ref
                    .read(noteCreateProvider(AccountScope.of(context)).notifier)
                    .deleteVoteContent(widget.index);
              },
              icon: const Icon(Icons.close)),
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
            value: ref.watch(noteCreateProvider(AccountScope.of(context))
                .select((value) => value.isVoteMultiple)),
            onChanged: (value) {
              ref
                  .read(noteCreateProvider(AccountScope.of(context)).notifier)
                  .toggleVoteMultiple();
            }),
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
        value: ref.watch(noteCreateProvider(AccountScope.of(context))
            .select((value) => value.voteExpireType)),
        items: [
          for (final item in VoteExpireType.values)
            DropdownMenuItem(
              value: item,
              child: Text(item.displayText(context)),
            )
        ],
        onChanged: (item) {
          if (item == null) return;
          ref
              .read(noteCreateProvider(AccountScope.of(context)).notifier)
              .setVoteExpireType(item);
        });
  }
}

class VoteUntilDate extends ConsumerStatefulWidget {
  const VoteUntilDate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => VoteUntilDateState();
}

class VoteUntilDateState extends ConsumerState<VoteUntilDate> {
  @override
  Widget build(BuildContext context) {
    final date = ref.watch(noteCreateProvider(AccountScope.of(context))
        .select((value) => value.voteDate));

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () async {
          final account = AccountScope.of(context);
          final resultDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate:
                  DateTime(2999, 12, 31)); //TODO: ｍisskeyの日付のデータピッカーどこまで行く？
          if (resultDate == null) return;
          if (!mounted) return;
          final resultTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                  hour: date?.hour ?? DateTime.now().hour,
                  minute: date?.minute ?? DateTime.now().minute));
          if (resultTime == null) return;

          ref.read(noteCreateProvider(account).notifier).setVoteExpireDate(
              DateTime(resultDate.year, resultDate.month, resultDate.day,
                  resultTime.hour, resultTime.minute, 0));
        },
        child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(10)),
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
                  ]),
            )),
      ),
    );
  }
}

class VoteUntilDuration extends ConsumerStatefulWidget {
  const VoteUntilDuration({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      VoteUntilDurationState();
}

class VoteUntilDurationState extends ConsumerState<VoteUntilDuration> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future(() async {
      controller.addListener(() {
        final value = int.tryParse(controller.text);
        if (value == null) return;
        ref
            .read(noteCreateProvider(AccountScope.of(context)).notifier)
            .setVoteDuration(value);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.text = ref
            .read(noteCreateProvider(AccountScope.of(context)))
            .voteDuration
            ?.toString() ??
        "";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
              controller: controller,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.timer)),
              keyboardType: const TextInputType.numberWithOptions(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
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
            value: ref.watch(noteCreateProvider(AccountScope.of(context))
                .select((value) => value.voteDurationType)),
            onChanged: (value) {
              if (value == null) return;
              ref
                  .read(noteCreateProvider(AccountScope.of(context)).notifier)
                  .setVoteDurationType(value);
            }),
      ],
    );
  }
}
