import 'dart:ffi';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/extensions/date_time_extension.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/mfm_text.dart';
import 'package:flutter_misskey_app/view/common/misskey_note.dart';
import 'package:flutter_misskey_app/view/user_page/user_detail.dart';
import 'package:flutter_misskey_app/view/user_page/user_notes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class UserPage extends ConsumerStatefulWidget {
  final String userId;
  const UserPage({super.key, required this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserPageState();
}

class UserPageState extends ConsumerState<UserPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            const TabBar(tabs: [
              Tab(
                text: "アカウント情報",
              ),
              Tab(text: "ノート")
            ]),
            Expanded(
              child: TabBarView(
                children: [
                  FutureBuilder(
                    future: ref
                        .read(misskeyProvider)
                        .users
                        .show(UsersShowRequest(userId: widget.userId)),
                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      if (data != null) {
                        return SingleChildScrollView(
                            child: UserDetail(
                          response: data,
                        ));
                      }
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        print(snapshot.stackTrace);
                        return const Center(
                          child: Text("えらー"),
                        );
                      }

                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  UserNotes(userId: widget.userId),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
