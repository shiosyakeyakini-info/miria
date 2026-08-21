// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dio)
final dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'26309262f0000d1b9dc277bb27f212a83dea1b6b';

@ProviderFor(fileSystem)
final fileSystemProvider = FileSystemProvider._();

final class FileSystemProvider
    extends $FunctionalProvider<FileSystem, FileSystem, FileSystem>
    with $Provider<FileSystem> {
  FileSystemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileSystemProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileSystemHash();

  @$internal
  @override
  $ProviderElement<FileSystem> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FileSystem create(Ref ref) {
    return fileSystem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileSystem value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileSystem>(value),
    );
  }
}

String _$fileSystemHash() => r'9b96bb59d396159330bbfc15f1c8ea184af0a9b7';

/// 実績名の対訳表。表示言語を変えたら引き直す。

@ProviderFor(achievements)
final achievementsProvider = AchievementsProvider._();

/// 実績名の対訳表。表示言語を変えたら引き直す。

final class AchievementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Achievements>,
          Achievements,
          FutureOr<Achievements>
        >
    with $FutureModifier<Achievements>, $FutureProvider<Achievements> {
  /// 実績名の対訳表。表示言語を変えたら引き直す。
  AchievementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'achievementsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$achievementsHash();

  @$internal
  @override
  $FutureProviderElement<Achievements> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Achievements> create(Ref ref) {
    return achievements(ref);
  }
}

String _$achievementsHash() => r'04523e9f4daab6bbe9cdf956d1e472bd4c680a7e';

/// 再認証で差し替わったアカウントのトークン。まだ差し替わっていなければ null。
///
/// [misskey] から [AccountRepository] を直接 watch すれば済みそうに見えるが、
/// [AccountRepository] 自身が [emojiRepository] 経由で [misskey] を読むため
/// 循環参照になる。トークンだけを一方通行の provider に切り出している。

@ProviderFor(LatestAccountToken)
final latestAccountTokenProvider = LatestAccountTokenFamily._();

