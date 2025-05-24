// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_mute_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(InstanceMutePageNotifier)
const instanceMutePageNotifierProvider = InstanceMutePageNotifierProvider._();

final class InstanceMutePageNotifierProvider
    extends
        $AsyncNotifierProvider<
          InstanceMutePageNotifier,
          (List<String>, AsyncValue<void>?)
        > {
  const InstanceMutePageNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instanceMutePageNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          InstanceMutePageNotifierProvider.$allTransitiveDependencies0,
          InstanceMutePageNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$instanceMutePageNotifierHash();

  @$internal
  @override
  InstanceMutePageNotifier create() => InstanceMutePageNotifier();

  @$internal
  @override
  $AsyncNotifierProviderElement<
    InstanceMutePageNotifier,
    (List<String>, AsyncValue<void>?)
  >
  $createElement($ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);
}

String _$instanceMutePageNotifierHash() =>
    r'66d63bb0c86f7bec0da2078bfcaff5f43a86d50f';

abstract class _$InstanceMutePageNotifier
    extends $AsyncNotifier<(List<String>, AsyncValue<void>?)> {
  FutureOr<(List<String>, AsyncValue<void>?)> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<(List<String>, AsyncValue<void>?)>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<(List<String>, AsyncValue<void>?)>>,
              AsyncValue<(List<String>, AsyncValue<void>?)>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
