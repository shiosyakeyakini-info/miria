import 'package:misskey_dart/misskey_dart.dart';

extension UsersListsShowResponseExtension on UsersListsShowResponse {
  UsersList toUsersList() {
    return UsersList(
      id: id,
      createdAt: createdAt,
      name: name,
      userIds: userIds,
      isPublic: isPublic,
    );
  }
}
