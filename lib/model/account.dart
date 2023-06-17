import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@Freezed(equal: false)
class Account with _$Account {
  const Account._();

  const factory Account({
    required String host,
    required String userId,
    required String token,
    required IResponse i,
  }) = _Account;

  factory Account.fromJson(Map<String, Object?> json) =>
      _$AccountFromJson(json);

  @override
  bool operator ==(Object other) {
    return other is Account &&
        other.runtimeType == runtimeType &&
        other.host == host &&
        other.userId == userId;
  }

  @override
  int get hashCode => Object.hash(runtimeType, host, userId);
}
