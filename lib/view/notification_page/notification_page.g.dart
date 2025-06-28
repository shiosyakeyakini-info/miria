// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(followRequests)
const followRequestsProvider = FollowRequestsProvider._();

final class FollowRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FollowRequest>>,
          List<FollowRequest>,
          FutureOr<List<FollowRequest>>
        >
    with
        $FutureModifier<List<FollowRequest>>,
        $FutureProvider<List<FollowRequest>> {
  const FollowRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'followRequestsProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          FollowRequestsProvider.$allTransitiveDependencies0,
          FollowRequestsProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$followRequestsHash();

  @$internal
  @override
  $FutureProviderElement<List<FollowRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FollowRequest>> create(Ref ref) {
    return followRequests(ref);
  }
}

String _$followRequestsHash() => r'e4fcfbd6849d685a1609a29b7a1ba35765342774';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
