import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/users_show_response_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/user_page/antenna_modal_sheet.dart';
import 'package:miria/view/user_page/users_list_modal_sheet.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';

enum UserControl {
  createMute,
  deleteMute,
  createRenoteMute,
  deleteRenoteMute,
  createBlock,
  deleteBlock,
}

class UserControlDialog extends ConsumerStatefulWidget {
  final Account account;
  final UsersShowResponse response;
  final bool isMe;

  const UserControlDialog({
    super.key,
    required this.account,
    required this.response,
    required this.isMe,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      UserControlDialogState();
}

class UserControlDialogState extends ConsumerState<UserControlDialog> {
  Future<void> addToList() async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => UsersListModalSheet(
        account: widget.account,
        user: widget.response.toUser(),
      ),
    );
  }

  Future<void> addToAntenna() async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => AntennaModalSheet(
        account: widget.account,
        user: widget.response.toUser(),
      ),
    );
  }

  Future<Expire?> getExpire() async {
    return await showDialog<Expire?>(
        context: context, builder: (context) => const ExpireSelectDialog());
  }

  Future<void> renoteMuteCreate() async {
    await ref
        .read(misskeyProvider(widget.account))
        .renoteMute
        .create(RenoteMuteCreateRequest(userId: widget.response.id));
    if (!mounted) return;
    Navigator.of(context).pop(UserControl.createRenoteMute);
  }

  Future<void> renoteMuteDelete() async {
    await ref
        .read(misskeyProvider(widget.account))
        .renoteMute
        .delete(RenoteMuteDeleteRequest(userId: widget.response.id));
    if (!mounted) return;
    Navigator.of(context).pop(UserControl.deleteRenoteMute);
  }

  Future<void> muteCreate() async {
    final expires = await getExpire();
    if (expires == null) return;
    final expiresDate = expires == Expire.indefinite
        ? null
        : DateTime.now().add(expires.expires!);
    await ref.read(misskeyProvider(widget.account)).mute.create(
        MuteCreateRequest(userId: widget.response.id, expiresAt: expiresDate));
    if (!mounted) return;
    Navigator.of(context).pop(UserControl.createMute);
  }

  Future<void> muteDelete() async {
    await ref
        .read(misskeyProvider(widget.account))
        .mute
        .delete(MuteDeleteRequest(userId: widget.response.id));
    if (!mounted) return;
    Navigator.of(context).pop(UserControl.deleteMute);
  }

  Future<void> blockingCreate() async {
    if (await SimpleConfirmDialog.show(
            context: context,
            message: "ブロックしてもええか？",
            primary: "ブロックする",
            secondary: "やっぱりやめる") !=
        true) {
      return;
    }

    await ref
        .read(misskeyProvider(widget.account))
        .blocking
        .create(BlockCreateRequest(userId: widget.response.id));
    if (!mounted) return;
    Navigator.of(context).pop(UserControl.createBlock);
  }

  Future<void> blockingDelete() async {
    await ref
        .read(misskeyProvider(widget.account))
        .blocking
        .delete(BlockDeleteRequest(userId: widget.response.id));
    if (!mounted) return;
    Navigator.of(context).pop(UserControl.deleteBlock);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ListTile(
        onTap: () {
          Clipboard.setData(
            ClipboardData(
              text: Uri(
                scheme: "https",
                host: widget.account.host,
                path: widget.response.acct,
              ).toString(),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("コピーしました")),
          );
          Navigator.of(context).pop();
        },
        title: const Text("リンクをコピー"),
      ),
      ListTile(
        onTap: () {
          Clipboard.setData(
            ClipboardData(
              text: widget.response.name ?? widget.response.username,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("コピーしました")),
          );
          Navigator.of(context).pop();
        },
        title: const Text("ユーザー名をコピー"),
      ),
      ListTile(
        onTap: () {
          Clipboard.setData(ClipboardData(text: widget.response.acct));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("コピーしました")),
          );
          Navigator.of(context).pop();
        },
        title: const Text("ユーザースクリーン名をコピー"),
      ),
      ListTile(
        title: const Text("ブラウザで開く"),
        onTap: () {
          launchUrl(
            Uri(
              scheme: "https",
              host: widget.account.host,
              path: widget.response.acct,
            ),
            mode: LaunchMode.inAppWebView,
          );
          Navigator.of(context).pop();
        },
      ),
      if (widget.response.host != null)
        ListTile(
          title: const Text("ブラウザでリモート先を開く"),
          onTap: () {
            final uri = widget.response.uri ?? widget.response.url;
            if (uri == null) return;
            launchUrl(uri, mode: LaunchMode.inAppWebView);
            Navigator.of(context).pop();
          },
        ),
      ListTile(
        title: const Text("別のアカウントで開く"),
        onTap: () => ref
            .read(misskeyNoteNotifierProvider(widget.account).notifier)
            .openUserInOtherAccount(context, widget.response.toUser())
            .expectFailure(context),
      ),
      ListTile(
        onTap: addToList,
        title: const Text("リストに追加"),
      ),
      ListTile(
        onTap: addToAntenna,
        title: const Text("アンテナに追加"),
      ),
      if (!widget.isMe) ...[
        if (widget.response.isRenoteMuted ?? false)
          ListTile(
            onTap: renoteMuteDelete.expectFailure(context),
            title: const Text("Renoteのミュート解除する"),
          )
        else
          ListTile(
            onTap: renoteMuteCreate.expectFailure(context),
            title: const Text("Renoteをミュートする"),
          ),
        if (widget.response.isMuted ?? false)
          ListTile(
            onTap: muteDelete.expectFailure(context),
            title: const Text("ミュート解除する"),
          )
        else
          ListTile(
            onTap: muteCreate.expectFailure(context),
            title: const Text("ミュートする"),
          ),
        if (widget.response.isBlocking ?? false)
          ListTile(
            onTap: blockingDelete.expectFailure(context),
            title: const Text("ブロックを解除する"),
          )
        else
          ListTile(
            onTap: blockingCreate.expectFailure(context),
            title: const Text("ブロックする"),
          )
      ],
    ]);
  }
}

class ExpireSelectDialog extends StatefulWidget {
  const ExpireSelectDialog({super.key});

  @override
  State<StatefulWidget> createState() => ExpireSelectDialogState();
}

enum Expire {
  indefinite(null, "無期限"),
  minutes_10(Duration(minutes: 10), "10分間"),
  hours_1(Duration(hours: 1), "1時間"),
  day_1(Duration(days: 1), "1日"),
  week_1(Duration(days: 7), "1週間");

  final Duration? expires;
  final String name;

  const Expire(this.expires, this.name);
}

class ExpireSelectDialogState extends State<ExpireSelectDialog> {
  Expire? selectedExpire = Expire.indefinite;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("期限を選択してください。"),
      content: Container(
        child: DropdownButton<Expire>(
          items: [
            for (final value in Expire.values)
              DropdownMenuItem<Expire>(
                value: value,
                child: Text(value.name),
              )
          ],
          onChanged: (value) => setState(() => selectedExpire = value),
          value: selectedExpire,
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(selectedExpire);
            },
            child: const Text("ほい"))
      ],
    );
  }
}
