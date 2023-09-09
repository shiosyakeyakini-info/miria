import 'package:auto_route/annotations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/futurable.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class HardMutePage extends ConsumerStatefulWidget {
  final Account account;

  const HardMutePage({super.key, required this.account});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HardMutePageState();
}

class HardMutePageState extends ConsumerState<HardMutePage> {
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

    await ref
        .read(misskeyProvider(widget.account))
        .i
        .update(IUpdateRequest(mutedWords: wordMutes));
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ハードミュート")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CommonFuture<IResponse>(
            future: ref.read(misskeyProvider(widget.account)).i.i(),
            futureFinished: (data) {
              controller.text = muteValueString(data.mutedWords);
            },
            complete: (context, data) {
              return Column(
                children: [
                  const Card(
                      child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        "指定した条件のノートをタイムラインに追加しないようにします。追加されなかったノートは、条件を変更しても除外されたままになります。反映されるまでに時間がかかる場合があります。"),
                  )),
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
                    "スペースで区切るとAND指定になり、改行で区切るとOR指定になります。\nキーワードをスラッシュで囲むと正規表現になります。",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  ElevatedButton.icon(
                      onPressed: save,
                      icon: const Icon(Icons.save),
                      label: const Text("保存"))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
