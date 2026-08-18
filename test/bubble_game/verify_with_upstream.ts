// サーバーがスコアを検証するとしたら何をすることになるか、を本家の実装でやってみる。
//
// `bubble_game_record`に残っているのは seed と操作ログだけなので、
// 検証する側はそれを本家の`DropAndFusionGame`に食わせて再生し、
// 出てきたスコアが申告された値と合うかを見ることになる。
// Miriaが送った記録がそれを通るか (＝移植が本家と同じ結果を出しているか) を
// 確かめるためのスクリプト。
//
// 使いかたは`README.md`の「サーバー側検証を模したチェック」を参照。

import fs from 'node:fs';
import { DropAndFusionGame } from 'misskey-bubble-game';

type Record = {
	gameMode: 'normal' | 'yen' | 'square' | 'sweets' | 'space';
	seed: string;
	score: number;
	logs: number[][];
};

/** 無限ループ避け。実際の記録は数千フレームで終わる。 */
const MAX_FRAMES = 100000;

const records: Record[] = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));

let ok = 0;
let ng = 0;

for (const record of records) {
	// 描画用のオプションを渡さないと本家の`Body.create`が落ちる (物理には影響しない)
	const game = new DropAndFusionGame({
		seed: record.seed,
		gameMode: record.gameMode,
		getMonoRenderOptions: () => ({}),
	});
	game.start();

	const logs = DropAndFusionGame.deserializeLogs(record.logs);

	while (game.frame < MAX_FRAMES) {
		for (const log of logs.filter(x => x.frame === game.frame)) {
			switch (log.operation) {
				case 'drop': game.drop(log.x); break;
				case 'hold': game.hold(); break;
				case 'surrender': game.surrender(); break;
			}
		}
		if (!game.tick()) break;
	}

	const match = game.score === record.score;
	if (match) ok++; else ng++;

	console.log(
		`${match ? 'OK  ' : 'NG  '} ${record.gameMode.padEnd(7)} ` +
		`stored=${String(record.score).padStart(6)} ` +
		`replayed=${String(game.score).padStart(6)} ` +
		`frames=${game.frame} ops=${record.logs.length}`,
	);
}

console.log(`\n${ok} matched, ${ng} mismatched`);
process.exit(ng === 0 ? 0 : 1);
