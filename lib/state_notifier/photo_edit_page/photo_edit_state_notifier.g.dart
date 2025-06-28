// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_edit_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(PhotoEditStateNotifier)
const photoEditStateNotifierProvider = PhotoEditStateNotifierProvider._();

final class PhotoEditStateNotifierProvider
    extends $NotifierProvider<PhotoEditStateNotifier, PhotoEdit> {
  const PhotoEditStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoEditStateNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          PhotoEditStateNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = accountContextProvider;

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
    r'8775951cc945fb8d595f0c3ac490e2e3d8820039';

abstract class _$PhotoEditStateNotifier extends $Notifier<PhotoEdit> {
  PhotoEdit build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PhotoEdit, PhotoEdit>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PhotoEdit, PhotoEdit>,
              PhotoEdit,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
