import 'package:auto_route/annotations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/futurable.dart';
import 'package:misskey_dart/misskey_dart.dart';

enum MuteType { soft, hard }

@RoutePage()
class WordMutePage extends ConsumerStatefulWidget {
  final Account account;
  final MuteType muteType;

  const WordMutePage({
    super.key,
    required this.account,
    required this.muteType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => WordMutePageState();
}

class WordMutePageState extends ConsumerState<WordMutePage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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

  Future<void> save() async {
    final text = controller.text;

    final List<MuteWord> wordMutes =
        text.split("\n").whereNot((element) => element.trim().isEmpty).map((e) {
      if (e.startsWith("/")) {
        return MuteWord(regExp: e);
      } else {
        return MuteWord(content: e.split(" "));
      }
    }).toList();

    await ref.read(misskeyProvider(widget.account)).i.update(
          IUpdateRequest(
            mutedWords: widget.muteType == MuteType.soft ? wordMutes : null,
            hardMutedWords: widget.muteType == MuteType.hard ? wordMutes : null,
          ),
        );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (widget.muteType) {
          MuteType.soft => S.of(context).wordMute,
          MuteType.hard => S.of(context).hardWordMute,
        }),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CommonFuture<MeDetailed>(
            future: ref.read(misskeyProvider(widget.account)).i.i(),
            futureFinished: (data) {
              controller.text = muteValueString(
                widget.muteType == MuteType.soft
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
                    onPressed: save,
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
