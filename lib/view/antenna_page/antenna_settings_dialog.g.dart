// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antenna_settings_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_initialSettings)
const _initialSettingsProvider = _InitialSettingsProvider._();

final class _InitialSettingsProvider
    extends
        $FunctionalProvider<AntennaSettings, AntennaSettings, AntennaSettings>
    with $Provider<AntennaSettings> {
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
  $ProviderElement<AntennaSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AntennaSettings create(Ref ref) {
    return _initialSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AntennaSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AntennaSettings>(value),
    );
  }
}

String _$initialSettingsHash() => r'5e44622c97f922cd7aa8410ac695fa6f5f3351b0';

@ProviderFor(_AntennaSettingsNotifier)
const _antennaSettingsNotifierProvider = _AntennaSettingsNotifierProvider._();

final class _AntennaSettingsNotifierProvider
    extends $NotifierProvider<_AntennaSettingsNotifier, AntennaSettings> {
  const _AntennaSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_antennaSettingsNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[_initialSettingsProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _AntennaSettingsNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = _initialSettingsProvider;

  @override
  String debugGetCreateSourceHash() => _$antennaSettingsNotifierHash();

  @$internal
  @override
  _AntennaSettingsNotifier create() => _AntennaSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AntennaSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AntennaSettings>(value),
    );
  }
}

String _$antennaSettingsNotifierHash() =>
    r'a33758bbcc3f54c6eb50d2176d6ed1ce7b54f9b5';

abstract class _$AntennaSettingsNotifier extends $Notifier<AntennaSettings> {
  AntennaSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AntennaSettings, AntennaSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AntennaSettings, AntennaSettings>,
              AntennaSettings,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(_usersListList)
const _usersListListProvider = _UsersListListProvider._();

final class _UsersListListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UsersList>>,
          List<UsersList>,
          FutureOr<List<UsersList>>
        >
    with $FutureModifier<List<UsersList>>, $FutureProvider<List<UsersList>> {
  const _UsersListListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_usersListListProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _UsersListListProvider.$allTransitiveDependencies0,
          _UsersListListProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$usersListListHash();

  @$internal
  @override
  $FutureProviderElement<List<UsersList>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UsersList>> create(Ref ref) {
    return _usersListList(ref);
  }
}

String _$usersListListHash() => r'038d168265d5f26396ee6dd063774e9b55055283';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
