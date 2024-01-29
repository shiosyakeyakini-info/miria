import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mfm_parser/mfm_parser.dart' as parser;
import 'package:miria/const.dart';
import 'package:miria/extensions/date_time_extension.dart';
import 'package:miria/extensions/list_mfm_node_extension.dart';
import 'package:miria/extensions/note_extension.dart';
import 'package:miria/extensions/note_visibility_extension.dart';
import 'package:miria/extensions/user_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:miria/view/common/constants.dart';
import 'package:miria/view/common/error_dialog_handler.dart';
import 'package:miria/view/common/misskey_notes/in_note_button.dart';
import 'package:miria/view/common/misskey_notes/link_preview.dart';
import 'package:miria/view/common/misskey_notes/local_only_icon.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:miria/view/common/misskey_notes/misskey_file_view.dart';
import 'package:miria/view/common/misskey_notes/note_modal_sheet.dart';
import 'package:miria/view/common/misskey_notes/note_vote.dart';
import 'package:miria/view/common/misskey_notes/reaction_button.dart';
import 'package:miria/view/common/misskey_notes/renote_modal_sheet.dart';
import 'package:miria/view/common/misskey_notes/renote_user_dialog.dart';
import 'package:miria/view/dialogs/simple_confirm_dialog.dart';
import 'package:miria/view/reaction_picker_dialog/reaction_picker_dialog.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MisskeyNote extends ConsumerStatefulWidget {
  final Note note;
  final bool isDisplayBorder;
  final int recursive;
  final Account? loginAs;
  final bool isForceUnvisibleReply;
  final bool isForceUnvisibleRenote;
  final bool isVisibleAllReactions;
  final bool isForceVisibleLong;

  const MisskeyNote({
    super.key,
    required this.note,
    this.isDisplayBorder = true,
    this.recursive = 1,
    this.loginAs,
    this.isForceUnvisibleReply = false,
    this.isForceUnvisibleRenote = false,
    this.isVisibleAllReactions = false,
    this.isForceVisibleLong = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MisskeyNoteState();
}

class MisskeyNoteState extends ConsumerState<MisskeyNote> {
  final globalKey = GlobalKey();
  late var isAllReactionVisible = widget.isVisibleAllReactions;
  bool isLongVisibleInitialized = false;

  List<parser.MfmNode>? displayTextNodes;
  DateTime? latestUpdatedAt;

  bool shouldCollaposed(List<parser.MfmNode> node) {
    final result = nodeMaxTextLength(node);
    return result.$1 >= 500 || result.$2 >= 6;
  }

  (int length, int newLinesCount) nodeMaxTextLength(
      List<parser.MfmNode> nodes) {
    var thisNodeCount = 0;
    var newLinesCount = 0;
    for (final node in nodes) {
      if (node is parser.MfmText) {
        thisNodeCount += node.text.length;
        // 2行連続した改行の個数を数える
        newLinesCount += node.text.split("\n\n").length - 1;
      } else if (node is parser.MfmEmojiCode ||
          node is parser.MfmUnicodeEmoji) {
        thisNodeCount += 1;
      } else if (node is parser.MfmFn) {
        final fnResult = nodeMaxTextLength(node.children ?? []);
        thisNodeCount += fnResult.$1;
        newLinesCount += fnResult.$2;
      } else if (node is parser.MfmBlock) {
        final blockResult = nodeMaxTextLength(node.children ?? []);
        thisNodeCount += blockResult.$1;
        newLinesCount += blockResult.$2;
      } else if (node is parser.MfmURL) {
        thisNodeCount += node.value.length;
      } else if (node is parser.MfmCodeBlock) {
        thisNodeCount += node.code.length;
      }
    }
    return (thisNodeCount, newLinesCount);
  }

  @override
  Widget build(BuildContext context) {
    final account = AccountScope.of(context);

    final latestActualNote = ref.watch(
        notesProvider(account).select((value) => value.notes[widget.note.id]));
    final renoteId = widget.note.renote?.id;
    final Note? renoteNote;

    bool isEmptyRenote = latestActualNote?.isEmptyRenote == true;

    if (isEmptyRenote) {
      renoteNote = ref.watch(
          notesProvider(account).select((value) => value.notes[renoteId]));
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

    if (latestUpdatedAt != displayNote.updatedAt) {
      latestUpdatedAt = displayNote.updatedAt;
      displayTextNodes = null;
    }

    displayTextNodes ??= const parser.MfmParser().parse(displayNote.text ?? "");

    final noteStatus = ref.watch(notesProvider(account)
        .select((value) => value.noteStatuses[widget.note.id]))!;

    if (noteStatus.isIncludeMuteWord && !noteStatus.isMuteOpened) {
      return SizedBox(
        width: double.infinity,
        child: GestureDetector(
            onTap: () => ref.read(notesProvider(account)).updateNoteStatus(
                  widget.note.id,
                  (status) => status.copyWith(isMuteOpened: true),
                ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0),
              child: Text(
                S.of(context).mutedNotePlaceholder(
                    displayNote.user.name ?? displayNote.user.username),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )),
      );
    }

    if (!noteStatus.isLongVisibleInitialized ||
        widget.isForceUnvisibleRenote ||
        widget.isForceUnvisibleReply ||
        widget.isForceVisibleLong) {
      final isReactionedRenote = ref
              .read(generalSettingsRepositoryProvider)
              .settings
              .enableFavoritedRenoteElipsed &&
          !widget.isForceVisibleLong &&
          !(displayNote.cw?.isNotEmpty == true) &&
          (renoteId != null && displayNote.myReaction != null);

      final isLongVisible = !(ref
              .read(generalSettingsRepositoryProvider)
              .settings
              .enableLongTextElipsed &&
          !isReactionedRenote &&
          !widget.isForceVisibleLong &&
          !(displayNote.cw?.isNotEmpty == true) &&
          shouldCollaposed(displayTextNodes!));

      ref.read(notesProvider(account)).updateNoteStatus(
            widget.note.id,
            (status) => status.copyWith(
              isLongVisible: isLongVisible,
              isReactionedRenote: isReactionedRenote,
              isLongVisibleInitialized: true,
            ),
            isNotify: false,
          );
    }

    final userId =
        "@${displayNote.user.username}${displayNote.user.host == null ? "" : "@${displayNote.user.host}"}";

    final isCwOpened = ref.watch(notesProvider(account)
        .select((value) => value.noteStatuses[widget.note.id]!.isCwOpened));
    final isReactionedRenote = ref.watch(notesProvider(account).select(
        (value) => value.noteStatuses[widget.note.id]!.isReactionedRenote));
    final isLongVisible = ref.watch(notesProvider(account)
        .select((value) => value.noteStatuses[widget.note.id]!.isLongVisible));

    final links = displayTextNodes!.extractLinks();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: widget.recursive > 1
            ? TextScaler.linear(MediaQuery.textScalerOf(context).scale(0.7))
            : null,
      ),
      child: RepaintBoundary(
        key: globalKey,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            margin: EdgeInsets.only(
                left: displayNote.channel?.color != null ? 5.0 : 0.0),
            padding: EdgeInsets.only(
              top: MediaQuery.textScalerOf(context).scale(5),
              bottom: MediaQuery.textScalerOf(context).scale(5),
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
                        color: Theme.of(context).dividerColor,
                        width: 0.5,
                      ),
                    ),
                  )
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
                    child: RenoteHeader(
                      note: widget.note,
                      loginAs: widget.loginAs,
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
                      onTap: () => ref
                          .read(misskeyNoteNotifierProvider(account).notifier)
                          .navigateToUserPage(
                            context,
                            displayNote.user,
                            widget.loginAs,
                          )
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
                                          account: widget.loginAs ?? account,
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
                              mfmText: displayNote.cw ?? "",
                              host: displayNote.user.host,
                              emoji: displayNote.emojis,
                              isEnableAnimatedMFM: ref
                                  .read(generalSettingsRepositoryProvider)
                                  .settings
                                  .enableAnimatedMFM,
                            ),
                            InNoteButton(
                              onPressed: () {
                                ref
                                    .read(notesProvider(account))
                                    .updateNoteStatus(
                                        widget.note.id,
                                        (status) => status.copyWith(
                                            isCwOpened: !status.isCwOpened));
                              },
                              child: Text(
                                isCwOpened
                                    ? S.of(context).hide
                                    : S.of(context).showCw,
                              ),
                            ),
                          ],
                          if (displayNote.cw == null ||
                              displayNote.cw != null && isCwOpened) ...[
                            if (isReactionedRenote)
                              SimpleMfmText(
                                "${(displayNote.text ?? "").substring(0, min((displayNote.text ?? "").length, 50))}..."
                                    .replaceAll("\n\n", "\n"),
                                isNyaize: displayNote.user.isCat,
                                emojis: displayNote.emojis,
                                suffixSpan: [
                                  WidgetSpan(
                                    child: InNoteButton(
                                      onPressed: () {
                                        ref
                                            .read(notesProvider(account))
                                            .updateNoteStatus(
                                              widget.note.id,
                                              (status) => status.copyWith(
                                                  isReactionedRenote: !status
                                                      .isReactionedRenote),
                                            );
                                      },
                                      child: Text(
                                          S.of(context).showReactionedNote),
                                    ),
                                  )
                                ],
                              )
                            else ...[
                              if (isLongVisible)
                                MfmText(
                                  mfmNode: displayTextNodes,
                                  host: displayNote.user.host,
                                  emoji: displayNote.emojis,
                                  isNyaize: displayNote.user.isCat,
                                  isEnableAnimatedMFM: ref
                                      .read(generalSettingsRepositoryProvider)
                                      .settings
                                      .enableAnimatedMFM,
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
                                )
                              else
                                SimpleMfmText(
                                  "${(displayNote.text ?? "").substring(0, min((displayNote.text ?? "").length, 150))}..."
                                      .replaceAll("\n\n", "\n"),
                                  emojis: displayNote.emojis,
                                  isNyaize: displayNote.user.isCat,
                                  suffixSpan: [
                                    WidgetSpan(
                                      child: InNoteButton(
                                        onPressed: () {
                                          ref
                                              .read(notesProvider(account))
                                              .updateNoteStatus(
                                                  widget.note.id,
                                                  (status) => status.copyWith(
                                                      isLongVisible: !status
                                                          .isLongVisible));
                                        },
                                        child: Text(S.of(context).showLongText),
                                      ),
                                    )
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
                              if (isLongVisible && widget.recursive < 2)
                                ...links.map(
                                  (link) => LinkPreview(
                                      account: account,
                                      link: link,
                                      host: displayNote.user.host),
                                ),
                              if (displayNote.renoteId != null &&
                                  (widget.recursive < 2 &&
                                      !widget.isForceUnvisibleRenote))
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  child: DottedBorder(
                                    color:
                                        AppTheme.of(context).renoteBorderColor,
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
                            ]
                          ],
                          if (displayNote.reactions.isNotEmpty &&
                              !isReactionedRenote)
                            const Padding(padding: EdgeInsets.only(bottom: 5)),
                          if (!isReactionedRenote)
                            Wrap(
                              spacing:
                                  MediaQuery.textScalerOf(context).scale(5),
                              runSpacing:
                                  MediaQuery.textScalerOf(context).scale(5),
                              children: [
                                for (final reaction in displayNote
                                    .reactions.entries
                                    .mapIndexed((index, element) =>
                                        (index: index, element: element))
                                    .sorted((a, b) {
                                  final primary = b.element.value
                                      .compareTo(a.element.value);
                                  if (primary != 0) return primary;
                                  return a.index.compareTo(b.index);
                                }).take(isAllReactionVisible
                                        ? displayNote.reactions.length
                                        : 16))
                                  ReactionButton(
                                    emojiData: MisskeyEmojiData.fromEmojiName(
                                        emojiName: reaction.element.key,
                                        repository: ref.read(
                                            emojiRepositoryProvider(account)),
                                        emojiInfo: displayNote.reactionEmojis),
                                    reactionCount: reaction.element.value,
                                    myReaction: displayNote.myReaction,
                                    noteId: displayNote.id,
                                    loginAs: widget.loginAs,
                                  ),
                                if (!isAllReactionVisible &&
                                    displayNote.reactions.length > 16)
                                  OutlinedButton(
                                      style: AppTheme.of(context)
                                          .reactionButtonStyle,
                                      onPressed: () => setState(() {
                                            isAllReactionVisible = true;
                                          }),
                                      child: Text(S.of(context).otherReactions(
                                          displayNote.reactions.length - 16))),
                              ],
                            ),
                          if (displayNote.channel != null)
                            NoteChannelView(channel: displayNote.channel!),
                          if (!isReactionedRenote)
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
                                        minimumSize: MaterialStatePropertyAll(
                                            Size(0, 0)),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () => ref
                                          .read(
                                            misskeyNoteNotifierProvider(account)
                                                .notifier,
                                          )
                                          .navigateToNoteDetailPage(
                                            context,
                                            displayNote,
                                            widget.loginAs,
                                          )
                                          .expectFailure(context),
                                      icon: Icon(
                                        Icons.u_turn_left,
                                        size: MediaQuery.textScalerOf(context)
                                            .scale(16),
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
                                          initialAccount: account));
                                    },
                                    style: const ButtonStyle(
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.zero),
                                      minimumSize:
                                          MaterialStatePropertyAll(Size(0, 0)),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    label: Text(
                                      displayNote.repliesCount == 0
                                          ? ""
                                          : displayNote.repliesCount.format(),
                                    ),
                                    icon: Icon(
                                      Icons.reply,
                                      size: MediaQuery.textScalerOf(context)
                                          .scale(16),
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                                  ),
                                  RenoteButton(
                                    displayNote: displayNote,
                                  ),
                                  FooterReactionButton(
                                    onPressed: () async =>
                                        await reactionControl(
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
                                              account: account,
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
                                      size: MediaQuery.textScalerOf(context)
                                          .scale(16),
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color,
                                    ),
                                  ),
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
      if (await SimpleConfirmDialog.show(
              context: context,
              message: S.of(context).confirmDeleteReaction,
              primary: S.of(context).cancelReaction,
              secondary: S.of(context).cancel) !=
          true) {
        return;
      }

      await ref
          .read(misskeyProvider(account))
          .notes
          .reactions
          .delete(NotesReactionsDeleteRequest(noteId: displayNote.id));
      if (account.host == "misskey.io") {
        await Future.delayed(
            const Duration(milliseconds: misskeyIOReactionDelay));
      }
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
    if (account.host == "misskey.io") {
      await Future.delayed(
          const Duration(milliseconds: misskeyIOReactionDelay));
    }
    await note.refresh(displayNote.id);
  }
}

