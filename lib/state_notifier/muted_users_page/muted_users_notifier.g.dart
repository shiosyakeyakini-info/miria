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
    extends $NotifierProvider<MutedUsersNotifier, void> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$mutedUsersNotifierHash() =>
    r'b35275ec22130fa0361b63e1384609cd981313af';

abstract class _$MutedUsersNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
