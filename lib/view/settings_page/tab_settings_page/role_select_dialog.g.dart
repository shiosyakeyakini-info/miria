// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_select_dialog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_roles)
const _rolesProvider = _RolesProvider._();

final class _RolesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RolesListResponse>>,
          List<RolesListResponse>,
          FutureOr<List<RolesListResponse>>
        >
    with
        $FutureModifier<List<RolesListResponse>>,
        $FutureProvider<List<RolesListResponse>> {
  const _RolesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_rolesProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          _RolesProvider.$allTransitiveDependencies0,
          _RolesProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyGetContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_rolesHash();

  @$internal
  @override
  $FutureProviderElement<List<RolesListResponse>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RolesListResponse>> create(Ref ref) {
    return _roles(ref);
  }
}

String _$_rolesHash() => r'c10d381c1a9041d45d7197d476ce56705dd16100';
