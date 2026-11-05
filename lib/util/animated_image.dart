/// アニメーションGIF / APNG / アニメーションWebP のフレーム遅延を、ブラウザと
/// 同じ規則で補正する。
///
/// APNG の `delay_num` や WebP の frame duration は省略・0 指定ができる。
/// 仕様上はそれを「できるだけ速く」と読むが、実際のブラウザはどれも
/// そう読まない。Chromium も Firefox も 10ms 以下の遅延は書き手の指定漏れと
/// みなして 100ms に読み替える（Blink の `DeferredImageDecoder`、Gecko の
/// `FrameAnimator`）。カスタム絵文字にはこの手の遅延なしの画像がそこそこ
/// 紛れており、Misskey をブラウザで見るぶんにはその読み替えのおかげで
/// 普通の速さに見えている。
///
/// Flutter は Skia が返す遅延をそのまま使うので、同じ絵文字が 1 フレーム
/// 1 vsync で回る。60fps で目に痛い速度になるうえ、毎フレーム再描画が走る。
/// ブラウザ側の読み替えをこちらでも入れて、見え方を合わせる。
library;

import "dart:ui" as ui;

import "package:flutter/foundation.dart";
import "package:flutter/painting.dart";

/// これ以下の遅延は「指定されていない」とみなす。
const kUnsetFrameDelay = Duration(milliseconds: 10);

/// 指定されていないときに使う遅延。ブラウザに合わせて 100ms。
const kFallbackFrameDelay = Duration(milliseconds: 100);

/// フレーム遅延をブラウザと同じ規則で読み替える。
Duration resolveFrameDelay(Duration delay) =>
    delay <= kUnsetFrameDelay ? kFallbackFrameDelay : delay;

/// アニメーションなら、フレーム遅延を補正する [ui.Codec] で包む。
///
/// 1 フレームしかない画像の遅延 0 は「ずっと表示する」であって指定漏れでは
/// ないので、そのまま返す。
ui.Codec withFrameDelayFallback(ui.Codec codec) =>
    codec.frameCount > 1 ? _FrameDelayFallbackCodec(codec) : codec;

/// [decode] が返す codec に [withFrameDelayFallback] を挟む。
ImageDecoderCallback frameDelayFallbackDecoder(ImageDecoderCallback decode) {
  return (
    ui.ImmutableBuffer buffer, {
    ui.TargetImageSizeCallback? getTargetSize,
  }) async => withFrameDelayFallback(
    await decode(buffer, getTargetSize: getTargetSize),
  );
}

/// 遅延を補正した [ui.Codec]。フレームの取り出し以外は元の codec に流す。
class _FrameDelayFallbackCodec implements ui.Codec {
  _FrameDelayFallbackCodec(this._codec);

  final ui.Codec _codec;

  @override
  int get frameCount => _codec.frameCount;

  @override
  int get repetitionCount => _codec.repetitionCount;

  @override
  Future<ui.FrameInfo> getNextFrame() async {
    final frame = await _codec.getNextFrame();
    final delay = resolveFrameDelay(frame.duration);
    if (delay == frame.duration) return frame;
    return _FrameInfo(image: frame.image, duration: delay);
  }

  @override
  void dispose() => _codec.dispose();
}

/// 遅延だけ差し替えた [ui.FrameInfo]。
///
/// [ui.FrameInfo] はエンジンしか作れないので、実装を用意して被せている。
/// 画像は元のフレームのものをそのまま持つ（破棄の責任も呼び出し側のまま）。
class _FrameInfo implements ui.FrameInfo {
  const _FrameInfo({required this.image, required this.duration});

  @override
  final ui.Image image;

  @override
  final Duration duration;
}

/// 画像の読み込みを [image] に任せつつ、フレーム遅延だけ補正する
/// [ImageProvider]。
///
/// キャッシュのキーは [image] のものをそのまま使う。包む前と後で
/// [ImageCache] の当たり外れが変わらないようにするため。
@immutable
class FrameDelayFallbackImage extends ImageProvider<Object> {
  const FrameDelayFallbackImage(this.image);

  final ImageProvider<Object> image;

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) =>
      image.obtainKey(configuration);

  @override
  ImageStreamCompleter loadImage(Object key, ImageDecoderCallback decode) =>
      image.loadImage(key, frameDelayFallbackDecoder(decode));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrameDelayFallbackImage && other.image == image;

  @override
  int get hashCode => image.hashCode;

  @override
  String toString() => "FrameDelayFallbackImage($image)";
}
