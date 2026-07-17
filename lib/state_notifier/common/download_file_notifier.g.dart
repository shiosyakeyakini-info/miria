// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_file_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DownloadFileNotifier)
final downloadFileProvider = DownloadFileNotifierProvider._();

final class DownloadFileNotifierProvider
    extends $NotifierProvider<DownloadFileNotifier, void> {
  DownloadFileNotifierProvider._()
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
    r'96e5b402886e219369940f5f470db59f99272c2f';

abstract class _$DownloadFileNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
