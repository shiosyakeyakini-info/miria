// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_input_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatInputStateNotifier)
final chatInputStateProvider = ChatInputStateNotifierProvider._();

final class ChatInputStateNotifierProvider
    extends $NotifierProvider<ChatInputStateNotifier, ChatInputState> {
  ChatInputStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatInputStateProvider',
        isAutoDispose: false,
        dependencies: <ProviderOrFamily>[
          accountContextProvider,
          misskeyPostContextProvider,
          fileSystemProvider,
          dioProvider,
          appRouterProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          ChatInputStateNotifierProvider.$allTransitiveDependencies0,
          ChatInputStateNotifierProvider.$allTransitiveDependencies1,
          ChatInputStateNotifierProvider.$allTransitiveDependencies2,
          ChatInputStateNotifierProvider.$allTransitiveDependencies3,
          ChatInputStateNotifierProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = accountContextProvider;
  static final $allTransitiveDependencies1 = misskeyPostContextProvider;
  static final $allTransitiveDependencies2 = fileSystemProvider;
  static final $allTransitiveDependencies3 = dioProvider;
  static final $allTransitiveDependencies4 = appRouterProvider;

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
    r'bab09d53611ae310d52a603c3b65725a69e56a99';

abstract class _$ChatInputStateNotifier extends $Notifier<ChatInputState> {
  ChatInputState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ChatInputState, ChatInputState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatInputState, ChatInputState>,
              ChatInputState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
