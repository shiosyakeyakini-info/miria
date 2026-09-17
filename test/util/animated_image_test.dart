import "dart:async";
import "dart:ui" as ui;

import "package:flutter/foundation.dart";
import "package:flutter/painting.dart";
import "package:flutter_test/flutter_test.dart";
import "package:image/image.dart" as img;
import "package:miria/util/animated_image.dart";

/// 指定した遅延を持つ 2 フレームの APNG をつくる。
///
/// [delay] が [Duration.zero] のときは `delay_num` が 0、つまりカスタム絵文字で
/// 実際に問題になっている「遅延が書かれていない」APNG になる。
Uint8List animatedPng({required Duration delay, int frames = 2}) {
  final animation = img.Image(width: 4, height: 4, numChannels: 4)
    ..frameDuration = delay.inMilliseconds;
  img.fill(animation, color: img.ColorRgba8(255, 0, 0, 255));

  for (var i = 1; i < frames; i++) {
    final frame = animation.addFrame()..frameDuration = delay.inMilliseconds;
    img.fill(frame, color: img.ColorRgba8(0, 255 - i * 16, 0, 255));
  }

  return Uint8List.fromList(img.encodePng(animation));
}

Uint8List stillPng() {
  final image = img.Image(width: 4, height: 4, numChannels: 4);
  img.fill(image, color: img.ColorRgba8(255, 0, 0, 255));
  return Uint8List.fromList(img.encodePng(image));
}

Future<List<Duration>> durationsOf(ui.Codec codec) async {
  final durations = <Duration>[];
  for (var i = 0; i < codec.frameCount; i++) {
    final frame = await codec.getNextFrame();
    durations.add(frame.duration);
    frame.image.dispose();
  }
  return durations;
}

Future<ui.Codec> decodeImage(Uint8List bytes) =>
    ui.instantiateImageCodec(bytes);

void main() {
  group("resolveFrameDelay", () {
    test("遅延なしはブラウザと同じ 100ms に読み替える", () {
      expect(resolveFrameDelay(Duration.zero), kFallbackFrameDelay);
      expect(
        resolveFrameDelay(const Duration(milliseconds: 10)),
        kFallbackFrameDelay,
      );
    });

    test("指定のある遅延はそのまま", () {
      expect(
        resolveFrameDelay(const Duration(milliseconds: 11)),
        const Duration(milliseconds: 11),
      );
      expect(
        resolveFrameDelay(const Duration(seconds: 1)),
        const Duration(seconds: 1),
      );
    });
  });

  group("withFrameDelayFallback", () {
    test("遅延が書かれていない APNG は 100ms になる", () async {
      final codec = await decodeImage(animatedPng(delay: Duration.zero));

      // Skia は書かれていない遅延を 0 のまま返す。ここが速すぎる原因。
      expect(codec.frameCount, 2);
      expect(await durationsOf(codec), everyElement(Duration.zero));

      final wrapped = withFrameDelayFallback(
        await decodeImage(animatedPng(delay: Duration.zero)),
      );
      expect(await durationsOf(wrapped), List.filled(2, kFallbackFrameDelay));
    });

    test("遅延が書かれている APNG には触らない", () async {
      final wrapped = withFrameDelayFallback(
        await decodeImage(animatedPng(delay: const Duration(milliseconds: 40))),
      );
      expect(
        await durationsOf(wrapped),
        List.filled(2, const Duration(milliseconds: 40)),
      );
    });

    test("静止画は包まない", () async {
      final codec = await decodeImage(stillPng());
      expect(withFrameDelayFallback(codec), same(codec));
    });

    test("フレーム数と繰り返し回数は元のまま", () async {
      final codec = await decodeImage(
        animatedPng(delay: Duration.zero, frames: 3),
      );
      final wrapped = withFrameDelayFallback(codec);
      expect(wrapped.frameCount, codec.frameCount);
      expect(wrapped.repetitionCount, codec.repetitionCount);
    });
  });

  group("FrameDelayFallbackImage", () {
    test("キャッシュのキーは包んだ側のものを使う", () async {
      final inner = _FakeImageProvider();
      final key = await const FrameDelayFallbackImage(
        _FakeImageProvider(),
      ).obtainKey(ImageConfiguration.empty);

      expect(key, await inner.obtainKey(ImageConfiguration.empty));
    });

    test("同じ画像を包んだものは等しい", () {
      expect(
        const FrameDelayFallbackImage(_FakeImageProvider()),
        const FrameDelayFallbackImage(_FakeImageProvider()),
      );
      expect(
        const FrameDelayFallbackImage(_FakeImageProvider()).hashCode,
        const FrameDelayFallbackImage(_FakeImageProvider()).hashCode,
      );
    });

    test("包んだ側のデコードに遅延の補正が挟まる", () async {
      const FrameDelayFallbackImage(_FakeImageProvider()).loadImage(
        "fake",
        (buffer, {getTargetSize}) => ui.instantiateImageCodecWithSize(
          buffer,
          getTargetSize: getTargetSize,
        ),
      );

      final decode = _FakeImageProvider.lastDecode!;
      final codec = await decode(
        await ui.ImmutableBuffer.fromUint8List(
          animatedPng(delay: Duration.zero),
        ),
      );

      expect(await durationsOf(codec), List.filled(2, kFallbackFrameDelay));
    });
  });
}

/// 渡された decode を覚えておくだけの [ImageProvider]。
class _FakeImageProvider extends ImageProvider<String> {
  const _FakeImageProvider();

  static ImageDecoderCallback? lastDecode;

  @override
  Future<String> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture("fake");

  @override
  ImageStreamCompleter loadImage(String key, ImageDecoderCallback decode) {
    lastDecode = decode;
    return OneFrameImageStreamCompleter(Completer<ImageInfo>().future);
  }

  @override
  bool operator ==(Object other) => other is _FakeImageProvider;

  @override
  int get hashCode => (_FakeImageProvider).hashCode;
}
