import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:miria/view/common/avatar_icon.dart';
import 'package:miria/view/common/misskey_notes/local_only_icon.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';
import 'package:miria/view/note_create_page/note_create_page.dart';
import 'package:miria/view/note_create_page/note_visibility_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/view/note_create_page/reaction_acceptance_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';

class NoteCreateSettingTop extends ConsumerWidget {
  const NoteCreateSettingTop({super.key});

  IconData resolveVisibilityIcon(NoteVisibility visibility) {
    switch (visibility) {
      case NoteVisibility.public:
        return Icons.public;
      case NoteVisibility.home:
        return Icons.home;
      case NoteVisibility.followers:
        return Icons.lock_outline;
      case NoteVisibility.specified:
        return Icons.mail;
    }
  }

  Widget resolveAcceptanceIcon(
      ReactionAcceptance? acceptance, BuildContext context) {
    switch (acceptance) {
      case null:
        return SvgPicture.asset(
          "assets/images/play_shapes_FILL0_wght400_GRAD0_opsz48.svg",
          color: Theme.of(context).textTheme.bodyMedium!.color,
          width: 28,
          height: 28,
        );
      case ReactionAcceptance.likeOnly:
        return const Icon(Icons.favorite_border);
      case ReactionAcceptance.likeOnlyForRemote:
        return const Icon(Icons.add_reaction_outlined);
      case ReactionAcceptance.nonSensitiveOnly:
        return const Icon(Icons.shield_outlined);
      case ReactionAcceptance.nonSensitiveOnlyForLocalLikeOnlyForRemote:
        return const Icon(Icons.add_moderator_outlined);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccount = ref.watch(selectedAccountProvider);
    final noteVisibility = ref.watch(noteVisibilityProvider);
    final reactionAcceptance = ref.watch(reactionAcceptanceProvider);
    final isLocal = ref.watch(isLocalProvider);
    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 5)),
        if (selectedAccount != null)
          AvatarIcon.fromIResponse(
            selectedAccount.i,
            height: Theme.of(context)
                    .iconButtonTheme
                    .style
                    ?.iconSize
                    ?.resolve({}) ??
                32,
          ),
        Expanded(child: Container()),
        Builder(
          builder: (context2) => IconButton(
              onPressed: () async {
                final result = await showModalBottomSheet<NoteVisibility?>(
                    context: context2,
                    builder: (context) => const NoteVisibilityDialog());
                if (result != null) {
                  ref.read(noteVisibilityProvider.notifier).state = result;
                }
              },
              icon: Icon(resolveVisibilityIcon(noteVisibility))),
        ),
        IconButton(
            onPressed: () async {
              // チャンネルのノートは強制ローカルから変えられない
              if (ref.read(channelProvider) != null) {
                SimpleMessageDialog.show(context, "チャンネルのノートを連合にすることはでけへんねん。");
                return;
              }
              if (ref.read(replyProvider) != null) {
                SimpleMessageDialog.show(
                    context, "リプライの元ノートが連合なしに設定されとるから、このノートも連合なしにしかでけへんねん。");
              }
              if (ref.read(renoteProvider) != null) {
                SimpleMessageDialog.show(context,
                    "リノートしようとしてるノートが連合なしに設定されとるから、このノートも連合なしにしかでけへんねん。");
              }
              ref.read(isLocalProvider.notifier).state =
                  !ref.read(isLocalProvider);
            },
            icon: isLocal ? const LocalOnlyIcon() : const Icon(Icons.rocket)),
        Builder(
            builder: (context2) => IconButton(
                onPressed: () async {
                  final result =
                      await showModalBottomSheet<ReactionAcceptance?>(
                          context: context2,
                          builder: (context) =>
                              const ReactionAcceptanceDialog());
                  ref.read(reactionAcceptanceProvider.notifier).state = result;
                },
                icon: resolveAcceptanceIcon(reactionAcceptance, context2))),
      ],
    );
  }
}
