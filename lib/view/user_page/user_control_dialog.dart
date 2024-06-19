import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/user_extension.dart";
import "package:miria/model/account.dart";
import "package:miria/model/note_search_condition.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/common/misskey_notes/misskey_note_notifier.dart";
import "package:miria/view/common/misskey_notes/abuse_dialog.dart";
import "package:miria/view/user_page/antenna_modal_sheet.dart";
import "package:miria/view/user_page/user_info_notifier.dart";
import "package:miria/view/user_page/users_list_modal_sheet.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:url_launcher/url_launcher.dart";

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
    required this.account,
    required this.response,
    super.key,
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

  Future<void> createMute() async {
    final expires = await showDialog<Expire?>(
      context: context,
      builder: (context) => const ExpireSelectDialog(),
    );
    if (expires == null) return;
    await ref
        .read(
          userInfoNotifierProvider(widget.account, widget.response.id).notifier,
        )
        .createMute(expires);
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        userInfoNotifierProvider(widget.account, widget.response.id);

    final isLoading = ref.watch(
      provider.select(
        (value) =>
            value.valueOrNull?.mute is AsyncLoading ||
            value.valueOrNull?.renoteMute is AsyncLoading ||
            value.valueOrNull?.block is AsyncLoading,
      ),
    );
    ref
      ..listen(provider.select((value) => value.valueOrNull?.mute),
          (_, next) async {
        if (next is! AsyncData) return;
        Navigator.of(context).pop();
      })
      ..listen(provider.select((value) => value.valueOrNull?.renoteMute),
          (_, next) {
        if (next is! AsyncData) return;
        Navigator.of(context).pop();
      })
      ..listen(
        provider.select((value) => value.valueOrNull?.block),
        (_, next) async {
          if (next is! AsyncData) return;
          Navigator.of(context).pop();
        },
      );

    if (isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final user = widget.response;
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.copy),
          title: Text(S.of(context).copyName),
          onTap: () async {
            await Clipboard.setData(
              ClipboardData(
                text: widget.response.name ?? widget.response.username,
              ),
            );
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).doneCopy),
                duration: const Duration(seconds: 1),
              ),
            );
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.alternate_email),
          title: Text(S.of(context).copyUserScreenName),
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: widget.response.acct));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).doneCopy),
                duration: const Duration(seconds: 1),
              ),
            );
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: Text(S.of(context).copyLinks),
          onTap: () async {
            await Clipboard.setData(
              ClipboardData(
                text: Uri(
                  scheme: "https",
                  host: widget.account.host,
                  path: widget.response.acct,
                ).toString(),
              ),
            );
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).doneCopy),
                duration: const Duration(seconds: 1),
              ),
            );
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.open_in_browser),
          title: Text(S.of(context).openBrowsers),
          onTap: () async {
            await launchUrl(
              Uri(
                scheme: "https",
                host: widget.account.host,
                path: widget.response.acct,
              ),
              mode: LaunchMode.inAppWebView,
            );
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
        ),
        if (widget.response.host != null)
          ListTile(
            leading: const Icon(Icons.rocket_launch),
            title: Text(S.of(context).openBrowsersAsRemote),
            onTap: () async {
              final uri = widget.response.uri ?? widget.response.url;
              if (uri == null) return;
              await launchUrl(uri, mode: LaunchMode.inAppWebView);
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
          ),
        ListTile(
          leading: const Icon(Icons.open_in_new),
          title: Text(S.of(context).openInAnotherAccount),
          onTap: () async => ref
              .read(misskeyNoteNotifierProvider(widget.account).notifier)
              .openUserInOtherAccount(context, user),
        ),
        ListTile(
          leading: const Icon(Icons.search),
          title: Text(S.of(context).searchNote),
          onTap: () async => context.pushRoute(
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
              onTap: ref.read(provider.notifier).deleteRenoteMute,
            )
          else
            ListTile(
              leading: const Icon(Icons.repeat_rounded),
              title: Text(S.of(context).createRenoteMute),
              onTap: ref.read(provider.notifier).createRenoteMute,
            ),
          if (user.isMuted)
            ListTile(
              leading: const Icon(Icons.visibility),
              title: Text(S.of(context).deleteMute),
              onTap: ref.read(provider.notifier).deleteMute,
            )
          else
            ListTile(
              leading: const Icon(Icons.visibility_off),
              title: Text(S.of(context).createMute),
              onTap: createMute,
            ),
          if (user.isBlocking)
            ListTile(
              leading: const Icon(Icons.block),
              title: Text(S.of(context).deleteBlock),
              onTap: ref.read(provider.notifier).deleteBlocking,
            )
          else
            ListTile(
              leading: const Icon(Icons.block),
              title: Text(S.of(context).createBlock),
              onTap: ref.read(provider.notifier).createBlocking,
            ),
          ListTile(
            leading: const Icon(Icons.report),
            title: Text(S.of(context).reportAbuse),
            onTap: () async {
              Navigator.of(context).pop();
              await showDialog(
                context: context,
                builder: (context) => AbuseDialog(
                  account: widget.account,
                  targetUser: widget.response,
                ),
              );
            },
          ),
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
      content: DropdownButton<Expire>(
        items: [
          for (final value in Expire.values)
            DropdownMenuItem<Expire>(
              value: value,
              child: Text(value.displayName(context)),
            ),
        ],
        onChanged: (value) => setState(() => selectedExpire = value),
        value: selectedExpire,
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(selectedExpire);
          },
          child: Text(S.of(context).done),
        ),
      ],
    );
  }
}
