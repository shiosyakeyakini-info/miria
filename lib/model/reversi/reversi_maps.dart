/// Misskey のリバーシのマップ定義を Dart に移植したもの。
///
/// 移植元は `misskey-dev/misskey` の `packages/misskey-reversi/src/maps.ts`
/// (AGPL-3.0-only, syuilo and misskey-project)。
///
/// サーバーは対局情報の `map` に文字列の配列をそのまま載せてくるので、
/// 盤面を描くだけならこの定義は要らない。必要になるのは対局前の設定画面で
/// マップを選ばせるときと、サーバーから来たマップ配列に名前を付けて
/// 表示するとき。
library;

/// リバーシのマップ。
class ReversiMap {
  const ReversiMap({
    required this.name,
    required this.category,
    required this.data,
    this.author,
  });

  /// マップ名。Misskey の UI でもこの英語名がそのまま出る。
  final String name;

  /// 分類。設定画面のグループ見出しに使う。
  final String category;

  /// 作者。公式の基本マップには付かない。
  final String? author;

  /// 1 行 1 文字列のマップ定義。
  final List<String> data;
}

const fourfour = ReversiMap(
  name: "4x4",
  category: "4x4",
  data: ["----", "-wb-", "-bw-", "----"],
);

const sixsix = ReversiMap(
  name: "6x6",
  category: "6x6",
  data: ["------", "------", "--wb--", "--bw--", "------", "------"],
);

const roundedSixsix = ReversiMap(
  name: "6x6 rounded",
  category: "6x6",
  author: "syuilo",
  data: [" ---- ", "------", "--wb--", "--bw--", "------", " ---- "],
);

const roundedSixsix2 = ReversiMap(
  name: "6x6 rounded 2",
  category: "6x6",
  author: "syuilo",
  data: ["  --  ", " ---- ", "--wb--", "--bw--", " ---- ", "  --  "],
);

const eighteight = ReversiMap(
  name: "8x8",
  category: "8x8",
  data: [
    "--------",
    "--------",
    "--------",
    "---wb---",
    "---bw---",
    "--------",
    "--------",
    "--------",
  ],
);

const eighteightH28 = ReversiMap(
  name: "8x8 handicap 28",
  category: "8x8",
  data: [
    "bbbbbbbb",
    "b------b",
    "b------b",
    "b--wb--b",
    "b--bw--b",
    "b------b",
    "b------b",
    "bbbbbbbb",
  ],
);

const roundedEighteight = ReversiMap(
  name: "8x8 rounded",
  category: "8x8",
  author: "syuilo",
  data: [
    " ------ ",
    "--------",
    "--------",
    "---wb---",
    "---bw---",
    "--------",
    "--------",
    " ------ ",
  ],
);

const roundedEighteight2 = ReversiMap(
  name: "8x8 rounded 2",
  category: "8x8",
  author: "syuilo",
  data: [
    "  ----  ",
    " ------ ",
    "--------",
    "---wb---",
    "---bw---",
    "--------",
    " ------ ",
    "  ----  ",
  ],
);

const roundedEighteight3 = ReversiMap(
  name: "8x8 rounded 3",
  category: "8x8",
  author: "syuilo",
  data: [
    "   --   ",
    "  ----  ",
    " ------ ",
    "---wb---",
    "---bw---",
    " ------ ",
    "  ----  ",
    "   --   ",
  ],
);

const eighteightWithNotch = ReversiMap(
  name: "8x8 with notch",
  category: "8x8",
  author: "syuilo",
  data: [
    "---  ---",
    "--------",
    "--------",
    " --wb-- ",
    " --bw-- ",
    "--------",
    "--------",
    "---  ---",
  ],
);

const eighteightWithSomeHoles = ReversiMap(
  name: "8x8 with some holes",
  category: "8x8",
  author: "syuilo",
  data: [
    "--- ----",
    "----- --",
    "-- -----",
    "---wb---",
    "---bw- -",
    " -------",
    "--- ----",
    "--------",
  ],
);

const circle = ReversiMap(
  name: "Circle",
  category: "8x8",
  author: "syuilo",
  data: [
    "   --   ",
    " ------ ",
    " ------ ",
    "---wb---",
    "---bw---",
    " ------ ",
    " ------ ",
    "   --   ",
  ],
);

