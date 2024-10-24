import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:misskey_dart/misskey_dart.dart";

class NoteVisibilityDialog extends ConsumerWidget {
  final Account account;

  const NoteVisibilityDialog({
    required this.account,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        ListTile(
          onTap: () async {
            if (!context.mounted) return;
            Navigator.of(context).pop(NoteVisibility.public);
          },
          leading: const Icon(Icons.public),
          title: Text(S.of(context).public),
          subtitle: Text(S.of(context).publicSubTitle),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pop(NoteVisibility.home);
          },
          leading: const Icon(Icons.home),
          title: Text(S.of(context).home),
          subtitle: Text(S.of(context).homeSubTitle),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pop(NoteVisibility.followers);
          },
          leading: const Icon(Icons.lock_outline),
          title: Text(S.of(context).follower),
          subtitle: Text(S.of(context).followersSubTitle),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pop(NoteVisibility.specified);
          },
          leading: const Icon(Icons.mail),
          title: Text(S.of(context).direct),
          subtitle: Text(S.of(context).specifiedSubTitle),
        ),
      ],
    );
  }
}
