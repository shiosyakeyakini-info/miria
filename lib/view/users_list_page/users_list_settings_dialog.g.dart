// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_list_settings_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$initialSettingsHash() => r'dfac19098b98ae3956aa22d651861d1133c68289';

/// See also [_initialSettings].
@ProviderFor(_initialSettings)
final _initialSettingsProvider =
    AutoDisposeProvider<UsersListSettings>.internal(
  _initialSettings,
  name: r'_initialSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$initialSettingsHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

typedef _InitialSettingsRef = AutoDisposeProviderRef<UsersListSettings>;
String _$usersListSettingsNotifierHash() =>
    r'6e354936966b2a1d0e0c4dca6d41e74ff0ccb243';

/// See also [_UsersListSettingsNotifier].
@ProviderFor(_UsersListSettingsNotifier)
final _usersListSettingsNotifierProvider = AutoDisposeNotifierProvider<
    _UsersListSettingsNotifier, UsersListSettings>.internal(
  _UsersListSettingsNotifier.new,
  name: r'_usersListSettingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$usersListSettingsNotifierHash,
  dependencies: <ProviderOrFamily>[_initialSettingsProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    _initialSettingsProvider,
    ...?_initialSettingsProvider.allTransitiveDependencies
  },
);

typedef _$UsersListSettingsNotifier = AutoDisposeNotifier<UsersListSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
