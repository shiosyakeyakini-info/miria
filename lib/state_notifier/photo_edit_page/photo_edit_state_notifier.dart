import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_editor/image_editor.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/misskey_post_file.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/state_notifier/photo_edit_page/color_filter_preset.dart';
import 'package:miria/view/photo_edit_page/license_confirm_dialog.dart';
import 'package:miria/view/reaction_picker_dialog/reaction_picker_dialog.dart';

part 'photo_edit_state_notifier.freezed.dart';

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
    int? selectedEmojiIndex,
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
    required double scale,
    required Offset position,
    required double angle,
  }) = _EditedEmojiData;
}

class PhotoEditStateNotifier extends StateNotifier<PhotoEdit> {
  static final List<String> _acceptReactions = [];

  PhotoEditStateNotifier(super.state);

  /// 状態を初期化する
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
      await ImmutableBuffer.fromUint8List(initialImage),
    );
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

  Future<Uint8List?> _drawImage(PhotoEdit attemptState) async {
    final initialImage = state.initialImage;
    if (initialImage == null) return null;
    final editorOption = ImageEditorOption();

    if (attemptState.angle != 0) {
      editorOption.addOption(RotateOption(attemptState.angle));
    }
    if (!attemptState.clipMode) {
      final offset = attemptState.cropOffset;
      final size = attemptState.cropSize;
      editorOption.addOption(
        ClipOption(
          x: offset.dx,
          y: offset.dy,
          width: size.width,
          height: size.height,
        ),
      );
    }

    final presets = ColorFilterPresets().presets;
    for (final colorPreset in attemptState.adaptivePresets) {
      editorOption.addOptions(
        presets.firstWhere((element) => element.name == colorPreset).option,
      );
    }

    final result = await ImageEditor.editImage(
      image: initialImage,
      imageEditorOption: editorOption,
    );
    return result;
  }

  /// 画像の描画を反映する
  Future<void> draw(PhotoEdit attemptState) async {
    final editedImage = await _drawImage(attemptState);
    if (editedImage == null) return;
    state = attemptState.copyWith(editedImage: editedImage);
  }

  Future<Uint8List?> createSaveData(GlobalKey renderingAreaKey) async {
    // RenderObjectを取得
    final boundary = renderingAreaKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final resultImage = byteData?.buffer.asUint8List();
    if (resultImage == null) return null;

    final padding = 20 * state.defaultSize.width / state.actualSize.width;

    final removedPaddingImage = await ImageEditor.editImage(
      image: resultImage,
      imageEditorOption: ImageEditorOption()
        ..addOptions([
          ClipOption(
            x: padding + (state.defaultSize.width - state.cropSize.width) / 2,
            y: padding + (state.defaultSize.height - state.cropSize.height) / 2,
            width: state.cropSize.width,
            height: state.cropSize.height,
          ),
        ]),
    );
    return removedPaddingImage;
  }

  Offset resolveRotatedOffset(
    Offset cropOffset,
    Size cropSize,
    Size defaultSize,
    int angle,
  ) {
    final rotatedX = defaultSize.width - cropSize.width - cropOffset.dx;
    return Offset(cropOffset.dy, rotatedX);
  }

  /// 画像を回転する
  void rotate() {
    final angle = ((state.angle - 90) % 360).abs();
    draw(
      state.copyWith(
        angle: angle,
        defaultSize: Size(state.defaultSize.height, state.defaultSize.width),
        cropSize: Size(state.cropSize.height, state.cropSize.width),
        cropOffset: resolveRotatedOffset(
          state.cropOffset,
          state.cropSize,
          state.defaultSize,
          angle,
        ),
        emojis: [
          for (final emoji in state.emojis)
            emoji.copyWith(
              angle: emoji.angle - pi / 2,
              position: Offset(
                emoji.position.dy,
                state.defaultSize.width - emoji.scale - emoji.position.dx,
              ),
            ),
        ],
        selectedEmojiIndex: null,
      ),
    );
  }

  /// 画像を切り取る
  void crop() {
    draw(
      state.copyWith(
        clipMode: !state.clipMode,
        colorFilterMode: false,
        selectedEmojiIndex: null,
      ),
    );
  }

  void decideDrawArea(Size size) {
    state = state.copyWith(actualSize: size);
  }

  /// 画像の切り取り範囲を制限する
  PhotoEdit validateCrop(PhotoEdit state) {
    final size = state.cropSize;
    final defaultSize = state.defaultSize;
    final offset = state.cropOffset;
    final validatedOffset = Offset(
      max(0, min(offset.dx, defaultSize.width)),
      max(0, min(offset.dy, defaultSize.height)),
    );
    final validatedCropSize = Size(
      max(1, min(size.width, defaultSize.width - validatedOffset.dx)),
      max(1, min(size.height, defaultSize.height - validatedOffset.dy)),
    );

    return state.copyWith(
      cropSize: validatedCropSize,
      cropOffset: validatedOffset,
    );
  }

  /// 画像の切り取り範囲の左上を移動する
  void cropMoveLeftTop(PointerMoveEvent detail) {
    state = validateCrop(
      state.copyWith(
        cropOffset: state.cropOffset + detail.localDelta,
        cropSize: Size(
          state.cropSize.width - detail.localDelta.dx,
          state.cropSize.height - detail.localDelta.dy,
        ),
      ),
    );
  }

  /// 画像の切り取り範囲の右上を移動する
  void cropMoveRightTop(PointerMoveEvent detail) {
    state = validateCrop(
      state.copyWith(
        cropOffset: Offset(
          state.cropOffset.dx,
          state.cropOffset.dy + detail.localDelta.dy,
        ),
        cropSize: Size(
          state.cropSize.width + detail.localDelta.dx,
          state.cropSize.height - detail.localDelta.dy,
        ),
      ),
    );
  }

  /// 画像の切り取り範囲の左下を移動する
  void cropMoveLeftBottom(PointerMoveEvent detail) {
    state = validateCrop(
      state.copyWith(
        cropOffset: Offset(
          state.cropOffset.dx + detail.localDelta.dx,
          state.cropOffset.dy,
        ),
        cropSize: Size(
          state.cropSize.width - detail.localDelta.dx,
          state.cropSize.height + detail.localDelta.dy,
        ),
      ),
    );
  }

  /// 画像の切り取り範囲の右下を移動する
  void cropMoveRightBottom(PointerMoveEvent detail) {
    state = validateCrop(
      state.copyWith(
        cropOffset: Offset(state.cropOffset.dx, state.cropOffset.dy),
        cropSize: Size(
          state.cropSize.width + detail.localDelta.dx,
          state.cropSize.height + detail.localDelta.dy,
        ),
      ),
    );
  }

  /// 画像の色調補正のプレビューを切り替える
  Future<void> colorFilter() async {
    state = state.copyWith(
      clipMode: false,
      selectedEmojiIndex: null,
      colorFilterMode: !state.colorFilterMode,
    );
    if (!state.colorFilterMode) return;
    createPreviewImage();
  }

  Future<void> createPreviewImage() async {
    final editedImage = state.editedImage;
    if (editedImage == null) return;
    final previewImage = await ImageEditor.editImage(
      image: editedImage,
      imageEditorOption: ImageEditorOption()
        ..addOption(const ScaleOption(300, 300, keepRatio: true)),
    );
    if (previewImage == null) return;
    final result = [
      for (final preset in ColorFilterPresets().presets)
        ColorFilterPreview(
          name: preset.name,
          image: await ImageEditor.editImage(
            image: previewImage,
            imageEditorOption: ImageEditorOption()..addOptions(preset.option),
          ),
        ),
    ].whereNotNull();

    state = state.copyWith(colorFilterPreviewImages: result.toList());
  }

  /// 画像の色調補正を設定する
  Future<void> selectColorFilter(String name) async {
    if (state.adaptivePresets.any((element) => element == name)) {
      final list = state.adaptivePresets.toList();
      list.removeWhere((element) => element == name);
      await draw(state.copyWith(adaptivePresets: list));
    } else {
      await draw(
        state.copyWith(adaptivePresets: [...state.adaptivePresets, name]),
      );
    }
    await createPreviewImage();
  }

  /// リアクションを追加する
  Future<void> addReaction(Account account, BuildContext context) async {
    final reaction = await showDialog<MisskeyEmojiData?>(
      context: context,
      builder: (context) =>
          ReactionPickerDialog(account: account, isAcceptSensitive: true),
    );
    if (reaction == null) return;

    switch (reaction) {
      case CustomEmojiData():
        // カスタム絵文字の場合、ライセンスを確認する
        if (_acceptReactions.none((e) => e == reaction.baseName)) {
          if (!mounted) return;
          final dialogResult = await showDialog<bool?>(
            context: context,
            builder: (context) => LicenseConfirmDialog(
              emoji: reaction.baseName,
              account: account,
            ),
          );
          if (dialogResult != true) return;
          _acceptReactions.add(reaction.baseName);
        }

        break;
      case UnicodeEmojiData():
        break;
      default:
        return;
    }

    state = state.copyWith(
      emojis: [
        ...state.emojis,
        EditedEmojiData(
          emoji: reaction,
          scale: 100,
          position: Offset(
            state.cropOffset.dx + (state.cropSize.width) / 2 - 50,
            state.cropOffset.dy + (state.cropSize.height) / 2 - 50,
          ),
          angle: 0,
        ),
      ],
      selectedEmojiIndex: state.emojis.length,
      clipMode: false,
    );
  }

  double _startScale = 0;
  double _startAngle = 0;

  /// リアクションを拡大・縮小・回転する　イベントの開始
  void reactionScaleStart(ScaleStartDetails detail) {
    final selectedIndex = state.selectedEmojiIndex;
    if (selectedIndex == null) return;
    _startScale = state.emojis[selectedIndex].scale;
    _startAngle = state.emojis[selectedIndex].angle;
  }

  /// リアクションを拡大・縮小・回転する　イベントの実施中
  void reactionScaleUpdate(ScaleUpdateDetails detail) {
    final selectedIndex = state.selectedEmojiIndex;
    if (selectedIndex == null) return;
    final emojis = state.emojis.toList();
    emojis[selectedIndex] = emojis[selectedIndex].copyWith(
      scale: _startScale * detail.scale,
      angle: _startAngle + detail.rotation,
    );

    state = state.copyWith(emojis: emojis, clipMode: false);
  }

  /// リアクションを移動する
  void reactionMove(PointerMoveEvent event) {
    final selectedIndex = state.selectedEmojiIndex;
    if (selectedIndex == null) return;
    final emojis = state.emojis.toList();
    emojis[selectedIndex] = emojis[selectedIndex].copyWith(
      position: Offset(
        emojis[selectedIndex].position.dx + event.localDelta.dx,
        emojis[selectedIndex].position.dy + event.localDelta.dy,
      ),
    );

    state = state.copyWith(emojis: emojis);
  }

  /// リアクションを選択する
  void selectReaction(int index) {
    state = state.copyWith(
      clipMode: false,
      colorFilterMode: false,
      selectedEmojiIndex: index,
    );
  }

  void clearSelectMode() {
    draw(
      state.copyWith(
        selectedEmojiIndex: null,
        colorFilterMode: false,
        clipMode: false,
      ),
    );
  }
}
