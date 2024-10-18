// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_note_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$misskeyNoteNotifierHash() =>
    r'5edd4690a767107f9c8a30e6b480a74de4e83d74';

/// See also [MisskeyNoteNotifier].
@ProviderFor(MisskeyNoteNotifier)
final misskeyNoteNotifierProvider =
    NotifierProvider<MisskeyNoteNotifier, void>.internal(
  MisskeyNoteNotifier.new,
  name: r'misskeyNoteNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$misskeyNoteNotifierHash,
  dependencies: <ProviderOrFamily>[
    accountContextProvider,
    misskeyGetContextProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    accountContextProvider,
    ...?accountContextProvider.allTransitiveDependencies,
    misskeyGetContextProvider,
    ...?misskeyGetContextProvider.allTransitiveDependencies
  },
);

typedef _$MisskeyNoteNotifier = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
