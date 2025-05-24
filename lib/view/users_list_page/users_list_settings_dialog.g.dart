// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_list_settings_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_initialSettings)
const _initialSettingsProvider = _InitialSettingsProvider._();

final class _InitialSettingsProvider
    extends $FunctionalProvider<UsersListSettings, UsersListSettings>
    with $Provider<UsersListSettings> {
  const _InitialSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_initialSettingsProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[],
        $allTransitiveDependencies: const <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$initialSettingsHash();

  @$internal
  @override
  $ProviderElement<UsersListSettings> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UsersListSettings create(Ref ref) {
    return _initialSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UsersListSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<UsersListSettings>(value),
    );
  }
}

String _$initialSettingsHash() => r'3dec59c0d7a3e36d255b82bfd7ea8eda758e9cf3';

@ProviderFor(_UsersListSettingsNotifier)
const _usersListSettingsNotifierProvider =
    _UsersListSettingsNotifierProvider._();

final class _UsersListSettingsNotifierProvider
    extends $NotifierProvider<_UsersListSettingsNotifier, UsersListSettings> {
  const _UsersListSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_usersListSettingsNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[_initialSettingsProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _UsersListSettingsNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = _initialSettingsProvider;

  @override
  String debugGetCreateSourceHash() => _$usersListSettingsNotifierHash();

  @$internal
  @override
  _UsersListSettingsNotifier create() => _UsersListSettingsNotifier();

  @$internal
  @override
  $NotifierProviderElement<_UsersListSettingsNotifier, UsersListSettings>
  $createElement($ProviderPointer pointer) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UsersListSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<UsersListSettings>(value),
    );
  }
}

String _$usersListSettingsNotifierHash() =>
    r'6e354936966b2a1d0e0c4dca6d41e74ff0ccb243';

abstract class _$UsersListSettingsNotifier
    extends $Notifier<UsersListSettings> {
  UsersListSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UsersListSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UsersListSettings>,
              UsersListSettings,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
