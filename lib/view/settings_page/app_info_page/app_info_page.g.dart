// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(packageInfo)
final packageInfoProvider = PackageInfoProvider._();

final class PackageInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<PackageInfo>,
          PackageInfo,
          FutureOr<PackageInfo>
        >
    with $FutureModifier<PackageInfo>, $FutureProvider<PackageInfo> {
  PackageInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packageInfoHash();

  @$internal
  @override
  $FutureProviderElement<PackageInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PackageInfo> create(Ref ref) {
    return packageInfo(ref);
  }
}

String _$packageInfoHash() => r'033806d620d2468d3918fbeb8531c7383430b019';
