// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'renote_modal_sheet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(RenoteNotifier)
const renoteNotifierProvider = RenoteNotifierFamily._();

final class RenoteNotifierProvider
    extends $NotifierProvider<RenoteNotifier, AsyncValue<void>?> {
  const RenoteNotifierProvider._({
    required RenoteNotifierFamily super.from,
    required (Account, Note) super.argument,
  }) : super(
         retry: null,
         name: r'renoteNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$renoteNotifierHash();

  @override
  String toString() {
    return r'renoteNotifierProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  RenoteNotifier create() => RenoteNotifier();

  @$internal
  @override
  $NotifierProviderElement<RenoteNotifier, AsyncValue<void>?> $createElement(
    $ProviderPointer pointer,
  ) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<AsyncValue<void>?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RenoteNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$renoteNotifierHash() => r'2f8d167b63754ec318a4f0f76509e87798948ec6';

final class RenoteNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RenoteNotifier,
          AsyncValue<void>?,
          AsyncValue<void>?,
          AsyncValue<void>?,
          (Account, Note)
        > {
  const RenoteNotifierFamily._()
    : super(
        retry: null,
        name: r'renoteNotifierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RenoteNotifierProvider call(Account account, Note note) =>
      RenoteNotifierProvider._(argument: (account, note), from: this);

  @override
  String toString() => r'renoteNotifierProvider';
}

abstract class _$RenoteNotifier extends $Notifier<AsyncValue<void>?> {
  late final _$args = ref.$arg as (Account, Note);
  Account get account => _$args.$1;
  Note get note => _$args.$2;

  AsyncValue<void>? build(Account account, Note note);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<AsyncValue<void>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>?>,
              AsyncValue<void>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(RenoteChannelNotifier)
const renoteChannelNotifierProvider = RenoteChannelNotifierFamily._();

final class RenoteChannelNotifierProvider
    extends
        $NotifierProvider<
          RenoteChannelNotifier,
          AsyncValue<CommunityChannel>?
        > {
  const RenoteChannelNotifierProvider._({
    required RenoteChannelNotifierFamily super.from,
    required Account super.argument,
  }) : super(
         retry: null,
         name: r'renoteChannelNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$renoteChannelNotifierHash();

  @override
  String toString() {
    return r'renoteChannelNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RenoteChannelNotifier create() => RenoteChannelNotifier();

  @$internal
  @override
  $NotifierProviderElement<RenoteChannelNotifier, AsyncValue<CommunityChannel>?>
  $createElement($ProviderPointer pointer) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CommunityChannel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<AsyncValue<CommunityChannel>?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RenoteChannelNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$renoteChannelNotifierHash() =>
    r'c519cce3b931c05ce41c7d31f69e849feca88bff';

final class RenoteChannelNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RenoteChannelNotifier,
          AsyncValue<CommunityChannel>?,
          AsyncValue<CommunityChannel>?,
          AsyncValue<CommunityChannel>?,
          Account
        > {
  const RenoteChannelNotifierFamily._()
    : super(
        retry: null,
        name: r'renoteChannelNotifierProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RenoteChannelNotifierProvider call(Account account) =>
      RenoteChannelNotifierProvider._(argument: account, from: this);

  @override
  String toString() => r'renoteChannelNotifierProvider';
}

abstract class _$RenoteChannelNotifier
    extends $Notifier<AsyncValue<CommunityChannel>?> {
  late final _$args = ref.$arg as Account;
  Account get account => _$args;

  AsyncValue<CommunityChannel>? build(Account account);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<CommunityChannel>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CommunityChannel>?>,
              AsyncValue<CommunityChannel>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(RenoteOtherAccountNotifier)
const renoteOtherAccountNotifierProvider = RenoteOtherAccountNotifierFamily._();

final class RenoteOtherAccountNotifierProvider
    extends
        $NotifierProvider<
          RenoteOtherAccountNotifier,
          AsyncValue<(Account, Note)>?
        > {
  const RenoteOtherAccountNotifierProvider._({
    required RenoteOtherAccountNotifierFamily super.from,
    required (Account, Note) super.argument,
  }) : super(
         retry: null,
         name: r'renoteOtherAccountNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = accountContextProvider;
  static const $allTransitiveDependencies1 = misskeyNoteNotifierProvider;

  @override
  String debugGetCreateSourceHash() => _$renoteOtherAccountNotifierHash();

  @override
  String toString() {
    return r'renoteOtherAccountNotifierProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  RenoteOtherAccountNotifier create() => RenoteOtherAccountNotifier();

  @$internal
  @override
  $NotifierProviderElement<
    RenoteOtherAccountNotifier,
    AsyncValue<(Account, Note)>?
  >
  $createElement($ProviderPointer pointer) => $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<(Account, Note)>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<AsyncValue<(Account, Note)>?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RenoteOtherAccountNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$renoteOtherAccountNotifierHash() =>
    r'b4c853348eb13b119f55678169ef84a621b6395b';

final class RenoteOtherAccountNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RenoteOtherAccountNotifier,
          AsyncValue<(Account, Note)>?,
          AsyncValue<(Account, Note)>?,
          AsyncValue<(Account, Note)>?,
          (Account, Note)
        > {
  const RenoteOtherAccountNotifierFamily._()
    : super(
        retry: null,
        name: r'renoteOtherAccountNotifierProvider',
        dependencies: const <ProviderOrFamily>[
          accountContextProvider,
          misskeyNoteNotifierProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          RenoteOtherAccountNotifierProvider.$allTransitiveDependencies0,
          RenoteOtherAccountNotifierProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  RenoteOtherAccountNotifierProvider call(Account account, Note note) =>
      RenoteOtherAccountNotifierProvider._(
        argument: (account, note),
        from: this,
      );

  @override
  String toString() => r'renoteOtherAccountNotifierProvider';
}

abstract class _$RenoteOtherAccountNotifier
    extends $Notifier<AsyncValue<(Account, Note)>?> {
  late final _$args = ref.$arg as (Account, Note);
  Account get account => _$args.$1;
  Note get note => _$args.$2;

  AsyncValue<(Account, Note)>? build(Account account, Note note);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<AsyncValue<(Account, Note)>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<(Account, Note)>?>,
              AsyncValue<(Account, Note)>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
