import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miria/model/acct.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'account_settings.freezed.dart';
part 'account_settings.g.dart';

enum CacheStrategy {
  whenTabChange,
  whenLaunch,
  whenOneDay,
}

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
    @Default(CacheStrategy.whenTabChange) CacheStrategy iCacheStrategy,
    DateTime? latestICached,
    @Default(CacheStrategy.whenLaunch) CacheStrategy emojiCacheStrategy,
    DateTime? latestEmojiCached,
    @Default(CacheStrategy.whenOneDay) CacheStrategy metaChacheStrategy,
    DateTime? latestMetaCached,
    @Default(false) bool forceShowAd,
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
