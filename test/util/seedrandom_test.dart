import "package:flutter_test/flutter_test.dart";
import "package:miria/util/seedrandom.dart";

/// 期待値はNode.jsで`seedrandom@3.0.5`を実行して得たもの。
///
/// ```js
/// const seedrandom = require('seedrandom');
/// const rng = seedrandom('1755000000000');
/// Array.from({length: 6}, () => rng());
/// ```
const _expected = {
  "1755000000000": [
    0.5319203571303807,
    0.8540165228180499,
    0.4449898492262454,
    0.6648969242483131,
    0.09156060432678471,
    0.2897875264948576,
  ],
  "miria": [
    0.8425743286671026,
    0.7053658015698965,
    0.6573934909728361,
    0.12539751068823343,
    0.3887397980511247,
    0.2695765878921393,
  ],
  "": [
    0.23144008215179881,
    0.27404636548159655,
    0.7901279251811976,
    0.40384160557189036,
    0.1321140086237582,
    0.6182831712505996,
  ],
  "0": [
    0.7803563384230067,
    0.05144520047760746,
    0.5317574394273067,
    0.4885194745974366,
    0.8764000274360477,
    0.7467466967539371,
  ],
};

void main() {
  group("SeedRandom", () {
    for (final entry in _expected.entries) {
      test('seedrandomと同じ乱数列になる: "${entry.key}"', () {
        final random = SeedRandom(entry.key);
        for (final expected in entry.value) {
          expect(random.nextDouble(), expected);
        }
      });
    }

    test("同じシードなら何度作っても同じ列になる", () {
      final first = SeedRandom("miria");
      final second = SeedRandom("miria");
      for (var i = 0; i < 32; i++) {
        expect(first.nextDouble(), second.nextDouble());
      }
    });

    test("値は0以上1未満に収まる", () {
      final random = SeedRandom("1755000000000");
      for (var i = 0; i < 1000; i++) {
        final value = random.nextDouble();
        expect(value, greaterThanOrEqualTo(0));
        expect(value, lessThan(1));
      }
    });
  });
}
