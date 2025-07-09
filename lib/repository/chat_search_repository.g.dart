// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_search_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ChatSearchRepository)
const chatSearchRepositoryProvider = ChatSearchRepositoryProvider._();

final class ChatSearchRepositoryProvider
    extends
        $NotifierProvider<
          ChatSearchRepository,
          Map<String, List<ChatMessage>>
        > {
  const ChatSearchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSearchRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

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
    r'58504836111bce81b8f63ccb2db5af1deaef4de0';

abstract class _$ChatSearchRepository
    extends $Notifier<Map<String, List<ChatMessage>>> {
  Map<String, List<ChatMessage>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
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
    element.handleValue(ref, created);
  }
}

@ProviderFor(ChatSearchPagination)
const chatSearchPaginationProvider = ChatSearchPaginationFamily._();

final class ChatSearchPaginationProvider
    extends $NotifierProvider<ChatSearchPagination, List<ChatMessage>> {
  const ChatSearchPaginationProvider._({
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
    r'16a70bbfc9d3636c3e5793d77b21ef13bfd747ba';

final class ChatSearchPaginationFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatSearchPagination,
          List<ChatMessage>,
          List<ChatMessage>,
          List<ChatMessage>,
          String
        > {
  const ChatSearchPaginationFamily._()
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
    final created = build(_$args);
    final ref = this.ref as $Ref<List<ChatMessage>, List<ChatMessage>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ChatMessage>, List<ChatMessage>>,
              List<ChatMessage>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
