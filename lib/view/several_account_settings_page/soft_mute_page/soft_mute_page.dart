import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/common/futurable.dart';

class SoftMutePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SoftMuteState();
}

class SoftMuteState extends ConsumerState<SoftMutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ミュート")),
      body: SingleChildScrollView(
        child: CommonFuture(
          future: () async {
            return [];
          }(),
          complete: (context, data) {
            return Row(
              children: [
                const Card(child: Text("指定した条件のノートをタイムラインから隠します。")),
                const TextField(
                  maxLines: null,
                  minLines: 5,
                ),
                Text(
                  "スペースで区切るとAND指定になり、改行で区切るとOR指定になります。\nキーワードをスラッシュで囲むと正規表現になります。",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
