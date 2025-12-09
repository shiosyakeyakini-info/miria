// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_preset_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
