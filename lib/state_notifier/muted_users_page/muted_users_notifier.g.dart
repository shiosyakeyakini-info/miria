// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muted_users_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MutedUsersNotifier)
final mutedUsersProvider = MutedUsersNotifierProvider._();

final class MutedUsersNotifierProvider
    extends $AsyncNotifierProvider<MutedUsersNotifier, List<Muting>> {
  MutedUsersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mutedUsersProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          MutedUsersNotifierProvider.$allTransitiveDependencies0,
          MutedUsersNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyPostContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$mutedUsersNotifierHash();

  @$internal
  @override
  MutedUsersNotifier create() => MutedUsersNotifier();
}

String _$mutedUsersNotifierHash() =>
    r'627cc21f13351f8fbde61aa1ae5d560d413952ad';

abstract class _$MutedUsersNotifier extends $AsyncNotifier<List<Muting>> {
  FutureOr<List<Muting>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Muting>>, List<Muting>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Muting>>, List<Muting>>,
              AsyncValue<List<Muting>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
