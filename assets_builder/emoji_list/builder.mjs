// Misskey絵文字JSONビルダー

import KuromojiAnalyzer from "kuroshiro-analyzer-kuromoji";
import requestPromise from "request-promise-native";
import Kuroshiro from "kuroshiro";
import fs from "fs";

async function main() {

    const kuroshiro = new Kuroshiro.default();
    await kuroshiro.init(new KuromojiAnalyzer());

    let body = await requestPromise("https://raw.githubusercontent.com/misskey-dev/misskey/develop/packages/frontend/src/emojilist.json");
    const emojiList = JSON.parse(body);

    let body2 = await requestPromise("https://raw.githubusercontent.com/yagays/emoji-ja/master/data/emoji_ja.json");
    const jpEmojiList = JSON.parse(body2);

    for(var i=0;i<emojiList.length;i++) {
        var findChar = emojiList[i].char;
        if(jpEmojiList[findChar] === undefined) {
            var isFound = false;
            for(var j=findChar.length;j>0;j--) {

                if(jpEmojiList[emojiList[i].char.substring(0, j)] !== undefined) {
                    findChar = emojiList[i].char.substring(0, j);
                    isFound = true;
                    break;
                }
            }

            if(!isFound) {
                break;
            }
        }

        var keywords = jpEmojiList[findChar].keywords;

        for(var j=0;j<keywords.length;j++) {
            keywords[j] = await kuroshiro.convert(keywords[j], {mode:"normal", to:"hiragana"});
        }

        emojiList[i].keywords = emojiList[i].keywords.concat(keywords);
    }

    fs.writeFileSync( "../../assets/emoji_list.json", JSON.stringify(emojiList));

}

main();