import "dart:convert";

import "package:flutter/services.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:miria/model/general_settings.dart";

part "achievement.freezed.dart";
part "achievement.g.dart";

/// Misskeyの実績（アチーブメント）の対訳。
@freezed
abstract class Achievement with _$Achievement {
  const factory Achievement({
    required String title,
    required String description,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}

/// 実績名から対訳を引く表。
///
/// サーバーは実績を`notes1`のような名前でしか寄越さず、その対訳はMisskeyの
/// localesにしかない。`assets_builder/achievements/builder.mjs`で抜き出した
/// `assets/achievements.json`を言語ごとに読んで引けるようにしている。
class Achievements {
  static const assetPath = "assets/achievements.json";

  final Map<String, Achievement> _achievements;

  const Achievements(this._achievements);

  static Future<Achievements> load(Languages language) async {
    final json =
        jsonDecode(await rootBundle.loadString(assetPath))
            as Map<String, dynamic>;
    final locale = json[language._misskeyLocale] as Map<String, dynamic>? ?? {};
    return Achievements({
      for (final entry in locale.entries)
        entry.key: Achievement.fromJson(entry.value as Map<String, dynamic>),
    });
  }

  /// 対訳のない実績はMisskey側で増えたもの。呼び出し側で実績名のまま出す。
  Achievement? operator [](String name) => _achievements[name];
}

extension on Languages {
  /// 実績の対訳を引くMisskeyのロケール。
  ///
  /// miriaの日本語は関西弁が規定なので、Misskeyでも関西弁のja-KSを引く。
  /// お嬢様言葉に当たるロケールはMisskeyにないので、素の日本語に落とす。
  String get _misskeyLocale => switch (this) {
    Languages.jaJP => "ja-KS",
    Languages.jaOJ => "ja-JP",
    Languages.zhCN => "zh-CN",
  };
}
