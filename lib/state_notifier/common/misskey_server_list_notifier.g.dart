// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_server_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MisskeyServerListNotifier)
final misskeyServerListProvider = MisskeyServerListNotifierProvider._();

final class MisskeyServerListNotifierProvider
    extends
        $AsyncNotifierProvider<
          MisskeyServerListNotifier,
          List<JoinMisskeyInstanceInfo>
        > {
  MisskeyServerListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misskeyServerListProvider',
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
    r'ef2653b2551eaa7056ce2379306c4a52b2b2075f';

abstract class _$MisskeyServerListNotifier
    extends $AsyncNotifier<List<JoinMisskeyInstanceInfo>> {
  FutureOr<List<JoinMisskeyInstanceInfo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
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
    element.handleCreate(ref, build);
  }
}
