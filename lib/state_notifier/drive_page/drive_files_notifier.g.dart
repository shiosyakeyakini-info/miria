// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_files_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(DriveFilesNotifier)
const driveFilesNotifierProvider = DriveFilesNotifierFamily._();

final class DriveFilesNotifierProvider
    extends
        $AsyncNotifierProvider<DriveFilesNotifier, PaginationState<DriveFile>> {
  const DriveFilesNotifierProvider._({
    required DriveFilesNotifierFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'driveFilesNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$driveFilesNotifierHash();

  @override
  String toString() {
    return r'driveFilesNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DriveFilesNotifier create() => DriveFilesNotifier();

  @override
  bool operator ==(Object other) {
    return other is DriveFilesNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$driveFilesNotifierHash() =>
    r'3b920bdc9dcd37d0185da5662f86901b337acd7c';

final class DriveFilesNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          DriveFilesNotifier,
          AsyncValue<PaginationState<DriveFile>>,
          PaginationState<DriveFile>,
          FutureOr<PaginationState<DriveFile>>,
          String?
        > {
  const DriveFilesNotifierFamily._()
    : super(
        retry: null,
        name: r'driveFilesNotifierProvider',
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          DriveFilesNotifierProvider.$allTransitiveDependencies0,
          DriveFilesNotifierProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  DriveFilesNotifierProvider call(String? folderId) =>
      DriveFilesNotifierProvider._(argument: folderId, from: this);

  @override
  String toString() => r'driveFilesNotifierProvider';
}

abstract class _$DriveFilesNotifier
    extends $AsyncNotifier<PaginationState<DriveFile>> {
  late final _$args = ref.$arg as String?;
  String? get folderId => _$args;

  FutureOr<PaginationState<DriveFile>> build(String? folderId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginationState<DriveFile>>,
              PaginationState<DriveFile>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginationState<DriveFile>>,
                PaginationState<DriveFile>
              >,
              AsyncValue<PaginationState<DriveFile>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
