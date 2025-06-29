// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muted_users_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mutedUsersNotifierHash() =>
    r'7d5337ea9b85d7acecb1d0a93b8ac71fd898e073';

/// See also [MutedUsersNotifier].
@ProviderFor(MutedUsersNotifier)
final mutedUsersNotifierProvider =
    AutoDisposeAsyncNotifierProvider<MutedUsersNotifier, List<Muting>>.internal(
  MutedUsersNotifier.new,
  name: r'mutedUsersNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mutedUsersNotifierHash,
  dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies
  },
);

typedef _$MutedUsersNotifier = AutoDisposeAsyncNotifier<List<Muting>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
