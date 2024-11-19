import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:miria/view/common/note_file_dialog/media_player.dart";
import "package:miria/view/themes/app_theme.dart";
import "package:misskey_dart/misskey_dart.dart";

class MediaViewer extends HookConsumerWidget {
  final DriveFile file;
  final bool autoPlay;
  const MediaViewer({
    required this.file,
    this.autoPlay = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isThumbnailVisible = useState(true);
    final enabledAutoPlay = useState(false);

    useEffect(
      () {
        enabledAutoPlay.value = autoPlay;
        return () {};
      },
      [],
    );

    final thumbnailWidget = GestureDetector(
      onTap: () {
        isThumbnailVisible.value = false;
      },
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.center,
        children: [
          if (!file.type.startsWith("audio"))
            NetworkImageView(
              url: file.thumbnailUrl.toString(),
              type: ImageType.imageThumbnail,
              fit: BoxFit.contain,
            ),
          Icon(
            Icons.play_circle,
            size: 100,
            color: AppTheme.of(context).colorTheme.primary,
          ),
        ],
      ),
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: (enabledAutoPlay.value ||
              (!enabledAutoPlay.value && !isThumbnailVisible.value))
          ? MediaPlayer(
              url: file.url,
              fileType: file.type,
              thumbnailUrl: file.thumbnailUrl,
            )
          : thumbnailWidget,
    );
  }
}
