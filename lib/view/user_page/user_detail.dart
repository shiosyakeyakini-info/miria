import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:miria/view/common/constants.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/misskey_note.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:miria/view/user_page/update_memo_dialog.dart';
import 'package:miria/view/user_page/user_control_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

class UserDetail extends ConsumerStatefulWidget {
  final Account account;
  final Account? controlAccount;
  final UsersShowResponse response;

  const UserDetail({
    super.key,
    required this.response,
    required this.account,
    required this.controlAccount,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserDetailState();
}

class UserDetailState extends ConsumerState<UserDetail> {
  late UsersShowResponse response;
  bool isFollowEditing = false;
  String memo = "";

  Future<void> followCreate() async {
    if (isFollowEditing) return;
    setState(() {
      isFollowEditing = true;
    });
    await ref
        .read(misskeyProvider(AccountScope.of(context)))
        .following
        .create(FollowingCreateRequest(userId: response.id));
    if (!mounted) return;
    setState(() {
      isFollowEditing = false;
      response = response.copyWith(
        isFollowing: !response.requiresFollowRequest,
        hasPendingFollowRequestFromYou: response.requiresFollowRequest,
      );
    });
  }

  Future<void> followDelete() async {
    if (isFollowEditing) return;
    setState(() {
      isFollowEditing = true;
    });
    await ref
        .read(misskeyProvider(AccountScope.of(context)))
        .following
        .delete(FollowingDeleteRequest(userId: response.id));
    if (!mounted) return;
    setState(() {
      isFollowEditing = false;
      response = response.copyWith(isFollowing: false);
    });
  }

  Future<void> followRequestCancel() async {
    if (isFollowEditing) return;
    setState(() {
      isFollowEditing = true;
    });
    await ref
        .read(misskeyProvider(AccountScope.of(context)))
        .following
        .requests
        .cancel(FollowingRequestsCancelRequest(userId: response.id));
    if (!mounted) return;
    setState(() {
      isFollowEditing = false;
      response = response.copyWith(hasPendingFollowRequestFromYou: false);
    });
  }

  Future<void> userControl(bool isMe) async {
    final result = await showModalBottomSheet<UserControl?>(
        context: context,
        builder: (context) => UserControlDialog(
              account: widget.account,
              response: response,
              isMe: isMe,
            ));
    if (result == null) return;

    switch (result) {
      case UserControl.createMute:
        setState(() {
          response = response.copyWith(isMuted: true);
        });
        break;
      case UserControl.deleteMute:
        setState(() {
          response = response.copyWith(isMuted: false);
        });
        break;
      case UserControl.createRenoteMute:
        setState(() {
          response = response.copyWith(isRenoteMuted: true);
        });
        break;
      case UserControl.deleteRenoteMute:
        setState(() {
          response = response.copyWith(isRenoteMuted: false);
        });
        break;
      case UserControl.createBlock:
        setState(() {
          response = response.copyWith(isBlocked: true);
        });
        break;
      case UserControl.deleteBlock:
        setState(() {
          response = response.copyWith(isBlocked: false);
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    response = widget.response;
    memo = response.memo ?? "";
  }

  Widget buildContent() {
    final userName =
        "${response.username}${response.host != null ? "@${response.host ?? ""}" : ""}";
    final isMe = (widget.response.host == null &&
        widget.response.username == AccountScope.of(context).userId);

    return Column(children: [
      if (widget.controlAccount == null)
        Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isMe)
                  const Spacer()
                else
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (response.isRenoteMuted ?? false)
                              const Card(
                                  child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Renoteのミュート中"),
                              )),
                            if (response.isMuted ?? false)
                              const Card(
                                  child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("ミュート中"),
                              )),
                            if (response.isBlocked ?? false)
                              const Card(
                                  child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("ブロック中"),
                              )),
                            if ((response.isFollowed ?? false))
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Card(
                                    child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text("フォローされています"),
                                )),
                              ),
                            if (!isFollowEditing)
                              (response.isFollowing ?? false)
                                  ? ElevatedButton(
                                      onPressed: followDelete,
                                      child: const Text("フォロー解除"),
                                    )
                                  : (response.hasPendingFollowRequestFromYou ??
                                          false)
                                      ? ElevatedButton(
                                          onPressed: followRequestCancel,
                                          child: const Text("フォロー許可待ち"),
                                        )
                                      : OutlinedButton(
                                          onPressed: followCreate,
                                          child: Text(
                                            (response.requiresFollowRequest)
                                                ? "フォロー申請"
                                                : "フォローする",
                                          ),
                                        )
                            else
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                    onPressed: () {},
                                    icon: SizedBox(
                                        width: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.fontSize ??
                                            22,
                                        height: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.fontSize ??
                                            22,
                                        child:
                                            const CircularProgressIndicator()),
                                    label: const Text("更新中")),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                      onPressed: () => userControl(isMe),
                      icon: const Icon(Icons.more_vert)),
                )
              ],
            )),
      const Divider(),
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
        child: Column(children: [
          Row(
            children: [
              AvatarIcon.fromUserResponse(
                response,
                height: 80,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MfmText(
                        response.name ?? response.username,
                        style: Theme.of(context).textTheme.headlineSmall,
                        emoji: response.emojis ?? {},
                      ),
                      Text(
                        "@$userName",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          if (widget.controlAccount == null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        memo.isNotEmpty ? memo : "なんかメモることあったら書いとき",
                        style: memo.isNotEmpty
                            ? null
                            : Theme.of(context).inputDecorationTheme.hintStyle,
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          final result = await showDialog(
                              context: context,
                              builder: (context) => UpdateMemoDialog(
                                    account: widget.account,
                                    initialMemo: memo,
                                    userId: response.id,
                                  ));
                          if (result != null) {
                            setState(() {
                              memo = result;
                            });
                          }
                        },
                        icon: const Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              for (final role in response.roles ?? [])
                Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).dividerColor)),
                    padding: const EdgeInsets.all(5),
                    child: Text(role.name)),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          if (response.host != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded),
                        Text("リモートユーザーのため、情報が不完全です。")
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.pushRoute(FederationRoute(
                          account: AccountScope.of(context),
                          host: response.host!)),
                      child: Text(
                        "サーバー情報を表示",
                        style: AppTheme.of(context).linkStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: MfmText(response.description ?? "",
                emoji: response.emojis ?? {}),
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
                TableCell(child: Text(response.location ?? ""))
              ]),
              TableRow(children: [
                const TableCell(
                  child: Text(
                    "登録日",
                    textAlign: TextAlign.center,
                  ),
                ),
                TableCell(child: Text(response.createdAt.format)), //FIXME
              ]),
              TableRow(children: [
                const TableCell(
                    child: Text(
                  "誕生日",
                  textAlign: TextAlign.center,
                )),
                TableCell(child: Text(response.birthday?.format ?? ""))
              ])
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          if (response.fields?.isNotEmpty == true) ...[
            Table(
              columnWidths: const {
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(3),
              },
              children: [
                for (final field in response.fields ?? <UserField>[])
                  TableRow(children: [
                    TableCell(
                        child: MfmText(
                      field.name,
                      emoji: response.emojis ?? {},
                    )),
                    TableCell(
                        child:
                            MfmText(field.value, emoji: response.emojis ?? {})),
                  ])
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
          ],
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(
              children: [
                Text(response.notesCount.format(),
                    style: Theme.of(context).textTheme.titleMedium),
                Text(
                  "ノート",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
            InkWell(
              onTap: () => context.pushRoute(UserFolloweeRoute(
                  userId: response.id, account: AccountScope.of(context))),
              child: Column(
                children: [
                  Text(response.followingCount.format(),
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    "フォロー",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () => context.pushRoute(UserFollowerRoute(
                  userId: response.id, account: AccountScope.of(context))),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(response.followersCount.format(),
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    "フォロワー",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ),
          ]),
        ]),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BirthdayConfetti(
      response: widget.response,
      child: Column(
        children: [
          if (response.bannerUrl != null)
            Image.network(response.bannerUrl.toString()),
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: buildContent()),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final note in response.pinnedNotes ?? [])
                  MisskeyNote(
                    note: note,
                    loginAs: widget.controlAccount,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BirthdayConfetti extends StatefulWidget {
  final UsersShowResponse response;
  final Widget child;

  const BirthdayConfetti({
    super.key,
    required this.response,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => BirthdayConfettiState();
}

class BirthdayConfettiState extends State<BirthdayConfetti> {
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 30));

  @override
  void initState() {
    super.initState();
    confettiController.play();
  }

  @override
  void dispose() {
    super.dispose();
    confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    if (now.month == widget.response.birthday?.month &&
        now.day == widget.response.birthday?.day) {
      return ConfettiWidget(
          confettiController: confettiController,
          blastDirection: 0,
          numberOfParticles: 40,
          child: widget.child);
    }

    return widget.child;
  }
}

extension on UsersShowResponse {
  bool get requiresFollowRequest {
    return isLocked &&
        !((isFollowed ?? false) && (autoAcceptFollowed ?? false));
  }
}
