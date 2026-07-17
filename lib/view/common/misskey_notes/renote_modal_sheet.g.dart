// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'renote_modal_sheet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RenoteNotifier)
final renoteProvider = RenoteNotifierFamily._();

final class RenoteNotifierProvider
    extends $NotifierProvider<RenoteNotifier, AsyncValue<void>?> {
  RenoteNotifierProvider._({
    required RenoteNotifierFamily super.from,
    required (Account, Note) super.argument,
  }) : super(
         retry: null,
         name: r'renoteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$renoteNotifierHash();

  @override
  String toString() {
    return r'renoteProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  RenoteNotifier create() => RenoteNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>?>(value),
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

String _$renoteNotifierHash() => r'814b848dfba8b096d27c1525a01ff0b9bba27d3c';

final class RenoteNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RenoteNotifier,
          AsyncValue<void>?,
          AsyncValue<void>?,
          AsyncValue<void>?,
          (Account, Note)
        > {
  RenoteNotifierFamily._()
    : super(
        retry: null,
        name: r'renoteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RenoteNotifierProvider call(Account account, Note note) =>
      RenoteNotifierProvider._(argument: (account, note), from: this);

  @override
  String toString() => r'renoteProvider';
}

abstract class _$RenoteNotifier extends $Notifier<AsyncValue<void>?> {
  late final _$args = ref.$arg as (Account, Note);
  Account get account => _$args.$1;
  Note get note => _$args.$2;

  AsyncValue<void>? build(Account account, Note note);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>?, AsyncValue<void>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>?, AsyncValue<void>?>,
              AsyncValue<void>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}

@ProviderFor(RenoteChannelNotifier)
final renoteChannelProvider = RenoteChannelNotifierFamily._();

final class RenoteChannelNotifierProvider
    extends
        $NotifierProvider<
          RenoteChannelNotifier,
          AsyncValue<CommunityChannel>?
        > {
  RenoteChannelNotifierProvider._({
    required RenoteChannelNotifierFamily super.from,
    required Account super.argument,
  }) : super(
         retry: null,
         name: r'renoteChannelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$renoteChannelNotifierHash();

  @override
  String toString() {
    return r'renoteChannelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RenoteChannelNotifier create() => RenoteChannelNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CommunityChannel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CommunityChannel>?>(
        value,
      ),
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
    r'09c1b8cacb23886e7043b246410f7f0267fcde0d';

final class RenoteChannelNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RenoteChannelNotifier,
          AsyncValue<CommunityChannel>?,
          AsyncValue<CommunityChannel>?,
          AsyncValue<CommunityChannel>?,
          Account
        > {
  RenoteChannelNotifierFamily._()
    : super(
        retry: null,
        name: r'renoteChannelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RenoteChannelNotifierProvider call(Account account) =>
      RenoteChannelNotifierProvider._(argument: account, from: this);

  @override
  String toString() => r'renoteChannelProvider';
}

abstract class _$RenoteChannelNotifier
    extends $Notifier<AsyncValue<CommunityChannel>?> {
  late final _$args = ref.$arg as Account;
  Account get account => _$args;

  AsyncValue<CommunityChannel>? build(Account account);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<CommunityChannel>?,
              AsyncValue<CommunityChannel>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CommunityChannel>?,
                AsyncValue<CommunityChannel>?
              >,
              AsyncValue<CommunityChannel>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(RenoteOtherAccountNotifier)
final renoteOtherAccountProvider = RenoteOtherAccountNotifierFamily._();

final class RenoteOtherAccountNotifierProvider
    extends
        $NotifierProvider<
          RenoteOtherAccountNotifier,
          AsyncValue<(Account, Note)>?
        > {
  RenoteOtherAccountNotifierProvider._({
    required RenoteOtherAccountNotifierFamily super.from,
    required (Account, Note) super.argument,
  }) : super(
         retry: null,
         name: r'renoteOtherAccountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = accountContextProvider;

  @override
  String debugGetCreateSourceHash() => _$renoteOtherAccountNotifierHash();

  @override
  String toString() {
    return r'renoteOtherAccountProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  RenoteOtherAccountNotifier create() => RenoteOtherAccountNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<(Account, Note)>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<(Account, Note)>?>(value),
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
    r'06215b8e751d786de11f16acbbdb031743d36ce8';

final class RenoteOtherAccountNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RenoteOtherAccountNotifier,
          AsyncValue<(Account, Note)>?,
          AsyncValue<(Account, Note)>?,
          AsyncValue<(Account, Note)>?,
          (Account, Note)
        > {
  RenoteOtherAccountNotifierFamily._()
    : super(
        retry: null,
        name: r'renoteOtherAccountProvider',
        dependencies: <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          RenoteOtherAccountNotifierProvider.$allTransitiveDependencies0,
        ],
        isAutoDispose: true,
      );

  RenoteOtherAccountNotifierProvider call(Account account, Note note) =>
      RenoteOtherAccountNotifierProvider._(
        argument: (account, note),
        from: this,
      );

  @override
  String toString() => r'renoteOtherAccountProvider';
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
    final ref =
        this.ref
            as $Ref<AsyncValue<(Account, Note)>?, AsyncValue<(Account, Note)>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<(Account, Note)>?,
                AsyncValue<(Account, Note)>?
              >,
              AsyncValue<(Account, Note)>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
