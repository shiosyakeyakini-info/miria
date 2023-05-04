import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/router/app_router.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_misskey_app/view/common/clip_item.dart';
import 'package:flutter_misskey_app/view/common/futable_list_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ClipListPage extends ConsumerStatefulWidget {
  const ClipListPage({super.key, required this.account});
  final Account account;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ClipListPageState();
}

class ClipListPageState extends ConsumerState<ClipListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("クリップ一覧"),
        ),
        body: AccountScope(
            account: widget.account,
            child: FutureListView(
              future: ref.read(misskeyProvider(widget.account)).clips.list(),
              builder: (context, item) => ClipItem(clip: item),
            )));
  }
}
