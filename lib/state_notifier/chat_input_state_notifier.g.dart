// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_input_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatInputStateNotifier)
const chatInputStateProvider = ChatInputStateNotifierProvider._();

final class ChatInputStateNotifierProvider
    extends $NotifierProvider<ChatInputStateNotifier, ChatInputState> {
  const ChatInputStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatInputStateProvider',
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
    r'8f52c5f62fecb89536e9dfad2a94d6fae21761e6';

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
