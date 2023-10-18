import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miria/model/acct.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'account_settings.freezed.dart';
part 'account_settings.g.dart';

@freezed
class AccountSettings with _$AccountSettings {
  const AccountSettings._();

  const factory AccountSettings({
    required String userId,
    required String host,
    @Default([]) List<String> reactions,
    @Default(NoteVisibility.public) NoteVisibility defaultNoteVisibility,
    @Default(false) bool defaultIsLocalOnly,
    @Default(null) ReactionAcceptance? defaultReactionAcceptance,
  }) = _AccountSettings;

  factory AccountSettings.fromJson(Map<String, dynamic> json) =>
      _$AccountSettingsFromJson(json);

  Acct get acct {
    return Acct(
      host: host,
      username: userId,
    );
  }
}
