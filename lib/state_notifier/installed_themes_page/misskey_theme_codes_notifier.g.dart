// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'misskey_theme_codes_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(MisskeyThemeCodesNotifier)
const misskeyThemeCodesNotifierProvider = MisskeyThemeCodesNotifierProvider._();

final class MisskeyThemeCodesNotifierProvider
    extends $AsyncNotifierProvider<MisskeyThemeCodesNotifier, List<String>> {
  const MisskeyThemeCodesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misskeyThemeCodesNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$misskeyThemeCodesNotifierHash();

  @$internal
  @override
  MisskeyThemeCodesNotifier create() => MisskeyThemeCodesNotifier();
}

String _$misskeyThemeCodesNotifierHash() =>
    r'1652e8ab8d892a3318dec198f4086bef1f2357a3';

abstract class _$MisskeyThemeCodesNotifier
    extends $AsyncNotifier<List<String>> {
  FutureOr<List<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<String>>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<String>>, List<String>>,
              AsyncValue<List<String>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(misskeyThemes)
const misskeyThemesProvider = MisskeyThemesProvider._();

final class MisskeyThemesProvider
    extends
        $FunctionalProvider<
          List<MisskeyTheme?>,
          List<MisskeyTheme?>,
          List<MisskeyTheme?>
        >
    with $Provider<List<MisskeyTheme?>> {
  const MisskeyThemesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'misskeyThemesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$misskeyThemesHash();

  @$internal
  @override
  $ProviderElement<List<MisskeyTheme?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<MisskeyTheme?> create(Ref ref) {
    return misskeyThemes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<MisskeyTheme?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<MisskeyTheme?>>(value),
    );
  }
}

String _$misskeyThemesHash() => r'68aa53d2ad61a1c3aebf2fc77fea1ee5c7b382e9';

@ProviderFor(installedColorThemes)
const installedColorThemesProvider = InstalledColorThemesProvider._();

final class InstalledColorThemesProvider
    extends
        $FunctionalProvider<
          List<ColorTheme>,
          List<ColorTheme>,
          List<ColorTheme>
        >
    with $Provider<List<ColorTheme>> {
  const InstalledColorThemesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'installedColorThemesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$installedColorThemesHash();

  @$internal
  @override
  $ProviderElement<List<ColorTheme>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<ColorTheme> create(Ref ref) {
    return installedColorThemes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ColorTheme> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ColorTheme>>(value),
    );
  }
}

String _$installedColorThemesHash() =>
    r'c1886a43fd49580a58af6925298c31aa3338e279';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
