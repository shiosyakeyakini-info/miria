import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/avatar_icon.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/local_only_icon.dart';
import 'package:flutter_misskey_app/view/common/misskey_notes/mfm_text.dart';
import 'package:flutter_misskey_app/view/note_create_page/note_visibility_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

final noteInputTextProvider = StateProvider.autoDispose<String>((ref) => "");

@RoutePage()
class NoteCreatePage extends ConsumerStatefulWidget {
  final Account? initialAccount;
  final CommunityChannel? channel;
  final Note? reply;
  final Note? renote;

  const NoteCreatePage({
    super.key,
    this.initialAccount,
    this.channel,
    this.reply,
    this.renote,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NoteCreatePageState();
}

class NoteCreatePageState extends ConsumerState<NoteCreatePage> {
  Account? selectedAccount;
  final noteController = TextEditingController();
  var isCw = false;
  final cwController = TextEditingController();
  var visibility = NoteVisibility.public;

  IconData get resolveVisibilityIcon {
    switch (visibility) {
      case NoteVisibility.public:
        return Icons.public;
      case NoteVisibility.home:
        return Icons.home;
      case NoteVisibility.followers:
        return Icons.lock_outline;
      case NoteVisibility.specified:
        return Icons.mail_outline;
    }
  }

  var isLocalOnly = false;

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 5)),
                if (selectedAccount != null)
                  AvatarIcon.fromIResponse(
                    selectedAccount!.i,
                    height: Theme.of(context)
                            .iconButtonTheme
                            .style
                            ?.iconSize
                            ?.resolve({}) ??
                        32,
                  ),
                Expanded(child: Container()),
                Builder(
                  builder: (context2) => IconButton(
                      onPressed: () async {
                        final result =
                            await showModalBottomSheet<NoteVisibility?>(
                                context: context2,
                                builder: (context) =>
                                    const NoteVisibilityDialog());
                        if (result != null) {
                          setState(() {
                            visibility = result;
                          });
                        }
                      },
                      icon: Icon(resolveVisibilityIcon)),
                ),
                IconButton(
                    onPressed: () async {
                      setState(() {
                        isLocalOnly = !isLocalOnly;
                      });
                    },
                    icon: isLocalOnly
                        ? const LocalOnlyIcon()
                        : const Icon(Icons.rocket)),
                IconButton(
                    onPressed: () async {}, icon: Icon(Icons.all_inclusive))
              ],
            ),
            if (widget.channel != null)
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    Icon(
                      Icons.tv,
                      size: Theme.of(context).textTheme.bodySmall!.fontSize! *
                          MediaQuery.of(context).textScaleFactor,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    Text(
                      widget.channel!.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            if (isCw)
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Theme.of(context).dividerColor))),
                child: TextField(
                  controller: cwController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      hintText: "注釈", contentPadding: EdgeInsets.all(5)),
                ),
              ),
            TextField(
              controller: noteController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  hintText: "何してはる？", contentPadding: EdgeInsets.all(5)),
            ),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.image)),
                IconButton(onPressed: () {}, icon: Icon(Icons.how_to_vote)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        isCw = !isCw;
                      });
                    },
                    icon: Icon(
                        isCw ? Icons.visibility_off : Icons.remove_red_eye)),
                IconButton(onPressed: () {}, icon: Icon(Icons.mail_outline))
              ],
            ),
            if (selectedAccount != null) MfmPreview(account: selectedAccount!),
          ],
        ),
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
      child: Padding(
        padding: EdgeInsets.all(5),
        child: MfmText(
          mfmText: previewText,
          emojiFontSizeRatio: 2,
        ),
      ),
    );
  }
}
