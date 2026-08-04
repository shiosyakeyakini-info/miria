// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_search_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatSearchRepository)
final chatSearchRepositoryProvider = ChatSearchRepositoryProvider._();

final class ChatSearchRepositoryProvider
    extends
        $NotifierProvider<
          ChatSearchRepository,
          Map<String, List<ChatMessage>>
        > {
  ChatSearchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSearchRepositoryProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          ChatSearchRepositoryProvider.$allTransitiveDependencies0,
          ChatSearchRepositoryProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = misskeyGetContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$chatSearchRepositoryHash();

  @$internal
  @override
  ChatSearchRepository create() => ChatSearchRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<ChatMessage>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<ChatMessage>>>(
        value,
      ),
    );
  }
}

String _$chatSearchRepositoryHash() =>
    r'f2975c708250d8823be846d6467ee529ec46c59b';

abstract class _$ChatSearchRepository
    extends $Notifier<Map<String, List<ChatMessage>>> {
  Map<String, List<ChatMessage>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<String, List<ChatMessage>>,
              Map<String, List<ChatMessage>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, List<ChatMessage>>,
                Map<String, List<ChatMessage>>
              >,
              Map<String, List<ChatMessage>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ChatSearchPagination)
final chatSearchPaginationProvider = ChatSearchPaginationFamily._();

final class ChatSearchPaginationProvider
    extends $NotifierProvider<ChatSearchPagination, List<ChatMessage>> {
  ChatSearchPaginationProvider._({
    required ChatSearchPaginationFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatSearchPaginationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatSearchPaginationHash();

  @override
  String toString() {
    return r'chatSearchPaginationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatSearchPagination create() => ChatSearchPagination();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ChatMessage> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ChatMessage>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatSearchPaginationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatSearchPaginationHash() =>
    r'9017350b3137cec1d4033e1ae135f7b9ecbe97fe';

final class ChatSearchPaginationFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatSearchPagination,
          List<ChatMessage>,
          List<ChatMessage>,
          List<ChatMessage>,
          String
        > {
  ChatSearchPaginationFamily._()
    : super(
        retry: null,
        name: r'chatSearchPaginationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatSearchPaginationProvider call(String searchKey) =>
      ChatSearchPaginationProvider._(argument: searchKey, from: this);

  @override
  String toString() => r'chatSearchPaginationProvider';
}

abstract class _$ChatSearchPagination extends $Notifier<List<ChatMessage>> {
  late final _$args = ref.$arg as String;
  String get searchKey => _$args;

  List<ChatMessage> build(String searchKey);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<ChatMessage>, List<ChatMessage>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ChatMessage>, List<ChatMessage>>,
              List<ChatMessage>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
