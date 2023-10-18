import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ClipItem extends StatelessWidget {
  final Clip clip;
  final Widget? trailing;

  const ClipItem({
    super.key,
    required this.clip,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.pushRoute(
          ClipDetailRoute(account: AccountScope.of(context), id: clip.id)),
      title: Text(clip.name ?? ""),
      subtitle: SimpleMfmText(clip.description ?? ""),
      trailing: trailing,
    );
  }
}
