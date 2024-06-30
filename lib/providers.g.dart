// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioHash() => r'41b696b35e5b56ccb124ee5abab8b893747d2153';

/// See also [dio].
@ProviderFor(dio)
final dioProvider = Provider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DioRef = ProviderRef<Dio>;
String _$fileSystemHash() => r'98684b2a2a8fd9ee5818ec713ba28d29da92c168';

/// See also [fileSystem].
@ProviderFor(fileSystem)
final fileSystemProvider = Provider<FileSystem>.internal(
  fileSystem,
  name: r'fileSystemProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fileSystemHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FileSystemRef = ProviderRef<FileSystem>;
String _$misskeyHash() => r'796d9e849aca70f97031c38e646439a01bc5abe5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [misskey].
@ProviderFor(misskey)
@Deprecated(
    "Most case will be replace misskeyGetContext or misskeyPostContext, but will be remain")
const misskeyProvider = MisskeyFamily();

/// See also [misskey].
class MisskeyFamily extends Family {
  /// See also [misskey].
  const MisskeyFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'misskeyProvider';

  /// See also [misskey].
  MisskeyProvider call(
    Account account,
  ) {
    return MisskeyProvider(
      account,
    );
  }

  @visibleForOverriding
  @override
  MisskeyProvider getProviderOverride(
    covariant MisskeyProvider provider,
  ) {
    return call(
      provider.account,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(Misskey Function(MisskeyRef ref) create) {
    return _$MisskeyFamilyOverride(this, create);
  }
}

class _$MisskeyFamilyOverride implements FamilyOverride {
  _$MisskeyFamilyOverride(this.overriddenFamily, this.create);

  final Misskey Function(MisskeyRef ref) create;

  @override
  final MisskeyFamily overriddenFamily;

  @override
  MisskeyProvider getProviderOverride(
    covariant MisskeyProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [misskey].
class MisskeyProvider extends Provider<Misskey> {
  /// See also [misskey].
  MisskeyProvider(
    Account account,
  ) : this._internal(
          (ref) => misskey(
            ref as MisskeyRef,
            account,
          ),
          from: misskeyProvider,
          name: r'misskeyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$misskeyHash,
          dependencies: MisskeyFamily._dependencies,
          allTransitiveDependencies: MisskeyFamily._allTransitiveDependencies,
          account: account,
        );

  MisskeyProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
  }) : super.internal();

  final Account account;

  @override
  Override overrideWith(
    Misskey Function(MisskeyRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MisskeyProvider._internal(
        (ref) => create(ref as MisskeyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
      ),
    );
  }

  @override
  (Account,) get argument {
    return (account,);
  }

  @override
  ProviderElement<Misskey> createElement() {
    return _MisskeyProviderElement(this);
  }

  MisskeyProvider _copyWith(
    Misskey Function(MisskeyRef ref) create,
  ) {
    return MisskeyProvider._internal(
      (ref) => create(ref as MisskeyRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      account: account,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MisskeyProvider && other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MisskeyRef on ProviderRef<Misskey> {
  /// The parameter `account` of this provider.
  Account get account;
}

class _MisskeyProviderElement extends ProviderElement<Misskey> with MisskeyRef {
  _MisskeyProviderElement(super.provider);

  @override
  Account get account => (origin as MisskeyProvider).account;
}

String _$misskeyWithoutAccountHash() =>
    r'69fd2ed57ba01ab828bd39dd8adde72f977dd91e';

/// See also [misskeyWithoutAccount].
@ProviderFor(misskeyWithoutAccount)
const misskeyWithoutAccountProvider = MisskeyWithoutAccountFamily();

/// See also [misskeyWithoutAccount].
class MisskeyWithoutAccountFamily extends Family {
  /// See also [misskeyWithoutAccount].
  const MisskeyWithoutAccountFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'misskeyWithoutAccountProvider';

  /// See also [misskeyWithoutAccount].
  MisskeyWithoutAccountProvider call(
    String host,
  ) {
    return MisskeyWithoutAccountProvider(
      host,
    );
  }

  @visibleForOverriding
  @override
  MisskeyWithoutAccountProvider getProviderOverride(
    covariant MisskeyWithoutAccountProvider provider,
  ) {
    return call(
      provider.host,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(Misskey Function(MisskeyWithoutAccountRef ref) create) {
    return _$MisskeyWithoutAccountFamilyOverride(this, create);
  }
}

class _$MisskeyWithoutAccountFamilyOverride implements FamilyOverride {
  _$MisskeyWithoutAccountFamilyOverride(this.overriddenFamily, this.create);

  final Misskey Function(MisskeyWithoutAccountRef ref) create;

  @override
  final MisskeyWithoutAccountFamily overriddenFamily;

  @override
  MisskeyWithoutAccountProvider getProviderOverride(
    covariant MisskeyWithoutAccountProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [misskeyWithoutAccount].
class MisskeyWithoutAccountProvider extends AutoDisposeProvider<Misskey> {
  /// See also [misskeyWithoutAccount].
  MisskeyWithoutAccountProvider(
    String host,
  ) : this._internal(
          (ref) => misskeyWithoutAccount(
            ref as MisskeyWithoutAccountRef,
            host,
          ),
          from: misskeyWithoutAccountProvider,
          name: r'misskeyWithoutAccountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$misskeyWithoutAccountHash,
          dependencies: MisskeyWithoutAccountFamily._dependencies,
          allTransitiveDependencies:
              MisskeyWithoutAccountFamily._allTransitiveDependencies,
          host: host,
        );

  MisskeyWithoutAccountProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.host,
  }) : super.internal();

  final String host;

  @override
  Override overrideWith(
    Misskey Function(MisskeyWithoutAccountRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MisskeyWithoutAccountProvider._internal(
        (ref) => create(ref as MisskeyWithoutAccountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        host: host,
      ),
    );
  }

  @override
  (String,) get argument {
    return (host,);
  }

  @override
  AutoDisposeProviderElement<Misskey> createElement() {
    return _MisskeyWithoutAccountProviderElement(this);
  }

  MisskeyWithoutAccountProvider _copyWith(
    Misskey Function(MisskeyWithoutAccountRef ref) create,
  ) {
    return MisskeyWithoutAccountProvider._internal(
      (ref) => create(ref as MisskeyWithoutAccountRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      host: host,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MisskeyWithoutAccountProvider && other.host == host;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, host.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MisskeyWithoutAccountRef on AutoDisposeProviderRef<Misskey> {
  /// The parameter `host` of this provider.
  String get host;
}

class _MisskeyWithoutAccountProviderElement
    extends AutoDisposeProviderElement<Misskey> with MisskeyWithoutAccountRef {
  _MisskeyWithoutAccountProviderElement(super.provider);

  @override
  String get host => (origin as MisskeyWithoutAccountProvider).host;
}

String _$notesWithHash() => r'0650987360236bb7d00f08b92ab03ebb6bfeb413';

/// See also [notesWith].
@ProviderFor(notesWith)
final notesWithProvider = AutoDisposeProvider<Raw<NoteRepository>>.internal(
  notesWith,
  name: r'notesWithProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$notesWithHash,
  dependencies: <ProviderOrFamily>[accountContextProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    accountContextProvider,
    ...?accountContextProvider.allTransitiveDependencies
  },
);

typedef NotesWithRef = AutoDisposeProviderRef<Raw<NoteRepository>>;
String _$emojiRepositoryHash() => r'cce1a6d3e6daba91779840fde7973c6e6987e471';

/// See also [emojiRepository].
@ProviderFor(emojiRepository)
const emojiRepositoryProvider = EmojiRepositoryFamily();

/// See also [emojiRepository].
class EmojiRepositoryFamily extends Family {
  /// See also [emojiRepository].
  const EmojiRepositoryFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'emojiRepositoryProvider';

  /// See also [emojiRepository].
  EmojiRepositoryProvider call(
    Account account,
  ) {
    return EmojiRepositoryProvider(
      account,
    );
  }

  @visibleForOverriding
  @override
  EmojiRepositoryProvider getProviderOverride(
    covariant EmojiRepositoryProvider provider,
  ) {
    return call(
      provider.account,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(
      EmojiRepository Function(EmojiRepositoryRef ref) create) {
    return _$EmojiRepositoryFamilyOverride(this, create);
  }
}

class _$EmojiRepositoryFamilyOverride implements FamilyOverride {
  _$EmojiRepositoryFamilyOverride(this.overriddenFamily, this.create);

  final EmojiRepository Function(EmojiRepositoryRef ref) create;

  @override
  final EmojiRepositoryFamily overriddenFamily;

  @override
  EmojiRepositoryProvider getProviderOverride(
    covariant EmojiRepositoryProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [emojiRepository].
class EmojiRepositoryProvider extends Provider<EmojiRepository> {
  /// See also [emojiRepository].
  EmojiRepositoryProvider(
    Account account,
  ) : this._internal(
          (ref) => emojiRepository(
            ref as EmojiRepositoryRef,
            account,
          ),
          from: emojiRepositoryProvider,
          name: r'emojiRepositoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$emojiRepositoryHash,
          dependencies: EmojiRepositoryFamily._dependencies,
          allTransitiveDependencies:
              EmojiRepositoryFamily._allTransitiveDependencies,
          account: account,
        );

  EmojiRepositoryProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
  }) : super.internal();

  final Account account;

  @override
  Override overrideWith(
    EmojiRepository Function(EmojiRepositoryRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EmojiRepositoryProvider._internal(
        (ref) => create(ref as EmojiRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
      ),
    );
  }

  @override
  (Account,) get argument {
    return (account,);
  }

  @override
  ProviderElement<EmojiRepository> createElement() {
    return _EmojiRepositoryProviderElement(this);
  }

  EmojiRepositoryProvider _copyWith(
    EmojiRepository Function(EmojiRepositoryRef ref) create,
  ) {
    return EmojiRepositoryProvider._internal(
      (ref) => create(ref as EmojiRepositoryRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      account: account,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EmojiRepositoryProvider && other.account == account;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EmojiRepositoryRef on ProviderRef<EmojiRepository> {
  /// The parameter `account` of this provider.
  Account get account;
}

class _EmojiRepositoryProviderElement extends ProviderElement<EmojiRepository>
    with EmojiRepositoryRef {
  _EmojiRepositoryProviderElement(super.provider);

  @override
  Account get account => (origin as EmojiRepositoryProvider).account;
}

String _$accountsHash() => r'd70730d18b80a35f4fac0b25ec10004ce706bef9';

/// See also [accounts].
@ProviderFor(accounts)
final accountsProvider = AutoDisposeProvider<List<Account>>.internal(
  accounts,
  name: r'accountsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$accountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AccountsRef = AutoDisposeProviderRef<List<Account>>;
String _$iHash() => r'ed4b1dd720889e8c1651bba7506fcb941b45342d';

/// See also [i].
@ProviderFor(i)
const iProvider = IFamily();

/// See also [i].
class IFamily extends Family {
  /// See also [i].
  const IFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'iProvider';

  /// See also [i].
  IProvider call(
    Acct acct,
  ) {
    return IProvider(
      acct,
    );
  }

  @visibleForOverriding
  @override
  IProvider getProviderOverride(
    covariant IProvider provider,
  ) {
    return call(
      provider.acct,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(MeDetailed Function(IRef ref) create) {
    return _$IFamilyOverride(this, create);
  }
}

class _$IFamilyOverride implements FamilyOverride {
  _$IFamilyOverride(this.overriddenFamily, this.create);

  final MeDetailed Function(IRef ref) create;

  @override
  final IFamily overriddenFamily;

  @override
  IProvider getProviderOverride(
    covariant IProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [i].
class IProvider extends AutoDisposeProvider<MeDetailed> {
  /// See also [i].
  IProvider(
    Acct acct,
  ) : this._internal(
          (ref) => i(
            ref as IRef,
            acct,
          ),
          from: iProvider,
          name: r'iProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$iHash,
          dependencies: IFamily._dependencies,
          allTransitiveDependencies: IFamily._allTransitiveDependencies,
          acct: acct,
        );

  IProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.acct,
  }) : super.internal();

  final Acct acct;

  @override
  Override overrideWith(
    MeDetailed Function(IRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IProvider._internal(
        (ref) => create(ref as IRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        acct: acct,
      ),
    );
  }

  @override
  (Acct,) get argument {
    return (acct,);
  }

  @override
  AutoDisposeProviderElement<MeDetailed> createElement() {
    return _IProviderElement(this);
  }

  IProvider _copyWith(
    MeDetailed Function(IRef ref) create,
  ) {
    return IProvider._internal(
      (ref) => create(ref as IRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      acct: acct,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IProvider && other.acct == acct;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, acct.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IRef on AutoDisposeProviderRef<MeDetailed> {
  /// The parameter `acct` of this provider.
  Acct get acct;
}

class _IProviderElement extends AutoDisposeProviderElement<MeDetailed>
    with IRef {
  _IProviderElement(super.provider);

  @override
  Acct get acct => (origin as IProvider).acct;
}

String _$accountHash() => r'1614cc4c66271ef2e69f4a527237ec179b58db56';

/// See also [account].
@ProviderFor(account)
const accountProvider = AccountFamily();

/// See also [account].
class AccountFamily extends Family {
  /// See also [account].
  const AccountFamily();

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'accountProvider';

  /// See also [account].
  AccountProvider call(
    Acct acct,
  ) {
    return AccountProvider(
      acct,
    );
  }

  @visibleForOverriding
  @override
  AccountProvider getProviderOverride(
    covariant AccountProvider provider,
  ) {
    return call(
      provider.acct,
    );
  }

  /// Enables overriding the behavior of this provider, no matter the parameters.
  Override overrideWith(Account Function(AccountRef ref) create) {
    return _$AccountFamilyOverride(this, create);
  }
}

class _$AccountFamilyOverride implements FamilyOverride {
  _$AccountFamilyOverride(this.overriddenFamily, this.create);

  final Account Function(AccountRef ref) create;

  @override
  final AccountFamily overriddenFamily;

  @override
  AccountProvider getProviderOverride(
    covariant AccountProvider provider,
  ) {
    return provider._copyWith(create);
  }
}

/// See also [account].
class AccountProvider extends AutoDisposeProvider<Account> {
  /// See also [account].
  AccountProvider(
    Acct acct,
  ) : this._internal(
          (ref) => account(
            ref as AccountRef,
            acct,
          ),
          from: accountProvider,
          name: r'accountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountHash,
          dependencies: AccountFamily._dependencies,
          allTransitiveDependencies: AccountFamily._allTransitiveDependencies,
          acct: acct,
        );

  AccountProvider._internal(
    super.create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.acct,
  }) : super.internal();

  final Acct acct;

  @override
  Override overrideWith(
    Account Function(AccountRef ref) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountProvider._internal(
        (ref) => create(ref as AccountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        acct: acct,
      ),
    );
  }

  @override
  (Acct,) get argument {
    return (acct,);
  }

  @override
  AutoDisposeProviderElement<Account> createElement() {
    return _AccountProviderElement(this);
  }

  AccountProvider _copyWith(
    Account Function(AccountRef ref) create,
  ) {
    return AccountProvider._internal(
      (ref) => create(ref as AccountRef),
      name: name,
      dependencies: dependencies,
      allTransitiveDependencies: allTransitiveDependencies,
      debugGetCreateSourceHash: debugGetCreateSourceHash,
      from: from,
      acct: acct,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AccountProvider && other.acct == acct;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, acct.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountRef on AutoDisposeProviderRef<Account> {
  /// The parameter `acct` of this provider.
  Acct get acct;
}

class _AccountProviderElement extends AutoDisposeProviderElement<Account>
    with AccountRef {
  _AccountProviderElement(super.provider);

  @override
  Acct get acct => (origin as AccountProvider).acct;
}

String _$cacheManagerHash() => r'0e854572e1bd7223650c8437a463a060314d0531';

/// See also [cacheManager].
@ProviderFor(cacheManager)
final cacheManagerProvider = Provider<BaseCacheManager?>.internal(
  cacheManager,
  name: r'cacheManagerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cacheManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CacheManagerRef = ProviderRef<BaseCacheManager?>;
String _$accountContextHash() => r'1c9bff1004e7054ed091327e5a83c07d9da2c20a';

/// See also [accountContext].
@ProviderFor(accountContext)
final accountContextProvider = AutoDisposeProvider<AccountContext>.internal(
  accountContext,
  name: r'accountContextProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountContextHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

typedef AccountContextRef = AutoDisposeProviderRef<AccountContext>;
String _$misskeyGetContextHash() => r'856e0720ad5d5a6fc0195f9974b0ae011677da27';

/// See also [misskeyGetContext].
@ProviderFor(misskeyGetContext)
final misskeyGetContextProvider = AutoDisposeProvider<Misskey>.internal(
  misskeyGetContext,
  name: r'misskeyGetContextProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$misskeyGetContextHash,
  dependencies: <ProviderOrFamily>[accountContextProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    accountContextProvider,
    ...?accountContextProvider.allTransitiveDependencies
  },
);

typedef MisskeyGetContextRef = AutoDisposeProviderRef<Misskey>;
String _$misskeyPostContextHash() =>
    r'4ca2dd620727f94948027056882dace0ef16e955';

/// See also [misskeyPostContext].
@ProviderFor(misskeyPostContext)
final misskeyPostContextProvider = AutoDisposeProvider<Misskey>.internal(
  misskeyPostContext,
  name: r'misskeyPostContextProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$misskeyPostContextHash,
  dependencies: <ProviderOrFamily>[accountContextProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    accountContextProvider,
    ...?accountContextProvider.allTransitiveDependencies
  },
);

typedef MisskeyPostContextRef = AutoDisposeProviderRef<Misskey>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, inference_failure_on_uninitialized_variable, inference_failure_on_function_return_type, inference_failure_on_untyped_parameter, deprecated_member_use_from_same_package