const smile = ReversiMap(
  name: "Smile",
  category: "8x8",
  author: "syuilo",
  data: [
    " ------ ",
    "--------",
    "-- -- --",
    "---wb---",
    "-- bw --",
    "---  ---",
    "--------",
    " ------ ",
  ],
);

const window = ReversiMap(
  name: "Window",
  category: "8x8",
  author: "syuilo",
  data: [
    "--------",
    "-  --  -",
    "-  --  -",
    "---wb---",
    "---bw---",
    "-  --  -",
    "-  --  -",
    "--------",
  ],
);

const reserved = ReversiMap(
  name: "Reserved",
  category: "8x8",
  author: "Aya",
  data: [
    "w------b",
    "--------",
    "--------",
    "---wb---",
    "---bw---",
    "--------",
    "--------",
    "b------w",
  ],
);

const x = ReversiMap(
  name: "X",
  category: "8x8",
  author: "Aya",
  data: [
    "w------b",
    "-w----b-",
    "--w--b--",
    "---wb---",
    "---bw---",
    "--b--w--",
    "-b----w-",
    "b------w",
  ],
);

const parallel = ReversiMap(
  name: "Parallel",
  category: "8x8",
  author: "Aya",
  data: [
    "--------",
    "--------",
    "--------",
    "---bb---",
    "---ww---",
    "--------",
    "--------",
    "--------",
  ],
);

const lackOfBlack = ReversiMap(
  name: "Lack of Black",
  category: "8x8",
  data: [
    "--------",
    "--------",
    "--------",
    "---w----",
    "---bw---",
    "--------",
    "--------",
    "--------",
  ],
);

const squareParty = ReversiMap(
  name: "Square Party",
  category: "8x8",
  author: "syuilo",
  data: [
    "--------",
    "-wwwbbb-",
    "-w-wb-b-",
    "-wwwbbb-",
    "-bbbwww-",
    "-b-bw-w-",
    "-bbbwww-",
    "--------",
  ],
);

const minesweeper = ReversiMap(
  name: "Minesweeper",
  category: "8x8",
  author: "syuilo",
  data: [
    "b-b--w-w",
    "-w-wb-b-",
    "w-b--w-b",
    "-b-wb-w-",
    "-w-bw-b-",
    "b-w--b-w",
    "-b-bw-w-",
    "w-w--b-b",
  ],
);

const tenthtenth = ReversiMap(
  name: "10x10",
  category: "10x10",
  data: [
    "----------",
    "----------",
    "----------",
    "----------",
    "----wb----",
    "----bw----",
    "----------",
    "----------",
    "----------",
    "----------",
  ],
);

const hole = ReversiMap(
  name: "The Hole",
  category: "10x10",
  author: "syuilo",
  data: [
    "----------",
    "----------",
    "--wb--wb--",
    "--bw--bw--",
    "----  ----",
    "----  ----",
    "--wb--wb--",
    "--bw--bw--",
    "----------",
    "----------",
  ],
);

const grid = ReversiMap(
  name: "Grid",
  category: "10x10",
  author: "syuilo",
  data: [
    "----------",
    "- - -- - -",
    "----------",
    "- - -- - -",
    "----wb----",
    "----bw----",
    "- - -- - -",
    "----------",
    "- - -- - -",
    "----------",
  ],
);

const cross = ReversiMap(
  name: "Cross",
  category: "10x10",
  author: "Aya",
  data: [
    "   ----   ",
    "   ----   ",
    "   ----   ",
    "----------",
    "----wb----",
    "----bw----",
    "----------",
    "   ----   ",
    "   ----   ",
    "   ----   ",
  ],
);

const charX = ReversiMap(
  name: "Char X",
  category: "10x10",
  author: "syuilo",
  data: [
    "---    ---",
    "----  ----",
    "----------",
    " -------- ",
    "  --wb--  ",
    "  --bw--  ",
    " -------- ",
    "----------",
    "----  ----",
    "---    ---",
  ],
);

const charY = ReversiMap(
  name: "Char Y",
  category: "10x10",
  author: "syuilo",
  data: [
    "---    ---",
    "----  ----",
    "----------",
    " -------- ",
    "  --wb--  ",
    "  --bw--  ",
    "  ------  ",
    "  ------  ",
    "  ------  ",
    "  ------  ",
  ],
);

