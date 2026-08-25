// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aiscript_plugin_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 入れてあるプラグインを起動して面倒を見る。
///
/// 一覧は端末ごとだが、実行はアカウントごとに行う。`Mk:api` が使う
/// トークンがアカウントで違うため。

@ProviderFor(AiScriptPluginNotifier)
final aiScriptPluginProvider = AiScriptPluginNotifierFamily._();

/// 入れてあるプラグインを起動して面倒を見る。
///
/// 一覧は端末ごとだが、実行はアカウントごとに行う。`Mk:api` が使う
/// トークンがアカウントで違うため。
final class AiScriptPluginNotifierProvider
    extends $NotifierProvider<AiScriptPluginNotifier, AiScriptPluginState> {
  /// 入れてあるプラグインを起動して面倒を見る。
  ///
  /// 一覧は端末ごとだが、実行はアカウントごとに行う。`Mk:api` が使う
  /// トークンがアカウントで違うため。
  AiScriptPluginNotifierProvider._({
    required AiScriptPluginNotifierFamily super.from,
    required Account super.argument,
  }) : super(
         retry: null,
         name: r'aiScriptPluginProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$aiScriptPluginNotifierHash();

  @override
  String toString() {
    return r'aiScriptPluginProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AiScriptPluginNotifier create() => AiScriptPluginNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiScriptPluginState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiScriptPluginState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AiScriptPluginNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aiScriptPluginNotifierHash() =>
    r'b9ebf5370cbb9e0ddf4f3b5a1495418f0a0b5a36';

/// 入れてあるプラグインを起動して面倒を見る。
///
/// 一覧は端末ごとだが、実行はアカウントごとに行う。`Mk:api` が使う
/// トークンがアカウントで違うため。

final class AiScriptPluginNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          AiScriptPluginNotifier,
          AiScriptPluginState,
          AiScriptPluginState,
          AiScriptPluginState,
          Account
        > {
  AiScriptPluginNotifierFamily._()
    : super(
        retry: null,
        name: r'aiScriptPluginProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// 入れてあるプラグインを起動して面倒を見る。
  ///
  /// 一覧は端末ごとだが、実行はアカウントごとに行う。`Mk:api` が使う
  /// トークンがアカウントで違うため。

  AiScriptPluginNotifierProvider call(Account account) =>
      AiScriptPluginNotifierProvider._(argument: account, from: this);

  @override
  String toString() => r'aiScriptPluginProvider';
}

/// 入れてあるプラグインを起動して面倒を見る。
///
/// 一覧は端末ごとだが、実行はアカウントごとに行う。`Mk:api` が使う
/// トークンがアカウントで違うため。

abstract class _$AiScriptPluginNotifier extends $Notifier<AiScriptPluginState> {
  late final _$args = ref.$arg as Account;
  Account get account => _$args;

  AiScriptPluginState build(Account account);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AiScriptPluginState, AiScriptPluginState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AiScriptPluginState, AiScriptPluginState>,
              AiScriptPluginState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
