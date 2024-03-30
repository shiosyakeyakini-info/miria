import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/user_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/note_search_condition.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/abuse_dialog.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/user_page/antenna_modal_sheet.dart';
import 'package:miria/view/user_page/users_list_modal_sheet.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final UserDetailed response;

  const UserControlDialog({
    super.key,
    required this.account,
    required this.response,
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
        user: widget.response,
      ),
    );
  }

  Future<void> addToAntenna() async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => AntennaModalSheet(
        account: widget.account,
        user: widget.response,
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
          message: S.of(context).confirmCreateBlock,
          primary: S.of(context).createBlock,
          secondary: S.of(context).cancel,
        ) !=
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
    final user = widget.response;
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.copy),
          title: Text(S.of(context).copyName),
          onTap: () {
            Clipboard.setData(
              ClipboardData(
                text: widget.response.name ?? widget.response.username,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).doneCopy), duration: const Duration(seconds: 1)),
            );
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.alternate_email),
          title: Text(S.of(context).copyUserScreenName),
          onTap: () {
            Clipboard.setData(ClipboardData(text: widget.response.acct));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).doneCopy), duration: const Duration(seconds: 1)),
            );
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: Text(S.of(context).copyLinks),
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
              SnackBar(content: Text(S.of(context).doneCopy), duration: const Duration(seconds: 1)),
            );
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.open_in_browser),
          title: Text(S.of(context).openBrowsers),
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
            leading: const Icon(Icons.rocket_launch),
            title: Text(S.of(context).openBrowsersAsRemote),
            onTap: () {
              final uri = widget.response.uri ?? widget.response.url;
              if (uri == null) return;
              launchUrl(uri, mode: LaunchMode.inAppWebView);
              Navigator.of(context).pop();
            },
          ),
        ListTile(
          leading: const Icon(Icons.open_in_new),
          title: Text(S.of(context).openInAnotherAccount),
          onTap: () => ref
              .read(misskeyNoteNotifierProvider(widget.account).notifier)
              .openUserInOtherAccount(context, user)
              .expectFailure(context),
        ),
        ListTile(
          leading: const Icon(Icons.search),
          title: Text(S.of(context).searchNote),
          onTap: () => context.pushRoute(
            SearchRoute(
              account: widget.account,
              initialNoteSearchCondition: NoteSearchCondition(
                user: widget.response,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.list),
          title: Text(S.of(context).addToList),
          onTap: addToList,
        ),
        ListTile(
          leading: const Icon(Icons.settings_input_antenna),
          title: Text(S.of(context).addToAntenna),
          onTap: addToAntenna,
        ),
        if (user is UserDetailedNotMeWithRelations) ...[
          if (user.isRenoteMuted)
            ListTile(
              leading: const Icon(Icons.repeat_rounded),
              title: Text(S.of(context).deleteRenoteMute),
              onTap: renoteMuteDelete.expectFailure(context),
            )
          else
            ListTile(
              leading: const Icon(Icons.repeat_rounded),
              title: Text(S.of(context).createRenoteMute),
              onTap: renoteMuteCreate.expectFailure(context),
            ),
          if (user.isMuted)
            ListTile(
              leading: const Icon(Icons.visibility),
              title: Text(S.of(context).deleteMute),
              onTap: muteDelete.expectFailure(context),
            )
          else
            ListTile(
              leading: const Icon(Icons.visibility_off),
              title: Text(S.of(context).createMute),
              onTap: muteCreate.expectFailure(context),
            ),
          if (user.isBlocking)
            ListTile(
              leading: const Icon(Icons.block),
              title: Text(S.of(context).deleteBlock),
              onTap: blockingDelete.expectFailure(context),
            )
          else
            ListTile(
              leading: const Icon(Icons.block),
              title: Text(S.of(context).createBlock),
              onTap: blockingCreate.expectFailure(context),
            ),
          ListTile(
            leading: const Icon(Icons.report),
            title: Text(S.of(context).reportAbuse),
            onTap: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => AbuseDialog(
                  account: widget.account,
                  targetUser: widget.response));
            },
          )
        ],
      ],
    );
  }
}

class ExpireSelectDialog extends StatefulWidget {
  const ExpireSelectDialog({super.key});

  @override
  State<StatefulWidget> createState() => ExpireSelectDialogState();
}

enum Expire {
  indefinite(null),
  minutes_10(Duration(minutes: 10)),
  hours_1(Duration(hours: 1)),
  day_1(Duration(days: 1)),
  week_1(Duration(days: 7));

  final Duration? expires;

  const Expire(this.expires);

  String displayName(BuildContext context) {
    return switch (this) {
      Expire.indefinite => S.of(context).unlimited,
      Expire.minutes_10 => S.of(context).minutes10,
      Expire.hours_1 => S.of(context).hours1,
      Expire.day_1 => S.of(context).day1,
      Expire.week_1 => S.of(context).week1,
    };
  }
}

class ExpireSelectDialogState extends State<ExpireSelectDialog> {
  Expire? selectedExpire = Expire.indefinite;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).selectDuration),
      content: Container(
        child: DropdownButton<Expire>(
          items: [
            for (final value in Expire.values)
              DropdownMenuItem<Expire>(
                value: value,
                child: Text(value.displayName(context)),
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
            child: Text(S.of(context).done))
      ],
    );
  }
}
