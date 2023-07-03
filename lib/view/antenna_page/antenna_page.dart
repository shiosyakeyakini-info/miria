import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/view/antenna_page/antenna_list.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class AntennaPage extends ConsumerWidget {
  final Account account;

  const AntennaPage({required this.account, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AccountScope(
      account: account,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("アンテナ"),
        ),
        body: const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: AntennaList()),
      ),
    );
  }
}
