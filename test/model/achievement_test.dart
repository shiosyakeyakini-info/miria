import "package:flutter_test/flutter_test.dart";
import "package:miria/model/achievement.dart";
import "package:miria/model/general_settings.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test("実績名を表示言語ごとに引ける", () async {
    final loaded = {
      for (final language in Languages.values)
        language: await Achievements.load(language),
    };

    for (final entry in loaded.entries) {
      final achievement = entry.value["notes1"];
      expect(achievement, isNotNull, reason: "${entry.key} で引けなかった");
      expect(achievement!.title, isNotEmpty);
      expect(achievement.description, isNotEmpty);
    }

    // miriaの日本語は関西弁なのでMisskeyのja-KSを引く。お嬢様言葉に当たる
    // ロケールはMisskeyにないので素の日本語（ja-JP）に落ちる
    final kansai = loaded[Languages.jaJP]!["notes1"]!.title;
    final japanese = loaded[Languages.jaOJ]!["notes1"]!.title;
    final chinese = loaded[Languages.zhCN]!["notes1"]!.title;
    expect({kansai, japanese, chinese}, hasLength(3));
  });

  test("Misskey側で増えた実績は引けない", () async {
    final achievements = await Achievements.load(Languages.jaJP);
    expect(achievements["まだ存在しない実績"], isNull);
  });
}
