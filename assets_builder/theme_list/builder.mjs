// Misskeyテーマビルダー
// TODO: そのうちちゃんと取り込めるようにしたい → SCSSの構文解釈がいる
// サブモジュール misskey をクローンしている必要があります

import fs from "fs";
import path from "path";
import JSON5 from "json5";

function simplyfyProps(theme) {
    
}

async function main() {
    const files = fs.readdirSync("../misskey/packages/frontend/src/themes")
        .filter((file) => fs.statSync(path.join()));
    console.log(files);

    const darkTheme = JSON5.parse(fs.readFileSync("../misskey/packages/frontend/src/themes/_dark.json5"));
    const lightTheme = JSON5.parse(fs.readFileSync("../misskey/packages/frontend/src/themes/_light.json5"));

    console.log(darkTheme);

    //TODO: つくりかけ

}

main();