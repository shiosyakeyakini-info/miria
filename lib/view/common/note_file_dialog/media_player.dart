import "dart:async";
import "dart:ffi";
import "dart:math";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:miria/l10n/app_localizations.dart";

import "package:url_launcher/url_launcher_string.dart";
import "package:video_player/video_player.dart";

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
  //late final videoKey = GlobalKey<VideoState>();
  late final VideoPlayerController controller;
  late final bool isAudioFile;

  MediaPlayerState() {
    _listener = () {
      // 検知したタイミングで再描画する
      setState(() {});
    };
  }

  bool isSeeking = false;
  bool isMute = false;

  @override
  void initState() {
    super.initState();
    isAudioFile = widget.fileType.startsWith("audio");
    if (isAudioFile) {
      isVisibleControlBar = true;
      isEnabledButton = true;
    }

    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {
          aspectRatio = controller.value.aspectRatio;
          controller.play();
        });
      });
    controller.addListener(_listener);
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }

  double aspectRatio = 1;

  int lastTapTime = 0;
  bool isVisibleControlBar = false;
  bool isEnabledButton = false;
  bool isFullScreen = false;
  Timer? timer;

  late final VoidCallback _listener;

  Duration position = const Duration(seconds: 0);
  final double iconSize = 30.0;

  Future<void> showMenu() async {
    await showModalBottomSheet<void>(
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
                unawaited(
                  launchUrlString(
                    widget.url,
                    mode: LaunchMode.externalApplication,
                  ),
                );
              },
            ),
            if (!isAudioFile)
              ListTile(
                leading: const Icon(Icons.fullscreen),
                title: Text(S.of(context).changeFullScreen),
                onTap: () async {
                  Navigator.of(innerContext).pop();
                  /*(videoKey.currentState
                                                      ?.enterFullscreen();*/
                },
              ),
          ],
        );
      },
    );
  }

  String formatDuration(Duration duration, {required Duration reference}) {
    // ignore: parameter_assignments
    duration = duration.abs();
    // ignore: parameter_assignments
    reference = reference.abs();

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return (duration.inHours > 0 || reference.inHours > 0)
        ? "$hours:$minutes:$seconds"
        : "$minutes:$seconds";
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

  @override
  Widget build(BuildContext context) {
    if (!isSeeking) {
      position = controller.value.position;
    }
    final duration = controller.value.duration;
    var maxBuffering = 0;
    for (final range in controller.value.buffered) {
      final end = range.end.inMilliseconds;
      if (end > maxBuffering) {
        maxBuffering = end;
      }
    }
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
                      child: VideoPlayer(controller),
                    ),
                  ),
                  if (controller.value.isBuffering)
                    const Center(
                      child: SizedBox.square(
                        dimension: 32,
                        child: CircularProgressIndicator(),
                      ),
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
            child: _buildControlBar(duration, maxBuffering),
          ),
        ),
      ],
    );
  }

  Widget _buildControlBar(Duration duration, int maxBuffering) {
    return Stack(
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
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (event) {
                cancelHideTimer();
              },
              onPointerUp: (event) {
                startHideTimer();
              },
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
                                    if (controller.value.isPlaying) {
                                      await controller.pause();
                                    } else {
                                      await controller.play();
                                    }
                                  },
                                  icon: Icon(
                                    controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                ),
                              ),
                              Text(
                                formatDuration(position, reference: duration),
                                textAlign: TextAlign.center,
                              ),
                              const Text(" / "),
                              Text(
                                formatDuration(duration, reference: position),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 5)),
                        IconButton(
                          iconSize: iconSize,
                          onPressed: () {
                            unawaited(controller.setVolume(isMute ? 100 : 0));
                            isMute = !isMute;
                          },
                          icon: Icon(
                            isMute ? Icons.volume_off : Icons.volume_up,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await showMenu();
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
                            value: position.abs().inMilliseconds.toDouble(),
                            secondaryTrackValue: maxBuffering.toDouble(),
                            min: 0,
                            max: duration.abs().inMilliseconds.toDouble(),
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
                            onChangeEnd: (value) {
                              controller.seekTo(position);
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
        ),
      ],
    );
  }
}
