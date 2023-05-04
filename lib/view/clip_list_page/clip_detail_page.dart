import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/model/account.dart';
import 'package:flutter_misskey_app/view/clip_list_page/clip_detail_note_list.dart';
import 'package:flutter_misskey_app/view/common/account_scope.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ClipDetailPage extends ConsumerStatefulWidget {
  final Account account;
  final String id;

  const ClipDetailPage({super.key, required this.account, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ClipDetailPageState();
}

class ClipDetailPageState extends ConsumerState<ClipDetailPage> {
  @override
  Widget build(BuildContext context) {
    return AccountScope(
      account: widget.account,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ClipDetailNoteList(id: widget.id)),
      ),
    );
  }
}
