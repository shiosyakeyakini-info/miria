// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_page_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(MisskeyPageNotifier)
const misskeyPageNotifierProvider = MisskeyPageNotifierFamily._();

final class MisskeyPageNotifierProvider
    extends
        $AsyncNotifierProvider<MisskeyPageNotifier, MisskeyPageNotifierState> {
  const MisskeyPageNotifierProvider._({
    required MisskeyPageNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'misskeyPageNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = accountContextProvider;
  static const $allTransitiveDependencies1 = misskeyGetContextProvider;
  static const $allTransitiveDependencies2 = misskeyPostContextProvider;

  @override
  String debugGetCreateSourceHash() => _$misskeyPageNotifierHash();

  @override
  String toString() {
    return r'misskeyPageNotifierProvider'
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
    r'ee6d060c8b5eddfefb89f6062692fdfa8b0e4d47';

final class MisskeyPageNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          MisskeyPageNotifier,
          AsyncValue<MisskeyPageNotifierState>,
          MisskeyPageNotifierState,
          FutureOr<MisskeyPageNotifierState>,
          String
        > {
  const MisskeyPageNotifierFamily._()
    : super(
        retry: null,
        name: r'misskeyPageNotifierProvider',
        dependencies: const <ProviderOrFamily>[
          accountContextProvider,
          misskeyGetContextProvider,
          misskeyPostContextProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          MisskeyPageNotifierProvider.$allTransitiveDependencies0,
          MisskeyPageNotifierProvider.$allTransitiveDependencies1,
          MisskeyPageNotifierProvider.$allTransitiveDependencies2,
        ],
        isAutoDispose: true,
      );

  MisskeyPageNotifierProvider call(String pageId) =>
      MisskeyPageNotifierProvider._(argument: pageId, from: this);

  @override
  String toString() => r'misskeyPageNotifierProvider';
}

abstract class _$MisskeyPageNotifier
    extends $AsyncNotifier<MisskeyPageNotifierState> {
  late final _$args = ref.$arg as String;
  String get pageId => _$args;

  FutureOr<MisskeyPageNotifierState> build(String pageId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
