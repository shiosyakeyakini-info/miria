// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_viewer_info_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ImageViewerInfoNotifier)
const imageViewerInfoNotifierProvider = ImageViewerInfoNotifierProvider._();

final class ImageViewerInfoNotifierProvider
    extends $NotifierProvider<ImageViewerInfoNotifier, ImageViewerInfo> {
  const ImageViewerInfoNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageViewerInfoNotifierProvider',
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
