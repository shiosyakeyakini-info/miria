import "package:auto_route/auto_route.dart";
import "package:confetti/confetti.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/extensions/string_extensions.dart";
import "package:miria/extensions/user_extension.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/constants.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:miria/view/user_page/update_memo_dialog.dart";
import "package:miria/view/user_page/user_info_notifier.dart";
import "package:misskey_dart/misskey_dart.dart";

class UserDetail extends ConsumerWidget {
  final Account account;
  final Account? controlAccount;
  final UserDetailed response;

  const UserDetail({
    required this.response,
    required this.account,
    required this.controlAccount,
    super.key,
  });

  Future<void> userControl(BuildContext context) async {
    await context
        .pushRoute(UserControlRoute(account: account, response: response));
    // await showModalBottomSheet<UserControl?>(
    //   context: context,
    //   builder: (context) => UserControlDialog(
    //     account: account,
    //     response: response,
    //   ),
    // );
  }

  Widget buildContent(BuildContext context, WidgetRef ref) {
    final response = this.response;
    final isFollowEditing = ref.watch(
      userInfoNotifierProvider(response.id)
          .select((value) => value.value?.follow is AsyncLoading),
    );
    final notifier = ref.read(userInfoNotifierProvider(response.id).notifier);
    final memo = response.memo ?? "";

    return Column(
      children: [
        if (controlAccount == null)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (response is UserDetailedNotMeWithRelations)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (response.isRenoteMuted)
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(S.of(context).renoteMuting),
                                ),
                              ),
                            if (response.isMuted)
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(S.of(context).muting),
                                ),
                              ),
                            if (response.isBlocking)
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(S.of(context).blocking),
                                ),
                              ),
                            if (response.isFollowed)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(S.of(context).followed),
                                  ),
                                ),
                              ),
                            if (!isFollowEditing)
                              if (response.isFollowing)
                                ElevatedButton(
                                  onPressed: notifier.deleteFollow,
                                  child: Text(S.of(context).unfollow),
                                )
                              else if (response.hasPendingFollowRequestFromYou)
                                ElevatedButton(
                                  onPressed: notifier.cancelFollowRequest,
                                  child: Text(
                                    S.of(context).followRequestPending,
                                  ),
                                )
                              else
                                OutlinedButton(
                                  onPressed: notifier.createFollow,
                                  child: Text(
                                    response.isLocked
                                        ? S.of(context).followRequest
                                        : S.of(context).createFollow,
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
                                    child: const CircularProgressIndicator(),
                                  ),
                                  label: Text(S.of(context).refreshing),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () async => userControl(context),
                    icon: const Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
          child: Column(
            children: [
              Row(
                children: [
                  AvatarIcon(
                    user: response,
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
                            mfmText: response.name ?? response.username,
                            style: Theme.of(context).textTheme.headlineSmall,
                            emoji: response.emojis,
                          ),
                          Text(
                            response.acct,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              if (controlAccount == null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            memo.isNotEmpty
                                ? memo
                                : S.of(context).memoDescription,
                            style: memo.isNotEmpty
                                ? null
                                : Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) => UpdateMemoDialog(
                                account: account,
                                initialMemo: memo,
                                userId: response.id,
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  for (final role in response.roles ?? []) RoleChip(role: role),
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
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded),
                            Text(S.of(context).remoteUserCaution),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async => context.pushRoute(
                            FederationRoute(
                              account: AccountScope.of(context),
                              host: response.host!,
                            ),
                          ),
                          child: Text(
                            S.of(context).showServerInformation,
                            style: AppTheme.of(context).linkStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.center,
                child: MfmText(
                  mfmText: response.description ?? "",
                  emoji: response.emojis,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Table(
                columnWidths: const {
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Text(
                          S.of(context).location,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TableCell(child: Text(response.location ?? "")),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Text(
                          S.of(context).registeredDate,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TableCell(
                        child: Text(response.createdAt.format(context)),
                      ), //FIXME
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Text(
                          S.of(context).birthday,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      TableCell(
                        child: Text(response.birthday?.format(context) ?? ""),
                      ),
                    ],
                  ),
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
                      TableRow(
                        children: [
                          TableCell(
                            child: MfmText(
                              mfmText: field.name,
                              emoji: response.emojis,
                            ),
                          ),
                          TableCell(
                            child: MfmText(
                              mfmText: field.value,
                              emoji: response.emojis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        response.notesCount.format(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        S.of(context).note,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  if (response.isFollowingVisibleForMe)
                    InkWell(
                      onTap: () async => context.pushRoute(
                        UserFolloweeRoute(
                          userId: response.id,
                          account: AccountScope.of(context),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            response.followingCount.format(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            S.of(context).follow,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  if (response.isFollowersVisibleForMe)
                    InkWell(
                      onTap: () async => context.pushRoute(
                        UserFollowerRoute(
                          userId: response.id,
                          account: AccountScope.of(context),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            response.followersCount.format(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            S.of(context).follower,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: BirthdayConfetti(
            response: response,
            child: Column(
              children: [
                if (response.bannerUrl != null)
                  Image.network(response.bannerUrl.toString()),
                Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: buildContent(context, ref),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
              ],
            ),
          ),
        ),
        if (response.pinnedNotes != null)
          SliverPadding(
            padding: const EdgeInsets.only(right: 10),
            sliver: SliverList.builder(
              itemCount: response.pinnedNotes!.length,
              itemBuilder: (context, index) => MisskeyNote(
                note: response.pinnedNotes![index],
                loginAs: controlAccount,
              ),
            ),
          ),
      ],
    );
  }
}

class BirthdayConfetti extends StatefulWidget {
  final UserDetailed response;
  final Widget child;

  const BirthdayConfetti({
    required this.response,
    required this.child,
    super.key,
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
        child: widget.child,
      );
    }

    return widget.child;
  }
}

class RoleChip extends ConsumerWidget {
  const RoleChip({required this.role, super.key});

  final UserRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = AccountScope.of(context);
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final height = MediaQuery.textScalerOf(context)
        .scale((textStyle?.fontSize ?? 14) * (textStyle?.height ?? 1));
    return Tooltip(
      message: role.description,
      child: GestureDetector(
        onTap: () async {
          final response = await ref
              .read(misskeyProvider(account))
              .roles
              .show(RolesShowRequest(roleId: role.id));
          if (response.isPublic && response.isExplorable) {
            if (!context.mounted) return;
            await context.pushRoute(
              ExploreRoleUsersRoute(item: response, account: account),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: role.color?.toColor() ?? Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.circular(height),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (role.iconUrl != null)
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: NetworkImageView(
                    url: role.iconUrl!.toString(),
                    type: ImageType.role,
                    height: height,
                  ),
                ),
              Text(role.name),
            ],
          ),
        ),
      ),
    );
  }
}
