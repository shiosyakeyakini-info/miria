// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_select_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_roles)
final _rolesProvider = _RolesProvider._();

final class _RolesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Role>>,
          List<Role>,
          FutureOr<List<Role>>
        >
    with $FutureModifier<List<Role>>, $FutureProvider<List<Role>> {
  _RolesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_rolesProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          _RolesProvider.$allTransitiveDependencies0,
          _RolesProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyGetContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_rolesHash();

  @$internal
  @override
  $FutureProviderElement<List<Role>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Role>> create(Ref ref) {
    return _roles(ref);
  }
}

String _$_rolesHash() => r'8013fca87190c36dd6360fb864fc1c7b94a15942';
