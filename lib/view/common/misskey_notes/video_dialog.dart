import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VideoDialog extends StatefulWidget {
  const VideoDialog({super.key, required this.url, required this.fileType});

  final String url;
  final String fileType;

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late final videoKey = GlobalKey<VideoState>();
  late final player = Player();
  late final controller = VideoController(player);
  late final bool isAudioFile;

  double aspectRatio = 1;

  int lastTapTime = 0;
  bool isVisibleControlBar = false;
  bool isEnabledButton = false;
  bool isFullScreen = false;
  Timer? timer;

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
    isAudioFile = widget.fileType.startsWith(RegExp("audio"));
    if (isAudioFile) {
      isVisibleControlBar = true;
      isEnabledButton = true;
    }
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  void dispose() {
    player.dispose();
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    VolumeController().removeListener();
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      if (!isFullScreen) {
        Navigator.of(context).pop();
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = MaterialVideoControlsThemeData(
        seekBarPositionColor: Theme.of(context).primaryColor,
        seekBarThumbColor: Theme.of(context).primaryColor,
        backdropColor: Colors.transparent,
        volumeGesture: false,
        brightnessGesture: false,
        displaySeekBar: false,
        automaticallyImplySkipNextButton: false,
        automaticallyImplySkipPreviousButton: false,
        primaryButtonBar: [],
        bottomButtonBar: []);

    final themeDataFull = MaterialVideoControlsThemeData(
        seekBarPositionColor: Theme.of(context).primaryColor,
        seekBarThumbColor: Theme.of(context).primaryColor,
        volumeGesture: false,
        brightnessGesture: false,
        automaticallyImplySkipNextButton: false,
        automaticallyImplySkipPreviousButton: false,
        bottomButtonBarMargin:
            const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 16.0),
        seekBarMargin: const EdgeInsets.only(bottom: 16.0));

    final themeDataDesktop = MaterialDesktopVideoControlsThemeData(
        seekBarPositionColor: Theme.of(context).primaryColor,
        seekBarThumbColor: Theme.of(context).primaryColor,
        modifyVolumeOnScroll: false,
        displaySeekBar: false,
        automaticallyImplySkipNextButton: false,
        automaticallyImplySkipPreviousButton: false,
        primaryButtonBar: [],
        bottomButtonBar: []);

    final themeDataDesktopFull = MaterialDesktopVideoControlsThemeData(
        seekBarPositionColor: Theme.of(context).primaryColor,
        seekBarThumbColor: Theme.of(context).primaryColor,
        modifyVolumeOnScroll: false,
        automaticallyImplySkipNextButton: false,
        automaticallyImplySkipPreviousButton: false);

    return AlertDialog(
      backgroundColor: Colors.transparent,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (event) {
                  if (isAudioFile) return;
                  timer?.cancel();
                  int now = DateTime.now().millisecondsSinceEpoch;
                  int elap = now - lastTapTime;
                  lastTapTime = now;
                  setState(() {
                    if (!isVisibleControlBar) {
                      isEnabledButton = true;
                      isVisibleControlBar = true;
                    } else if (elap > 500 &&
                        (event.localPosition.dy + 100 <
                                MediaQuery.of(context).size.height &&
                            max(event.localPosition.dx,
                                    event.localPosition.dy) >=
                                45)) {
                      isVisibleControlBar = false;
                    }
                  });
                },
                onPointerUp: (event) {
                  if (isAudioFile) return;
                  timer?.cancel();
                  timer = Timer(const Duration(seconds: 2), () {
                    if (!mounted) return;
                    setState(() {
                      isVisibleControlBar = false;
                    });
                  });
                },
                child: Dismissible(
                  key: const ValueKey(""),
                  behavior: HitTestBehavior.translucent,
                  direction: DismissDirection.vertical,
                  resizeDuration: null,
                  onDismissed: (_) => {Navigator.of(context).pop()},
                  child: Stack(
                    children: [
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
                                        isFullScreen = true;
                                        await defaultEnterNativeFullscreen();
                                        videoKey.currentState
                                            ?.update(fill: Colors.black);
                                      },
                                      onExitFullscreen: () async {
                                        await defaultExitNativeFullscreen();
                                        isFullScreen = false;
                                        videoKey.currentState
                                            ?.update(fill: Colors.transparent);
                                      },
                                    )),
                              ))),
                      AnimatedOpacity(
                        curve: Curves.easeInOut,
                        opacity: isVisibleControlBar ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        onEnd: () {
                          if (mounted && !isVisibleControlBar) {
                            setState(() {
                              isEnabledButton = false;
                            });
                          }
                        },
                        child: Visibility(
                          maintainState: true,
                          maintainAnimation: true,
                          visible: isEnabledButton,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                child: _VideoControls(
                                  controller: controller,
                                  isAudioFile: isAudioFile,
                                  onMenuPressed: () => {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (innerContext) {
                                        return ListView(
                                          children: [
                                            ListTile(
                                                leading: const Icon(
                                                    Icons.open_in_browser),
                                                title: Text(
                                                    S.of(context).openBrowsers),
                                                onTap: () async {
                                                  Navigator.of(innerContext)
                                                      .pop();
                                                  Navigator.of(context).pop();
                                                  launchUrlString(
                                                    widget.url,
                                                    mode: LaunchMode
                                                        .externalApplication,
                                                  );
                                                }),
                                            if (!isAudioFile)
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.fullscreen),
                                                title: Text(S
                                                    .of(context)
                                                    .changeFullScreen),
                                                onTap: () async {
                                                  Navigator.of(innerContext)
                                                      .pop();
                                                  videoKey.currentState
                                                      ?.enterFullscreen();
                                                },
                                              )
                                          ],
                                        );
                                      },
                                    )
                                  },
                                ),
                              ),
                              Positioned(
                                left: 10,
                                top: 10,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  constraints: const BoxConstraints(
                                      minWidth: 0, minHeight: 0),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                  fillColor: Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withAlpha(200),
                                  shape: const CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.close,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withAlpha(200),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _VideoControls extends StatefulWidget {
  final VideoController controller;
  final double iconSize = 30.0;
  final VoidCallback? onMenuPressed;
  final bool isAudioFile;

  const _VideoControls(
      {required this.controller,
      required this.isAudioFile,
      this.onMenuPressed});

  @override
  State<_VideoControls> createState() => _VideoControlState();
}

class _VideoControlState extends State<_VideoControls> {
  final List<StreamSubscription> subscriptions = [];

  late Duration position = widget.controller.player.state.position;
  late Duration bufferPosition = widget.controller.player.state.buffer;
  late Duration duration = widget.controller.player.state.duration;

  bool isSeeking = false;
  bool isMute = false;

  @override
  void initState() {
    super.initState();
    if (subscriptions.isEmpty) {
      subscriptions.addAll([
        widget.controller.player.stream.position.listen((event) {
          setState(() {
            if (!isSeeking) {
              position = event;
            }
          });
        }),
        widget.controller.player.stream.buffer.listen((event) {
          setState(() {
            bufferPosition = event;
          });
        }),
        widget.controller.player.stream.duration.listen((event) {
          setState(() {
            duration = event;
          });
        })
      ]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
              top: BorderSide(
            color: Theme.of(context).primaryColor,
          ))),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          iconSize: widget.iconSize,
                          onPressed: () =>
                              widget.controller.player.playOrPause(),
                          icon: StreamBuilder(
                              stream: widget.controller.player.stream.playing,
                              builder: (context, playing) => Icon(
                                    playing.data == true
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  )),
                        ),
                      ),
                      Text(position.label(reference: duration),
                          textAlign: TextAlign.center),
                      const Text(" / "),
                      Text(duration.label(reference: duration),
                          textAlign: TextAlign.center),
                    ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                  ),
                  IconButton(
                      iconSize: widget.iconSize,
                      onPressed: () async {
                        await widget.controller.player
                            .setVolume(isMute ? 100 : 0);
                        isMute = !isMute;
                      },
                      icon: StreamBuilder(
                        stream: widget.controller.player.stream.volume,
                        builder: (context, playing) => Icon(
                          playing.data == 0
                              ? Icons.volume_off
                              : Icons.volume_up,
                        ),
                      )),
                  IconButton(
                    onPressed: widget.onMenuPressed,
                    icon: const Icon(Icons.more_horiz),
                    iconSize: widget.iconSize,
                  )
                ])),
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SliderTheme(
                      data: SliderThemeData(
                          overlayShape: SliderComponentShape.noOverlay,
                          trackHeight: 3.0,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6.0)),
                      child: Slider(
                        thumbColor: Theme.of(context).primaryColor,
                        activeColor: Theme.of(context).primaryColor,
                        value: position.inMilliseconds.toDouble(),
                        secondaryTrackValue:
                            bufferPosition.inMilliseconds.toDouble(),
                        min: 0,
                        max: duration.inMilliseconds.toDouble(),
                        onChangeStart: (double value) {
                          isSeeking = true;
                        },
                        onChanged: (double value) {
                          setState(() {
                            position = Duration(milliseconds: value.toInt());
                          });
                        },
                        onChangeEnd: (double value) {
                          widget.controller.player.seek(position);
                          isSeeking = false;
                        },
                      )))
            ])
      ]),
    );
  }
}
