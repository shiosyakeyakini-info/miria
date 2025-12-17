import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/state_notifier/common/download_file_notifier.dart";
import "package:miria/state_notifier/note_file_dialog/image_viewer_info_notifier.dart";
import "package:miria/view/common/note_file_dialog/image_viewer.dart";
import "package:miria/view/common/note_file_dialog/media_viewer.dart";
import "package:miria/view/common/note_file_dialog/unsupported_note_file.dart";
import "package:miria/view/dialogs/simple_message_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";

class NoteFileDialog extends HookConsumerWidget {
  final List<DriveFile> driveFiles;
  final int initialPage;
  final String? noteUrl;

  const NoteFileDialog({
    required this.driveFiles,
    required this.initialPage,
    this.noteUrl,
    super.key,
  });

  bool get isDesktop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageViewInfo = ref.watch(imageViewerInfoProvider);
    final isAutoPlay = useState(true);
    final isEnabledSaveButton = useState(true);

    useEffect(() {
      final f = driveFiles[initialPage].type.startsWith("image");
      isEnabledSaveButton.value = f;
      return () {};
    }, []);

    final pageController = usePageController(initialPage: initialPage);
    pageController.addListener(() {
      final page = pageController.page!.round();
      final f = driveFiles[page].type.startsWith("image");
      isEnabledSaveButton.value = f;
      isAutoPlay.value = false;
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        backgroundColor: Colors.transparent,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.arrowLeft): () async {
                ref.read(imageViewerInfoProvider.notifier).reset();
                await pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              const SingleActivator(LogicalKeyboardKey.arrowRight): () async {
                ref.read(imageViewerInfoProvider.notifier).reset();
                await pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              const SingleActivator(LogicalKeyboardKey.escape): () async {
                Navigator.of(context).pop();
              },
            },
            child: Focus(
              autofocus: true,
              child: Dismissible(
                key: const ValueKey(""),
                behavior: HitTestBehavior.translucent,
                direction:
                    (!imageViewInfo.isDoubleTap &&
                        imageViewInfo.scale == 1.0 &&
                        imageViewInfo.pointersCount <= 1)
                    ? DismissDirection.vertical
                    : DismissDirection.none,
                resizeDuration: null,
                onDismissed: (_) => {Navigator.of(context).pop()},
                child: Stack(
                  children: [
                    PageView(
                      controller: pageController,
                      physics:
                          (!imageViewInfo.isDoubleTap &&
                              imageViewInfo.scale == 1.0 &&
                              imageViewInfo.pointersCount <= 1)
                          ? const ScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      children: [
                        for (final file in driveFiles)
                          if (file.type.startsWith("image"))
                            ImageViewer(file: file)
                          else if (file.type.startsWith(RegExp("video|audio")))
                            MediaViewer(file: file, autoPlay: isAutoPlay.value)
                          else
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: UnsupportedNoteFile(
                                file: file,
                                showThumbnail: false,
                                noteUrl: noteUrl,
                              ),
                            ),
                      ],
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: RawMaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        constraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        fillColor: Theme.of(
                          context,
                        ).scaffoldBackgroundColor.withAlpha(200),
                        shape: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.close,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withAlpha(200),
                          ),
                        ),
                      ),
                    ),
                    if (isEnabledSaveButton.value &&
                        (defaultTargetPlatform == TargetPlatform.android ||
                            defaultTargetPlatform == TargetPlatform.iOS))
                      Positioned(
                        right: 10,
                        top: 10,
                        child: RawMaterialButton(
                          onPressed: () async {
                            final page = pageController.page?.toInt();
                            if (page == null) return;
                            final driveFile = driveFiles[page];
                            final f = await ref
                                .read(downloadFileProvider.notifier)
                                .downloadFile(driveFile);
                            if (!context.mounted) return;
                            if (f != DownloadFileResult.succeeded) {
                              await showDialog(
                                context: context,
                                builder: (context) => SimpleMessageDialog(
                                  message:
                                      "${S.of(context).failedFileSave}\n[$f]",
                                ),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).savedImage),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          constraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                          fillColor: Theme.of(
                            context,
                          ).scaffoldBackgroundColor.withAlpha(200),
                          shape: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              Icons.save,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color?.withAlpha(200),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
