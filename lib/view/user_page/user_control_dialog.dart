import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/users_show_response_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/user_page/antenna_modal_sheet.dart';
import 'package:miria/view/user_page/users_list_modal_sheet.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';

class UserControlDialog extends ConsumerWidget {
  final Account account;
  final String userId;

  const UserControlDialog({
    super.key,
    required this.account,
    required this.userId,
  });

  Future<void> addToList(BuildContext context, User user) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => UsersListModalSheet(
        account: account,
        user: user,
      ),
    );
  }

  Future<void> addToAntenna(BuildContext context, User user) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => AntennaModalSheet(
        account: account,
        user: user,
      ),
    );
  }

  Future<Expire?> getExpire(BuildContext context) async {
    return await showDialog<Expire?>(
        context: context, builder: (context) => const ExpireSelectDialog());
  }

  Future<void> renoteMuteCreate(BuildContext context, WidgetRef ref) async {
    await ref
        .read(userDetailedNotifierProvider((account, userId)).notifier)
        .createRenoteMute();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> renoteMuteDelete(BuildContext context, WidgetRef ref) async {
    await ref
        .read(userDetailedNotifierProvider((account, userId)).notifier)
        .deleteRenoteMute();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> muteCreate(BuildContext context, WidgetRef ref) async {
    final expires = await getExpire(context);
    if (expires == null) return;
    await ref
        .read(userDetailedNotifierProvider((account, userId)).notifier)
        .createMute(expires.expires);
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> muteDelete(BuildContext context, WidgetRef ref) async {
    await ref
        .read(
          userDetailedNotifierProvider((account, userId)).notifier,
        )
        .deleteMute();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> blockingCreate(BuildContext context, WidgetRef ref) async {
    if (await SimpleConfirmDialog.show(
          context: context,
          message: "ブロックしてもええか？",
          primary: "ブロックする",
          secondary: "やっぱりやめる",
        ) ??
        false) {
      return;
    }

    await ref
        .read(userDetailedNotifierProvider((account, userId)).notifier)
        .createBlock();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> blockingDelete(BuildContext context, WidgetRef ref) async {
    await ref
        .read(userDetailedNotifierProvider((account, userId)).notifier)
        .deleteBlock();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailedNotifierProvider((account, userId)));
    return user.when(
      data: (user) => ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text("名前をコピー"),
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: user.name ?? user.username),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("コピーしました")),
              );
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: const Text("ユーザー名をコピー"),
            onTap: () {
              Clipboard.setData(ClipboardData(text: user.acct));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("コピーしました")),
              );
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text("リンクをコピー"),
            onTap: () {
              Clipboard.setData(
                ClipboardData(
                  text: Uri(
                    scheme: "https",
                    host: user.host,
                    path: user.acct,
                  ).toString(),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("コピーしました")),
              );
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.open_in_browser),
            title: const Text("ブラウザで開く"),
            onTap: () {
              launchUrl(
                Uri(
                  scheme: "https",
                  host: user.host,
                  path: user.acct,
                ),
                mode: LaunchMode.inAppWebView,
              );
              Navigator.of(context).pop();
            },
          ),
          if (user.host != null)
            ListTile(
              leading: const Icon(Icons.rocket_launch),
              title: const Text("ブラウザでリモート先を開く"),
              onTap: () {
                final uri = user.uri ?? user.url;
                if (uri == null) return;
                launchUrl(uri, mode: LaunchMode.inAppWebView);
                Navigator.of(context).pop();
              },
            ),
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: const Text("別のアカウントで開く"),
            onTap: () => ref
                .read(misskeyNoteNotifierProvider(account).notifier)
                .openUserInOtherAccount(context, user.toUser())
                .expectFailure(context),
          ),
          if (account.hasToken) ...[
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("リストに追加"),
              onTap: () => addToList(context, user.toUser()),
            ),
            ListTile(
              leading: const Icon(Icons.settings_input_antenna),
              title: const Text("アンテナに追加"),
              onTap: () => addToAntenna(context, user.toUser()),
            ),
            if (user.host != null || user.username != account.userId) ...[
              if (user.isRenoteMuted ?? false)
                ListTile(
                  leading: const Icon(Icons.repeat_rounded),
                  title: const Text("Renoteのミュート解除する"),
                  onTap: () =>
                      renoteMuteDelete(context, ref).expectFailure(context),
                )
              else
                ListTile(
                  leading: const Icon(Icons.repeat_rounded),
                  title: const Text("Renoteをミュートする"),
                  onTap: () =>
                      renoteMuteCreate(context, ref).expectFailure(context),
                ),
              if (user.isMuted ?? false)
                ListTile(
                  leading: const Icon(Icons.visibility),
                  title: const Text("ミュート解除する"),
                  onTap: () => muteDelete(context, ref).expectFailure(context),
                )
              else
                ListTile(
                  leading: const Icon(Icons.visibility_off),
                  title: const Text("ミュートする"),
                  onTap: () => muteCreate(context, ref).expectFailure(context),
                ),
              if (user.isBlocking ?? false)
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text("ブロックを解除する"),
                  onTap: () =>
                      blockingDelete(context, ref).expectFailure(context),
                )
              else
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text("ブロックする"),
                  onTap: () =>
                      blockingCreate(context, ref).expectFailure(context),
                ),
            ],
          ],
        ],
      ),
      error: (e, st) => Center(child: ErrorDetail(error: e, stackTrace: st)),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
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
