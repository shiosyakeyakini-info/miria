// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_update_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileUpdateNotifierHash() =>
    r'071c4fe04568d890a513ff38887fee40753cca22';

/// See also [ProfileUpdateNotifier].
@ProviderFor(ProfileUpdateNotifier)
final profileUpdateNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ProfileUpdateNotifier, void>.internal(
  ProfileUpdateNotifier.new,
  name: r'profileUpdateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileUpdateNotifierHash,
  dependencies: <ProviderOrFamily>[
    accountContextProvider,
    profileEditRequestProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    accountContextProvider,
    ...?accountContextProvider.allTransitiveDependencies,
    profileEditRequestProvider,
    ...?profileEditRequestProvider.allTransitiveDependencies
  },
);

typedef _$ProfileUpdateNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
