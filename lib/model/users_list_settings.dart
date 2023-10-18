import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'users_list_settings.freezed.dart';

@freezed
class UsersListSettings with _$UsersListSettings {
  const factory UsersListSettings({
    @Default("") String name,
    @Default(false) bool isPublic,
  }) = _UsersListSettings;
  const UsersListSettings._();

  factory UsersListSettings.fromUsersList(UsersList list) {
    return UsersListSettings(
      name: list.name ?? "",
      isPublic: list.isPublic ?? false,
    );
  }
}
