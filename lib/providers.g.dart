// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(dio)
const dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio>
    with $Provider<Dio> {
  const DioProvider._()
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
      providerOverride: $ValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'73be4093313fcb2b7055df1752404e24a2b1f68c';

@ProviderFor(fileSystem)
const fileSystemProvider = FileSystemProvider._();

final class FileSystemProvider
    extends $FunctionalProvider<FileSystem, FileSystem>
    with $Provider<FileSystem> {
  const FileSystemProvider._()
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
      providerOverride: $ValueProvider<FileSystem>(value),
    );
  }
}

String _$fileSystemHash() => r'9b96bb59d396159330bbfc15f1c8ea184af0a9b7';

@ProviderFor(misskey)
@Deprecated(
  "Most case will be replace misskeyGetContext or misskeyPostContext, but will be remain",
)
const misskeyProvider = MisskeyFamily._();

final class MisskeyProvider extends $FunctionalProvider<Misskey, Misskey>
    with $Provider<Misskey> {
  const MisskeyProvider._({
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
      providerOverride: $ValueProvider<Misskey>(value),
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

String _$misskeyHash() => r'5f10aa38a56d482bf42572c93b20bb2babd87058';

final class MisskeyFamily extends $Family
    with $FunctionalFamilyOverride<Misskey, Account> {
  const MisskeyFamily._()
    : super(
        retry: null,
        name: r'misskeyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  MisskeyProvider call(Account account) =>
      MisskeyProvider._(argument: account, from: this);

  @override
  String toString() => r'misskeyProvider';
}

@ProviderFor(appRouter)
const appRouterProvider = AppRouterProvider._();

final class AppRouterProvider
    extends $FunctionalProvider<Raw<AppRouter>, Raw<AppRouter>>
    with $Provider<Raw<AppRouter>> {
  const AppRouterProvider._()
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
      providerOverride: $ValueProvider<Raw<AppRouter>>(value),
    );
  }
}

String _$appRouterHash() => r'9ef2ee218086b41ec585ffa1b0ed6b63ebdbb7d8';

@ProviderFor(misskeyWithoutAccount)
const misskeyWithoutAccountProvider = MisskeyWithoutAccountFamily._();

final class MisskeyWithoutAccountProvider
    extends $FunctionalProvider<Misskey, Misskey>
    with $Provider<Misskey> {
  const MisskeyWithoutAccountProvider._({
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
      providerOverride: $ValueProvider<Misskey>(value),
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
    r'e222a8dd22abe066249f52f043f6a6a38446a225';

final class MisskeyWithoutAccountFamily extends $Family
    with $FunctionalFamilyOverride<Misskey, String> {
  const MisskeyWithoutAccountFamily._()
    : super(
        retry: null,
        name: r'misskeyWithoutAccountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MisskeyWithoutAccountProvider call(String host) =>
      MisskeyWithoutAccountProvider._(argument: host, from: this);

  @override
  String toString() => r'misskeyWithoutAccountProvider';
}

@ProviderFor(notesWith)
const notesWithProvider = NotesWithProvider._();

final class NotesWithProvider
    extends $FunctionalProvider<Raw<NoteRepository>, Raw<NoteRepository>>
    with $Provider<Raw<NoteRepository>> {
  const NotesWithProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesWithProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          NotesWithProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = accountContextProvider;

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
      providerOverride: $ValueProvider<Raw<NoteRepository>>(value),
    );
  }
}

String _$notesWithHash() => r'a9573c0a72738c0f75dfba0916d1722cd9be8a44';

@ProviderFor(emojiRepository)
const emojiRepositoryProvider = EmojiRepositoryFamily._();

final class EmojiRepositoryProvider
    extends $FunctionalProvider<EmojiRepository, EmojiRepository>
    with $Provider<EmojiRepository> {
  const EmojiRepositoryProvider._({
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
      providerOverride: $ValueProvider<EmojiRepository>(value),
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

String _$emojiRepositoryHash() => r'a3f4aeaa087ee4b3fd7c433960b5cb4c9c21b7c6';

final class EmojiRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<EmojiRepository, Account> {
  const EmojiRepositoryFamily._()
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
const accountsProvider = AccountsProvider._();

final class AccountsProvider
    extends $FunctionalProvider<List<Account>, List<Account>>
    with $Provider<List<Account>> {
  const AccountsProvider._()
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
      providerOverride: $ValueProvider<List<Account>>(value),
    );
  }
}

String _$accountsHash() => r'6d734a28da45c1d169a7abfbc5405b93078bdc1d';

@ProviderFor(i)
const iProvider = IFamily._();

final class IProvider extends $FunctionalProvider<MeDetailed, MeDetailed>
    with $Provider<MeDetailed> {
  const IProvider._({required IFamily super.from, required Acct super.argument})
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
      providerOverride: $ValueProvider<MeDetailed>(value),
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
  const IFamily._()
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
const accountProvider = AccountFamily._();

final class AccountProvider extends $FunctionalProvider<Account, Account>
    with $Provider<Account> {
  const AccountProvider._({
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
      providerOverride: $ValueProvider<Account>(value),
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
  const AccountFamily._()
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
const cacheManagerProvider = CacheManagerProvider._();

final class CacheManagerProvider
    extends $FunctionalProvider<BaseCacheManager?, BaseCacheManager?>
    with $Provider<BaseCacheManager?> {
  const CacheManagerProvider._()
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
  $ProviderElement<BaseCacheManager?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BaseCacheManager? create(Ref ref) {
    return cacheManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseCacheManager? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<BaseCacheManager?>(value),
    );
  }
}

String _$cacheManagerHash() => r'4de111f3ed09ad0694b65f0a69ee9cacfacae1e7';

@ProviderFor(accountContext)
const accountContextProvider = AccountContextProvider._();

final class AccountContextProvider
    extends $FunctionalProvider<AccountContext, AccountContext>
    with $Provider<AccountContext> {
  const AccountContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountContextProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[],
        $allTransitiveDependencies: const <ProviderOrFamily>[],
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
      providerOverride: $ValueProvider<AccountContext>(value),
    );
  }
}

String _$accountContextHash() => r'60c79f603d793d1efa1077712179b03cc831f51a';

@ProviderFor(misskeyGetContext)
const misskeyGetContextProvider = MisskeyGetContextProvider._();

final class MisskeyGetContextProvider
    extends $FunctionalProvider<Misskey, Misskey>
    with $Provider<Misskey> {
  const MisskeyGetContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misskeyGetContextProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          MisskeyGetContextProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = accountContextProvider;

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
      providerOverride: $ValueProvider<Misskey>(value),
    );
  }
}

String _$misskeyGetContextHash() => r'fc267a3d020bd51305b5def2d9badedf26c4faac';

@ProviderFor(misskeyPostContext)
const misskeyPostContextProvider = MisskeyPostContextProvider._();

final class MisskeyPostContextProvider
    extends $FunctionalProvider<Misskey, Misskey>
    with $Provider<Misskey> {
  const MisskeyPostContextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misskeyPostContextProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          MisskeyPostContextProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = accountContextProvider;

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
      providerOverride: $ValueProvider<Misskey>(value),
    );
  }
}

String _$misskeyPostContextHash() =>
    r'2132cf565692af187c7efa17b3350e53c8c4d6fa';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
