import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:miria/view/common/constants.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/local_only_icon.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/misskey_file_view.dart';
import 'package:miria/view/common/misskey_notes/note_modal_sheet.dart';
import 'package:miria/view/common/misskey_notes/note_vote.dart';
import 'package:miria/view/common/misskey_notes/reaction_button.dart';
import 'package:miria/view/common/misskey_notes/renote_modal_sheet.dart';
import 'package:miria/view/common/misskey_notes/renote_user_dialog.dart';
import 'package:miria/view/reaction_picker_dialog/reaction_picker_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:misskey_dart/misskey_dart.dart';

Future<void> _navigateDetailPage(
    BuildContext context, Note note, Account? loginAs) async {
  final pushRoute = context.pushRoute;
  if (loginAs == null) {
    pushRoute(NoteDetailRoute(note: note, account: AccountScope.of(context)));
    return;
  }
  final ref = ProviderScope.containerOf(context);
  final host = note.user.host ?? AccountScope.of(context).host;

  try {
    // まず、自分のサーバーの直近のノートに該当のノートが含まれているか見る
    final myHostUserData = await ref
        .read(misskeyProvider(loginAs))
        .users
        .showByName(UsersShowByUserNameRequest(
            userName: note.user.username, host: host));

    final myHostUserNotes =
        await ref.read(misskeyProvider(loginAs)).users.notes(UsersNotesRequest(
              userId: myHostUserData.id,
              untilDate: note.createdAt.millisecondsSinceEpoch + 1,
            ));

    final foundMyHostNote = myHostUserNotes
        .firstWhereOrNull((e) => e.uri?.pathSegments.lastOrNull == note.id);
    if (foundMyHostNote != null) {
      pushRoute(NoteDetailRoute(note: foundMyHostNote, account: loginAs));
      return;
    }
    throw Exception();
  } catch (e) {
    // 最終手段として、連合で照会する
    final result = await ref.read(misskeyProvider(loginAs)).ap.show(
        ApShowRequest(
            uri: note.uri ??
                Uri(
                    scheme: "https",
                    host: host,
                    pathSegments: ["notes", note.id])));
    // よくかんがえたら無駄
    final resultNote = await ref
        .read(misskeyProvider(loginAs))
        .notes
        .show(NotesShowRequest(noteId: result.object["id"]));
    pushRoute(NoteDetailRoute(note: resultNote, account: loginAs));
  }
}

Future<void> _navigateUserDetailPage(
    BuildContext context, Note note, Account? loginAs) async {
  final pushRoute = context.pushRoute;
  if (loginAs == null) {
    pushRoute(
        UserRoute(userId: note.user.id, account: AccountScope.of(context)));
    return;
  }

  final ref = ProviderScope.containerOf(context);
  final host = note.user.host ?? AccountScope.of(context).host;

  try {
    // まず、自分のサーバーの直近のノートに該当のノートが含まれているか見る
    final myHostUserData = await ref
        .read(misskeyProvider(loginAs))
        .users
        .showByName(UsersShowByUserNameRequest(
            userName: note.user.username, host: host));
    pushRoute(UserRoute(userId: myHostUserData.id, account: loginAs));
  } catch (e) {
    // 最終手段として、連合で照会する
    final result = await ref.read(misskeyProvider(loginAs)).ap.show(
        ApShowRequest(
            uri: note.uri ??
                Uri(
                    scheme: "https",
                    host: host,
                    pathSegments: ["@${note.id}"])));
    // よくかんがえたら無駄
    pushRoute(UserRoute(userId: result.object["id"], account: loginAs));
  }
}

class MisskeyNote extends ConsumerStatefulWidget {
  final Note note;
  final bool isDisplayBorder;
  final int recursive;
  final Account? loginAs;
  final bool isForceUnvisibleReply;
  final bool isForceUnvisibleRenote;

