import "dart:convert";
import "dart:typed_data";
import "dart:ui" as ui;

import "package:dio/dio.dart";
import "package:flutter/rendering.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:miria/model/bubble_game/mono.dart";

/// SVGを画像に変換するときの一辺の大きさ。
const _svgRasterSize = 256;

/// モノの画像をインスタンスから読み込んで保持する。
///
/// 画像は本家のクライアントと同じく`/client-assets/drop-and-fusion/`以下にある。
/// スイーツモードだけSVGなので、描画しやすいように画像へ変換している。
class MonoTextures {
  const MonoTextures(this._images);

  final Map<String, ui.Image> _images;

  ui.Image? operator [](Mono mono) => _images[mono.id];

  static Future<MonoTextures> load({
    required Dio dio,
    required Uri host,
    required List<Mono> monos,
  }) async {
    final images = <String, ui.Image>{};

    await Future.wait([
      for (final mono in monos)
        _loadOne(dio, host, mono).then((image) {
          if (image != null) images[mono.id] = image;
        }),
    ]);

    return MonoTextures(images);
  }

  static Future<ui.Image?> _loadOne(Dio dio, Uri host, Mono mono) async {
    try {
      final response = await dio.getUri<List<int>>(
        host.replace(path: mono.img),
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null) return null;

      if (mono.img.endsWith(".svg")) {
        return await _rasterizeSvg(utf8.decode(bytes));
      }

      final codec = await ui.instantiateImageCodec(Uint8List.fromList(bytes));
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (_) {
      // 画像が取れなくても図形で描けるのでゲーム自体は続けられる
      return null;
    }
  }

  static Future<ui.Image> _rasterizeSvg(String source) async {
    final pictureInfo = await vg.loadPicture(SvgStringLoader(source), null);
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.scale(
        _svgRasterSize / pictureInfo.size.width,
        _svgRasterSize / pictureInfo.size.height,
      );
      canvas.drawPicture(pictureInfo.picture);
      final picture = recorder.endRecording();
      try {
        return await picture.toImage(_svgRasterSize, _svgRasterSize);
      } finally {
        picture.dispose();
      }
    } finally {
      pictureInfo.picture.dispose();
    }
  }

  void dispose() {
    for (final image in _images.values) {
      image.dispose();
    }
  }
}