const walls = ReversiMap(
  name: "Walls",
  category: "10x10",
  author: "Aya",
  data: [
    " bbbbbbbb ",
    "w--------w",
    "w--------w",
    "w--------w",
    "w---wb---w",
    "w---bw---w",
    "w--------w",
    "w--------w",
    "w--------w",
    " bbbbbbbb ",
  ],
);

const cpu = ReversiMap(
  name: "CPU",
  category: "10x10",
  author: "syuilo",
  data: [
    " b b  b b ",
    "w--------w",
    " -------- ",
    "w--------w",
    " ---wb--- ",
    " ---bw--- ",
    "w--------w",
    " -------- ",
    "w--------w",
    " b b  b b ",
  ],
);

const checker = ReversiMap(
  name: "Checker",
  category: "10x10",
  author: "Aya",
  data: [
    "----------",
    "----------",
    "----------",
    "---wbwb---",
    "---bwbw---",
    "---wbwb---",
    "---bwbw---",
    "----------",
    "----------",
    "----------",
  ],
);

const japaneseCurry = ReversiMap(
  name: "Japanese curry",
  category: "10x10",
  author: "syuilo",
  data: [
    "w-b-b-b-b-",
    "-w-b-b-b-b",
    "w-w-b-b-b-",
    "-w-w-b-b-b",
    "w-w-wwb-b-",
    "-w-wbb-b-b",
    "w-w-w-b-b-",
    "-w-w-w-b-b",
    "w-w-w-w-b-",
    "-w-w-w-w-b",
  ],
);

const mosaic = ReversiMap(
  name: "Mosaic",
  category: "10x10",
  author: "syuilo",
  data: [
    "- - - - - ",
    " - - - - -",
    "- - - - - ",
    " - w w - -",
    "- - b b - ",
    " - w w - -",
    "- - b b - ",
    " - - - - -",
    "- - - - - ",
    " - - - - -",
  ],
);

const arena = ReversiMap(
  name: "Arena",
  category: "10x10",
  author: "syuilo",
  data: [
    "- - -- - -",
    " - -  - - ",
    "- ------ -",
    " -------- ",
    "- --wb-- -",
    "- --bw-- -",
    " -------- ",
    "- ------ -",
    " - -  - - ",
    "- - -- - -",
  ],
);

const reactor = ReversiMap(
  name: "Reactor",
  category: "10x10",
  author: "syuilo",
  data: [
    "-w------b-",
    "b- -  - -w",
    "- --wb-- -",
    "---b  w---",
    "- b wb w -",
    "- w bw b -",
    "---w  b---",
    "- --bw-- -",
    "w- -  - -b",
    "-b------w-",
  ],
);

const sixeight = ReversiMap(
  name: "6x8",
  category: "Special",
  data: [
    "------",
    "------",
    "------",
    "--wb--",
    "--bw--",
    "------",
    "------",
    "------",
  ],
);

const spark = ReversiMap(
  name: "Spark",
  category: "Special",
  author: "syuilo",
  data: [
    " -      - ",
    "----------",
    " -------- ",
    " -------- ",
    " ---wb--- ",
    " ---bw--- ",
    " -------- ",
    " -------- ",
    "----------",
    " -      - ",
  ],
);

const islands = ReversiMap(
  name: "Islands",
  category: "Special",
  author: "syuilo",
  data: [
    "--------  ",
    "---wb---  ",
    "---bw---  ",
    "--------  ",
    "  -    -  ",
    "  -    -  ",
    "  --------",
    "  --------",
    "  --------",
    "  --------",
  ],
);

const galaxy = ReversiMap(
  name: "Galaxy",
  category: "Special",
  author: "syuilo",
  data: [
    "   ------   ",
    "  --www---  ",
    " ------w--- ",
    "---bbb--w---",
    "--b---b-w-b-",
    "-b--wwb-w-b-",
    "-b-w-bww--b-",
    "-b-w-b---b--",
    "---w--bbb---",
    " ---w------ ",
    "  ---www--  ",
    "   ------   ",
  ],
);

