// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clips_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clipsNotifierHash() => r'df24732aca182347a988675c5c7974a6a5bb587d';

/// See also [ClipsNotifier].
@ProviderFor(ClipsNotifier)
final clipsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ClipsNotifier, List<Clip>>.internal(
  ClipsNotifier.new,
  name: r'clipsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clipsNotifierHash,
  dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies
  },
);

typedef _$ClipsNotifier = AutoDisposeAsyncNotifier<List<Clip>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
