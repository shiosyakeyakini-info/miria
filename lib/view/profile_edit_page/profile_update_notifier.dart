import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:miria/providers.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'profile_edit_provider.dart';

part 'profile_update_notifier.g.dart';

@Riverpod(dependencies: [accountContext, profileEditRequest])
class ProfileUpdateNotifier extends _$ProfileUpdateNotifier {
  @override
  Future<void> build() async {}

  Future<void> submit() async {
    final misskey = ref.read(misskeyPostContextProvider);
    final request = ref.read(profileEditRequestProvider);
    final avatarFile = ref.read(profileAvatarFileProvider);
    String? avatarId = request.avatarId;
    if (avatarFile != null) {
      final file = await misskey.drive.files.createAsBinary(
        const DriveFilesCreateRequest(force: true, name: 'avatar'),
        avatarFile.data,
      );
      avatarId = file.id;
    }
    await misskey.i.update(request.copyWith(avatarId: avatarId));
  }
}
