// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_input_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ChatInputStateNotifier)
const chatInputStateNotifierProvider = ChatInputStateNotifierProvider._();

final class ChatInputStateNotifierProvider
    extends $NotifierProvider<ChatInputStateNotifier, ChatInputState> {
  const ChatInputStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatInputStateNotifierProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[
          accountContextProvider,
          misskeyPostContextProvider,
          fileSystemProvider,
          dioProvider,
          appRouterProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          ChatInputStateNotifierProvider.$allTransitiveDependencies0,
          ChatInputStateNotifierProvider.$allTransitiveDependencies1,
          ChatInputStateNotifierProvider.$allTransitiveDependencies2,
          ChatInputStateNotifierProvider.$allTransitiveDependencies3,
          ChatInputStateNotifierProvider.$allTransitiveDependencies4,
        },
      );

  static const $allTransitiveDependencies0 = accountContextProvider;
  static const $allTransitiveDependencies1 = misskeyPostContextProvider;
  static const $allTransitiveDependencies2 = fileSystemProvider;
  static const $allTransitiveDependencies3 = dioProvider;
  static const $allTransitiveDependencies4 = appRouterProvider;

  @override
  String debugGetCreateSourceHash() => _$chatInputStateNotifierHash();

  @$internal
  @override
  ChatInputStateNotifier create() => ChatInputStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatInputState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatInputState>(value),
    );
  }
}

String _$chatInputStateNotifierHash() =>
    r'4fda6ecca228c0c64d4d2ac485affa1d146a2dec';

abstract class _$ChatInputStateNotifier extends $Notifier<ChatInputState> {
  ChatInputState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChatInputState, ChatInputState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatInputState, ChatInputState>,
              ChatInputState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