/// 再認証で差し替わったアカウントのトークン。まだ差し替わっていなければ null。
///
/// [misskey] から [AccountRepository] を直接 watch すれば済みそうに見えるが、
/// [AccountRepository] 自身が [emojiRepository] 経由で [misskey] を読むため
/// 循環参照になる。トークンだけを一方通行の provider に切り出している。
final class LatestAccountTokenProvider
    extends $NotifierProvider<LatestAccountToken, String?> {
  /// 再認証で差し替わったアカウントのトークン。まだ差し替わっていなければ null。
  ///
  /// [misskey] から [AccountRepository] を直接 watch すれば済みそうに見えるが、
  /// [AccountRepository] 自身が [emojiRepository] 経由で [misskey] を読むため
  /// 循環参照になる。トークンだけを一方通行の provider に切り出している。
  LatestAccountTokenProvider._({
    required LatestAccountTokenFamily super.from,
    required Acct super.argument,
  }) : super(
         retry: null,
         name: r'latestAccountTokenProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$latestAccountTokenHash();

  @override
  String toString() {
    return r'latestAccountTokenProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LatestAccountToken create() => LatestAccountToken();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LatestAccountTokenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$latestAccountTokenHash() =>
    r'0ef1d3156b8af62c8fc2d7f3c34bdbf506cca88d';

/// 再認証で差し替わったアカウントのトークン。まだ差し替わっていなければ null。
///
/// [misskey] から [AccountRepository] を直接 watch すれば済みそうに見えるが、
/// [AccountRepository] 自身が [emojiRepository] 経由で [misskey] を読むため
/// 循環参照になる。トークンだけを一方通行の provider に切り出している。

final class LatestAccountTokenFamily extends $Family
    with
        $ClassFamilyOverride<
          LatestAccountToken,
          String?,
          String?,
          String?,
          Acct
        > {
  LatestAccountTokenFamily._()
    : super(
        retry: null,
        name: r'latestAccountTokenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// 再認証で差し替わったアカウントのトークン。まだ差し替わっていなければ null。
  ///
  /// [misskey] から [AccountRepository] を直接 watch すれば済みそうに見えるが、
  /// [AccountRepository] 自身が [emojiRepository] 経由で [misskey] を読むため
  /// 循環参照になる。トークンだけを一方通行の provider に切り出している。

  LatestAccountTokenProvider call(Acct acct) =>
      LatestAccountTokenProvider._(argument: acct, from: this);

  @override
  String toString() => r'latestAccountTokenProvider';
}

/// 再認証で差し替わったアカウントのトークン。まだ差し替わっていなければ null。
///
/// [misskey] から [AccountRepository] を直接 watch すれば済みそうに見えるが、
/// [AccountRepository] 自身が [emojiRepository] 経由で [misskey] を読むため
/// 循環参照になる。トークンだけを一方通行の provider に切り出している。

abstract class _$LatestAccountToken extends $Notifier<String?> {
  late final _$args = ref.$arg as Acct;
  Acct get acct => _$args;

  String? build(Acct acct);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(misskey)
@Deprecated(
  'Most case will be replace misskeyGetContext or misskeyPostContext, but will be remain',
)
final misskeyProvider = MisskeyFamily._();

@Deprecated(
  'Most case will be replace misskeyGetContext or misskeyPostContext, but will be remain',
)
final class MisskeyProvider
    extends $FunctionalProvider<Misskey, Misskey, Misskey>
    with $Provider<Misskey> {
  MisskeyProvider._({
    required MisskeyFamily super.from,
    required Account super.argument,
  }) : super(
         retry: null,
         name: r'misskeyProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$misskeyHash();

  @override
  String toString() {
    return r'misskeyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Misskey> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Misskey create(Ref ref) {
    final argument = this.argument as Account;
    return misskey(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Misskey value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Misskey>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MisskeyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$misskeyHash() => r'4366215e55c7927fbb561e5a158b87f93c1b3869';

@Deprecated(
  'Most case will be replace misskeyGetContext or misskeyPostContext, but will be remain',
)
final class MisskeyFamily extends $Family
    with $FunctionalFamilyOverride<Misskey, Account> {
  MisskeyFamily._()
    : super(
        retry: null,
        name: r'misskeyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  @Deprecated(
    'Most case will be replace misskeyGetContext or misskeyPostContext, but will be remain',
  )
  MisskeyProvider call(Account account) =>
      MisskeyProvider._(argument: account, from: this);

  @override
  String toString() => r'misskeyProvider';
}

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

final class AppRouterProvider
    extends $FunctionalProvider<Raw<AppRouter>, Raw<AppRouter>, Raw<AppRouter>>
    with $Provider<Raw<AppRouter>> {
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<Raw<AppRouter>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Raw<AppRouter> create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<AppRouter> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<AppRouter>>(value),
    );
  }
}

String _$appRouterHash() => r'9ef2ee218086b41ec585ffa1b0ed6b63ebdbb7d8';

@ProviderFor(misskeyWithoutAccount)
final misskeyWithoutAccountProvider = MisskeyWithoutAccountFamily._();

final class MisskeyWithoutAccountProvider
    extends $FunctionalProvider<Misskey, Misskey, Misskey>
    with $Provider<Misskey> {
  MisskeyWithoutAccountProvider._({
    required MisskeyWithoutAccountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'misskeyWithoutAccountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$misskeyWithoutAccountHash();

  @override
  String toString() {
    return r'misskeyWithoutAccountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Misskey> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Misskey create(Ref ref) {
    final argument = this.argument as String;
    return misskeyWithoutAccount(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Misskey value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Misskey>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MisskeyWithoutAccountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$misskeyWithoutAccountHash() =>
    r'1cebee6922380b9c1e0e7ff964edba58635511fd';

final class MisskeyWithoutAccountFamily extends $Family
    with $FunctionalFamilyOverride<Misskey, String> {
  MisskeyWithoutAccountFamily._()
    : super(
        retry: null,
        name: r'misskeyWithoutAccountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MisskeyWithoutAccountProvider call(String hostOrUrl) =>
      MisskeyWithoutAccountProvider._(argument: hostOrUrl, from: this);

  @override
  String toString() => r'misskeyWithoutAccountProvider';
}

@ProviderFor(notesWith)
final notesWithProvider = NotesWithProvider._();

final class NotesWithProvider
    extends
        $FunctionalProvider<
          Raw<NoteRepository>,
          Raw<NoteRepository>,
          Raw<NoteRepository>
        >
    with $Provider<Raw<NoteRepository>> {
  NotesWithProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesWithProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          NotesWithProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = accountContextProvider;

  @override
  String debugGetCreateSourceHash() => _$notesWithHash();

  @$internal
  @override
  $ProviderElement<Raw<NoteRepository>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Raw<NoteRepository> create(Ref ref) {
    return notesWith(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<NoteRepository> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<NoteRepository>>(value),
    );
  }
}

String _$notesWithHash() => r'a9573c0a72738c0f75dfba0916d1722cd9be8a44';

@ProviderFor(emojiRepository)
final emojiRepositoryProvider = EmojiRepositoryFamily._();

final class EmojiRepositoryProvider
    extends
        $FunctionalProvider<EmojiRepository, EmojiRepository, EmojiRepository>
    with $Provider<EmojiRepository> {
  EmojiRepositoryProvider._({
    required EmojiRepositoryFamily super.from,
    required Account super.argument,
  }) : super(
         retry: null,
         name: r'emojiRepositoryProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$emojiRepositoryHash();

  @override
  String toString() {
    return r'emojiRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<EmojiRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EmojiRepository create(Ref ref) {
    final argument = this.argument as Account;
    return emojiRepository(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmojiRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmojiRepository>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EmojiRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$emojiRepositoryHash() => r'07d72eba6563ff08950d1d074dd322975681aef9';

final class EmojiRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<EmojiRepository, Account> {
  EmojiRepositoryFamily._()
    : super(
        retry: null,
        name: r'emojiRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  EmojiRepositoryProvider call(Account account) =>
      EmojiRepositoryProvider._(argument: account, from: this);

  @override
  String toString() => r'emojiRepositoryProvider';
}

@ProviderFor(accounts)
final accountsProvider = AccountsProvider._();

final class AccountsProvider
    extends $FunctionalProvider<List<Account>, List<Account>, List<Account>>
    with $Provider<List<Account>> {
  AccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountsHash();

  @$internal
  @override
  $ProviderElement<List<Account>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Account> create(Ref ref) {
    return accounts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Account> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Account>>(value),
    );
  }
}

String _$accountsHash() => r'6d734a28da45c1d169a7abfbc5405b93078bdc1d';

@ProviderFor(i)
final iProvider = IFamily._();

final class IProvider
    extends $FunctionalProvider<MeDetailed, MeDetailed, MeDetailed>
    with $Provider<MeDetailed> {
  IProvider._({required IFamily super.from, required Acct super.argument})
    : super(
        retry: null,
        name: r'iProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iHash();

  @override
  String toString() {
    return r'iProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MeDetailed> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MeDetailed create(Ref ref) {
    final argument = this.argument as Acct;
    return i(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeDetailed value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeDetailed>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$iHash() => r'eb59c9498f7460da48dbfba37dd31a55083cc71d';

final class IFamily extends $Family
    with $FunctionalFamilyOverride<MeDetailed, Acct> {
  IFamily._()
    : super(
        retry: null,
        name: r'iProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IProvider call(Acct acct) => IProvider._(argument: acct, from: this);

  @override
  String toString() => r'iProvider';
}

@ProviderFor(account)
final accountProvider = AccountFamily._();

final class AccountProvider
    extends $FunctionalProvider<Account, Account, Account>
    with $Provider<Account> {
  AccountProvider._({
    required AccountFamily super.from,
    required Acct super.argument,
  }) : super(
         retry: null,
         name: r'accountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$accountHash();

  @override
  String toString() {
    return r'accountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Account> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Account create(Ref ref) {
    final argument = this.argument as Acct;
    return account(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Account value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Account>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AccountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$accountHash() => r'cc90ca8feaa911a399c33aaa744345120b0cfae4';

final class AccountFamily extends $Family
    with $FunctionalFamilyOverride<Account, Acct> {
  AccountFamily._()
    : super(
        retry: null,
        name: r'accountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AccountProvider call(Acct acct) =>
      AccountProvider._(argument: acct, from: this);

  @override
  String toString() => r'accountProvider';
}

@ProviderFor(cacheManager)
final cacheManagerProvider = CacheManagerProvider._();

final class CacheManagerProvider
    extends $FunctionalProvider<CacheManager, CacheManager, CacheManager>
    with $Provider<CacheManager> {
  CacheManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheManagerHash();

  @$internal
  @override
  $ProviderElement<CacheManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CacheManager create(Ref ref) {
    return cacheManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CacheManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CacheManager>(value),
    );
  }
}

String _$cacheManagerHash() => r'35e531d61d807b28b881aeee098bfd076a99e068';

@ProviderFor(miriaWindowListener)
final miriaWindowListenerProvider = MiriaWindowListenerProvider._();

final class MiriaWindowListenerProvider
    extends
        $FunctionalProvider<
          MiriaWindowListener,
          MiriaWindowListener,
          MiriaWindowListener
        >
    with $Provider<MiriaWindowListener> {
  MiriaWindowListenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'miriaWindowListenerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$miriaWindowListenerHash();

  @$internal
  @override
  $ProviderElement<MiriaWindowListener> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MiriaWindowListener create(Ref ref) {
    return miriaWindowListener(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MiriaWindowListener value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MiriaWindowListener>(value),
    );
  }
}

String _$miriaWindowListenerHash() =>
    r'5f1551bf4377d43a7a4ff48f82703eed5c0218bc';

@ProviderFor(accountContext)
final accountContextProvider = AccountContextProvider._();

final class AccountContextProvider
    extends $FunctionalProvider<AccountContext, AccountContext, AccountContext>
    with $Provider<AccountContext> {
  AccountContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountContextProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$accountContextHash();

  @$internal
  @override
  $ProviderElement<AccountContext> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccountContext create(Ref ref) {
    return accountContext(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountContext value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountContext>(value),
    );
  }
}

String _$accountContextHash() => r'60c79f603d793d1efa1077712179b03cc831f51a';

@ProviderFor(misskeyGetContext)
final misskeyGetContextProvider = MisskeyGetContextProvider._();

final class MisskeyGetContextProvider
    extends $FunctionalProvider<Misskey, Misskey, Misskey>
    with $Provider<Misskey> {
  MisskeyGetContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misskeyGetContextProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          MisskeyGetContextProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = accountContextProvider;

  @override
  String debugGetCreateSourceHash() => _$misskeyGetContextHash();

  @$internal
  @override
  $ProviderElement<Misskey> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Misskey create(Ref ref) {
    return misskeyGetContext(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Misskey value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Misskey>(value),
    );
  }
}

String _$misskeyGetContextHash() => r'94040ebfd1b6217a4e9a57ae4fec722518fd895a';

@ProviderFor(misskeyPostContext)
final misskeyPostContextProvider = MisskeyPostContextProvider._();

final class MisskeyPostContextProvider
    extends $FunctionalProvider<Misskey, Misskey, Misskey>
    with $Provider<Misskey> {
  MisskeyPostContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misskeyPostContextProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          MisskeyPostContextProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = accountContextProvider;

  @override
  String debugGetCreateSourceHash() => _$misskeyPostContextHash();

  @$internal
  @override
  $ProviderElement<Misskey> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Misskey create(Ref ref) {
    return misskeyPostContext(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Misskey value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Misskey>(value),
    );
  }
}

String _$misskeyPostContextHash() =>
    r'2a3f314cdde5415eb1fe46ace933785f03ee22b1';
