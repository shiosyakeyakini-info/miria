import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/common/simple_message_dialog.dart';
import 'package:miria/view/note_create_page/note_create_page.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NoteVisibilityDialog extends ConsumerWidget {
  const NoteVisibilityDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        ListTile(
          onTap: () {
            final replyVisibility = ref.read(replyProvider)?.visibility;
            if (replyVisibility == NoteVisibility.specified ||
                replyVisibility == NoteVisibility.followers ||
                replyVisibility == NoteVisibility.home) {
              SimpleMessageDialog.show(context,
                  "リプライが${replyVisibility!.displayName}やから、パブリックにでけへん");
              return;
            }

            Navigator.of(context).pop(NoteVisibility.public);
          },
          leading: const Icon(Icons.public),
          title: const Text("パブリック"),
          subtitle: const Text("みんなに公開"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pop(NoteVisibility.home);
          },
          leading: const Icon(Icons.home_outlined),
          title: const Text("ホーム"),
          subtitle: const Text("ホームタイムラインのみに公開"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pop(NoteVisibility.followers);
          },
          leading: const Icon(Icons.lock_outline),
          title: const Text("フォロワー"),
          subtitle: const Text("自分のフォロワーのみに公開"),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pop(NoteVisibility.specified);
          },
          leading: const Icon(Icons.mail_outline),
          title: const Text("ダイレクト"),
          subtitle: const Text("選択したユーザーのみに公開"),
        ),
      ],
    );
  }
}
