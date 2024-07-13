import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/model/tab_setting.dart";
import "package:miria/providers.dart";
import "package:miria/repository/socket_timeline_repository.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/common_drawer.dart";
import "package:miria/view/common/misskey_notes/local_only_icon.dart";
import "package:miria/view/common/timeline_listview.dart";
import "package:miria/view/note_create_page/note_create_setting_top.dart";
import "package:miria/view/note_create_page/note_visibility_dialog.dart";
import "package:miria/view/note_create_page/reaction_acceptance_dialog.dart";
import "package:miria/view/time_line_page/misskey_time_line.dart";
import "package:misskey_dart/misskey_dart.dart";

class TimelineTablet extends HookConsumerWidget {
  const TimelineTablet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabSettings = ref.read(
      tabSettingsRepositoryProvider.select((repo) => repo.tabSettings),
    );

    return Scaffold(
      drawer: const TimelineTabletDrawer(),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          devicePixelRatio: MediaQuery.of(context).devicePixelRatio * 0.5,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const TimelineTabletDrawer(),
                const SizedBox(width: 15),
                for (final tabSetting in tabSettings)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          right:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      child: SizedBox(
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Timeline(tabSetting: tabSetting),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimelineTabletDrawer extends ConsumerWidget {
  const TimelineTabletDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstAccount =
        ref.watch(accountsProvider.select((value) => value.first.acct));
    return CommonDrawer(
      initialOpenAcct: firstAccount,
      allOpen: true,
    );
  }
}

class Timeline extends HookConsumerWidget {
  final TabSetting tabSetting;

  const Timeline({
    required this.tabSetting,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider(tabSetting.acct));
    final scrollController = useMemoized(() => TimelineScrollController());
    useEffect(() => scrollController.dispose);

    return AccountContextScope.as(
      account: account,
      child: Column(
        children: [
          const SizedBox(height: 5),
          SectionHeader(
            tabSetting: tabSetting,
            scrollController: scrollController,
          ),
          TabTextField(tabSetting: tabSetting),
          Expanded(
            child: MisskeyTimeline(
              tabSetting: tabSetting,
              controller: scrollController,
            ),
          )
        ],
      ),
    );
  }
}

class SectionHeader extends ConsumerWidget {
  final TabSetting tabSetting;
  final TimelineScrollController scrollController;
  const SectionHeader({
    required this.tabSetting,
    required this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faviconUrl = ref.watch(
      accountProvider(ref.read(accountContextProvider).getAccount.acct)
          .select((value) => value.meta?.iconUrl),
    );
    final socketTimelineBase = ref.watch(timelineProvider(tabSetting));
    final socketTimeline = socketTimelineBase is SocketTimelineRepository
        ? socketTimelineBase
        : null;

    return Row(
      children: [
        Image.network(
          faviconUrl?.toString() ??
              "https://${ref.read(accountContextProvider).getAccount.host}/favicon.ico",
          height: 28,
        ),
        AvatarIcon(
          user: ref.read(accountContextProvider).getAccount.i,
          height: 28,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => scrollController.forceScrollToTop(),
            child: Text(tabSetting.name ?? tabSetting.tabType.name),
          ),
        ),
        if (socketTimeline != null)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async => socketTimeline.reconnect(),
          ),
      ],
    );
  }
}

class TabTextField extends HookConsumerWidget {
  final TabSetting tabSetting;

