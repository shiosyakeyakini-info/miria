import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/misskey_notes/local_only_icon.dart";
import "package:miria/view/note_create_page/note_visibility_dialog.dart";
import "package:miria/view/note_create_page/reaction_acceptance_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";

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

class AcceptanceIcon extends StatelessWidget {
  final ReactionAcceptance? acceptance;
  const AcceptanceIcon({required this.acceptance, super.key});

  @override
  Widget build(BuildContext context) {
    return switch (acceptance) {
      null => SvgPicture.asset(
          "assets/images/play_shapes_FILL0_wght400_GRAD0_opsz48.svg",
          colorFilter: ColorFilter.mode(
            Theme.of(context).textTheme.bodyMedium!.color ??
                const Color(0xff5f6368),
            BlendMode.srcIn,
          ),
          width: 28,
          height: 28,
        ),
      ReactionAcceptance.likeOnly => const Icon(Icons.favorite_border),
      ReactionAcceptance.likeOnlyForRemote =>
        const Icon(Icons.add_reaction_outlined),
      ReactionAcceptance.nonSensitiveOnly => const Icon(Icons.shield_outlined),
      ReactionAcceptance.nonSensitiveOnlyForLocalLikeOnlyForRemote =>
        const Icon(Icons.add_moderator_outlined),
    };
  }
}

class NoteCreateSettingTop extends ConsumerWidget {
  const NoteCreateSettingTop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(noteCreateNotifierProvider.notifier);

    final noteVisibility = ref.watch(
      noteCreateNotifierProvider.select((value) => value.noteVisibility),
    );
    final reactionAcceptance = ref.watch(
      noteCreateNotifierProvider.select((value) => value.reactionAcceptance),
    );
    final isLocal = ref.watch(
      noteCreateNotifierProvider.select((value) => value.localOnly),
    );
    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 5)),
        AvatarIcon(
          user: ref.read(accountContextProvider).postAccount.i,
          height:
              Theme.of(context).iconButtonTheme.style?.iconSize?.resolve({}) ??
                  32,
        ),
        Expanded(child: Container()),
        Builder(
          builder: (context2) => IconButton(
            onPressed: () async {
              final result = await showModalBottomSheet<NoteVisibility?>(
                context: context2,
                builder: (context3) => NoteVisibilityDialog(
                  account: ref.read(accountContextProvider).postAccount,
                ),
              );
              if (result != null) {
                if (result == NoteVisibility.public &&
                    !await ref
                        .read(noteCreateNotifierProvider.notifier)
                        .validateNoteVisibility(NoteVisibility.public)) {
                  return;
                }

                notifier.setNoteVisibility(result);
              }
            },
            icon: Icon(resolveVisibilityIcon(noteVisibility)),
          ),
        ),
        IconButton(
          onPressed: () async => notifier.toggleLocalOnly(),
          icon: isLocal ? const LocalOnlyIcon() : const Icon(Icons.rocket),
        ),
        Builder(
          builder: (context2) => IconButton(
            onPressed: () async {
              final result = await showModalBottomSheet<ReactionAcceptance?>(
                context: context2,
                builder: (context) => const ReactionAcceptanceDialog(),
              );
              notifier.setReactionAcceptance(result);
            },
            icon: AcceptanceIcon(acceptance: reactionAcceptance),
          ),
        ),
      ],
    );
  }
}
