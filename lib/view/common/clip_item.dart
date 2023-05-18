import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ClipItem extends StatelessWidget {
  final Clip clip;
  const ClipItem({super.key, required this.clip});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.pushRoute(
          ClipDetailRoute(account: AccountScope.of(context), id: clip.id)),
      title: Text(clip.name ?? ""),
      subtitle: Text(clip.description ?? ""),
    );
  }
}
