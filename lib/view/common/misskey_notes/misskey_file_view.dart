import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/general_settings.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/image_dialog.dart';
import 'package:miria/view/common/misskey_notes/in_note_button.dart';
import 'package:miria/view/common/misskey_notes/network_image.dart';
import 'package:miria/view/common/misskey_notes/video_dialog.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MisskeyFileView extends ConsumerStatefulWidget {
  final List<DriveFile> files;

  final double height;

  const MisskeyFileView({
    super.key,
    required this.files,
    this.height = 200,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MisskeyFileViewState();
}

class MisskeyFileViewState extends ConsumerState<MisskeyFileView> {
  late bool isElipsed = widget.files.length >= 5;

  @override
  Widget build(BuildContext context) {
    final targetFiles = widget.files;

    if (targetFiles.isEmpty) {
      return Container();
    } else if (targetFiles.length == 1) {
      final targetFile = targetFiles.first;
      return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: widget.height, maxWidth: double.infinity),
            child: MisskeyImage(
              isSensitive: targetFile.isSensitive,
              thumbnailUrl: targetFile.thumbnailUrl,
              targetFiles: [targetFile.url.toString()],
              fileType: targetFile.type,
              name: targetFile.name,
              position: 0,
            )),
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
                      (index, element) => (element: element, index: index))
                  .take(isElipsed ? 4 : targetFiles.length))
                SizedBox(
                    height: widget.height,
                    width: double.infinity,
                    child: MisskeyImage(
                      isSensitive: targetFile.element.isSensitive,
                      thumbnailUrl: targetFile.element.thumbnailUrl,
                      targetFiles: targetFiles.map((e) => e.url).toList(),
                      fileType: targetFile.element.type,
                      name: targetFile.element.name,
                      position: targetFile.index,
                    ))
            ],
          ),
          if (isElipsed)
            InNoteButton(
                onPressed: () => setState(() {
                      isElipsed = !isElipsed;
                    }),
                child: Text(S.of(context).showMoreFiles))
        ],
      );
    }
  }
}

class MisskeyImage extends ConsumerStatefulWidget {
  final bool isSensitive;
  final String? thumbnailUrl;
  final List<String> targetFiles;
  final int position;
  final String fileType;
  final String name;

  const MisskeyImage({
    super.key,
    required this.isSensitive,
    required this.thumbnailUrl,
    required this.targetFiles,
    required this.position,
    required this.fileType,
    required this.name,
  });

  @override
  ConsumerState<MisskeyImage> createState() => MisskeyImageState();
}

class MisskeyImageState extends ConsumerState<MisskeyImage> {
  var nsfwAccepted = false;
  Widget? cachedWidget;

  @override
  void didUpdateWidget(covariant MisskeyImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!const ListEquality()
        .equals(oldWidget.targetFiles, widget.targetFiles)) {
      cachedWidget = null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final nsfwSetting = ref.read(generalSettingsRepositoryProvider
        .select((repository) => repository.settings.nsfwInherit));
    if (nsfwSetting == NSFWInherit.allHidden) {
      // 強制的にNSFW表示
      setState(() {
        nsfwAccepted = false;
      });
    } else if (nsfwSetting == NSFWInherit.ignore) {
      // 設定を無視
      setState(() {
        nsfwAccepted = true;
      });
    } else if (nsfwSetting == NSFWInherit.inherit && !widget.isSensitive) {
      // 閲覧注意ではなく、継承する
      setState(() {
        nsfwAccepted = true;
      });
    } else if (nsfwSetting == NSFWInherit.removeNsfw && !widget.isSensitive) {
      setState(() {
        nsfwAccepted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nsfwSetting = ref.watch(generalSettingsRepositoryProvider
        .select((repository) => repository.settings.nsfwInherit));
    return Stack(
      children: [
        Align(
          child: GestureDetector(onTap: () {
            if (!nsfwAccepted) {
              setState(() {
                nsfwAccepted = true;
              });
              return;
            } else {
              if (widget.fileType.startsWith("image")) {
                showDialog(
                    context: context,
                    builder: (context) => ImageDialog(
                          imageUrlList: widget.targetFiles,
                          initialPage: widget.position,
                        ));
              } else if (widget.fileType.startsWith(RegExp("video|audio"))) {
                showDialog(
                  context: context,
                  builder: (context) => VideoDialog(
                    url: widget.targetFiles[widget.position],
                    fileType: widget.fileType,
                  ),
                );
              } else {
                launchUrl(Uri.parse(widget.targetFiles[widget.position]),
                    mode: LaunchMode.externalApplication);
              }
            }
          }, child: Builder(
            builder: (context) {
              if (!nsfwAccepted) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black54),
                    width: double.infinity,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.warning_rounded,
                              color: Colors.white),
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
                                        ?.fontSize),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (cachedWidget != null) {
                return cachedWidget!;
              }

              cachedWidget = FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 100)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (widget.fileType.startsWith("image")) {
                      cachedWidget = SizedBox(
                        height: 200,
                        child: NetworkImageView(
                          url: widget.thumbnailUrl ??
                              widget.targetFiles[widget.position],
                          type: ImageType.imageThumbnail,
                          loadingBuilder: (context, widget, chunkEvent) =>
                              SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: widget,
                          ),
                        ),
                      );
                    } else if (widget.fileType
                        .startsWith(RegExp("video|audio"))) {
                      cachedWidget = Stack(
                        children: [
                          Positioned.fill(
                            child: SizedBox(
                              height: 200,
                              child: widget.thumbnailUrl != null
                                  ? NetworkImageView(
                                      url: widget.thumbnailUrl!,
                                      type: ImageType.imageThumbnail,
                                      loadingBuilder:
                                          (context, widget, chunkEvent) =>
                                              SizedBox(
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
                                  child: Icon(Icons.play_circle, size: 60)))
                        ],
                      );
                    } else {
                      cachedWidget = TextButton.icon(
                          onPressed: () {
                            launchUrl(
                                Uri.parse(widget.targetFiles[widget.position]),
                                mode: LaunchMode.externalApplication);
                          },
                          icon: const Icon(Icons.file_download_outlined),
                          label: Text(widget.name));
                    }

                    return cachedWidget!;
                  }
                  return Container();
                },
              );
              return cachedWidget!;
            },
          )),
        ),
        if (widget.isSensitive &&
            (nsfwSetting == NSFWInherit.ignore ||
                nsfwSetting == NSFWInherit.allHidden))
          Positioned(
              left: 5,
              top: 5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha(140),
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(3)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2, right: 2),
                  child: Text(
                    S.of(context).sensitive,
                    style: TextStyle(color: Colors.white.withAlpha(170)),
                  ),
                ),
              )),
      ],
    );
  }
}
