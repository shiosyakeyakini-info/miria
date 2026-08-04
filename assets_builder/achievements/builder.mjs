// Misskey実績（アチーブメント）名ビルダー
// サブモジュール misskey をクローンしている必要があります
//
// Misskeyのlocalesから_achievements._typesだけを抜き出して
// assets/achievements.json に書き出す。
// アプリ側でどう引くかは lib/model/achievement.dart を参照。

import fs from "fs";
import yaml from "js-yaml";

const localesDir = "../misskey/locales";

// 書き出すMisskeyのロケール。
// miriaの言語との対応付けは lib/model/achievement.dart の _MisskeyLocale にある。
// miriaの日本語は関西弁が規定なので、素の日本語ではなくja-KSを使う。
const targetLocales = ["ja-JP", "ja-KS", "zh-CN"];

// 各ロケールのフォールバック元。locales/index.js の build() と同じ規則で、
// ja-JPが全ロケールの土台になっており、各ロケールのymlは差分しか持っていない。
const fallbacks = {
  "ja-JP": [],
  "ja-KS": ["ja-JP"],
  "en-US": ["ja-JP"],
};
const fallbacksOf = (locale) => fallbacks[locale] ?? ["ja-JP", "en-US"];

// locales/index.js の merge() 相当。後勝ちで再帰的に混ぜる。
const merge = (...args) =>
  args.reduce((a, c) => ({
    ...a,
    ...c,
    ...Object.entries(a)
      .filter(([k]) => c && typeof c[k] === "object")
      .reduce((a, [k, v]) => ((a[k] = merge(v, c[k])), a), {}),
  }), {});

// 空文字列が入っているとフォールバックが効かなくなるので、プロパティごと消す。
// これも locales/index.js と同じ。
const removeEmpty = (obj) => {
  for (const [k, v] of Object.entries(obj)) {
    if (v === "") {
      delete obj[k];
    } else if (typeof v === "object" && v !== null) {
      removeEmpty(v);
    }
  }
  return obj;
};

// 何故か文字列にバックスペース文字が混入することがあり、YAMLが壊れるので取り除く
const clean = (text) => text.replace(new RegExp(String.fromCodePoint(0x08), "g"), "");

const loaded = {};
const load = (locale) => {
  if (loaded[locale] != null) return loaded[locale];
  const raw = yaml.load(clean(fs.readFileSync(`${localesDir}/${locale}.yml`, "utf-8"))) ?? {};
  // 実績以外は要らないので、ここで落としてから混ぜる
  return (loaded[locale] = removeEmpty(raw._achievements?._types ?? {}));
};

const resolve = (locale) => merge(...fallbacksOf(locale).map(load), load(locale));

const result = {};
for (const locale of targetLocales) {
  const types = resolve(locale);
  if (Object.keys(types).length === 0) {
    throw new Error(`${locale}.yml に _achievements._types がない`);
  }

  const achievements = {};
  for (const [key, value] of Object.entries(types)) {
    // Misskeyのlocalesのキーは "_notes1" だが、通知や実績一覧で降ってくる
    // 実績名は "notes1" なので、前置のアンダースコアを落として引けるようにする
    achievements[key.replace(/^_/, "")] = {
      title: value.title,
      description: value.description,
    };
  }
  result[locale] = achievements;
}

fs.writeFileSync("../../assets/achievements.json", JSON.stringify(result));
console.log(
  targetLocales.map((e) => `${e}: ${Object.keys(result[e]).length}件`).join(", "),
);
