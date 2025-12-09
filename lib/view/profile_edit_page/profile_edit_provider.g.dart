// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileName)
const profileNameProvider = ProfileNameProvider._();

final class ProfileNameProvider extends $NotifierProvider<ProfileName, String> {
  const ProfileNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileNameHash();

  @$internal
  @override
  ProfileName create() => ProfileName();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$profileNameHash() => r'47209a9eaa4af46cf45ff6ec7e7ad71b69983487';

abstract class _$ProfileName extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProfileDescription)
const profileDescriptionProvider = ProfileDescriptionProvider._();

final class ProfileDescriptionProvider
    extends $NotifierProvider<ProfileDescription, String> {
  const ProfileDescriptionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileDescriptionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileDescriptionHash();

  @$internal
  @override
  ProfileDescription create() => ProfileDescription();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$profileDescriptionHash() =>
    r'd6e94ded58e2628096cf8c31fc19e4cef1af9a8b';

abstract class _$ProfileDescription extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProfileLocation)
const profileLocationProvider = ProfileLocationProvider._();

final class ProfileLocationProvider
    extends $NotifierProvider<ProfileLocation, String> {
  const ProfileLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileLocationHash();

  @$internal
  @override
  ProfileLocation create() => ProfileLocation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$profileLocationHash() => r'dffd9a1a45dc23f051547c7ef7e013a4da52a008';

abstract class _$ProfileLocation extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProfileBirthday)
const profileBirthdayProvider = ProfileBirthdayProvider._();

final class ProfileBirthdayProvider
    extends $NotifierProvider<ProfileBirthday, DateTime?> {
  const ProfileBirthdayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileBirthdayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileBirthdayHash();

  @$internal
  @override
  ProfileBirthday create() => ProfileBirthday();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$profileBirthdayHash() => r'eeb81b88a263a57cfca1269f69e6d867d4a4bcb1';

abstract class _$ProfileBirthday extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProfileFields)
const profileFieldsProvider = ProfileFieldsProvider._();

final class ProfileFieldsProvider
    extends $NotifierProvider<ProfileFields, List<UserField>> {
  const ProfileFieldsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileFieldsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileFieldsHash();

  @$internal
  @override
  ProfileFields create() => ProfileFields();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<UserField> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<UserField>>(value),
    );
  }
}

String _$profileFieldsHash() => r'fc59443cc56a02848ab7a1afb6eeaf0f89e6e206';

abstract class _$ProfileFields extends $Notifier<List<UserField>> {
  List<UserField> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<UserField>, List<UserField>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<UserField>, List<UserField>>,
              List<UserField>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProfileFollowedMessage)
const profileFollowedMessageProvider = ProfileFollowedMessageProvider._();

final class ProfileFollowedMessageProvider
    extends $NotifierProvider<ProfileFollowedMessage, String> {
  const ProfileFollowedMessageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileFollowedMessageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileFollowedMessageHash();

  @$internal
  @override
  ProfileFollowedMessage create() => ProfileFollowedMessage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$profileFollowedMessageHash() =>
    r'4cdb7ccc2868a09365bd83a17273bb3d686ab84d';

abstract class _$ProfileFollowedMessage extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProfileAvatarDriveId)
const profileAvatarDriveIdProvider = ProfileAvatarDriveIdProvider._();

final class ProfileAvatarDriveIdProvider
    extends $NotifierProvider<ProfileAvatarDriveId, String?> {
  const ProfileAvatarDriveIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileAvatarDriveIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileAvatarDriveIdHash();

  @$internal
  @override
  ProfileAvatarDriveId create() => ProfileAvatarDriveId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$profileAvatarDriveIdHash() =>
    r'9bfe18f7a58b670a45f61dc1fbd7f76a7b1c1ebb';

abstract class _$ProfileAvatarDriveId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ProfileAvatarFile)
const profileAvatarFileProvider = ProfileAvatarFileProvider._();

final class ProfileAvatarFileProvider
    extends
        $NotifierProvider<ProfileAvatarFile, ({Uint8List data, String name})?> {
  const ProfileAvatarFileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileAvatarFileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileAvatarFileHash();

  @$internal
  @override
  ProfileAvatarFile create() => ProfileAvatarFile();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({Uint8List data, String name})? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({Uint8List data, String name})?>(
        value,
      ),
    );
  }
}

String _$profileAvatarFileHash() => r'3c9882fc8e3d2f9c47a8f1a1d321049398058e23';

abstract class _$ProfileAvatarFile
    extends $Notifier<({Uint8List data, String name})?> {
  ({Uint8List data, String name})? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              ({Uint8List data, String name})?,
              ({Uint8List data, String name})?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                ({Uint8List data, String name})?,
                ({Uint8List data, String name})?
              >,
              ({Uint8List data, String name})?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(profileEditRequest)
const profileEditRequestProvider = ProfileEditRequestProvider._();

final class ProfileEditRequestProvider
    extends $FunctionalProvider<IUpdateRequest, IUpdateRequest, IUpdateRequest>
    with $Provider<IUpdateRequest> {
  const ProfileEditRequestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileEditRequestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditRequestHash();

  @$internal
  @override
  $ProviderElement<IUpdateRequest> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IUpdateRequest create(Ref ref) {
    return profileEditRequest(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IUpdateRequest value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IUpdateRequest>(value),
    );
  }
}

String _$profileEditRequestHash() =>
    r'7808ee90e71cadb3719449a8757393383938efe1';
