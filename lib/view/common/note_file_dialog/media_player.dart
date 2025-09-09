import "dart:async";
import "dart:io";
import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:fvp/fvp.dart" as fvp;
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/const.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/view/common/dialog/dialog_state.dart";
import "package:url_launcher/url_launcher_string.dart";
import "package:video_player/video_player.dart";
import "package:video_player_android/video_player_android.dart";
import "package:video_player_avfoundation/video_player_avfoundation.dart";
import "package:video_player_platform_interface/video_player_platform_interface.dart";
import "package:window_manager/window_manager.dart";

class MediaPlayer extends ConsumerStatefulWidget {
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

class MediaPlayerState extends ConsumerState<MediaPlayer>
    with _MediaPlayerMixin {
  @override
  VideoPlayerController get videoController => controller;

  late final VideoPlayerController controller;
  late final VoidCallback _listener;
  bool isErrorDialogShown = false;
  bool isFullScreen = false;

  MediaPlayerState() {
    _listener = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  void initState() {
    super.initState();
    isAudioFile = widget.fileType.startsWith("audio");
    if (isAudioFile) {
      isVisibleControlBar = true;
      isEnabledButton = true;
    }

    // movファイル等でバッファリング問題が起きやすいため
    // iOS/Androidではオーディオファイル以外にAVPlayer/ExoPlayerを使用する
    if (!isDesktop && !isAudioFile) {
      if (Platform.isAndroid &&
          VideoPlayerPlatform.instance is! AndroidVideoPlayer) {
        VideoPlayerPlatform.instance = AndroidVideoPlayer();
      } else if (Platform.isIOS &&
          VideoPlayerPlatform.instance is! AVFoundationVideoPlayer) {
        VideoPlayerPlatform.instance = AVFoundationVideoPlayer();
      }
    } else {
      fvp.registerWith(
        options: {
          //"global": {"ffmpeg.log": "debug"},
          "player": {
            "demux.buffer.ranges": "8", // ループ再生時のバッファリング緩和
            //"avformat.probesize": "10M", // 解析上限容量
            //"avformat.analyzeduration": "5M", // 解析上限時間(10M = 10s)
          },
        },
      );
    }

    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    controller
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() {
            controller.play();
          });
        })
        .catchError((error) async {
          if (!mounted || isErrorDialogShown) return;
          isErrorDialogShown = true;
          await ref
              .read(dialogStateNotifierProvider.notifier)
              .showSimpleDialog(
                message: (context) => S.of(context).thrownError,
              );
          if (!mounted) return;
          Navigator.of(context).pop();
        });
    controller.addListener(_listener);
  }

  @override
  void dispose() {
    controller
      ..removeListener(_listener)
      ..dispose();
    super.dispose();
  }

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
                  isFullScreen = true;
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          _FullScreenMediaPlayer(controller: controller),
                    ),
                  );
                  isFullScreen = false;
                },
              ),
            ListTile(
              leading: const Icon(Icons.repeat),
              title: Text(S.of(context).loopPlayback),
              trailing: controller.value.isLooping
                  ? const Icon(Icons.check)
                  : null,
              onTap: () async {
                Navigator.of(innerContext).pop();
                await controller.setLooping(!controller.value.isLooping);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Align(
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: (!isFullScreen)
                          ? _VideoPlayer(
                              controller: controller,
                              isFullscreen: false,
                            )
                          : Container(),
                    ),
                  ),
                  if (!controller.value.isInitialized ||
                      controller.value.isBuffering)
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
            child: _buildControlBar(),
          ),
        ),
      ],
    );
  }

  Widget _buildControlBar() {
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

    return IconTheme(
      data: IconThemeData(size: 30.0, color: IconTheme.of(context).color),
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
                            onPressed: () => showPlaybackSpeedMenu(context),
                            onLongPress: () => resetPlaybackSpeed(),
                            icon: Icon(Icons.speed),
                          ),
                          IconButton(
                            onPressed: () async {
                              await controller.setVolume(
                                controller.value.volume == 0 ? 1.0 : 0,
                              );
                            },
                            icon: Icon(
                              controller.value.volume == 0
                                  ? Icons.volume_off
                                  : Icons.volume_up,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await showMenu();
                            },
                            icon: const Icon(Icons.more_horiz),
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
                              secondaryTrackValue: maxBuffering
                                  .toDouble()
                                  .clamp(
                                    0.0,
                                    duration.abs().inMilliseconds.toDouble(),
                                  ),
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
                              onChangeEnd: (value) async {
                                await controller.seekTo(position);
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
      ),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isFullscreen;
  const _VideoPlayer({required this.controller, this.isFullscreen = false});
  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  final FocusNode focusNode = FocusNode();
  final seekSeconds = 10;
  final Set<LogicalKeyboardKey> pressedKeys = <LogicalKeyboardKey>{};

  KeyEventResult handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) {
      pressedKeys.remove(event.logicalKey);
      return KeyEventResult.handled;
    }
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    if (pressedKeys.contains(event.logicalKey)) {
      return KeyEventResult.handled;
    }
    pressedKeys.add(event.logicalKey);

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (widget.isFullscreen) {
        Navigator.of(context).pop();
        return KeyEventResult.handled;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.space) {
      if (widget.controller.value.isPlaying) {
        unawaited(widget.controller.pause());
      } else {
        unawaited(widget.controller.play());
      }
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      unawaited(
        widget.controller.setVolume(
          math.max(0.0, widget.controller.value.volume - 0.1),
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      unawaited(
        widget.controller.setVolume(
          math.min(1.0, widget.controller.value.volume + 0.1),
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      final v =
          widget.controller.value.position + Duration(seconds: seekSeconds);
      unawaited(
        widget.controller.seekTo(
          (v > widget.controller.value.duration)
              ? widget.controller.value.duration
              : v,
        ),
      );
      if (!widget.controller.value.isPlaying) {
        unawaited(widget.controller.play());
      }
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      final v =
          widget.controller.value.position - Duration(seconds: seekSeconds);
      unawaited(
        widget.controller.seekTo((v < Duration.zero) ? Duration.zero : v),
      );

      if (!widget.controller.value.isPlaying) {
        unawaited(widget.controller.play());
      }
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.keyF) {
      if (widget.isFullscreen) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                _FullScreenMediaPlayer(controller: widget.controller),
          ),
        );
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: handleKey,
      child: VideoPlayer(widget.controller),
    );
  }
}

class _FullScreenMediaPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  const _FullScreenMediaPlayer({required this.controller});

  @override
  _FullScreenMediaPlayerState createState() => _FullScreenMediaPlayerState();
}

