// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/account_settings_repository.dart';
import 'package:miria/repository/emoji_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:misskey_dart/misskey_dart.dart';

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
      ref
          .read(emojiRepositoryProvider(Account(
              host: "",
              userId: "userId",
              token: "token",
              i: IResponse.fromJson({}))))
          .emoji = (await ref
              .read(misskeyProvider(Account(
                  host: "", userId: "", token: "", i: IResponse.fromJson({}))))
              .emojis())
          .emojis;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Container());
  }
}

void main() {
  const mfmText =
      r"""$[fg.color=29BEEF $[bg.color=000 $[rotate.deg=-90 **こんにちは？**] こんにちは！] げんき]""";

  runApp(ProviderScope(
      overrides: const [
        // emojiRepositoryProvider.overrideWith(
        //   (ref, account) => EmojiRepositoryImpl(
        //       misskey: ref.read(
        //         misskeyProvider(account),
        //       ),
        //       account: Account(
        //           host: "",
        //           userId: "",
        //           token: "",
        //           i: IResponse(
        //               id: "",
        //               name: "",
        //               username: "",
        //               avatarUrl: Uri.parse("https://example.com"),
        //             isBot: false,
        //             isCat: false,
        //             badgeRoles: [],
        //             createdAt: DateTime.now(),
        //             isSilenced: false,
        //             isLocked: false,
        //             isSuspended: false,
        //             followersCount: 0,
        //             followingCount: 0,
        //             notesCount: 0,
        //             publicReactions: [],
        //
        //           )),
        //       accountSettingsRepository: AccountSettingsRepository()),
        // )
      ],
      child: MaterialApp(
          theme: ThemeData(fontFamily: "Noto Sans CJK JP"),
          home: Scaffold(
              body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
                border: TableBorder.all(color: Colors.black45),
                columnWidths: const {
                  0: FixedColumnWidth(150),
                  1: FlexColumnWidth(1.0)
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  const TableRow(children: [Text("もとのテキスト"), Text(mfmText)]),
                  const TableRow(
                      children: [Text("表示"), TestWidget(mfmText: mfmText)])
                ]),
          )))));
}
