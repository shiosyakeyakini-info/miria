// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'antenna_settings_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_initialSettings)
final _initialSettingsProvider = _InitialSettingsProvider._();

final class _InitialSettingsProvider
    extends
        $FunctionalProvider<AntennaSettings, AntennaSettings, AntennaSettings>
    with $Provider<AntennaSettings> {
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

String _$_initialSettingsHash() => r'5e44622c97f922cd7aa8410ac695fa6f5f3351b0';

@ProviderFor(_AntennaSettingsNotifier)
final _antennaSettingsProvider = _AntennaSettingsNotifierProvider._();

final class _AntennaSettingsNotifierProvider
    extends $NotifierProvider<_AntennaSettingsNotifier, AntennaSettings> {
  _AntennaSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_antennaSettingsProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[_initialSettingsProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          _AntennaSettingsNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = _initialSettingsProvider;

  @override
  String debugGetCreateSourceHash() => _$_antennaSettingsNotifierHash();

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

String _$_antennaSettingsNotifierHash() =>
    r'a33758bbcc3f54c6eb50d2176d6ed1ce7b54f9b5';

abstract class _$AntennaSettingsNotifier extends $Notifier<AntennaSettings> {
  AntennaSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AntennaSettings, AntennaSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AntennaSettings, AntennaSettings>,
              AntennaSettings,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(_usersListList)
final _usersListListProvider = _UsersListListProvider._();

final class _UsersListListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UsersList>>,
          List<UsersList>,
          FutureOr<List<UsersList>>
        >
    with $FutureModifier<List<UsersList>>, $FutureProvider<List<UsersList>> {
  _UsersListListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_usersListListProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          _UsersListListProvider.$allTransitiveDependencies0,
          _UsersListListProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyGetContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_usersListListHash();

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

String _$_usersListListHash() => r'038d168265d5f26396ee6dd063774e9b55055283';
