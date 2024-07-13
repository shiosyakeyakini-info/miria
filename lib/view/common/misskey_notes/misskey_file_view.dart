import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/image_dialog.dart";
import "package:miria/view/common/misskey_notes/in_note_button.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:miria/view/common/misskey_notes/video_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:url_launcher/url_launcher.dart";

class MisskeyFileView extends HookConsumerWidget {
  final List<DriveFile> files;

  final double height;

  const MisskeyFileView({
    required this.files,
    super.key,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isElipsed = useState(files.length >= 5);
    final targetFiles = files;

    if (targetFiles.isEmpty) {
      return Container();
    } else if (targetFiles.length == 1) {
      final targetFile = targetFiles.first;
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: height,
            maxWidth: double.infinity,
          ),
          child: MisskeyImage(
            isSensitive: targetFile.isSensitive,
            thumbnailUrl: targetFile.thumbnailUrl,
            targetFiles: [targetFile.url.toString()],
            fileType: targetFile.type,
            name: targetFile.name,
            position: 0,
          ),
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final targetFile in targetFiles
                  .mapIndexed(
                    (index, element) => (element: element, index: index),
                  )
                  .take(isElipsed.value ? 4 : targetFiles.length))
                SizedBox(
                  height: height,
                  width: double.infinity,
                  child: MisskeyImage(
                    isSensitive: targetFile.element.isSensitive,
                    thumbnailUrl: targetFile.element.thumbnailUrl,
                    targetFiles: targetFiles.map((e) => e.url).toList(),
                    fileType: targetFile.element.type,
                    name: targetFile.element.name,
                    position: targetFile.index,
                  ),
                ),
            ],
          ),
          if (isElipsed.value)
            InNoteButton(
              onPressed: () => isElipsed.value = !isElipsed.value,
              child: Text(S.of(context).showMoreFiles),
            ),
        ],
      );
    }
  }
}

class MisskeyImage extends HookConsumerWidget {
  final bool isSensitive;
  final String? thumbnailUrl;
  final List<String> targetFiles;
  final int position;
  final String fileType;
  final String name;

  const MisskeyImage({
    required this.isSensitive,
    required this.thumbnailUrl,
    required this.targetFiles,
    required this.position,
    required this.fileType,
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialNsfw = useMemoized(() {
      final nsfwSetting = ref.read(
        generalSettingsRepositoryProvider
            .select((repository) => repository.settings.nsfwInherit),
      );
      if (nsfwSetting == NSFWInherit.allHidden) {
        // 強制的にNSFW表示
        return false;
      } else if (nsfwSetting == NSFWInherit.ignore) {
        // 設定を無視
        return true;
      } else if (nsfwSetting == NSFWInherit.inherit && !isSensitive) {
        // 閲覧注意ではなく、継承する
        return true;
      } else if (nsfwSetting == NSFWInherit.removeNsfw && !isSensitive) {
        return true;
      } else {
        return false;
      }
    });
    final nsfwAccepted = useState(initialNsfw);

    final nsfwSetting = ref.watch(
      generalSettingsRepositoryProvider
          .select((repository) => repository.settings.nsfwInherit),
    );

    final delayed = useFuture(
      // ignore: discarded_futures
      useMemoized(
        () => Future.delayed(const Duration(milliseconds: 100)),
      ),
    );

    if (delayed.connectionState != ConnectionState.done) return Container();

    return Stack(
      children: [
        Align(
          child: GestureDetector(
            onTap: () async {
              if (!nsfwAccepted.value) {
                nsfwAccepted.value = true;
                return;
              } else {
                if (fileType.startsWith("image")) {
                  await showDialog(
                    context: context,
                    builder: (context) => ImageDialog(
                      imageUrlList: targetFiles,
                      initialPage: position,
                    ),
                  );
                } else if (fileType.startsWith(RegExp("video|audio"))) {
                  await showDialog(
                    context: context,
                    builder: (context) => VideoDialog(
                      url: targetFiles[position],
                      fileType: fileType,
                    ),
                  );
                } else {
                  await launchUrl(
                    Uri.parse(targetFiles[position]),
                    mode: LaunchMode.externalApplication,
                  );
                }
              }
            },
            child: Builder(
              builder: (context) {
                if (!nsfwAccepted.value) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.black54),
                      width: double.infinity,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning_rounded,
                              color: Colors.white,
                            ),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  S.of(context).sensitive,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  S.of(context).tapToShow,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.fontSize,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (fileType.startsWith("image")) {
                  return SizedBox(
                    height: 200,
                    child: NetworkImageView(
                      url: thumbnailUrl ?? targetFiles[position],
                      type: ImageType.imageThumbnail,
                      loadingBuilder: (context, widget, chunkEvent) => SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: widget,
                      ),
                    ),
                  );
                } else if (fileType.startsWith(RegExp("video|audio"))) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: SizedBox(
                          height: 200,
                          child: thumbnailUrl != null
                              ? NetworkImageView(
                                  url: thumbnailUrl!,
                                  type: ImageType.imageThumbnail,
                                  loadingBuilder:
                                      (context, widget, chunkEvent) => SizedBox(
                                    width: double.infinity,
                                    height: 200,
                                    child: widget,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                      const Positioned.fill(
                        child: Center(
                          child: Icon(Icons.play_circle, size: 60),
                        ),
                      ),
                    ],
                  );
                } else {
                  return TextButton.icon(
                    onPressed: () async => launchUrl(
                      Uri.parse(targetFiles[position]),
                      mode: LaunchMode.externalApplication,
                    ),
                    icon: const Icon(Icons.file_download_outlined),
                    label: Text(name),
                  );
                }
              },
            ),
          ),
        ),
        if (isSensitive &&
            (nsfwSetting == NSFWInherit.ignore ||
                nsfwSetting == NSFWInherit.allHidden))
          Positioned(
            left: 5,
            top: 5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(140),
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Text(
                  S.of(context).sensitive,
                  style: TextStyle(color: Colors.white.withAlpha(170)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
