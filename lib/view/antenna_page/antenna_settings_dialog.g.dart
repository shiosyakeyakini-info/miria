// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antenna_settings_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$initialSettingsHash() => r'3b39e5af696c3cf1f2c31b32096d8cff96734d61';

/// See also [_initialSettings].
@ProviderFor(_initialSettings)
final _initialSettingsProvider = AutoDisposeProvider<AntennaSettings>.internal(
  _initialSettings,
  name: r'_initialSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$initialSettingsHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

typedef _InitialSettingsRef = AutoDisposeProviderRef<AntennaSettings>;
String _$usersListListHash() => r'348c98aa5cbb2c466be69801978f189e9f5a91fc';

/// See also [_usersListList].
@ProviderFor(_usersListList)
final _usersListListProvider =
    AutoDisposeFutureProvider<List<UsersList>>.internal(
  _usersListList,
  name: r'_usersListListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$usersListListHash,
  dependencies: <ProviderOrFamily>[misskeyGetContextProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    misskeyGetContextProvider,
    ...?misskeyGetContextProvider.allTransitiveDependencies
  },
);

typedef _UsersListListRef = AutoDisposeFutureProviderRef<List<UsersList>>;
String _$antennaSettingsNotifierHash() =>
    r'a33758bbcc3f54c6eb50d2176d6ed1ce7b54f9b5';

/// See also [_AntennaSettingsNotifier].
@ProviderFor(_AntennaSettingsNotifier)
final _antennaSettingsNotifierProvider = AutoDisposeNotifierProvider<
    _AntennaSettingsNotifier, AntennaSettings>.internal(
  _AntennaSettingsNotifier.new,
  name: r'_antennaSettingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$antennaSettingsNotifierHash,
  dependencies: <ProviderOrFamily>[_initialSettingsProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    _initialSettingsProvider,
    ...?_initialSettingsProvider.allTransitiveDependencies
  },
);

typedef _$AntennaSettingsNotifier = AutoDisposeNotifier<AntennaSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
