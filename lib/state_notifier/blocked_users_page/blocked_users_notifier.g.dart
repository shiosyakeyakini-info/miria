// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_users_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$blockedUsersNotifierHash() =>
    r'a6cd66eec5df179c1f1f09a772f6fd7ed7f76814';

/// See also [BlockedUsersNotifier].
@ProviderFor(BlockedUsersNotifier)
final blockedUsersNotifierProvider = AutoDisposeAsyncNotifierProvider<
    BlockedUsersNotifier, List<Blocking>>.internal(
  BlockedUsersNotifier.new,
  name: r'blockedUsersNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$blockedUsersNotifierHash,
  dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies
  },
);

typedef _$BlockedUsersNotifier = AutoDisposeAsyncNotifier<List<Blocking>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
