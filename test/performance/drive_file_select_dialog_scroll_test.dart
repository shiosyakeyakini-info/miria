import "dart:io" as io;
import "dart:typed_data";
import "dart:ui" as ui;

import "package:file/local.dart";
import "package:flutter/material.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/misskey_notes/network_image.dart";
import "package:miria/view/note_create_page/drive_file_select_dialog.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../test_util/default_root_widget.dart";
import "../test_util/mock.mocks.dart";
import "../test_util/test_datas.dart";

/// ドライブのファイル選択ダイアログが、ファイル数に対してどれだけの
/// ウィジェット・描画コスト・画像メモリを抱えるのかを測るための計測台。
///
/// 通常のテストのように何かを保証するのが目的ではなく、数字を出すのが目的。
/// 出力は `fvm flutter test test/performance --reporter expanded` で読める。
///
/// ここで測れないもの:
///
/// - ラスタライズ（GPU）時間。`flutter test` の binding は build/layout/paint
///   までしか回さない。
/// - デコード済み画像の実バイト数。テスト binding では画像の読み込みが
///   pending のまま完了しないので、`imageCache.currentSizeBytes` は 0 のまま。
///   生きている画像ストリームの本数（= 同時に抱えている画像の枚数）だけが
///   意味を持つ。
///
/// どちらも動いているアプリなら読める。
/// `.claude/skills/drive-miria/scripts/marionette.py frames|imagecache|tree|mem`
///
/// 時間の列（scrollFrame / selectRebuild）はJITの暖まり具合に引っ張られて
/// 順番どおりに増えてくれないことがある。信用できるのは数のほうで、
/// 時間を真面目に見たいなら動いているアプリで測ること。
void main() {
  // 実際のサムネイルに近い大きさのPNGを1枚だけ作り、全ファイルで中身を使い回す。
  // URLはファイルごとに変えるので、画像キャッシュ上は別物として数えられる。
  late Uint8List thumbnailBytes;
  late io.Directory tempDir;
  late io.File thumbnailFile;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    thumbnailBytes = await _solidPng(300);
    tempDir = await io.Directory.systemTemp.createTemp("miria_drive_bench");
    thumbnailFile = io.File("${tempDir.path}/thumbnail.png")
      ..writeAsBytesSync(thumbnailBytes);
  });

  tearDownAll(() async {
    await tempDir.delete(recursive: true);
  });

  setUp(() {
    imageCache
      ..clear()
      ..clearLiveImages();
  });

  for (final fileCount in const [10, 40, 160]) {
    testWidgets("ドライブに $fileCount 件あるときの計測", (tester) async {
      final mockMisskey = MockMisskey();
      final mockDrive = MockMisskeyDrive();
      final mockDriveFiles = MockMisskeyDriveFiles();
      final mockDriveFolders = MockMisskeyDriveFolders();
      final mockCacheManager = MockCacheManager();

      when(mockMisskey.drive).thenReturn(mockDrive);
      when(mockDrive.files).thenReturn(mockDriveFiles);
      when(mockDrive.folders).thenReturn(mockDriveFolders);
      when(
        mockDriveFolders.folders(any),
      ).thenAnswer((_) async => const <DriveFolder>[]);
      when(mockDriveFiles.files(any)).thenAnswer(
        (_) async => List.generate(
          fileCount,
          (index) => TestData.drive1.copyWith(
            id: "bench$index",
            name: "bench$index.png",
            // URLが同じだと画像キャッシュが1件にまとまってしまい、
            // 「ファイルの数だけデコード済みビットマップを抱える」という
            // 本番の状況を再現できない。
            thumbnailUrl: "https://bench.invalid/thumbnail$index.png",
            url: "https://bench.invalid/$index.png",
          ),
        ),
      );

      when(
        mockCacheManager.getFileStream(
          any,
          key: anyNamed("key"),
          headers: anyNamed("headers"),
          withProgress: anyNamed("withProgress"),
        ),
      ).thenAnswer(
        (invocation) => Stream.value(
          FileInfo(
            const LocalFileSystem().file(thumbnailFile.path),
            FileSource.Cache,
            DateTime.now().add(const Duration(days: 1)),
            invocation.positionalArguments.first as String,
          ),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            misskeyProvider.overrideWith((ref, account) => mockMisskey),
            cacheManagerProvider.overrideWith((ref) => mockCacheManager),
          ],
          child: DefaultRootNoRouterWidget(
            child: AccountContextScope.as(
              account: TestData.account,
              child: DriveFileSelectDialog(
                account: TestData.account,
                allowMultiple: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final elements = tester.allElements.length;
      final renderObjects = tester.allElements
          .whereType<RenderObjectElement>()
          .length;
      final thumbnails = find.byType(NetworkImageView).evaluate().length;

      // スクロール1フレームぶんの build + layout + paint。
      final scrollTarget = find.byType(SingleChildScrollView).first;
      final gesture = await tester.startGesture(tester.getCenter(scrollTarget));
      await tester.pump();
      const frames = 20;
      final stopwatch = Stopwatch()..start();
      for (var i = 0; i < frames; i++) {
        await gesture.moveBy(const Offset(0, -24));
        await tester.pump(const Duration(milliseconds: 16));
      }
      stopwatch.stop();
      await gesture.up();
      await tester.pump();

      final perFrameMicros = stopwatch.elapsedMicroseconds / frames;

      // ファイルを1つ選ぶと、ダイアログ全体が作り直される。
      // 遅延生成が効いていないので、選択のたびに全タイルが再構築される。
      final selectStopwatch = Stopwatch()..start();
      await tester.tap(find.byType(NetworkImageView).first);
      await tester.pump();
      selectStopwatch.stop();

      // ignore: avoid_print
      print(
        "[drive bench] files=$fileCount "
        "elements=$elements renderObjects=$renderObjects "
        "thumbnailWidgets=$thumbnails "
        "liveImageStreams=${imageCache.liveImageCount}件 "
        "scrollFrame=${(perFrameMicros / 1000).toStringAsFixed(2)}ms "
        "selectRebuild=${(selectStopwatch.elapsedMicroseconds / 1000).toStringAsFixed(2)}ms",
      );

      // 現状の特性: 表示領域に関係なく、ドライブにある件数ぶんのタイルが
      // まるごと存在している（SingleChildScrollView の中で shrinkWrap した
      // ListView は、ビューポートによる間引きが効かない）。
      // 遅延生成に直したらここが落ちる。落ちたら期待を書き換えること。
      expect(thumbnails, fileCount);
    });
  }
}

/// 指定サイズの単色PNGを作る。デコード後は size * size * 4 バイトになる。
Future<Uint8List> _solidPng(int size) async {
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder).drawRect(
    Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
    Paint()..color = const Color(0xFF336699),
  );
  final image = await recorder.endRecording().toImage(size, size);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}
