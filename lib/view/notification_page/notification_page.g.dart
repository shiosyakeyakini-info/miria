// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$followRequestsHash() => r'0b953c859590344d5bc8e0eced81484ffadb2f47';

/// See also [followRequests].
@ProviderFor(followRequests)
final followRequestsProvider =
    AutoDisposeFutureProvider<List<FollowRequest>>.internal(
  followRequests,
  name: r'followRequestsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$followRequestsHash,
  dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies
  },
);

typedef FollowRequestsRef = AutoDisposeFutureProviderRef<List<FollowRequest>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
