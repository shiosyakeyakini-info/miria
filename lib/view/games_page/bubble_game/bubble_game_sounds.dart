import "dart:async";

import "package:audioplayers/audioplayers.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "package:miria/model/bubble_game/mono.dart";

/// バブルゲームのBGMと効果音。
///
/// 音はインスタンスの`/client-assets/drop-and-fusion/`から取ってくる。
/// フォークで差し替えられていることがあるので、アプリには同梱しない。
///
/// 鳴らしかた (音量・左右の振り分け・再生レートによる音程) は本家に合わせている。
class BubbleGameSounds {
  BubbleGameSounds._(this._files, this._bgm, this._sfxPlayers);

  /// 効果音を重ねて鳴らすための数。
  /// 衝突音は短い間に何度も鳴るので、ある程度の同時発音数が要る。
  static const _sfxPlayerCount = 8;

  /// 短い間に鳴らす衝突音の上限。
  /// 積み上がった盤面では毎フレーム何度も衝突するため、鳴らしすぎないようにする。
  static const _collisionInterval = Duration(milliseconds: 40);

  final Map<_Sound, String> _files;
  final AudioPlayer _bgm;
  final List<AudioPlayer> _sfxPlayers;

  int _nextPlayer = 0;
  DateTime? _lastCollisionAt;
  var _disposed = false;

  double bgmVolume = 0.25;
  double sfxVolume = 1;

  /// 必要な音をまとめて取得する。取れなかった音は黙って鳴らさない。
  static Future<BubbleGameSounds> load({
    required BaseCacheManager cacheManager,
    required Uri host,
    required BubbleGameMode gameMode,
  }) async {
    // おかねモードだけ専用の音がある
    final isYen = gameMode == BubbleGameMode.yen;
    final names = {
      _Sound.bgm: "bgm_1",
      _Sound.drop: isYen ? "drop_yen" : "drop",
      _Sound.fusion: isYen ? "fusion_yen" : "fusion",
      _Sound.collision: isYen ? "collision_yen" : "collision",
      _Sound.hold: "hold",
      _Sound.gameOver: isYen ? "gameover_yen" : "gameover",
    };

    final files = <_Sound, String>{};
    await Future.wait([
      for (final entry in names.entries)
        cacheManager
            .getSingleFile(
              host
                  .replace(
                    path: "/client-assets/drop-and-fusion/${entry.value}.mp3",
                  )
                  .toString(),
            )
            .then(
              (file) => files[entry.key] = file.path,
              // 音が無くても遊べるので、取れなければ諦める
              onError: (_) {},
            ),
    ]);

    return BubbleGameSounds._(
      files,
      AudioPlayer()..setReleaseMode(ReleaseMode.loop),
      [
        for (var i = 0; i < _sfxPlayerCount; i++)
          AudioPlayer()..setReleaseMode(ReleaseMode.stop),
      ],
    );
  }

  Future<void> startBgm() async {
    final path = _files[_Sound.bgm];
    if (path == null || _disposed) return;
    await _guard(() async {
      await _bgm.setVolume(bgmVolume);
      await _bgm.play(DeviceFileSource(path), volume: bgmVolume);
    });
  }

  Future<void> setBgmVolume(double volume) async {
    bgmVolume = volume;
    if (_disposed) return;
    await _guard(() => _bgm.setVolume(volume));
  }

  Future<void> stopBgm() async {
    if (_disposed) return;
    await _guard(_bgm.stop);
  }

  void playDrop(double pan) => _play(_Sound.drop, volume: sfxVolume, pan: pan);

  void playHold() => _play(_Sound.hold, volume: 0.5 * sfxVolume);

  void playGameOver({required bool isYen}) =>
      _play(_Sound.gameOver, volume: (isYen ? 0.5 : 1) * sfxVolume);

  /// 合体音。音程は合体してできたモノごとに決まっている。
  void playFusion({
    required double pan,
    required double pitch,
    required bool isYen,
  }) => _play(
    _Sound.fusion,
    volume: (isYen ? 0.25 : 1) * sfxVolume,
    pan: pan,
    rate: isYen ? pitch / 4 : pitch,
  );

  /// 衝突音。強くぶつかるほど大きく、低い音になる。
  void playCollision({
    required double energy,
    required double pan,
    required bool isYen,
  }) {
    const minEnergy = 2.5;
    const maxEnergy = 9.0;
    const pitchMax = 4.0;
    const pitchMin = 0.5;

    if (energy <= minEnergy) return;

    final now = DateTime.now();
    final last = _lastCollisionAt;
    if (last != null && now.difference(last) < _collisionInterval) return;
    _lastCollisionAt = now;

    final volume =
        (energy - minEnergy < maxEnergy ? energy - minEnergy : maxEnergy) /
        maxEnergy /
        4;
    final pitch =
        pitchMin +
        (pitchMax - pitchMin) * (1 - (energy < 10 ? energy : 10) / 10);

    _play(
      _Sound.collision,
      volume: volume * sfxVolume,
      pan: pan,
      rate: isYen ? (pitch < 1 ? 1 : pitch) : pitch,
    );
  }

  /// ゲームの進行を止めたくないので、鳴り終わりは待たない。
  void _play(
    _Sound sound, {
    required double volume,
    double pan = 0,
    double rate = 1,
  }) {
    final path = _files[sound];
    if (path == null || _disposed || volume <= 0) return;

    final player = _sfxPlayers[_nextPlayer];
    _nextPlayer = (_nextPlayer + 1) % _sfxPlayers.length;

    unawaited(
      _guard(() async {
        await player.setSource(DeviceFileSource(path));
        await player.setVolume(volume.clamp(0, 1));
        await player.setBalance(pan.clamp(-1, 1));
        await player.setPlaybackRate(rate.clamp(0.25, 4));
        await player.resume();
      }),
    );
  }

  /// 音まわりの失敗でゲームが止まらないようにする。
  Future<void> _guard(Future<void> Function() body) async {
    try {
      await body();
    } catch (_) {
      // 鳴らせなくても遊べる
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    await _guard(_bgm.dispose);
    for (final player in _sfxPlayers) {
      await _guard(player.dispose);
    }
  }
}

enum _Sound { bgm, drop, fusion, collision, hold, gameOver }
