// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_file_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DownloadFileNotifier)
const downloadFileProvider = DownloadFileNotifierProvider._();

final class DownloadFileNotifierProvider
    extends $NotifierProvider<DownloadFileNotifier, void> {
  const DownloadFileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadFileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadFileNotifierHash();

  @$internal
  @override
  DownloadFileNotifier create() => DownloadFileNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$downloadFileNotifierHash() =>
    r'e8165329f9e2c6712e895cb1579d7346cbc7ccaf';

abstract class _$DownloadFileNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
