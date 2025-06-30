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

@ProviderFor(isLimitedApiServer)
const isLimitedApiServerProvider = IsLimitedApiServerFamily._();

final class IsLimitedApiServerProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const IsLimitedApiServerProvider._({
    required IsLimitedApiServerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isLimitedApiServerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isLimitedApiServerHash();

  @override
  String toString() {
    return r'isLimitedApiServerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return isLimitedApiServer(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsLimitedApiServerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isLimitedApiServerHash() =>
    r'5fd059383ab465ad3272534a57fe818d23cfdde7';

final class IsLimitedApiServerFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  const IsLimitedApiServerFamily._()
    : super(
        retry: null,
        name: r'isLimitedApiServerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsLimitedApiServerProvider call(String host) =>
      IsLimitedApiServerProvider._(argument: host, from: this);

  @override
  String toString() => r'isLimitedApiServerProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
