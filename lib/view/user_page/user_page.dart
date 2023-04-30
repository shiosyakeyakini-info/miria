import 'dart:ffi';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/extensions/date_time_extension.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/view/common/mfm_text.dart';
import 'package:flutter_misskey_app/view/common/misskey_note.dart';
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
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: ref
            .read(misskeyProvider)
            .users
            .show(UsersShowRequest(userId: widget.userId)),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data != null) {
            final userName =
                "${data.username}${data.host != null ? "@${data.host ?? ""}" : ""}";
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (data.bannerUrl != null)
                    Image.network(data.bannerUrl.toString()),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                width: 80,
                                child:
                                    Image.network(data.avatarUrl.toString())),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MfmText(
                                      mfmText: data.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                    Text(
                                      "@$userName",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 5)),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            for (final role in data.roles ?? [])
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Theme.of(context).dividerColor)),
                                  padding: const EdgeInsets.all(5),
                                  child: Text(role.name)),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 5)),
                        Align(
                          alignment: Alignment.center,
                          child: MfmText(mfmText: data.description ?? ""),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        Table(
                          columnWidths: const {
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(children: [
                              const TableCell(
                                child: Text(
                                  "場所",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              TableCell(child: Text(data.location ?? ""))
                            ]),
                            TableRow(children: [
                              const TableCell(
                                child: Text(
                                  "登録日",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              TableCell(
                                  child: Text(data.createdAt.format)), //FIXME
                            ]),
                            TableRow(children: [
                              const TableCell(
                                  child: Text(
                                "誕生日",
                                textAlign: TextAlign.center,
                              )),
                              TableCell(
                                  child: Text(data.birthday?.format ?? ""))
                            ])
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        if (data.fields?.isNotEmpty == true) ...[
                          Table(
                            columnWidths: const {
                              1: FlexColumnWidth(2),
                              2: FlexColumnWidth(3),
                            },
                            children: [
                              for (final field in data.fields ?? <UserField>[])
                                TableRow(children: [
                                  TableCell(
                                      child: MfmText(mfmText: field.name)),
                                  TableCell(
                                      child: MfmText(mfmText: field.value)),
                                ])
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(data.notesCount.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text(
                                  "ノート",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(data.followingCount.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text(
                                  "フォロー",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(data.followersCount.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text(
                                  "フォロワー",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ],
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            for (final note in data.pinnedNotes ?? [])
                              MisskeyNote(note: note),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
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
    );
  }
}
