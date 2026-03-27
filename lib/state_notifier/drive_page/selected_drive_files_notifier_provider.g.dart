// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_drive_files_notifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(SelectedDriveFilesNotifier)
const selectedDriveFilesNotifierProvider =
    SelectedDriveFilesNotifierProvider._();

final class SelectedDriveFilesNotifierProvider
    extends $NotifierProvider<SelectedDriveFilesNotifier, List<DriveFile>> {
  const SelectedDriveFilesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDriveFilesNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[accountContextProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          SelectedDriveFilesNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = accountContextProvider;

  @override
  String debugGetCreateSourceHash() => _$selectedDriveFilesNotifierHash();

  @$internal
  @override
  SelectedDriveFilesNotifier create() => SelectedDriveFilesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DriveFile> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DriveFile>>(value),
    );
  }
}

String _$selectedDriveFilesNotifierHash() =>
    r'a97ebffe2481508e61cd1310017ec2020153cfce';

abstract class _$SelectedDriveFilesNotifier extends $Notifier<List<DriveFile>> {
  List<DriveFile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<DriveFile>, List<DriveFile>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<DriveFile>, List<DriveFile>>,
              List<DriveFile>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
