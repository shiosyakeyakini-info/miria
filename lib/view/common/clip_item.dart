import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:misskey_dart/misskey_dart.dart";

class ClipItem extends ConsumerWidget {
  final Clip clip;
  final Widget? trailing;

  const ClipItem({
    required this.clip,
    super.key,
    this.trailing,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () async => context.pushRoute(
        ClipDetailRoute(
            accountContext: ref.read(accountContextProvider), id: clip.id,),
      ),
      title: Text(clip.name ?? ""),
      subtitle: SimpleMfmText(clip.description ?? ""),
      trailing: trailing,
    );
  }
}
