// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_edit_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PhotoEditStateNotifier)
final photoEditStateProvider = PhotoEditStateNotifierProvider._();

final class PhotoEditStateNotifierProvider
    extends $NotifierProvider<PhotoEditStateNotifier, PhotoEdit> {
  PhotoEditStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoEditStateProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          PhotoEditStateNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = accountContextProvider;

  @override
  String debugGetCreateSourceHash() => _$photoEditStateNotifierHash();

  @$internal
  @override
  PhotoEditStateNotifier create() => PhotoEditStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoEdit value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoEdit>(value),
    );
  }
}

String _$photoEditStateNotifierHash() =>
    r'6b8f661acddd8b29461f44631faa37efd5608210';

abstract class _$PhotoEditStateNotifier extends $Notifier<PhotoEdit> {
  PhotoEdit build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PhotoEdit, PhotoEdit>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhotoEdit, PhotoEdit>,
              PhotoEdit,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
