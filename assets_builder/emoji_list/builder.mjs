// Misskey絵文字JSONビルダー
//
// Unicode絵文字の一覧と読みがなは、かつてMisskey本体の
// packages/frontend-shared/js/emojilist.json と
// packages/frontend/src/unicode-emoji-indexes/*.json にあったが、
// 現在は @misskey-dev/emoji-data に切り出されている。
// このビルダーはそちらを引くので、サブモジュール misskey は要らない。
// ただしバージョンだけは本家の pin に合わせたいので、サブモジュールが
// あればつきあわせて、ずれていれば警告する。

import { createRequire } from "node:module";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const require = createRequire(import.meta.url);
const here = path.dirname(fileURLToPath(import.meta.url));

// Misskeyの unicodeEmojiCategories と同じ並び。
// emojilist.json の3番目の要素がこの配列の添字を指す。
// https://github.com/misskey-dev/misskey/blob/develop/packages/frontend-shared/js/emojilist.ts
const categories = [
    "face",
    "people",
    "animals_and_nature",
    "food_and_drink",
    "activity",
    "travel_and_places",
    "objects",
    "symbols",
    "flags",
];

/// 本家が pin している @misskey-dev/emoji-data のバージョンと食い違っていたら警告する。
function warnIfVersionMismatch() {
    const misskeyPackageJson = path.join(
        here,
        "../misskey/packages/frontend-shared/package.json",
    );
    if (!fs.existsSync(misskeyPackageJson)) return;

    const pinned = JSON.parse(fs.readFileSync(misskeyPackageJson, "utf8"))
        .dependencies?.["@misskey-dev/emoji-data"];
    // package.json 自体は exports に載っていないので、実体の場所から辿る。
    const installedPackageJson = path.join(
        path.dirname(require.resolve("@misskey-dev/emoji-data/emojilist.json")),
        "../package.json",
    );
    const installed = JSON.parse(
        fs.readFileSync(installedPackageJson, "utf8"),
    ).version;
    if (pinned && !pinned.includes(installed)) {
        console.warn(
            `warning: 本家は @misskey-dev/emoji-data ${pinned} を使っているが、` +
                `ここに入っているのは ${installed} です。` +
                `package.json のバージョンを合わせて npm install しなおしてください。`,
        );
    }
}

function main() {
    warnIfVersionMismatch();

    const emojiList = require("@misskey-dev/emoji-data/emojilist.json");
    const jpHiraBodyList = require("@misskey-dev/emoji-data/indexes/ja-JP_hira.json");
    const jpBodyList = require("@misskey-dev/emoji-data/indexes/ja-JP.json");
    const enBodyList = require("@misskey-dev/emoji-data/indexes/en-US.json");

    const emojis = [];

    for (const [char, name, categoryIndex] of emojiList) {
        const category = categories[categoryIndex];
        if (category === undefined) {
            throw new Error(
                `${char} (${name}) のカテゴリ ${categoryIndex} がわからない。` +
                    `Misskeyの unicodeEmojiCategories が増えていないか確認してください。`,
            );
        }

        emojis.push({
            category,
            char,
            name,
            // 読みがなのない絵文字が混ざることがあるので、なければ諦める。
            keywords: [
                ...(jpHiraBodyList[char] ?? []),
                ...(jpBodyList[char] ?? []),
                ...(enBodyList[char] ?? []),
            ],
        });
    }

    fs.writeFileSync(
        path.join(here, "../../assets/emoji_list.json"),
        JSON.stringify(emojis),
    );
    console.log(`assets/emoji_list.json に ${emojis.length} 件書き出しました。`);
}

main();
