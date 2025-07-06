// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_preset_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(serverPresets)
const serverPresetsProvider = ServerPresetsProvider._();

final class ServerPresetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServerPresets>,
          ServerPresets,
          FutureOr<ServerPresets>
        >
    with $FutureModifier<ServerPresets>, $FutureProvider<ServerPresets> {
  const ServerPresetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverPresetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverPresetsHash();

  @$internal
  @override
  $FutureProviderElement<ServerPresets> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ServerPresets> create(Ref ref) {
    return serverPresets(ref);
  }
}

String _$serverPresetsHash() => r'f7049001e7e7f95b4b337b9d54c482b5a95dc428';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
