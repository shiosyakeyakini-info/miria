// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_server_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_instanceInfos)
const _instanceInfosProvider = _InstanceInfosProvider._();

final class _InstanceInfosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<JoinMisskeyInstanceInfo>>,
          List<JoinMisskeyInstanceInfo>,
          FutureOr<List<JoinMisskeyInstanceInfo>>
        >
    with
        $FutureModifier<List<JoinMisskeyInstanceInfo>>,
        $FutureProvider<List<JoinMisskeyInstanceInfo>> {
  const _InstanceInfosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_instanceInfosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_instanceInfosHash();

  @$internal
  @override
  $FutureProviderElement<List<JoinMisskeyInstanceInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<JoinMisskeyInstanceInfo>> create(Ref ref) {
    return _instanceInfos(ref);
  }
}

String _$_instanceInfosHash() => r'cdfbdd33cdb1299615800f5bc64634c4cd548e41';

@ProviderFor(MisskeyServerListNotifier)
const misskeyServerListNotifierProvider = MisskeyServerListNotifierProvider._();

final class MisskeyServerListNotifierProvider
    extends
        $AsyncNotifierProvider<
          MisskeyServerListNotifier,
          List<JoinMisskeyInstanceInfo>
        > {
  const MisskeyServerListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misskeyServerListNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$misskeyServerListNotifierHash();

  @$internal
  @override
  MisskeyServerListNotifier create() => MisskeyServerListNotifier();
}

String _$misskeyServerListNotifierHash() =>
    r'd876e4f09b2bc68aa2daab45e120f47e6f8a6557';

abstract class _$MisskeyServerListNotifier
    extends $AsyncNotifier<List<JoinMisskeyInstanceInfo>> {
  FutureOr<List<JoinMisskeyInstanceInfo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<JoinMisskeyInstanceInfo>>,
              List<JoinMisskeyInstanceInfo>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<JoinMisskeyInstanceInfo>>,
                List<JoinMisskeyInstanceInfo>
              >,
              AsyncValue<List<JoinMisskeyInstanceInfo>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
