import "dart:async";

import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/user_extension.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/model/account.dart";
import "package:miria/model/note_search_condition.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/common/misskey_notes/misskey_note_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/user_page/user_info_notifier.dart";
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

@RoutePage()
class UserControlDialog extends HookConsumerWidget implements AutoRouteWrapper {
  final Account account;
  final UserDetailed response;

  const UserControlDialog({
    required this.account,
    required this.response,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = userInfoNotifierProxyProvider(response.id);

    final createBlocking = useAsync(ref.read(provider).createBlocking);
    final deleteBlocking = useAsync(ref.read(provider).deleteBlocking);
    final createRenoteMute = useAsync(ref.read(provider).createRenoteMute);
    final deleteRenoteMute = useAsync(ref.read(provider).deleteRenoteMute);
    final createMute = useAsync(ref.read(provider).createMute);
    final deleteMute = useAsync(ref.read(provider).deleteMute);
    final copyName = useAsync(() async {
      await Clipboard.setData(
        ClipboardData(text: response.name ?? response.username),
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).doneCopy),
          duration: const Duration(seconds: 1),
        ),
      );
      Navigator.of(context).pop();
    });
    final copyScreenName = useAsync(() async {
      await Clipboard.setData(ClipboardData(text: response.acct));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).doneCopy),
          duration: const Duration(seconds: 1),
        ),
      );
      Navigator.of(context).pop();
    });
    final copyLinks = useAsync(() async {
      await Clipboard.setData(
        ClipboardData(
          text: Uri(
            scheme: "https",
            host: account.host,
            path: response.acct,
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
    });
    final openBrowserAsRemote = useAsync(() async {
      final uri = response.uri ?? response.url;
      if (uri == null) return;
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    });
    final openUserInOtherAccount = useAsync(
      () async => ref
          .read(misskeyNoteNotifierProvider.notifier)
          .openUserInOtherAccount(response),
    );

    final isLoading = [
      createBlocking.value,
      deleteBlocking.value,
      createRenoteMute.value,
      deleteRenoteMute.value,
      createMute.value,
      deleteMute.value,
    ].where((e) => e is AsyncData || e is AsyncLoading).isNotEmpty;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final user = response;
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.copy),
          title: Text(S.of(context).copyName),
          onTap: copyName.executeOrNull,
        ),
        ListTile(
          leading: const Icon(Icons.alternate_email),
          title: Text(S.of(context).copyUserScreenName),
          onTap: copyScreenName.executeOrNull,
        ),
        ListTile(
          leading: const Icon(Icons.link),
          title: Text(S.of(context).copyLinks),
          onTap: copyLinks.executeOrNull,
        ),
        ListTile(
          leading: const Icon(Icons.open_in_browser),
          title: Text(S.of(context).openBrowsers),
          onTap: () async {
            await launchUrl(
              Uri(
                scheme: "https",
                host: account.host,
                path: response.acct,
              ),
              mode: LaunchMode.externalApplication,
            );
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
        ),
        if (response.host != null)
          ListTile(
            leading: const Icon(Icons.rocket_launch),
            title: Text(S.of(context).openBrowsersAsRemote),
            onTap: openBrowserAsRemote.executeOrNull,
          ),
        ListTile(
          leading: const Icon(Icons.open_in_new),
          title: Text(S.of(context).openInAnotherAccount),
          onTap: openUserInOtherAccount.executeOrNull,
        ),
        ListTile(
          leading: const Icon(Icons.search),
          title: Text(S.of(context).searchNote),
          onTap: () async => context.pushRoute(
            SearchRoute(
              accountContext: ref.read(accountContextProvider),
              initialNoteSearchCondition: NoteSearchCondition(
                user: response,
              ),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.list),
          title: Text(S.of(context).addToList),
          onTap: () async => context
              .pushRoute(UsersListModalRoute(account: account, user: response)),
        ),
        ListTile(
          leading: const Icon(Icons.settings_input_antenna),
          title: Text(S.of(context).addToAntenna),
          onTap: () async => context
              .pushRoute(AntennaModalRoute(account: account, user: user)),
        ),
        if (user is UserDetailedNotMeWithRelations) ...[
          if (user.isRenoteMuted)
            ListTile(
              leading: const Icon(Icons.repeat_rounded),
              title: Text(S.of(context).deleteRenoteMute),
              onTap: deleteRenoteMute.executeOrNull,
            )
          else
            ListTile(
              leading: const Icon(Icons.repeat_rounded),
              title: Text(S.of(context).createRenoteMute),
              onTap: createRenoteMute.executeOrNull,
            ),
          if (user.isMuted)
            ListTile(
              leading: const Icon(Icons.visibility),
              title: Text(S.of(context).deleteMute),
              onTap: deleteMute.executeOrNull,
            )
          else
            ListTile(
              leading: const Icon(Icons.visibility_off),
              title: Text(S.of(context).createMute),
              onTap: createMute.executeOrNull,
            ),
          if (user.isBlocking)
            ListTile(
              leading: const Icon(Icons.block),
              title: Text(S.of(context).deleteBlock),
              onTap: deleteBlocking.executeOrNull,
            )
          else
            ListTile(
              leading: const Icon(Icons.block),
              title: Text(S.of(context).createBlock),
              onTap: createBlocking.executeOrNull,
            ),
          ListTile(
            leading: const Icon(Icons.report),
            title: Text(S.of(context).reportAbuse),
            onTap: () async {
              await (
                context.maybePop(),
                context.pushRoute(
                  AbuseRoute(account: account, targetUser: response),
                )
              ).wait;
            },
          ),
        ],
      ],
    );
  }
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

@RoutePage()
class ExpireSelectDialog extends HookWidget {
  const ExpireSelectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedExpire = useState<Expire?>(Expire.indefinite);

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
        onChanged: (value) => selectedExpire.value = value,
        value: selectedExpire.value,
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
