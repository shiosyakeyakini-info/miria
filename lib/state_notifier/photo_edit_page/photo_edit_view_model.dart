import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_editor/image_editor.dart';
import 'package:miria/model/image_file.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/state_notifier/photo_edit_page/color_filter_preset.dart';

part 'photo_edit_view_model.freezed.dart';

@freezed
class PhotoEdit with _$PhotoEdit {
  const factory PhotoEdit({
    @Default(false) bool clipMode,
    @Default(false) bool colorFilterMode,
    @Default([]) List<ColorFilterPreview> colorFilterPreviewImages,
    @Default([]) List<String> adaptivePresets,
    @Default(false) bool isInitialized,
    Uint8List? initialImage,
    Uint8List? editedImage,
    @Default(Offset(0, 0)) Offset cropOffset,
    @Default(Size.zero) Size cropSize,
    @Default(Size.zero) Size defaultSize,
    @Default(Size.zero) Size actualSize,
    @Default(0) int angle,
    @Default([]) List<EditedEmojiData> emojis,
  }) = _PhotoEdit;
}

@freezed
class ColorFilterPreview with _$ColorFilterPreview {
  const factory ColorFilterPreview({required String name, Uint8List? image}) =
      _ColorFilterPreview;
}

@freezed
class EditedEmojiData with _$EditedEmojiData {
  const factory EditedEmojiData({
    required MisskeyEmojiData emoji,
    required Size size,
    required Offset position,
    required double angle,
  }) = _EditedEmojiData;
}

class PhotoEditStateNotifier extends StateNotifier<PhotoEdit> {
  PhotoEditStateNotifier(super.state);

  Future<void> initialize(MisskeyPostFile file) async {
    if (state.isInitialized) return;
    Uint8List initialImage;
    switch (file) {
      case ImageFile():
        initialImage = file.data;
        break;
      case ImageFileAlreadyPostedFile():
        initialImage = file.data;
        break;
      default:
        throw UnsupportedError("$file is unsupported.");
    }
    final imageData = await ImageDescriptor.encoded(
        await ImmutableBuffer.fromUint8List(initialImage));
    final defaultSize =
        Size(imageData.width.toDouble(), imageData.height.toDouble());

    state = state.copyWith(
      isInitialized: true,
      initialImage: initialImage,
      editedImage: initialImage,
      defaultSize: defaultSize,
      cropSize: defaultSize,
    );
  }

  Future<void> draw(PhotoEdit attemptState) async {
    final initialImage = state.initialImage;
    if (initialImage == null) return;
    final editorOption = ImageEditorOption();

    if (attemptState.angle != 0) {
      editorOption.addOption(RotateOption(attemptState.angle));
    }
    if (!attemptState.clipMode) {
      final offset = attemptState.cropOffset;
      final size = attemptState.cropSize;
      editorOption.addOption(ClipOption(
          x: offset.dx, y: offset.dy, width: size.width, height: size.height));
    }

    final presets = ColorFilterPresets().presets;
    for (final colorPreset in attemptState.adaptivePresets) {
      editorOption.addOptions(
          presets.firstWhere((element) => element.name == colorPreset).option);
    }

    state = attemptState.copyWith(
        editedImage: await ImageEditor.editImage(
            image: initialImage, imageEditorOption: editorOption));
  }

  Offset resolveRotatedOffset(
      Offset cropOffset, Size cropSize, Size defaultSize, int angle) {
    final rotatedX = defaultSize.width - cropSize.width - cropOffset.dx;
    return Offset(cropOffset.dy, rotatedX);
  }

  void rotate() {
    final angle = ((state.angle - 90) % 360).abs();
    draw(state.copyWith(
      angle: angle,
      defaultSize: Size(state.defaultSize.height, state.defaultSize.width),
      cropSize: Size(state.cropSize.height, state.cropSize.width),
      cropOffset: resolveRotatedOffset(
          state.cropOffset, state.cropSize, state.defaultSize, angle),
    ));
  }

  void crop() {
    draw(state.copyWith(clipMode: !state.clipMode, colorFilterMode: false));
  }

  void decideDrawArea(Size size) {
    state = state.copyWith(actualSize: size);
  }

  PhotoEdit validateCrop(PhotoEdit state) {
    final size = state.cropSize;
    final defaultSize = state.defaultSize;
    final offset = state.cropOffset;
    final validatedCropSize = Size(
        max(0, min(size.width, defaultSize.width - offset.dx + 1)),
        max(0, min(size.height, defaultSize.height - offset.dy + 1)));
    final validateOffset = Offset(max(0, min(offset.dx, defaultSize.width)),
        max(0, min(offset.dy, defaultSize.height)));

    return state.copyWith(
      cropSize: validatedCropSize,
      cropOffset: validateOffset,
    );
  }

  void cropMoveLeftTop(PointerMoveEvent detail) {
    state = validateCrop(state.copyWith(
        cropOffset: state.cropOffset + detail.localDelta,
        cropSize: Size(state.cropSize.width - detail.localDelta.dx,
            state.cropSize.height - detail.localDelta.dy)));
  }

  void cropMoveRightTop(PointerMoveEvent detail) {
    state = validateCrop(state.copyWith(
        cropOffset: Offset(
            state.cropOffset.dx, state.cropOffset.dy + detail.localDelta.dy),
        cropSize: Size(state.cropSize.width + detail.localDelta.dx,
            state.cropSize.height - detail.localDelta.dy)));
  }

  void cropMoveLeftBottom(PointerMoveEvent detail) {
    state = validateCrop(state.copyWith(
        cropOffset: Offset(
            state.cropOffset.dx + detail.localDelta.dx, state.cropOffset.dy),
        cropSize: Size(state.cropSize.width - detail.localDelta.dx,
            state.cropSize.height + detail.localDelta.dy)));
  }

  void cropMoveRightBottom(PointerMoveEvent detail) {
    state = validateCrop(state.copyWith(
        cropOffset: Offset(state.cropOffset.dx, state.cropOffset.dy),
        cropSize: Size(state.cropSize.width + detail.localDelta.dx,
            state.cropSize.height + detail.localDelta.dy)));
  }

  Future<void> colorFilter() async {
    state = state.copyWith(
      clipMode: false,
      colorFilterMode: !state.colorFilterMode,
    );
    if (!state.colorFilterMode) return;

    final editedImage = state.editedImage;
    if (editedImage == null) return;
    final previewImage = await ImageEditor.editImage(
        image: editedImage,
        imageEditorOption: ImageEditorOption()
          ..addOption(const ScaleOption(300, 300, keepRatio: true)));
    if (previewImage == null) return;
    final result = [
      for (final preset in ColorFilterPresets().presets)
        ColorFilterPreview(
            name: preset.name,
            image: await ImageEditor.editImage(
                image: previewImage,
                imageEditorOption: ImageEditorOption()
                  ..addOptions(preset.option)))
    ].whereNotNull();

    state = state.copyWith(colorFilterPreviewImages: result.toList());
  }

  void selectColorFilter(String name) {
    if (state.adaptivePresets.any((element) => element == name)) {
      final list = state.adaptivePresets.toList();
      list.removeWhere((element) => element == name);
      draw(state.copyWith(adaptivePresets: list));
    } else {
      draw(state.copyWith(adaptivePresets: [...state.adaptivePresets, name]));
    }
  }
}
