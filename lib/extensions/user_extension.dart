import 'package:misskey_dart/misskey_dart.dart';

extension AbstractedUserExtension on AbstractedUser {
  String get acct {
    return "@$username${host != null ? "@$host" : ""}";
  }
}