  const TabTextField({
    required this.tabSetting,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final account = ref.watch(accountContextProvider).postAccount;
    final settings =
        ref.read(accountSettingsRepositoryProvider).fromAccount(account);
    final reactionAppearance = useState(settings.defaultReactionAcceptance);
    final localOnly = useState(settings.defaultIsLocalOnly);
    final visibility = useState(settings.defaultNoteVisibility);

    final note = useHandledFuture(() async {
      await ref.read(misskeyPostContextProvider).notes.create(
            NotesCreateRequest(
              text: controller.text,
              localOnly: localOnly.value,
              visibility: visibility.value,
              reactionAcceptance: reactionAppearance.value,
              channelId: tabSetting.channelId,
            ),
          );
      controller.text = "";
    });

    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: SizedBox.shrink()),
            IconButton(
              onPressed: () async {
                final result = await showModalBottomSheet<NoteVisibility?>(
                  context: context,
                  builder: (context) => NoteVisibilityDialog(
                    account: ref.read(accountContextProvider).postAccount,
                  ),
                );
                if (result != null) visibility.value = result;
              },
              icon: Icon(resolveVisibilityIcon(visibility.value)),
            ),
            IconButton(
              onPressed: () => localOnly.value = !localOnly.value,
              icon: localOnly.value
                  ? const LocalOnlyIcon()
                  : const Icon(Icons.rocket),
            ),
            IconButton(
              onPressed: () async {
                final result = await showModalBottomSheet<ReactionAcceptance?>(
                  context: context,
                  builder: (context) => const ReactionAcceptanceDialog(),
                );
                reactionAppearance.value = result;
              },
              icon: AcceptanceIcon(acceptance: reactionAppearance.value),
            ),
            IconButton(
              onPressed: note.executeOrNull,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
        Focus(
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.enter &&
                  (HardwareKeyboard.instance.isControlPressed ||
                      HardwareKeyboard.instance.isMetaPressed)) {
                unawaited(note.execute());
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: EmojiInputComplement(controller: controller),
        ),
      ],
    );
  }
}

class EmojiInputComplement extends HookWidget {
  final TextEditingController controller;

  const EmojiInputComplement({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final overlayEntry = useState<OverlayEntry?>(null);
    final layerLink = useMemoized(() => LayerLink());
    final options = useMemoized(() => [
          "apple",
          "banana",
          "grape",
          "orange",
          "pineapple",
          "strawberry",
          "watermelon"
        ]);

    final hideOverlay = useCallback(
      () {
        overlayEntry.value?.remove();
        overlayEntry.value = null;
      },
      [overlayEntry],
    );

    final selectOption = useCallback<void Function(String)>(
      (option) {
        final text = controller.text;
        final selection = controller.selection;
        final newText =
            text.replaceRange(selection.start, selection.end, option);

        controller.value = controller.value.copyWith(
          text: newText,
          selection:
              TextSelection.collapsed(offset: selection.start + option.length),
        );

        hideOverlay();
      },
      [controller, hideOverlay],
    );

    final getCursorOffset = useCallback(
      () {
        final textPainter = TextPainter(
          text: TextSpan(
            text: controller.text,
            style: DefaultTextStyle.of(context).style,
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final caretOffset =
            textPainter.getOffsetForCaret(controller.selection.base, Rect.zero);
        return caretOffset.translate(0, textPainter.height);
      },
      [controller],
    );

    final createOverlayEntry = useCallback(
      () {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox == null) return null;
        final size = renderBox.size;
        final cursorOffset = getCursorOffset();

        return OverlayEntry(
          builder: (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: layerLink,
              showWhenUnlinked: false,
              offset: cursorOffset,
              child: Material(
                elevation: 4.0,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    for (final option in options)
                      ListTile(
                        title: Text(option),
                        onTap: () => selectOption(option),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      [context, layerLink, options, getCursorOffset, selectOption],
    );

    final showOverlay = useCallback(
      () {
        if (overlayEntry.value != null) {
          overlayEntry.value!.remove();
        }
        final entry = createOverlayEntry();
        if (entry == null) return;
        overlayEntry.value = entry;
        Overlay.of(context).insert(entry);
      },
      [createOverlayEntry, overlayEntry],
    );

    useEffect(
      () {
        void onTextChanged() {
          if (controller.text.contains("@")) {
            showOverlay();
          } else {
            hideOverlay();
          }
        }

        controller.addListener(onTextChanged);

        return () => controller.removeListener(onTextChanged);
      },
      [controller],
    );

    return TextField(
      controller: controller,
      maxLines: 2,
    );
  }
}
