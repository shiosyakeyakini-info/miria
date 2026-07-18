// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'federation_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FederationState)
final federationStateProvider = FederationStateFamily._();

final class FederationStateProvider
    extends $AsyncNotifierProvider<FederationState, FederationData> {
  FederationStateProvider._({
    required FederationStateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'federationStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = accountContextProvider;
  static final $allTransitiveDependencies1 = misskeyGetContextProvider;

  @override
  String debugGetCreateSourceHash() => _$federationStateHash();

  @override
  String toString() {
    return r'federationStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  FederationState create() => FederationState();

  @override
  bool operator ==(Object other) {
    return other is FederationStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$federationStateHash() => r'5847f3fd4a4ab06e720277f05fc29840bf9b93f8';

final class FederationStateFamily extends $Family
    with
        $ClassFamilyOverride<
          FederationState,
          AsyncValue<FederationData>,
          FederationData,
          FutureOr<FederationData>,
          String
        > {
  FederationStateFamily._()
    : super(
        retry: null,
        name: r'federationStateProvider',
        dependencies: <ProviderOrFamily>[
          accountContextProvider,
          misskeyGetContextProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          FederationStateProvider.$allTransitiveDependencies0,
          FederationStateProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  FederationStateProvider call(String host) =>
      FederationStateProvider._(argument: host, from: this);

  @override
  String toString() => r'federationStateProvider';
}

abstract class _$FederationState extends $AsyncNotifier<FederationData> {
  late final _$args = ref.$arg as String;
  String get host => _$args;

  FutureOr<FederationData> build(String host);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<FederationData>, FederationData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FederationData>, FederationData>,
              AsyncValue<FederationData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
