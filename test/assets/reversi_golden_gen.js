// 本家 (misskey-dev/misskey packages/misskey-reversi) の TypeScript をそのまま
// トランスパイルして走らせ、Dart 移植版の照合用データを吐く。
// 手の選び方は seed 固定の PRNG なので、何度回しても同じ棋譜になる。

const fs = require('fs');
const { Game } = require('./out/game.js');
const maps = require('./out/maps.js');

function mulberry32(a) {
	return function () {
		a |= 0; a = (a + 0x6D2B79F5) | 0;
		let t = Math.imul(a ^ (a >>> 15), 1 | a);
		t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
		return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
	};
}

function boardToString(board) {
	return board.map(c => c === true ? 'b' : c === false ? 'w' : c === null ? '-' : 'x').join('');
}

const optionSets = [
	{ label: 'default', isLlotheo: false, canPutEverywhere: false, loopedBoard: false },
	{ label: 'llotheo', isLlotheo: true, canPutEverywhere: false, loopedBoard: false },
	{ label: 'looped', isLlotheo: false, canPutEverywhere: false, loopedBoard: true },
	{ label: 'putEverywhere', isLlotheo: false, canPutEverywhere: true, loopedBoard: false },
	{ label: 'loopedPutEverywhere', isLlotheo: false, canPutEverywhere: true, loopedBoard: true },
];

const cases = [];
let seed = 1;

for (const [key, map] of Object.entries(maps)) {
	if (typeof map !== 'object' || map === null || !Array.isArray(map.data)) continue;

	for (const opts of optionSets) {
		const rand = mulberry32(seed++);
		const game = new Game(map.data, {
			isLlotheo: opts.isLlotheo,
			canPutEverywhere: opts.canPutEverywhere,
			loopedBoard: opts.loopedBoard,
		});

		const record = {
			map: key,
			opts: opts.label,
			initialBoard: boardToString(game.board),
			initialTurn: game.turn,
			initialCrc32: game.calcCrc32(),
			moves: [],
		};

		while (game.turn !== null) {
			const puttable = game.getPuttablePlaces(game.turn);
			const pos = puttable[Math.floor(rand() * puttable.length)];
			const move = [pos, puttable.length, 0];
			record.moves.push(move);
			game.putStone(pos);
			move[2] = game.calcCrc32();
			if (record.moves.length > 5000) throw new Error('too many moves');
		}

		record.finalBoard = boardToString(game.board);
		record.blackCount = game.blackCount;
		record.whiteCount = game.whiteCount;
		record.winner = game.winner;
		record.moveCount = record.moves.length;

		// 最後の 1 手を undo して戻ることも確かめる
		if (record.moves.length > 0) {
			game.undo();
			record.undoBoard = boardToString(game.board);
			record.undoTurn = game.turn;
			record.undoCrc32 = game.calcCrc32();
		}

		cases.push(record);
	}
}

fs.writeFileSync('golden.json', JSON.stringify({ cases }));
console.log(`cases: ${cases.length}, moves: ${cases.reduce((a, c) => a + c.moveCount, 0)}`);
