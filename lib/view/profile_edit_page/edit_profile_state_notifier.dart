import "dart:typed_data";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:miria/providers.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "edit_profile_state_notifier.freezed.dart";
part "edit_profile_state_notifier.g.dart";

@freezed
sealed class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    @Default("") String name,
    @Default("") String description,
    @Default("") String location,
    DateTime? birthday,
    @Default([]) List<UserField> fields,
    @Default("") String followedMessage,
    String? avatarDriveId,
    ({Uint8List data, String name})? avatarFile,
    Uri? currentAvatarUrl,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
  }) = _EditProfileState;
}

@Riverpod(dependencies: [accountContext, misskeyGetContext, misskeyPostContext])
class EditProfileStateNotifier extends _$EditProfileStateNotifier {
  @override
  Future<EditProfileState> build() async {
    final me = await ref.read(misskeyGetContextProvider).i.i();
    final fields = me.fields?.toList() ?? [];
    final min = fields.length < 5 ? 5 : fields.length;

    return EditProfileState(
      name: me.name ?? "",
      description: me.description ?? "",
      location: me.location ?? "",
      birthday: me.birthday,
      fields: [
        ...fields,
        ...List.generate(
          min - fields.length,
          (_) => const UserField(name: "", value: ""),
        ),
      ],
      followedMessage: me.followedMessage ?? "",
      currentAvatarUrl: me.avatarUrl,
    );
  }

  void updateName(String value) {
    switch (state) {
      case AsyncData(value: final data):
        state = AsyncData(data.copyWith(name: value));
      default:
        break;
    }
  }

  void updateDescription(String value) {
    switch (state) {
      case AsyncData(value: final data):
        state = AsyncData(data.copyWith(description: value));
      default:
        break;
    }
  }

  void updateLocation(String value) {
    switch (state) {
      case AsyncData(value: final data):
        state = AsyncData(data.copyWith(location: value));
      default:
        break;
    }
  }

  void updateBirthday(DateTime? value) {
    switch (state) {
      case AsyncData(value: final data):
        state = AsyncData(data.copyWith(birthday: value));
      default:
        break;
    }
  }

  void updateFollowedMessage(String value) {
    switch (state) {
      case AsyncData(value: final data):
        state = AsyncData(data.copyWith(followedMessage: value));
      default:
        break;
    }
  }

  void updateField(int index, {String? name, String? value}) {
    switch (state) {
      case AsyncData(value: final data):
        final newFields = data.fields.toList();
        if (index >= newFields.length) return;

        newFields[index] = UserField(
          name: name ?? newFields[index].name,
          value: value ?? newFields[index].value,
        );

        state = AsyncData(data.copyWith(fields: newFields));
      default:
        break;
    }
  }

  void addField() {
    switch (state) {
      case AsyncData(value: final data):
        state = AsyncData(
          data.copyWith(
            fields: [
              ...data.fields,
              const UserField(name: "", value: ""),
            ],
          ),
        );
      default:
        break;
    }
  }

  void removeField(int index) {
    switch (state) {
      case AsyncData(value: final data):
        final newFields = data.fields.toList();
        if (newFields.length > index) {
          newFields.removeAt(index);
          state = AsyncData(data.copyWith(fields: newFields));
        }
      default:
        break;
    }
  }

  void updateAvatarFile(({Uint8List data, String name}) file) {
    switch (state) {
      case AsyncData(value: final currentData):
        state = AsyncData(
          currentData.copyWith(avatarFile: file, avatarDriveId: null),
        );
      default:
        break;
    }
  }

  void updateAvatarDriveId(String id) {
    switch (state) {
      case AsyncData(value: final currentData):
        state = AsyncData(
          currentData.copyWith(avatarDriveId: id, avatarFile: null),
        );
      default:
        break;
    }
  }

  Future<void> submit() async {
    final currentState = switch (state) {
      AsyncData(value: final data) => data,
      _ => null,
    };
    if (currentState == null || currentState.isSubmitting) return;

    state = AsyncData(currentState.copyWith(isSubmitting: true));

    try {
      final misskey = ref.read(misskeyPostContextProvider);

      // アバター画像のアップロード
      var avatarId = currentState.avatarDriveId;
      if (currentState.avatarFile != null) {
        final file = await misskey.drive.files.createAsBinary(
          const DriveFilesCreateRequest(force: true, name: "avatar"),
          currentState.avatarFile!.data,
        );
        avatarId = file.id;
      }

      // プロフィール更新
      final request = IUpdateRequest(
        name: currentState.name.isEmpty ? null : currentState.name,
        description: currentState.description.isEmpty
            ? null
            : currentState.description,
        location: currentState.location.isEmpty ? null : currentState.location,
        birthday: currentState.birthday,
        fields: currentState.fields
            .where((f) => f.name.isNotEmpty || f.value.isNotEmpty)
            .toList(),
        followedMessage: currentState.followedMessage.isEmpty
            ? null
            : currentState.followedMessage,
        avatarId: avatarId,
      );

      await misskey.i.update(request);

      state = AsyncData(currentState.copyWith(isSubmitting: false));
    } catch (e) {
      state = AsyncData(currentState.copyWith(isSubmitting: false));
      rethrow;
    }
  }
}
