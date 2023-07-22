import 'package:misskey_dart/misskey_dart.dart';

extension UsersShowResponseExtension on UsersShowResponse {
  String get acct {
    return "@$username${host != null ? "@$host" : ""}";
  }
}