class NoteHeader1 extends ConsumerWidget {
  final Note displayNote;
  final Account? loginAs;

  const NoteHeader1({
    super.key,
    required this.displayNote,
    required this.loginAs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = AccountScope.of(context);

    return Row(
      children: [
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: UserInformation(user: displayNote.user))),
        if (displayNote.updatedAt != null)
          Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Icon(Icons.edit,
                  size: Theme.of(context).textTheme.bodySmall?.fontSize,
                  color: Theme.of(context).textTheme.bodySmall?.color)),
        GestureDetector(
          onTap: () => ref
              .read(misskeyNoteNotifierProvider(account).notifier)
              .navigateToNoteDetailPage(context, displayNote, loginAs)
              .expectFailure(context),
          child: Text(
            displayNote.createdAt.differenceNow(context),
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        if (displayNote.visibility != NoteVisibility.public)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              displayNote.visibility.icon,
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

class RenoteHeader extends ConsumerWidget {
  final Note note;
  final Account? loginAs;

  const RenoteHeader({
    super.key,
    required this.note,
    this.loginAs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renoteTextStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppTheme.of(context).renoteBorderColor,
        );
    final account = AccountScope.of(context);

    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 10)),
        Expanded(
          child: GestureDetector(
            onTap: () => ref
                .read(misskeyNoteNotifierProvider(account).notifier)
                .navigateToUserPage(context, note.user, loginAs)
                .expectFailure(context),
            child: SimpleMfmText(
              note.user.name ?? note.user.username,
              style: renoteTextStyle?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              emojis: note.user.emojis,
              suffixSpan: [
                TextSpan(
                  text: note.user.acct == note.renote?.user.acct
                      ? S.of(context).selfRenotedBy
                      : S.of(context).renotedBy,
                  style: renoteTextStyle,
                )
              ],
            ),
          ),
        ),
        if (note.updatedAt != null)
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Icon(
              Icons.edit,
              size: renoteTextStyle?.fontSize,
              color: renoteTextStyle?.color,
            ),
          ),
        Text(
          note.createdAt.differenceNow(context),
          textAlign: TextAlign.right,
          style: renoteTextStyle,
        ),
        if (note.visibility != NoteVisibility.public)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              note.visibility.icon,
              size: renoteTextStyle?.fontSize,
              color: renoteTextStyle?.color,
            ),
          ),
        if (note.localOnly)
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: LocalOnlyIcon(
              size: renoteTextStyle?.fontSize,
              color: renoteTextStyle?.color,
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
    final account = AccountScope.of(context);

    return GestureDetector(
      onTap: () {
        context.pushRoute(ChannelDetailRoute(
          account: account,
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
        !(displayNote.user.host == null &&
            account.userId == displayNote.user.username)) {
      return Icon(
        Icons.block,
        size: MediaQuery.textScalerOf(context).scale(16),
        color: Theme.of(context).textTheme.bodySmall?.color,
      );
    }

    return TextButton.icon(
      onPressed: () => showModalBottomSheet(
          context: context,
          builder: (innerContext) =>
              RenoteModalSheet(note: displayNote, account: account)),
      onLongPress: () => showDialog(
          context: context,
          builder: (context) =>
              RenoteUserDialog(account: account, noteId: displayNote.id)),
      icon: Icon(
        Icons.repeat_rounded,
        size: MediaQuery.textScalerOf(context).scale(16),
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
          size: MediaQuery.textScalerOf(context).scale(16),
          color: Theme.of(context).textTheme.bodySmall?.color,
        ));
  }
}
