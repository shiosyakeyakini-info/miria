// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_page_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MisskeyPageNotifier)
final misskeyPageProvider = MisskeyPageNotifierFamily._();

final class MisskeyPageNotifierProvider
    extends
        $AsyncNotifierProvider<MisskeyPageNotifier, MisskeyPageNotifierState> {
  MisskeyPageNotifierProvider._({
    required MisskeyPageNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'misskeyPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = accountContextProvider;
  static final $allTransitiveDependencies1 = misskeyGetContextProvider;
  static final $allTransitiveDependencies2 = misskeyPostContextProvider;

  @override
  String debugGetCreateSourceHash() => _$misskeyPageNotifierHash();

  @override
  String toString() {
    return r'misskeyPageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MisskeyPageNotifier create() => MisskeyPageNotifier();

  @override
  bool operator ==(Object other) {
    return other is MisskeyPageNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$misskeyPageNotifierHash() =>
    r'5be4cec382dc016a6579e72585c7fb918480e941';

final class MisskeyPageNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          MisskeyPageNotifier,
          AsyncValue<MisskeyPageNotifierState>,
          MisskeyPageNotifierState,
          FutureOr<MisskeyPageNotifierState>,
          String
        > {
  MisskeyPageNotifierFamily._()
    : super(
        retry: null,
        name: r'misskeyPageProvider',
        dependencies: <ProviderOrFamily>[
          accountContextProvider,
          misskeyGetContextProvider,
          misskeyPostContextProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          MisskeyPageNotifierProvider.$allTransitiveDependencies0,
          MisskeyPageNotifierProvider.$allTransitiveDependencies1,
          MisskeyPageNotifierProvider.$allTransitiveDependencies2,
        ],
        isAutoDispose: true,
      );

  MisskeyPageNotifierProvider call(String pageId) =>
      MisskeyPageNotifierProvider._(argument: pageId, from: this);

  @override
  String toString() => r'misskeyPageProvider';
}

abstract class _$MisskeyPageNotifier
    extends $AsyncNotifier<MisskeyPageNotifierState> {
  late final _$args = ref.$arg as String;
  String get pageId => _$args;

  FutureOr<MisskeyPageNotifierState> build(String pageId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<MisskeyPageNotifierState>,
              MisskeyPageNotifierState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<MisskeyPageNotifierState>,
                MisskeyPageNotifierState
              >,
              AsyncValue<MisskeyPageNotifierState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
