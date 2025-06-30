import "dart:typed_data";

import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "profile_edit_provider.g.dart";

@riverpod
class ProfileName extends _$ProfileName {
  @override
  String build() => "";

  void update(String value) => state = value;
}

@riverpod
class ProfileDescription extends _$ProfileDescription {
  @override
  String build() => "";

  void update(String value) => state = value;
}

@riverpod
class ProfileLocation extends _$ProfileLocation {
  @override
  String build() => "";

  void update(String value) => state = value;
}

@riverpod
class ProfileBirthday extends _$ProfileBirthday {
  @override
  DateTime? build() => null;

  void update(DateTime? value) => state = value;
}

@riverpod
class ProfileFields extends _$ProfileFields {
  @override
  List<UserField> build() => [];

  void update(List<UserField> value) => state = value;
}

@riverpod
class ProfileFollowedMessage extends _$ProfileFollowedMessage {
  @override
  String build() => "";

  void update(String value) => state = value;
}

@riverpod
class ProfileAvatarDriveId extends _$ProfileAvatarDriveId {
  @override
  String? build() => null;

  void update(String? value) => state = value;
}

@riverpod
class ProfileAvatarFile extends _$ProfileAvatarFile {
  @override
  ({Uint8List data, String name})? build() => null;

  void update(({Uint8List data, String name})? value) => state = value;
}

@riverpod
IUpdateRequest profileEditRequest(Ref ref) {
  final name = ref.watch(profileNameProvider);
  final description = ref.watch(profileDescriptionProvider);
  final location = ref.watch(profileLocationProvider);
  final birthday = ref.watch(profileBirthdayProvider);
  final fields = ref.watch(profileFieldsProvider);
  final followedMessage = ref.watch(profileFollowedMessageProvider);
  final avatarId = ref.watch(profileAvatarDriveIdProvider);
  return IUpdateRequest(
    name: name.isEmpty ? null : name,
    description: description.isEmpty ? null : description,
    location: location.isEmpty ? null : location,
    birthday: birthday,
    fields: fields.isEmpty ? null : fields,
    followedMessage: followedMessage.isEmpty ? null : followedMessage,
    avatarId: avatarId,
  );
}
