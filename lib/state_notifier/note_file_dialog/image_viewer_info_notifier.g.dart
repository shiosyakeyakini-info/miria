// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_viewer_info_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ImageViewerInfoNotifier)
const imageViewerInfoProvider = ImageViewerInfoNotifierProvider._();

final class ImageViewerInfoNotifierProvider
    extends $NotifierProvider<ImageViewerInfoNotifier, ImageViewerInfo> {
  const ImageViewerInfoNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageViewerInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageViewerInfoNotifierHash();

  @$internal
  @override
  ImageViewerInfoNotifier create() => ImageViewerInfoNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageViewerInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageViewerInfo>(value),
    );
  }
}

String _$imageViewerInfoNotifierHash() =>
    r'72fb1a4dc91a618f416a5b506e48944861631ebe';

abstract class _$ImageViewerInfoNotifier extends $Notifier<ImageViewerInfo> {
  ImageViewerInfo build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ImageViewerInfo, ImageViewerInfo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ImageViewerInfo, ImageViewerInfo>,
              ImageViewerInfo,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
