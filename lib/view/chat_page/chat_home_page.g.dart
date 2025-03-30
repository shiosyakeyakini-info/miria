// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_home_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$historyHash() => r'34cb5d8b89849e3b3b9d054cd152ab8cb1d5b7a2';

/// See also [history].
@ProviderFor(history)
final historyProvider = AutoDisposeFutureProvider<List<ChatMessage>>.internal(
  history,
  name: r'historyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$historyHash,
  dependencies: <ProviderOrFamily>[misskeyPostContextProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    misskeyPostContextProvider,
    ...?misskeyPostContextProvider.allTransitiveDependencies
  },
);

typedef HistoryRef = AutoDisposeFutureProviderRef<List<ChatMessage>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
