// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muted_users_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(MutedUsersNotifier)
const mutedUsersNotifierProvider = MutedUsersNotifierProvider._();

final class MutedUsersNotifierProvider
    extends $AsyncNotifierProvider<MutedUsersNotifier, List<Muting>> {
  const MutedUsersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mutedUsersNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          MutedUsersNotifierProvider.$allTransitiveDependencies0,
          MutedUsersNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$mutedUsersNotifierHash();

  @$internal
  @override
  MutedUsersNotifier create() => MutedUsersNotifier();
}

String _$mutedUsersNotifierHash() =>
    r'7d5337ea9b85d7acecb1d0a93b8ac71fd898e073';

abstract class _$MutedUsersNotifier extends $AsyncNotifier<List<Muting>> {
  FutureOr<List<Muting>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Muting>>, List<Muting>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Muting>>, List<Muting>>,
              AsyncValue<List<Muting>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
