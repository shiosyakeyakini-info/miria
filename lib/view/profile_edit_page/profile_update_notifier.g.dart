// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_update_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ProfileUpdateNotifier)
const profileUpdateNotifierProvider = ProfileUpdateNotifierProvider._();

final class ProfileUpdateNotifierProvider
    extends $AsyncNotifierProvider<ProfileUpdateNotifier, void> {
  const ProfileUpdateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileUpdateNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          accountContextProvider,
          profileEditRequestProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          ProfileUpdateNotifierProvider.$allTransitiveDependencies0,
          ProfileUpdateNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = accountContextProvider;
  static const $allTransitiveDependencies1 = profileEditRequestProvider;

  @override
  String debugGetCreateSourceHash() => _$profileUpdateNotifierHash();

  @$internal
  @override
  ProfileUpdateNotifier create() => ProfileUpdateNotifier();
}

String _$profileUpdateNotifierHash() =>
    r'a50ed87aedb0999777dcb50998cd4960f0697b41';

abstract class _$ProfileUpdateNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
