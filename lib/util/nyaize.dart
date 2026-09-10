/// 猫のユーザーの投稿に掛かる文字置換。AiScript の `Mk:nyaize` から呼ぶ。
///
/// 本家 Misskey の `packages/misskey-js/src/nyaize.ts` の移植。
///
/// SPDX-FileCopyrightText: syuilo and misskey-project
/// SPDX-License-Identifier: AGPL-3.0-only
library;

final _enRegex1 = RegExp("(?<=n)a", caseSensitive: false);
final _enRegex2 = RegExp("(?<=morn)ing", caseSensitive: false);
final _enRegex3 = RegExp("(?<=every)one", caseSensitive: false);
final _koRegex1 = RegExp("[나-낳]");
final _koRegex2 = RegExp(
  r"(다$)|(다(?=\.))|(다(?= ))|(다(?=!))|(다(?=\?))",
  multiLine: true,
);
final _koRegex3 = RegExp(r"(야(?=\?))|(야$)|(야(?= ))", multiLine: true);

String nyaize(String text) => text
    // ja-JP
    .replaceAll("な", "にゃ")
    .replaceAll("ナ", "ニャ")
    .replaceAll("ﾅ", "ﾆｬ")
    // en-US
    .replaceAllMapped(_enRegex1, (match) => match[0] == "A" ? "YA" : "ya")
    .replaceAllMapped(_enRegex2, (match) => match[0] == "ING" ? "YAN" : "yan")
    .replaceAllMapped(_enRegex3, (match) => match[0] == "ONE" ? "NYAN" : "nyan")
    // ko-KR
    .replaceAllMapped(
      _koRegex1,
      (match) => String.fromCharCode(
        match[0]!.codeUnitAt(0) + "냐".codeUnitAt(0) - "나".codeUnitAt(0),
      ),
    )
    .replaceAll(_koRegex2, "다냥")
    .replaceAll(_koRegex3, "냥");
