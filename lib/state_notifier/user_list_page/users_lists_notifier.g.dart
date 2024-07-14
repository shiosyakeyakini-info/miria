// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_lists_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$usersListsNotifierHash() =>
    r'9ed5c5424d4e68f5f7468227498b1b5a6bcf46a1';

/// See also [UsersListsNotifier].
@ProviderFor(UsersListsNotifier)
final usersListsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    UsersListsNotifier, List<UsersList>>.internal(
  UsersListsNotifier.new,
  name: r'usersListsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$usersListsNotifierHash,
  dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies
  },
);

typedef _$UsersListsNotifier = AutoDisposeAsyncNotifier<List<UsersList>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
