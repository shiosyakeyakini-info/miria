// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_folders_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(DriveFoldersNotifier)
const driveFoldersNotifierProvider = DriveFoldersNotifierFamily._();

final class DriveFoldersNotifierProvider
    extends
        $AsyncNotifierProvider<
          DriveFoldersNotifier,
          PaginationState<DriveFolder>
        > {
  const DriveFoldersNotifierProvider._({
    required DriveFoldersNotifierFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'driveFoldersNotifierProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = misskeyPostContextProvider;
  static const $allTransitiveDependencies1 =
      MisskeyPostContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$driveFoldersNotifierHash();

  @override
  String toString() {
    return r'driveFoldersNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DriveFoldersNotifier create() => DriveFoldersNotifier();

  @override
  bool operator ==(Object other) {
    return other is DriveFoldersNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$driveFoldersNotifierHash() =>
    r'41773785dedca3384a89ffaf819a43dbbc99de38';

final class DriveFoldersNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          DriveFoldersNotifier,
          AsyncValue<PaginationState<DriveFolder>>,
          PaginationState<DriveFolder>,
          FutureOr<PaginationState<DriveFolder>>,
          String?
        > {
  const DriveFoldersNotifierFamily._()
    : super(
        retry: null,
        name: r'driveFoldersNotifierProvider',
        dependencies: const <ProviderOrFamily>[misskeyPostContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          DriveFoldersNotifierProvider.$allTransitiveDependencies0,
          DriveFoldersNotifierProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  DriveFoldersNotifierProvider call(String? folderId) =>
      DriveFoldersNotifierProvider._(argument: folderId, from: this);

  @override
  String toString() => r'driveFoldersNotifierProvider';
}

abstract class _$DriveFoldersNotifier
    extends $AsyncNotifier<PaginationState<DriveFolder>> {
  late final _$args = ref.$arg as String?;
  String? get folderId => _$args;

  FutureOr<PaginationState<DriveFolder>> build(String? folderId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginationState<DriveFolder>>,
              PaginationState<DriveFolder>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginationState<DriveFolder>>,
                PaginationState<DriveFolder>
              >,
              AsyncValue<PaginationState<DriveFolder>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
