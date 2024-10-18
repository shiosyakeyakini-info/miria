// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_edit_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$photoEditStateNotifierHash() =>
    r'8775951cc945fb8d595f0c3ac490e2e3d8820039';

/// See also [PhotoEditStateNotifier].
@ProviderFor(PhotoEditStateNotifier)
final photoEditStateNotifierProvider =
    AutoDisposeNotifierProvider<PhotoEditStateNotifier, PhotoEdit>.internal(
  PhotoEditStateNotifier.new,
  name: r'photoEditStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$photoEditStateNotifierHash,
  dependencies: <ProviderOrFamily>[accountContextProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    accountContextProvider,
    ...?accountContextProvider.allTransitiveDependencies
  },
);

typedef _$PhotoEditStateNotifier = AutoDisposeNotifier<PhotoEdit>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
