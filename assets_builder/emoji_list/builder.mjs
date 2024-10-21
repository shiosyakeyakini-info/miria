// Misskey絵文字JSONビルダー
// サブモジュール misskey をクローンしている必要があります

import KuromojiAnalyzer from "kuroshiro-analyzer-kuromoji";
import requestPromise from "request-promise-native";
import Kuroshiro from "kuroshiro";
import fs from "fs";

async function main() {

    const kuroshiro = new Kuroshiro.default();
    await kuroshiro.init(new KuromojiAnalyzer());

    const categories = ['face', 'people', 'animals_and_nature', 'food_and_drink', 'activity', 'travel_and_places', 'objects', 'symbols', 'flags'];

    const body = fs.readFileSync("../misskey/packages/frontend-shared/js/emojilist.json");
    const emojiList = JSON.parse(body);
    const jpHiraBody = fs.readFileSync("../misskey/packages/frontend/src/unicode-emoji-indexes/ja-JP_hira.json")
    const jpHiraBodyList = JSON.parse(jpHiraBody);
    const jpBody = fs.readFileSync("../misskey/packages/frontend/src/unicode-emoji-indexes/ja-JP.json");
    const jpBodyList = JSON.parse(jpBody);
    const enBody = fs.readFileSync("../misskey/packages/frontend/src/unicode-emoji-indexes/en-US.json");
    const enBodyList = JSON.parse(enBody);

    // let body2 = await requestPromise("https://raw.githubusercontent.com/yagays/emoji-ja/master/data/emoji_ja.json");
    // const jpEmojiList = JSON.parse(body2);

    const emojis = [];

    for(var i=0;i<emojiList.length;i++) {
        emojis.push({
            "category": categories[emojiList[i][2]],
            "char": emojiList[i][0],
            "name": emojiList[i][1],
            "keywords": [
                ...jpHiraBodyList[emojiList[i][0]],
                ...jpBodyList[emojiList[i][0]],
                ...enBodyList[emojiList[i][0]]
            ]
        });
    }

    fs.writeFileSync( "../../assets/emoji_list.json", JSON.stringify(emojis));

}

main();