// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_update_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileUpdateNotifier)
final profileUpdateProvider = ProfileUpdateNotifierProvider._();

final class ProfileUpdateNotifierProvider
    extends $AsyncNotifierProvider<ProfileUpdateNotifier, void> {
  ProfileUpdateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileUpdateProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          accountContextProvider,
          profileEditRequestProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          ProfileUpdateNotifierProvider.$allTransitiveDependencies0,
          ProfileUpdateNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = accountContextProvider;
  static final $allTransitiveDependencies1 = profileEditRequestProvider;

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
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
