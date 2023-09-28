import 'package:freezed_annotation/freezed_annotation.dart';

part 'acct.freezed.dart';
part 'acct.g.dart';

@freezed
class Acct with _$Acct {
  const factory Acct({
    required String host,
    required String username,
  }) = _Acct;
  const Acct._();

  factory Acct.fromJson(Map<String, Object?> json) => _$AcctFromJson(json);

  @override
  String toString() {
    return "@$username@$host";
  }
}
