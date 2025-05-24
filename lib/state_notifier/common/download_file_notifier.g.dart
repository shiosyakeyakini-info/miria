// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_file_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(DownloadFileNotifier)
const downloadFileNotifierProvider = DownloadFileNotifierProvider._();

final class DownloadFileNotifierProvider
    extends $NotifierProvider<DownloadFileNotifier, void> {
  const DownloadFileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadFileNotifierProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadFileNotifierHash();

  @$internal
  @override
  DownloadFileNotifier create() => DownloadFileNotifier();

  @$internal
  @override
  $NotifierProviderElement<DownloadFileNotifier, void> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<void>(value),
    );
  }
}

String _$downloadFileNotifierHash() =>
    r'99b394364feb8276a67c277ad703172e94fffc1b';

abstract class _$DownloadFileNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<void>, void, Object?, Object?>;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
