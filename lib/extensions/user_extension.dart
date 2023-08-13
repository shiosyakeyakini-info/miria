import 'package:misskey_dart/misskey_dart.dart';

extension UserExtension on User {
  String get acct {
    return "@$username${host != null ? "@$host" : ""}";
  }
}