  const MisskeyNote({
    super.key,
    required this.note,
    this.isDisplayBorder = true,
    this.recursive = 1,
    this.loginAs,
    this.isForceUnvisibleReply = false,
    this.isForceUnvisibleRenote = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MisskeyNoteState();
}

class MisskeyNoteState extends ConsumerState<MisskeyNote> {
  var isCwOpened = false;
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final latestActualNote = ref.watch(notesProvider(AccountScope.of(context))
        .select((value) => value.notes[widget.note.id]));
    final renoteId = widget.note.renote?.id;
    final Note? renoteNote;

    bool isEmptyRenote = renoteId != null &&
        latestActualNote?.text == null &&
        latestActualNote?.cw == null &&
        (latestActualNote?.files.isEmpty ?? true) &&
        latestActualNote?.poll == null;

    if (isEmptyRenote) {
      renoteNote = ref.watch(notesProvider(AccountScope.of(context))
          .select((value) => value.notes[renoteId]));
    } else {
      renoteNote = null;
    }
    final displayNote = renoteNote ?? latestActualNote;

    if (displayNote == null || latestActualNote == null) {
      // 削除された？
      return Container();
    }

    if (widget.recursive == 3) {
      return Container();
    }

    final userId =
        "@${displayNote.user.username}${displayNote.user.host == null ? "" : "@${displayNote.user.host}"}";

    return MediaQuery(
      data: MediaQueryData(
          textScaleFactor: MediaQuery.of(context).textScaleFactor *
              (widget.recursive > 1 ? 0.7 : 1)),
      child: RepaintBoundary(
        key: globalKey,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: EdgeInsets.only(
              top: 5 * MediaQuery.of(context).textScaleFactor,
              bottom: 5 * MediaQuery.of(context).textScaleFactor,
              left: displayNote.channel?.color != null ? 4.0 : 0.0,
            ),
            decoration: widget.isDisplayBorder
                ? BoxDecoration(
                    color: widget.recursive == 1 &&
                            ref.read(noteModalSheetSharingModeProviding)
                        ? Theme.of(context).scaffoldBackgroundColor
                        : null,
                    border: Border(
                        left: displayNote.channel?.color != null
                            ? BorderSide(
                                color: Color(
                                    0xFF000000 | displayNote.channel!.color!),
                                width: 4)
                            : BorderSide.none,
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor, width: 0.5)))
                : BoxDecoration(
                    color: widget.recursive == 1
                        ? Theme.of(context).scaffoldBackgroundColor
                        : null),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isEmptyRenote)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: SimpleMfmText(
                      "${widget.note.user.name ?? widget.note.user.username} が ${widget.note.user.username == widget.note.renote?.user.username ? "セルフRenote" : "Renote"}",
                      style: Theme.of(context).textTheme.bodySmall,
                      emojis: widget.note.user.emojis,
                    ),
                  ),
                if (displayNote.reply != null && !widget.isForceUnvisibleReply)
                  MisskeyNote(
                    note: displayNote.reply!,
                    isDisplayBorder: false,
                    recursive: widget.recursive + 1,
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AvatarIcon(
                      user: displayNote.user,
                      onTap: () async => await _navigateUserDetailPage(
                              context, displayNote, widget.loginAs)
                          .expectFailure(context),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NoteHeader1(
                            displayNote: displayNote,
                            loginAs: widget.loginAs,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  userId,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              if (displayNote.user.instance != null)
                                GestureDetector(
                                  onTap: () => context.pushRoute(
                                      FederationRoute(
                                          account: widget.loginAs ??
                                              AccountScope.of(context),
                                          host: displayNote.user.host!)),
                                  child: InkResponse(
                                    child: Text(
                                        displayNote.user.instance?.name ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                  ),
                                ),
                            ],
                          ),
                          if (displayNote.cw != null) ...[
                            MfmText(
                              displayNote.cw ?? "",
                              host: displayNote.user.host,
                              emoji: displayNote.emojis,
                              suffixSpan: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      padding: const EdgeInsets.all(5),
                                      textStyle: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.fontSize),
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isCwOpened = !isCwOpened;
                                      });
                                    },
                                    child: Text(
                                      isCwOpened ? "隠す" : "続きを見る",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (displayNote.cw == null ||
                              displayNote.cw != null && isCwOpened) ...[
                            MfmText(
                              displayNote.text ?? "",
                              host: displayNote.user.host,
                              emoji: displayNote.emojis,
                              onEmojiTap: (emojiData) async =>
                                  await reactionControl(
                                      ref, context, displayNote,
                                      requestEmoji: emojiData),
                              suffixSpan: [
                                if (!isEmptyRenote &&
                                    displayNote.renoteId != null &&
                                    (widget.recursive == 2 ||
                                        widget.isForceUnvisibleRenote))
                                  TextSpan(
                                    text: "  RN:...",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),
                            MisskeyFileView(
                              files: displayNote.files,
                              height: 200 *
                                  pow(0.5, widget.recursive - 1).toDouble(),
                            ),
                            if (displayNote.poll != null)
                              NoteVote(
                                displayNote: displayNote,
                                poll: displayNote.poll!,
                                loginAs: widget.loginAs,
                              ),
                            if (displayNote.renoteId != null &&
                                (widget.recursive < 2 &&
                                    !widget.isForceUnvisibleRenote))
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: DottedBorder(
                                  color: AppTheme.of(context).renoteBorderColor,
                                  radius:
                                      AppTheme.of(context).renoteBorderRadius,
                                  strokeWidth:
                                      AppTheme.of(context).renoteStrokeWidth,
                                  dashPattern:
                                      AppTheme.of(context).renoteDashPattern,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: MisskeyNote(
                                      note: displayNote.renote!,
                                      isDisplayBorder: false,
                                      recursive: widget.recursive + 1,
                                      loginAs: widget.loginAs,
                                    ),
                                  ),
                                ),
                              )
                          ],
                          if (displayNote.reactions.isNotEmpty)
                            const Padding(padding: EdgeInsets.only(bottom: 5)),
                          Wrap(
                            spacing: 5 * MediaQuery.of(context).textScaleFactor,
                            runSpacing:
                                5 * MediaQuery.of(context).textScaleFactor,
                            children: [
                              for (final reaction in displayNote
                                  .reactions.entries
                                  .mapIndexed((index, element) =>
                                      (index: index, element: element))
                                  .sorted((a, b) {
                                final primary =
                                    b.element.value.compareTo(a.element.value);
                                if (primary != 0) return primary;
                                return a.index.compareTo(b.index);
                              }))
                                ReactionButton(
                                  emojiData: MisskeyEmojiData.fromEmojiName(
                                      emojiName: reaction.element.key,
                                      repository: ref.read(
                                          emojiRepositoryProvider(
                                              AccountScope.of(context))),
                                      emojiInfo: displayNote.reactionEmojis),
                                  reactionCount: reaction.element.value,
                                  myReaction: displayNote.myReaction,
                                  noteId: displayNote.id,
                                  loginAs: widget.loginAs,
                                )
                            ],
                          ),
                          if (displayNote.channel != null)
                            NoteChannelView(channel: displayNote.channel!),
                          Row(
                            mainAxisAlignment: widget.loginAs != null
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (widget.loginAs != null) ...[
                                IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                    style: const ButtonStyle(
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.zero),
                                      minimumSize:
                                          MaterialStatePropertyAll(Size(0, 0)),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () async =>
                                        await _navigateDetailPage(context,
                                                displayNote, widget.loginAs)
                                            .expectFailure(context),
                                    icon: Icon(
                                      Icons.u_turn_left,
                                      size: 16 *
                                          MediaQuery.of(context)
                                              .textScaleFactor,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ))
                              ] else ...[
                                TextButton.icon(
                                    onPressed: () {
                                      context.pushRoute(NoteCreateRoute(
                                          reply: displayNote,
                                          initialAccount:
                                              AccountScope.of(context)));
                                    },
                                    style: const ButtonStyle(
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.zero),
                                      minimumSize:
                                          MaterialStatePropertyAll(Size(0, 0)),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    label: Text(displayNote.repliesCount == 0
                                        ? ""
                                        : displayNote.repliesCount.format()),
                                    icon: Icon(
                                      Icons.reply,
                                      size: 16 *
                                          MediaQuery.of(context)
                                              .textScaleFactor,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    )),
                                RenoteButton(
                                  displayNote: displayNote,
                                ),
                                FooterReactionButton(
                                  onPressed: () async => await reactionControl(
                                      ref, context, displayNote),
                                  displayNote: displayNote,
                                ),
                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (builder) {
                                            return NoteModalSheet(
                                              baseNote: widget.note,
                                              targetNote: displayNote,
                                              account: AccountScope.of(context),
                                              noteBoundaryKey: globalKey,
                                            );
                                          });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    style: const ButtonStyle(
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.zero),
                                      minimumSize:
                                          MaterialStatePropertyAll(Size(0, 0)),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    icon: Icon(
                                      Icons.more_horiz,
                                      size: 16 *
                                          MediaQuery.of(context)
                                              .textScaleFactor,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    )),
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> reactionControl(
    WidgetRef ref,
    BuildContext context,
    Note displayNote, {
    MisskeyEmojiData? requestEmoji,
  }) async {
    // 他のサーバーからログインしている場合は不可
    if (widget.loginAs != null) return;

    final account = AccountScope.of(context);
    final isLikeOnly =
        (displayNote.reactionAcceptance == ReactionAcceptance.likeOnly ||
            (displayNote.reactionAcceptance ==
                    ReactionAcceptance.likeOnlyForRemote &&
                displayNote.user.host != null));
    if (displayNote.myReaction != null && requestEmoji != null) {
      // すでにリアクション済み
      return;
    }
    if (requestEmoji != null &&
        !ref
            .read(generalSettingsRepositoryProvider)
            .settings
            .enableDirectReaction) {
      // カスタム絵文字押下でのリアクション無効
      return;
    }
    if (requestEmoji != null && isLikeOnly) {
      // いいねのみでカスタム絵文字押下
      return;
    }
    if (displayNote.myReaction != null && requestEmoji == null) {
      await ref
          .read(misskeyProvider(account))
          .notes
          .reactions
          .delete(NotesReactionsDeleteRequest(noteId: displayNote.id));
      await ref.read(notesProvider(account)).refresh(displayNote.id);
      return;
    }
    final misskey = ref.read(misskeyProvider(account));
    final note = ref.read(notesProvider(account));
    final MisskeyEmojiData? selectedEmoji;
    if (isLikeOnly) {
      selectedEmoji = const UnicodeEmojiData(char: '❤️');
    } else if (requestEmoji == null) {
      selectedEmoji = await showDialog<MisskeyEmojiData?>(
          context: context,
          builder: (context) => ReactionPickerDialog(
                account: account,
                isAcceptSensitive: displayNote.reactionAcceptance !=
                        ReactionAcceptance.nonSensitiveOnly &&
                    displayNote.reactionAcceptance !=
                        ReactionAcceptance
                            .nonSensitiveOnlyForLocalLikeOnlyForRemote,
              ));
    } else {
      selectedEmoji = requestEmoji;
    }

    if (selectedEmoji == null) return;
    await misskey.notes.reactions.create(NotesReactionsCreateRequest(
        noteId: displayNote.id, reaction: ":${selectedEmoji.baseName}:"));
    await note.refresh(displayNote.id);
  }
}

class NoteHeader1 extends StatelessWidget {
  final Note displayNote;
  final Account? loginAs;

