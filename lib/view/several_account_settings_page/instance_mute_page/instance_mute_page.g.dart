// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_mute_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InstanceMutePageNotifier)
final instanceMutePageProvider = InstanceMutePageNotifierProvider._();

final class InstanceMutePageNotifierProvider
    extends
        $AsyncNotifierProvider<
          InstanceMutePageNotifier,
          (List<String>, AsyncValue<void>?)
        > {
  InstanceMutePageNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instanceMutePageProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          InstanceMutePageNotifierProvider.$allTransitiveDependencies0,
          InstanceMutePageNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$instanceMutePageNotifierHash();

  @$internal
  @override
  InstanceMutePageNotifier create() => InstanceMutePageNotifier();
}

String _$instanceMutePageNotifierHash() =>
    r'16ed1bcb95f9877f14966297f66239086ace23a1';

abstract class _$InstanceMutePageNotifier
    extends $AsyncNotifier<(List<String>, AsyncValue<void>?)> {
  FutureOr<(List<String>, AsyncValue<void>?)> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<(List<String>, AsyncValue<void>?)>,
              (List<String>, AsyncValue<void>?)
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<(List<String>, AsyncValue<void>?)>,
                (List<String>, AsyncValue<void>?)
              >,
              AsyncValue<(List<String>, AsyncValue<void>?)>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
