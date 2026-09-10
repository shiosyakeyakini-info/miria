import "dart:io";

import "package:flutter/foundation.dart";
import "package:image/image.dart" as img;
import "package:image_editor/image_editor.dart";

/// image_editor がプラグインの実装を持つのは android / ios / macos / ohos だけで、
/// デスクトップでは [ImageEditorPlatform.instance] が [UnsupportedImageEditor] の
/// ままになり、画像編集がまるごと使えない。
///
/// ネイティブ実装が刺さらなかったときだけ、package:image で同じことをする
/// [DartImageEditor] を差し込む。
void registerDartImageEditor() {
  if (ImageEditorPlatform.instance is UnsupportedImageEditor) {
    ImageEditorPlatform.instance = DartImageEditor();
  }
}

/// 画像編集が使えるかどうか。
///
/// プラットフォーム名ではなく実装が刺さっているかで判定する。
bool get isImageEditorAvailable =>
    ImageEditorPlatform.instance is! UnsupportedImageEditor;

/// package:image による [ImageEditorPlatform] の実装。
///
/// ネイティブ実装（android の Bitmap、ios/macos の CoreImage）と結果を揃えることを
/// 目的にしていて、色行列は android.graphics.ColorMatrix 準拠、つまり平行移動の列が
/// 0-255 スケールであることを前提にしている。package:image は 8bit の生の値に
/// そのまま行列をかけるので、何もしなければその前提に一致する。
class DartImageEditor extends ImageEditorPlatform {
  @override
  Future<Uint8List?> editImage({
    required Uint8List image,
    required ImageEditorOption imageEditorOption,
  }) => compute(_editImage, (image: image, option: imageEditorOption));

  @override
  Future<Uint8List?> editFileImage({
    required File file,
    required ImageEditorOption imageEditorOption,
  }) async => editImage(
    image: await file.readAsBytes(),
    imageEditorOption: imageEditorOption,
  );

  @override
  Future<File> editImageAndGetFile({
    required Uint8List image,
    required ImageEditorOption imageEditorOption,
  }) async {
    final result = await editImage(
      image: image,
      imageEditorOption: imageEditorOption,
    );
    if (result == null) {
      throw HandleError("failed to decode the source image");
    }
    final target = File(
      "${Directory.systemTemp.path}"
      "/dart_image_editor_${DateTime.now().microsecondsSinceEpoch}",
    );
    return target.writeAsBytes(result);
  }

  @override
  Future<File?> editFileImageAndGetFile({
    required File file,
    required ImageEditorOption imageEditorOption,
  }) async => editImageAndGetFile(
    image: await file.readAsBytes(),
    imageEditorOption: imageEditorOption,
  );

  /// 複数枚の合成はmiriaが使っておらず、実装していない。
  @override
  Future<Uint8List?> mergeToMemory({required ImageMergeOption option}) =>
      throw UnimplementedError("merge is not supported by $runtimeType");

  /// 複数枚の合成はmiriaが使っておらず、実装していない。
  @override
  Future<File?> mergeToFile({required ImageMergeOption option}) =>
      throw UnimplementedError("merge is not supported by $runtimeType");
}

Uint8List? _editImage(({Uint8List image, ImageEditorOption option}) request) {
  final img.Image? decoded;
  try {
    decoded = img.decodeImage(request.image);
  } catch (_) {
    // 画像として壊れていると、デコーダの判定が範囲外まで読みにいくことがある
    return null;
  }
  if (decoded == null) return null;

  // ネイティブ実装はEXIFの向きを見ないし結果にも残さないので、ここでも捨てる。
  // copyResizeが向きを勝手に焼き込むのを防ぐ意味もある。
  var result = decoded..exif = img.ExifData();
  for (final option in request.option.options) {
    if (option.canIgnore) continue;
    result = _apply(result, option);
  }

  // ImageFormat 自体は image_editor から export されていないので、
  // 既知の OutputFormat と引き比べる
  final format = request.option.outputFormat;
  return format.format == const OutputFormat.png().format
      ? img.encodePng(result)
      : img.encodeJpg(result, quality: format.quality);
}

img.Image _apply(img.Image image, Option option) {
  switch (option) {
    case ClipOption():
      return img.copyCrop(
        image,
        x: option.x.round(),
        y: option.y.round(),
        width: option.width.round(),
        height: option.height.round(),
      );

    case RotateOption():
      // androidのMatrix#postRotateと同じく時計回り、補間つき
      return img.copyRotate(
        image,
        angle: option.degree,
        interpolation: img.Interpolation.linear,
      );

    case FlipOption():
      return img.flip(
        image,
        direction: switch ((option.horizontal, option.vertical)) {
          (true, true) => img.FlipDirection.both,
          (true, false) => img.FlipDirection.horizontal,
          (false, _) => img.FlipDirection.vertical,
        },
      );

    case ScaleOption():
      var width = option.width;
      var height = option.height;
      if (option.keepRatio) {
        // 端数の落とし方までandroidの実装に合わせる
        final ratio = image.width / image.height;
        if (option.keepWidthFirst) {
          height = (width / ratio).toInt();
        } else {
          width = (ratio * height).toInt();
        }
      }
      return img.copyResize(
        image,
        width: width,
        height: height,
        interpolation: (width < image.width || height < image.height)
            ? img.Interpolation.average
            : img.Interpolation.linear,
      );

    case ColorOption():
      return _applyColorMatrix(image, option.matrix);

    default:
      throw UnimplementedError(
        "${option.key} is not supported by DartImageEditor",
      );
  }
}

/// android.graphics.ColorMatrix と同じ 4x5 行列をかける。
///
/// 第5列は平行移動で、0-255スケールであることに注意。
img.Image _applyColorMatrix(img.Image image, List<double> matrix) {
  final result = image.convert(format: img.Format.uint8, numChannels: 4);
  for (final pixel in result) {
    final (r, g, b, a) = (pixel.r, pixel.g, pixel.b, pixel.a);
    pixel.setRgba(
      _channel(matrix, 0, r, g, b, a),
      _channel(matrix, 5, r, g, b, a),
      _channel(matrix, 10, r, g, b, a),
      _channel(matrix, 15, r, g, b, a),
    );
  }
  return result;
}

int _channel(List<double> matrix, int offset, num r, num g, num b, num a) =>
    (matrix[offset] * r +
            matrix[offset + 1] * g +
            matrix[offset + 2] * b +
            matrix[offset + 3] * a +
            matrix[offset + 4])
        .round()
        .clamp(0, 255);
