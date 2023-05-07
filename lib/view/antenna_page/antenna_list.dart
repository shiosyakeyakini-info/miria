import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/futable_list_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class AntennaList extends ConsumerWidget {
  const AntennaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureListView<Antenna>(
        future:
            ref.read(misskeyProvider(AccountScope.of(context))).antennas.list(),
        builder: (context, element) {
          return ListTile(
            onTap: () => context.pushRoute(AntennaNotesRoute(
                antenna: element, account: AccountScope.of(context))),
            title: Text(element.name),
          );
        });
  }
}
