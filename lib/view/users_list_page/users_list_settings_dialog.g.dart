// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_list_settings_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_initialSettings)
final _initialSettingsProvider = _InitialSettingsProvider._();

final class _InitialSettingsProvider
    extends
        $FunctionalProvider<
          UsersListSettings,
          UsersListSettings,
          UsersListSettings
        >
    with $Provider<UsersListSettings> {
  _InitialSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_initialSettingsProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$_initialSettingsHash();

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
      providerOverride: $SyncValueProvider<UsersListSettings>(value),
    );
  }
}

String _$_initialSettingsHash() => r'3dec59c0d7a3e36d255b82bfd7ea8eda758e9cf3';

@ProviderFor(_UsersListSettingsNotifier)
final _usersListSettingsProvider = _UsersListSettingsNotifierProvider._();

final class _UsersListSettingsNotifierProvider
    extends $NotifierProvider<_UsersListSettingsNotifier, UsersListSettings> {
  _UsersListSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_usersListSettingsProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[_initialSettingsProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          _UsersListSettingsNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = _initialSettingsProvider;

  @override
  String debugGetCreateSourceHash() => _$_usersListSettingsNotifierHash();

  @$internal
  @override
  _UsersListSettingsNotifier create() => _UsersListSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UsersListSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UsersListSettings>(value),
    );
  }
}

String _$_usersListSettingsNotifierHash() =>
    r'6e354936966b2a1d0e0c4dca6d41e74ff0ccb243';

abstract class _$UsersListSettingsNotifier
    extends $Notifier<UsersListSettings> {
  UsersListSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UsersListSettings, UsersListSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UsersListSettings, UsersListSettings>,
              UsersListSettings,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
