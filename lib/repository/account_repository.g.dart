// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AccountRepository)
final accountRepositoryProvider = AccountRepositoryProvider._();

final class AccountRepositoryProvider
    extends $NotifierProvider<AccountRepository, List<Account>> {
  AccountRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountRepositoryHash();

  @$internal
  @override
  AccountRepository create() => AccountRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Account> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Account>>(value),
    );
  }
}

String _$accountRepositoryHash() => r'79dbcc9020ca1905a09340adc1d18a75427e9957';

abstract class _$AccountRepository extends $Notifier<List<Account>> {
  List<Account> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Account>, List<Account>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Account>, List<Account>>,
              List<Account>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
