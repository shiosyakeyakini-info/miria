import "package:auto_route/auto_route.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/futurable.dart";
import "package:misskey_dart/misskey_dart.dart";

enum MuteType { soft, hard }

@RoutePage()
class WordMutePage extends HookConsumerWidget {
  final Account account;
  final MuteType muteType;

  const WordMutePage({
    required this.account,
    required this.muteType,
    super.key,
  });

  String muteValueString(List<MuteWord>? wordMutes) {
    if (wordMutes == null) return "";

    return wordMutes
        .map((e) {
          if (e.regExp != null) {
            return e.regExp;
          } else if (e.content != null) {
            return e.content!.join(" ");
          }
        })
        .whereNotNull()
        .join("\n");
  }

  Future<void> save(String text, BuildContext context, WidgetRef ref) async {
    final wordMutes =
        text.split("\n").whereNot((element) => element.trim().isEmpty).map((e) {
      if (e.startsWith("/")) {
        return MuteWord(regExp: e);
      } else {
        return MuteWord(content: e.split(" "));
      }
    }).toList();

    await ref.read(misskeyGetContextProvider).i.update(
          IUpdateRequest(
            mutedWords: muteType == MuteType.soft ? wordMutes : null,
            hardMutedWords: muteType == MuteType.hard ? wordMutes : null,
          ),
        );
    if (!context.mounted) return;
    await context.maybePop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          switch (muteType) {
            MuteType.soft => S.of(context).wordMute,
            MuteType.hard => S.of(context).hardWordMute,
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CommonFuture<MeDetailed>(
            future: ref.read(misskeyPostContextProvider).i.i(),
            futureFinished: (data) {
              controller.text = muteValueString(
                muteType == MuteType.soft
                    ? data.mutedWords
                    : data.hardMutedWords,
              );
            },
            complete: (context, data) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  TextField(
                    maxLines: null,
                    minLines: 5,
                    controller: controller,
                    autofocus: true,
                  ),
                  Text(
                    S.of(context).wordMuteDescription,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => save(controller.text, context, ref),
                    icon: const Icon(Icons.save),
                    label: Text(S.of(context).save),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
