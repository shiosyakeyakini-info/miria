// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/emoji_repository.dart';
import 'package:flutter_misskey_app/view/mfm_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class TestWidget extends ConsumerStatefulWidget {
  final String mfmText;

  const TestWidget({super.key, required this.mfmText});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TestWidgetState();
}

class TestWidgetState extends ConsumerState<TestWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      ref.read(emojiRepositoryProvider).emoji =
          (await ref.read(misskeyProvider).emojis()).emojis;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: MfmText(mfmText: widget.mfmText));
  }
}

void main() {
  const mfmText = r"""$[fg.color=29BEEF $[bg.color=000 $[rotate.deg=-90 **こんにちは？**] こんにちは！] げんき]""";

  runApp(ProviderScope(
      overrides: [
        emojiRepositoryProvider.overrideWith(
            (ref) => EmojiRepositoryImpl(misskey: ref.read(misskeyProvider)))
      ],
      child: MaterialApp(
          theme: ThemeData(fontFamily: "Noto Sans CJK JP"),
          home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(color: Colors.black45),
                  columnWidths: {
                    0: FixedColumnWidth(150),
                    1: FlexColumnWidth(1.0)
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  
                  children: [
            TableRow(children: [Text("もとのテキスト"), Text(mfmText)]),
            TableRow(children: [Text("表示"), TestWidget(mfmText: mfmText)])
          ]),
              )))));
}
