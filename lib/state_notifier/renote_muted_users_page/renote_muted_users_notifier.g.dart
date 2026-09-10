// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'renote_muted_users_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(RenoteMutedUsersNotifier)
const renoteMutedUsersNotifierProvider = RenoteMutedUsersNotifierProvider._();

final class RenoteMutedUsersNotifierProvider
    extends $AsyncNotifierProvider<RenoteMutedUsersNotifier, List<RenoteMuting>> {
  const RenoteMutedUsersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'renoteMutedUsersNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          RenoteMutedUsersNotifierProvider.$allTransitiveDependencies0,
          RenoteMutedUsersNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  $AsyncNotifierProviderElement<RenoteMutedUsersNotifier, List<RenoteMuting>>
      $createElement(ProviderContainer container) =>
          $AsyncNotifierProviderElement(this, container);

  @override
  RenoteMutedUsersNotifier $create(
    $AsyncNotifierProviderElement<RenoteMutedUsersNotifier, List<RenoteMuting>>
        element,
  ) =>
      RenoteMutedUsersNotifier();

  @override
  bool operator ==(Object other) {
    return other is RenoteMutedUsersNotifierProvider && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode {
    return (RenoteMutedUsersNotifierProvider).hashCode;
  }
}

mixin RenoteMutedUsersNotifierRef
    on $AsyncNotifierProviderRef<List<RenoteMuting>> {
  /// The parameter `from` of this provider.
}

class _$RenoteMutedUsersNotifier extends $AsyncNotifier<List<RenoteMuting>>
    with RenoteMutedUsersNotifierRef {
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<RenoteMuting>>, List<RenoteMuting>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<RenoteMuting>>, List<RenoteMuting>>,
              AsyncValue<List<RenoteMuting>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package