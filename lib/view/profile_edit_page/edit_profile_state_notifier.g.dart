// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditProfileStateNotifier)
const editProfileStateProvider = EditProfileStateNotifierProvider._();

final class EditProfileStateNotifierProvider
    extends $AsyncNotifierProvider<EditProfileStateNotifier, EditProfileState> {
  const EditProfileStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editProfileStateProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          accountContextProvider,
          misskeyGetContextProvider,
          misskeyPostContextProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          EditProfileStateNotifierProvider.$allTransitiveDependencies0,
          EditProfileStateNotifierProvider.$allTransitiveDependencies1,
          EditProfileStateNotifierProvider.$allTransitiveDependencies2,
        ],
      );

  static const $allTransitiveDependencies0 = accountContextProvider;
  static const $allTransitiveDependencies1 = misskeyGetContextProvider;
  static const $allTransitiveDependencies2 = misskeyPostContextProvider;

  @override
  String debugGetCreateSourceHash() => _$editProfileStateNotifierHash();

  @$internal
  @override
  EditProfileStateNotifier create() => EditProfileStateNotifier();
}

String _$editProfileStateNotifierHash() =>
    r'8c9aad09d8919bd4d4af1d04613ad6259794d272';

abstract class _$EditProfileStateNotifier
    extends $AsyncNotifier<EditProfileState> {
  FutureOr<EditProfileState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<EditProfileState>, EditProfileState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EditProfileState>, EditProfileState>,
              AsyncValue<EditProfileState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
