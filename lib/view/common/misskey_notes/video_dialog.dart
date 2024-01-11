import 'dart:math';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoDialog extends StatefulWidget {
  const VideoDialog({super.key, required this.url});

  final String url;

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late final videoKey = GlobalKey<VideoState>();
  late final player = Player();
  late final controller = VideoController(player);
  double aspectRatio = 1;

  @override
  void initState() {
    super.initState();
    player.open(Media(widget.url));
    controller.rect.addListener(() {
      final rect = controller.rect.value;
      if (rect == null || rect.width == 0 || rect.height == 0) {
        return;
      }
      setState(() {
        aspectRatio = rect.width / rect.height;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = MaterialVideoControlsThemeData(
        seekBarPositionColor: Theme.of(context).primaryColor,
        seekBarThumbColor: Theme.of(context).primaryColor,
        backdropColor: Colors.transparent,
        volumeGesture: false,
        brightnessGesture: false);

    final themeDataFull = MaterialVideoControlsThemeData(
        seekBarPositionColor: Theme.of(context).primaryColor,
        seekBarThumbColor: Theme.of(context).primaryColor,
        volumeGesture: false,
        brightnessGesture: false,
        bottomButtonBarMargin:
            const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 16.0),
        seekBarMargin: const EdgeInsets.only(bottom: 16.0));

    final themeDataDesktop = MaterialDesktopVideoControlsThemeData(
        seekBarPositionColor: Theme.of(context).primaryColor,
        seekBarThumbColor: Theme.of(context).primaryColor,
        modifyVolumeOnScroll: false);

    final themeDataDesktopFull = MaterialDesktopVideoControlsThemeData(
        seekBarPositionColor: Theme.of(context).primaryColor,
        seekBarThumbColor: Theme.of(context).primaryColor,
        modifyVolumeOnScroll: false);

    return AlertDialog(
        backgroundColor: Colors.transparent,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            Positioned.fill(
              child: Dismissible(
                key: const ValueKey(""),
                behavior: HitTestBehavior.translucent,
                direction: DismissDirection.vertical,
                resizeDuration: null,
                onDismissed: (_) => {Navigator.of(context).pop()},
                child: Stack(children: [
                  Align(
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: MaterialVideoControlsTheme(
                        normal: themeData,
                        fullscreen: themeDataFull,
                        child: MaterialDesktopVideoControlsTheme(
                          normal: themeDataDesktop,
                          fullscreen: themeDataDesktopFull,
                          child: Video(
                            key: videoKey,
                            controller: controller,
                            controls: AdaptiveVideoControls,
                            fill: Colors.transparent,
                            onEnterFullscreen: () async {
                              await defaultEnterNativeFullscreen();
                              videoKey.currentState?.update(
                                fill: Colors.black
                                );
                            },
                            onExitFullscreen: () async {
                              await defaultExitNativeFullscreen();
                              videoKey.currentState?.update(
                                fill: Colors.transparent
                                );
                            },
                        )),
                    ))),
            Positioned(
              left: 10,
              top: 10,
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                constraints: 
                    const BoxConstraints(minWidth: 0, minHeight: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero,
                fillColor: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withAlpha(200),
                shape: const CircleBorder(),
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(Icons.close,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withAlpha(200))))),
             ])))
      ])));
  }
}
