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
  late final player = Player();
  late final controller = VideoController(player);
  double aspectRatio = 1;
  var verticalDragX = 0.0;
  var verticalDragY = 0.0;
  int? listeningId;

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
      volumeGesture: false,
      brightnessGesture: false,
    );
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
                child: Listener(
                    onPointerDown: (event) {
                      // プレイヤー操作できるように画面下部に不感エリア
                      if (event.position.dy / MediaQuery.of(context).size.height > 0.85) {
                        listeningId = null;
                        return;
                      }

                      if (listeningId != null) {
                        setState(() {
                          verticalDragX = 0;
                          verticalDragY = 0;
                        });
                        listeningId = null;
                        return;
                      }
                      listeningId = event.pointer;
                    },
                    onPointerMove: (event) {
                      if (listeningId != null) {
                        setState(() {
                          //verticalDragX += event.delta.dx;
                          verticalDragY += event.delta.dy;
                        });
                      }
                    },
                    onPointerUp: (event) {
                      final angle = (atan2(verticalDragY, verticalDragX).abs() /
                          pi *
                          180);
                      if (listeningId != null &&
                          verticalDragY.abs() > 10 &&
                          (angle > 60 && angle < 120)) {
                        Navigator.of(context).pop();
                      } else {
                        listeningId = null;
                      }
                    },
                    child: Transform.translate(
                        offset: Offset(verticalDragX, verticalDragY),
                        child: MaterialVideoControlsTheme(
                            normal: themeData,
                            fullscreen: themeData,
                            child: Video(controller: controller)))),
              ),
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
                        .withAlpha(300),
                    shape: const CircleBorder(),
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(Icons.close,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withAlpha(500)))),
              ),
            ])));
  }
}
