import "dart:math";

import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
part "image_viewer_info_notifier.freezed.dart";
part "image_viewer_info_notifier.g.dart";

@riverpod
class ImageViewerInfoNotifier extends _$ImageViewerInfoNotifier {
  @override
  ImageViewerInfo build() {
    return const ImageViewerInfo();
  }

  void reset() {
    state = const ImageViewerInfo();
  }

  void update(ImageViewerInfo imageScale) {
    state = imageScale;
  }

  void updateScale(double scale) {
    state = state.copyWith(
      scale: scale,
    );
  }

  void addPointer() {
    state = state.copyWith(
      pointersCount: state.pointersCount + 1,
    );
  }

  void removePointer() {
    final v = max(0, state.pointersCount - 1);
    state = state.copyWith(
      pointersCount: v,
      isDoubleTap: false,
    );
  }
}

@freezed
abstract class ImageViewerInfo with _$ImageViewerInfo {
  const factory ImageViewerInfo({
    @Default(1.0) double scale,
    @Default(1.0) double lastScale,
    @Default(0) int pointersCount,
    @Default(false) bool isDoubleTap,
    @Default(null) Offset? lastTapLocalPosition,
  }) = _ImageViewerInfo;
}
