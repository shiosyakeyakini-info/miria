// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antennas_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$antennasNotifierHash() => r'0cecb08c54c64bfafc6cc235c2e1e86f3ec237d2';

/// See also [AntennasNotifier].
@ProviderFor(AntennasNotifier)
final antennasNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AntennasNotifier, List<Antenna>>.internal(
  AntennasNotifier.new,
  name: r'antennasNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$antennasNotifierHash,
  dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies
  },
);

typedef _$AntennasNotifier = AutoDisposeAsyncNotifier<List<Antenna>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
