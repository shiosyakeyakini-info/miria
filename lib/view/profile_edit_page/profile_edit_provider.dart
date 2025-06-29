import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'profile_edit_provider.g.dart';

final profileNameProvider = StateProvider.autoDispose<String>((ref) => '');
final profileDescriptionProvider =
    StateProvider.autoDispose<String>((ref) => '');
final profileLocationProvider = StateProvider.autoDispose<String>((ref) => '');
final profileBirthdayProvider =
    StateProvider.autoDispose<DateTime?>((ref) => null);
final profileFieldsProvider =
    StateProvider.autoDispose<List<UserField>>((ref) => []);
final profileFollowedMessageProvider =
    StateProvider.autoDispose<String>((ref) => '');
final profileAvatarDriveIdProvider =
    StateProvider.autoDispose<String?>((ref) => null);
final profileAvatarFileProvider =
    StateProvider.autoDispose<({Uint8List data, String name})?>((ref) => null);

@riverpod
IUpdateRequest profileEditRequest(ProfileEditRequestRef ref) {
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
