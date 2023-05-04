import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/mfm_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noteInputTextProvider = StateProvider.autoDispose<String>((ref) => "");

@RoutePage()
class NoteCreatePage extends ConsumerStatefulWidget {
  final Account? initialAccount;

  const NoteCreatePage({
    super.key,
    this.initialAccount,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NoteCreatePageState();
}

class NoteCreatePageState extends ConsumerState<NoteCreatePage> {
  Account? selectedAccount;
  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    noteController.addListener(() {
      ref.read(noteInputTextProvider.notifier).state = noteController.text;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedAccount =
        widget.initialAccount ?? ref.read(accountRepository).account.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ノート"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.send))],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: TextField(
                controller: noteController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(hintText: "何してはる？"),
              )),
          if (selectedAccount != null)
            Expanded(flex: 1, child: MfmPreview(account: selectedAccount!)),
        ],
      ),
    );
  }
}

class MfmPreview extends ConsumerWidget {
  final Account account;

  const MfmPreview({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewText = ref.watch(noteInputTextProvider);

    return AccountScope(
      account: account,
      child: MfmText(
        mfmText: previewText,
        emojiFontSizeRatio: 2,
      ),
    );
  }
}