class _FullScreenMediaPlayerState extends State<_FullScreenMediaPlayer>
    with _MediaPlayerMixin {
  @override
  VideoPlayerController get videoController => widget.controller;
  late final VoidCallback _listener;

  double volume = 1.0;

  _FullScreenMediaPlayerState() {
    _listener = () {
      setState(() {});
    };
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
    volume = widget.controller.value.volume;
    unawaited(enterFullScreen());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    unawaited(exitFullScreen());
    super.dispose();
  }

  Future<void> enterFullScreen() async {
    if (isDesktop) {
      await windowManager.setFullScreen(true);
      return;
    }
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> exitFullScreen() async {
    if (isDesktop) {
      await windowManager.setFullScreen(false);
      return;
    }
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              cancelHideTimer();
              setState(() {
                isEnabledButton = true;
                isVisibleControlBar = !isVisibleControlBar;
              });
            },
            onPointerUp: (event) {
              startHideTimer();
            },
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Align(
                      child: AspectRatio(
                        aspectRatio: widget.controller.value.aspectRatio,
                        child: _VideoPlayer(
                          controller: widget.controller,
                          isFullscreen: true,
                        ),
                      ),
                    ),
                    if (!widget.controller.value.isInitialized ||
                        widget.controller.value.isBuffering)
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
              child: _buildControlBar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    if (!isSeeking) {
      position = widget.controller.value.position;
    }

    final duration = widget.controller.value.duration;
    var maxBuffering = 0;
    for (final range in widget.controller.value.buffered) {
      final end = range.end.inMilliseconds;
      if (end > maxBuffering) {
        maxBuffering = end;
      }
    }
    return IconTheme(
      data: IconThemeData(size: 30.0, color: Colors.white),
      child: DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                width: MediaQuery.of(context).size.width,
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
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
                          bottom: 5,
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
                                      onPressed: () async {
                                        if (widget.controller.value.isPlaying) {
                                          await widget.controller.pause();
                                        } else {
                                          await widget.controller.play();
                                        }
                                      },
                                      icon: Icon(
                                        widget.controller.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatDuration(
                                      position,
                                      reference: duration,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Text(" / "),
                                  Text(
                                    formatDuration(
                                      duration,
                                      reference: position,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await widget.controller.setVolume(
                                        widget.controller.value.volume == 0
                                            ? volume
                                            : 0,
                                      );
                                    },
                                    icon: Icon(
                                      widget.controller.value.volume == 0
                                          ? Icons.volume_off
                                          : Icons.volume_up,
                                    ),
                                  ),
                                  SliderTheme(
                                    data: SliderThemeData(
                                      overlayShape:
                                          SliderComponentShape.noOverlay,
                                      trackHeight: 3.0,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6.0,
                                      ),
                                    ),
                                    child: Slider(
                                      thumbColor: Colors.white,
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.grey,
                                      value: widget.controller.value.volume,
                                      min: 0,
                                      max: 1.0,
                                      onChangeStart: (value) {
                                        cancelHideTimer();
                                      },
                                      onChanged: (value) async {
                                        await widget.controller.setVolume(
                                          value,
                                        );
                                        volume = value;
                                      },
                                      onChangeEnd: (value) async {
                                        await widget.controller.setVolume(
                                          value,
                                        );
                                        volume = value;
                                        startHideTimer();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 5)),
                            IconButton(
                              onPressed: () => widget.controller.setLooping(
                                !widget.controller.value.isLooping,
                              ),
                              icon: Icon(
                                widget.controller.value.isLooping
                                    ? Icons.repeat_on
                                    : Icons.repeat,
                              ),
                            ),
                            IconButton(
                              onPressed: () => showPlaybackSpeedMenu(context),
                              onLongPress: () => resetPlaybackSpeed(),
                              icon: Icon(Icons.speed),
                            ),

                            IconButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).removeRoute(ModalRoute.of(context)!);
                              },
                              icon: const Icon(Icons.fullscreen_exit),
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
                                trackHeight: 3.0,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6.0,
                                ),
                              ),
                              child: Slider(
                                thumbColor: Theme.of(context).primaryColor,
                                activeColor: Theme.of(context).primaryColor,
                                value: position.abs().inMilliseconds.toDouble(),
                                secondaryTrackValue: maxBuffering
                                    .toDouble()
                                    .clamp(
                                      0.0,
                                      duration.abs().inMilliseconds.toDouble(),
                                    ),
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
                                onChangeEnd: (value) async {
                                  await widget.controller.seekTo(position);
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
        ),
      ),
    );
  }
}

mixin _MediaPlayerMixin<T extends StatefulWidget> on State<T> {
  VideoPlayerController get videoController;
  Timer? timer;
  bool isVisibleControlBar = false;
  bool isAudioFile = false;
  bool isSeeking = false;
  bool isEnabledButton = false;

  Duration position = const Duration(seconds: 0);

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
    timer?.cancel();
  }

  Future<void> showPlaybackSpeedMenu(BuildContext context) async {
    final speeds = [
      0.25,
      0.50,
      0.75,
      1.00,
      1.25,
      1.50,
      2.00,
      2.25,
      2.50,
      2.75,
      3.0,
    ];
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            ...speeds.map((speed) {
              return ListTile(
                title: Text("${speed.toStringAsFixed(2)}x"),
                leading: videoController.value.playbackSpeed == speed
                    ? const Icon(Icons.check)
                    : SizedBox(width: Theme.of(context).iconTheme.size),
                onTap: () async {
                  await videoController.setPlaybackSpeed(speed);
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
              );
            }),
          ],
        );
      },
    );
  }

  Future<void> resetPlaybackSpeed() async {
    await videoController.setPlaybackSpeed(1.0);
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
}