  const NoteHeader1({
    super.key,
    required this.displayNote,
    required this.loginAs,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: UserInformation(user: displayNote.user))),
        GestureDetector(
          onTap: () async =>
              await _navigateDetailPage(context, displayNote, loginAs)
                  .expectFailure(context),
          child: Text(
            displayNote.createdAt.differenceNow,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        if (displayNote.visibility == NoteVisibility.followers)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              Icons.lock,
              size: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        if (displayNote.visibility == NoteVisibility.home)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              Icons.home,
              size: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        if (displayNote.visibility == NoteVisibility.specified)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              Icons.mail,
              size: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        if (displayNote.localOnly)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: LocalOnlyIcon(
              size: Theme.of(context).textTheme.bodySmall?.fontSize,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          )
      ],
    );
  }
}

class NoteChannelView extends StatelessWidget {
  final NoteChannelInfo channel;

  const NoteChannelView({super.key, required this.channel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(ChannelDetailRoute(
          account: AccountScope.of(context),
          channelId: channel.id,
        ));
      },
      child: Row(
        children: [
          Icon(
            Icons.tv,
            size: Theme.of(context).textTheme.bodySmall?.fontSize,
            color: channel.color != null
                ? Color(0xFF000000 | channel.color!)
                : Theme.of(context).textTheme.bodySmall?.color,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5),
          ),
          Text(
            channel.name,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class RenoteButton extends StatelessWidget {
  final Note displayNote;
  const RenoteButton({
    super.key,
    required this.displayNote,
  });

  @override
  Widget build(BuildContext context) {
    final account = AccountScope.of(context);

    // 他人のノートで、ダイレクトまたはフォロワーのみへの公開の場合、リノート不可
    if ((displayNote.visibility == NoteVisibility.specified ||
            displayNote.visibility == NoteVisibility.followers) &&
        !(account.host == displayNote.user.host &&
            account.userId == displayNote.user.username)) {
      return Icon(
        Icons.block,
        size: 16 * MediaQuery.of(context).textScaleFactor,
        color: Theme.of(context).textTheme.bodySmall?.color,
      );
    }

    return TextButton.icon(
      onPressed: () => showModalBottomSheet(
          context: context,
          builder: (innerContext) => RenoteModalSheet(
              note: displayNote, account: AccountScope.of(context))),
      onLongPress: () => showDialog(
          context: context,
          builder: (context) =>
              RenoteUserDialog(account: account, noteId: displayNote.id)),
      icon: Icon(
        Icons.repeat_rounded,
        size: 16 * MediaQuery.of(context).textScaleFactor,
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
      label: Text(
          "${displayNote.renoteCount != 0 ? displayNote.renoteCount : ""}",
          style: Theme.of(context).textTheme.bodySmall),
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll(EdgeInsets.zero),
        minimumSize: MaterialStatePropertyAll(Size(0, 0)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class FooterReactionButton extends StatelessWidget {
  final Note displayNote;
  final VoidCallback onPressed;

  const FooterReactionButton({
    super.key,
    required this.displayNote,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    if (displayNote.myReaction == null) {
      if (displayNote.reactionAcceptance == ReactionAcceptance.likeOnly ||
          (displayNote.user.host != null &&
              displayNote.reactionAcceptance ==
                  ReactionAcceptance.likeOnlyForRemote)) {
        icon = Icons.favorite_border;
      } else {
        icon = Icons.add;
      }
    } else {
      icon = Icons.remove;
    }
    return IconButton(
        onPressed: onPressed,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
        style: const ButtonStyle(
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
          minimumSize: MaterialStatePropertyAll(Size(0, 0)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        icon: Icon(
          icon,
          size: 16 * MediaQuery.of(context).textScaleFactor,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ));
  }
}
