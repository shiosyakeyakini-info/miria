import "dart:async";
import "dart:io";
import "dart:math";

import "package:flutter/material.dart";
import "package:media_kit/media_kit.dart";
import "package:media_kit_video/media_kit_video.dart";
import "package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:url_launcher/url_launcher_string.dart";
import "package:volume_controller/volume_controller.dart";

class MediaPlayer extends StatefulWidget {
  final String url;
  final String fileType;
  final String? thumbnailUrl;

  const MediaPlayer({
    required this.url,
    required this.fileType,
    this.thumbnailUrl,
    super.key,
  });

  @override
  MediaPlayerState createState() => MediaPlayerState();
}

class MediaPlayerState extends State<MediaPlayer> {
  late final videoKey = GlobalKey<VideoState>();
  late final player = Player();
  late final controller = VideoController(player);
  late final bool isAudioFile;
  final List<StreamSubscription> subscriptions = [];

  double aspectRatio = 1;

  bool isVisibleControlBar = false;
  bool isEnabledButton = false;
  bool isFullscreen = false;
  Timer? timer;

  Duration position = const Duration();
  Duration bufferPosition = const Duration();
  Duration duration = const Duration();
  final double iconSize = 30.0;
  bool isSeeking = false;

  bool get isDesktop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @override
  void initState() {
    super.initState();
    isAudioFile = widget.fileType.startsWith("audio");
    if (isAudioFile) {
      isVisibleControlBar = true;
      isEnabledButton = true;
    }

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

    subscriptions.addAll([
      controller.player.stream.position.listen((event) {
        setState(() {
          if (!isSeeking) {
            position = event;
          }
        });
      }),
      controller.player.stream.buffer.listen((event) {
        setState(() {
          bufferPosition = event;
        });
      }),
      controller.player.stream.duration.listen((event) {
        setState(() {
          duration = event;
        });
      }),
    ]);
  }

  @override
  void dispose() {
    Future.microtask(() async {
      for (final subscription in subscriptions) {
        await subscription.cancel();
      }
      await player.dispose();
    });
    VolumeController.instance.removeListener();
    super.dispose();
  }

  Future<void> _showMenu() {
    return showModalBottomSheet(
      context: context,
      builder: (innerContext) {
        return ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: Text(S.of(context).openBrowsers),
              onTap: () async {
                Navigator.of(innerContext).pop();
                Navigator.of(context).pop();
                await launchUrlString(
                  widget.url,
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            if (!isAudioFile)
              ListTile(
                leading: const Icon(Icons.fullscreen),
                title: Text(S.of(context).changeFullScreen),
                onTap: () async {
                  Navigator.of(innerContext).pop();
                  await videoKey.currentState?.enterFullscreen();
                },
              ),
          ],
        );
      },
    );
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
      seekOnDoubleTap: false,
      automaticallyImplySkipNextButton: false,
      automaticallyImplySkipPreviousButton: false,
      primaryButtonBar: [],
      bottomButtonBar: [],
    );

    final themeDataFull = MaterialVideoControlsThemeData(
      seekBarPositionColor: Theme.of(context).primaryColor,
      seekBarThumbColor: Theme.of(context).primaryColor,
      volumeGesture: false,
      brightnessGesture: false,
      displaySeekBar: true,
      seekOnDoubleTap: true,
      automaticallyImplySkipNextButton: false,
      automaticallyImplySkipPreviousButton: false,
      bottomButtonBarMargin: const EdgeInsets.only(
        left: 16.0,
        right: 8.0,
        bottom: 16.0,
      ),
      seekBarMargin: const EdgeInsets.only(bottom: 16.0),
    );

    final themeDataDesktop = MaterialDesktopVideoControlsThemeData(
      seekBarPositionColor: Theme.of(context).primaryColor,
      seekBarThumbColor: Theme.of(context).primaryColor,
      modifyVolumeOnScroll: false,
      displaySeekBar: false,
      automaticallyImplySkipNextButton: false,
      automaticallyImplySkipPreviousButton: false,
      primaryButtonBar: [],
      bottomButtonBar: [],
      playAndPauseOnTap: false,
    );

    final themeDataDesktopFull = MaterialDesktopVideoControlsThemeData(
      seekBarPositionColor: Theme.of(context).primaryColor,
      seekBarThumbColor: Theme.of(context).primaryColor,
      modifyVolumeOnScroll: false,
      automaticallyImplySkipNextButton: false,
      automaticallyImplySkipPreviousButton: false,
      playAndPauseOnTap: false,
    );

    return Stack(
      children: [
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (event) {
            if (isAudioFile) return;
            cancelHideTimer();
            setState(() {
              isEnabledButton = true;
              isVisibleControlBar = !isVisibleControlBar;
            });
          },
          onPointerUp: (event) {
            startHideTimer();
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
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
                              isFullscreen = true;
                              await defaultEnterNativeFullscreen();
                              videoKey.currentState?.update(fill: Colors.black);
                            },
                            onExitFullscreen: () async {
                              await defaultExitNativeFullscreen();
                              isFullscreen = false;
                              videoKey.currentState?.update(
                                fill: Colors.transparent,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!isDesktop)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Container(color: Colors.transparent),
                    ),
                ],
              ),
            ),
          ),
        ),
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
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border(
                        top: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 0,
                            right: 0,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                        iconSize: iconSize,
                                        onPressed: () async {
                                          cancelHideTimer();
                                          await controller.player.playOrPause();
                                          startHideTimer();
                                        },
                                        icon: StreamBuilder(
                                          stream:
                                              controller.player.stream.playing,
                                          builder: (context, playing) => Icon(
                                            playing.data == true
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${position.label(reference: duration)} / ${duration.label(reference: duration)}",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                iconSize: iconSize,
                                onPressed: () async {
                                  cancelHideTimer();
                                  final isMute =
                                      controller.player.state.volume == 0;
                                  await controller.player.setVolume(
                                    isMute ? 100 : 0,
                                  );
                                  startHideTimer();
                                },
                                icon: StreamBuilder(
                                  stream: controller.player.stream.volume,
                                  builder: (context, playing) => Icon(
                                    playing.data == 0
                                        ? Icons.volume_off
                                        : Icons.volume_up,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  cancelHideTimer();
                                  await _showMenu();
                                  startHideTimer();
                                },
                                icon: const Icon(Icons.more_horiz),
                                iconSize: iconSize,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SliderTheme(
                                data: SliderThemeData(
                                  overlayShape: SliderComponentShape.noOverlay,
                                  trackHeight: 5.0,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 10.0,
                                  ),
                                ),
                                child: Slider(
                                  thumbColor: Theme.of(context).primaryColor,
                                  activeColor: Theme.of(context).primaryColor,
                                  value: min(
                                    position.inMilliseconds,
                                    duration.inMilliseconds,
                                  ).toDouble(),
                                  secondaryTrackValue: bufferPosition
                                      .inMilliseconds
                                      .toDouble(),
                                  min: 0,
                                  max: duration.inMilliseconds.toDouble(),
                                  onChangeStart: (value) {
                                    cancelHideTimer();
                                    isSeeking = true;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      position = Duration(
                                        milliseconds: value.toInt(),
                                      );
                                    });
                                  },
                                  onChangeEnd: (value) async {
                                    await controller.player.seek(position);
                                    isSeeking = false;
                                    startHideTimer();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void startHideTimer() {
    if (isAudioFile) return;
    timer?.cancel();
    timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        isVisibleControlBar = false;
      });
    });
  }

  void cancelHideTimer() {
    if (isAudioFile) return;
    timer?.cancel();
  }
}
