// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_create_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noteCreateNotifierHash() =>
    r'a6c19cac73b572cf30473220f793e1826dbeb286';

/// See also [NoteCreateNotifier].
@ProviderFor(NoteCreateNotifier)
final noteCreateNotifierProvider =
    AutoDisposeNotifierProvider<NoteCreateNotifier, NoteCreate>.internal(
  NoteCreateNotifier.new,
  name: r'noteCreateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noteCreateNotifierHash,
  dependencies: <ProviderOrFamily>[
    misskeyPostContextProvider,
    notesWithProvider,
    accountContextProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies,
    notesWithProvider,
    ...?notesWithProvider.allTransitiveDependencies,
    accountContextProvider,
    ...?accountContextProvider.allTransitiveDependencies
  },
);

typedef _$NoteCreateNotifier = AutoDisposeNotifier<NoteCreate>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