const triangle = ReversiMap(
  name: "Triangle",
  category: "Special",
  author: "syuilo",
  data: [
    "    --    ",
    "    --    ",
    "   ----   ",
    "   ----   ",
    "  --wb--  ",
    "  --bw--  ",
    " -------- ",
    " -------- ",
    "----------",
    "----------",
  ],
);

const iphonex = ReversiMap(
  name: "iPhone X",
  category: "Special",
  author: "syuilo",
  data: [
    " --  -- ",
    "--------",
    "--------",
    "--------",
    "--------",
    "---wb---",
    "---bw---",
    "--------",
    "--------",
    "--------",
    "--------",
    " ------ ",
  ],
);

const dealWithIt = ReversiMap(
  name: "Deal with it!",
  category: "Special",
  author: "syuilo",
  data: [
    "------------",
    "--w-b-------",
    " --b-w------",
    "  --w-b---- ",
    "   -------  ",
  ],
);

const twoBoard = ReversiMap(
  name: "Two board",
  category: "Special",
  author: "Aya",
  data: [
    "-------- --------",
    "-------- --------",
    "-------- --------",
    "---wb--- ---wb---",
    "---bw--- ---bw---",
    "-------- --------",
    "-------- --------",
    "-------- --------",
  ],
);

/// 移植元でのエクスポート名からマップを引く。
///
/// Misskey の設定 UI はこのキーでマップを指定する
/// （対局設定の `map` は配列そのものだが、フロントエンドの選択肢はキー順）。
const reversiMapsByKey = <String, ReversiMap>{
  "fourfour": fourfour,
  "sixsix": sixsix,
  "roundedSixsix": roundedSixsix,
  "roundedSixsix2": roundedSixsix2,
  "eighteight": eighteight,
  "eighteightH28": eighteightH28,
  "roundedEighteight": roundedEighteight,
  "roundedEighteight2": roundedEighteight2,
  "roundedEighteight3": roundedEighteight3,
  "eighteightWithNotch": eighteightWithNotch,
  "eighteightWithSomeHoles": eighteightWithSomeHoles,
  "circle": circle,
  "smile": smile,
  "window": window,
  "reserved": reserved,
  "x": x,
  "parallel": parallel,
  "lackOfBlack": lackOfBlack,
  "squareParty": squareParty,
  "minesweeper": minesweeper,
  "tenthtenth": tenthtenth,
  "hole": hole,
  "grid": grid,
  "cross": cross,
  "charX": charX,
  "charY": charY,
  "walls": walls,
  "cpu": cpu,
  "checker": checker,
  "japaneseCurry": japaneseCurry,
  "mosaic": mosaic,
  "arena": arena,
  "reactor": reactor,
  "sixeight": sixeight,
  "spark": spark,
  "islands": islands,
  "galaxy": galaxy,
  "triangle": triangle,
  "iphonex": iphonex,
  "dealWithIt": dealWithIt,
  "twoBoard": twoBoard,
};

/// 全マップ。定義順は移植元の `maps.ts` に合わせてある。
const reversiMaps = <ReversiMap>[
  fourfour,
  sixsix,
  roundedSixsix,
  roundedSixsix2,
  eighteight,
  eighteightH28,
  roundedEighteight,
  roundedEighteight2,
  roundedEighteight3,
  eighteightWithNotch,
  eighteightWithSomeHoles,
  circle,
  smile,
  window,
  reserved,
  x,
  parallel,
  lackOfBlack,
  squareParty,
  minesweeper,
  tenthtenth,
  hole,
  grid,
  cross,
  charX,
  charY,
  walls,
  cpu,
  checker,
  japaneseCurry,
  mosaic,
  arena,
  reactor,
  sixeight,
  spark,
  islands,
  galaxy,
  triangle,
  iphonex,
  dealWithIt,
  twoBoard,
];

/// [data] と一致するマップを名前で引く。見つからなければ null。
///
/// サーバーは対局情報にマップ名を載せず配列だけを送ってくるので、
/// 表示用の名前が要るときはこれで逆引きする。
ReversiMap? findReversiMap(List<String> data) {
  for (final map in reversiMaps) {
    if (map.data.length != data.length) continue;
    var matched = true;
    for (var i = 0; i < data.length; i++) {
      if (map.data[i] != data[i]) {
        matched = false;
        break;
      }
    }
    if (matched) return map;
  }
  return null;
}
