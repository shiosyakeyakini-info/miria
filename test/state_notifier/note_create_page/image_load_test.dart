import "package:file/file.dart";
import "package:file/local.dart";
import "package:file/memory.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:image/image.dart";
import "package:miria/providers.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";

ProviderContainer createContainer() {
  return ProviderContainer(
    overrides: [fileSystemProvider.overrideWithValue(MemoryFileSystem.test())],
  )..listen(noteCreateNotifierProvider, (_, _) {});
}

void main() {
  const FileSystem fs = LocalFileSystem();
  group("画像読込", () {
    test("PNG画像が読み込めること", () async {
      final file = fs.file("test/assets/images/test.png");
      final container = createContainer();
      final d = await container
          .read(noteCreateNotifierProvider.notifier)
          .loadImage(file);
      final data = await d?.file.readAsBytes();
      expect(decodePng(data!), isNotNull);
    });

    test("GIF画像が読み込めること", () async {
      final file = fs.file("test/assets/images/test.gif");
      final container = createContainer();
      final d = await container
          .read(noteCreateNotifierProvider.notifier)
          .loadImage(file);
      final data = await d?.file.readAsBytes();
      expect(decodeGif(data!), isNotNull);
    });

    test("JPEG画像が読み込めること", () async {
      final file = fs.file("test/assets/images/exif_test.jpg");
      final container = createContainer();
      final d = await container
          .read(noteCreateNotifierProvider.notifier)
          .loadImage(file);
      expect(d, isNotNull);
      final data = await d?.file.readAsBytes();
      expect(decodeJpg(data!), isNotNull);
    });

    test("TIFFはJPEGに変換されること", () async {
      final file = fs.file("test/assets/images/test.tiff");
      final container = createContainer();
      final d = await container
          .read(noteCreateNotifierProvider.notifier)
          .loadImage(file);
      expect(d, isNotNull);
      final data = await d?.file.readAsBytes();
      expect(decodeTiff(data!), isNull);
      expect(decodeJpg(data), isNotNull);
    });

    test("入力JPEG画像にgpsIfdのキーがあること", () async {
      final file = fs.file("test/assets/images/exif_test.jpg");
      final exif = decodeJpgExif(await file.readAsBytes());
      expect(exif?.gpsIfd.values.length, 5);
    });

    test("出力JPEG画像にgpsIfdのキーが存在しないこと", () async {
      final file = fs.file("test/assets/images/exif_test.jpg");
      final container = createContainer();
      final d = await container
          .read(noteCreateNotifierProvider.notifier)
          .loadImage(file);
      expect(d, isNotNull);
      final data = await d?.file.readAsBytes();
      final exif = decodeJpgExif(data!);
      expect(exif, isNotNull);
      expect(exif?.gpsIfd.keys.length, 0);
    });

    test("出力JPEG画像のEXIFに向き以外存在しないこと", () async {
      final file = fs.file("test/assets/images/exif_test.jpg");
      final container = createContainer();
      final d = await container
          .read(noteCreateNotifierProvider.notifier)
          .loadImage(file);
      expect(d, isNotNull);
      final data = await d?.file.readAsBytes();
      final exif = decodeJpgExif(data!);
      expect(exif, isNotNull);
      expect(exif?.imageIfd.keys.length, 1);
      expect(exif?.imageIfd.keys.first, 0x112);
    });

    test("出力JPEG画像のEXIFのOrientation値が6であること", () async {
      final file = fs.file("test/assets/images/exif_test.jpg");
      final container = createContainer();
      final d = await container
          .read(noteCreateNotifierProvider.notifier)
          .loadImage(file);
      expect(d, isNotNull);
      final data = await d?.file.readAsBytes();
      final exif = decodeJpgExif(data!);
      expect(exif, isNotNull);
      expect(exif?.imageIfd.keys.length, 1);
      expect(exif?.imageIfd.orientation, 6);
    });

    test("EXIFがIFDだけのJPEG画像が読み込めること", () async {
      final file = fs.file("test/assets/images/exif_ifd_only.jpg");
      final container = createContainer();
      final d = await container
          .read(noteCreateNotifierProvider.notifier)
          .loadImage(file);
      expect(d, isNotNull);
      final data = await d?.file.readAsBytes();
      final img = decodeJpg(data!);
      expect(img, isNotNull);
    });

    test("EXIFがIFDだけのJPEG画像はOrientation値が1になること", () async {
      final file = fs.file("test/assets/images/exif_ifd_only.jpg");
      final container = createContainer();
      final d = await container
          .read(noteCreateNotifierProvider.notifier)
          .loadImage(file);
      expect(d, isNotNull);
      final data = await d?.file.readAsBytes();
      final exif = decodeJpgExif(data!);
      expect(exif, isNotNull);
      expect(exif?.imageIfd.keys.length, 1);
      expect(exif?.imageIfd.orientation, 1);
    });

    test("EXIFがないJPEG画像の場合はEXIFをつけないこと", () async {
      final file = fs.file("test/assets/images/exif_no_data.jpg");
      final container = createContainer();
      final d = await container
          .read(noteCreateNotifierProvider.notifier)
          .loadImage(file);
      expect(d, isNotNull);
      final data = await d?.file.readAsBytes();
      expect(decodeJpg(data!), isNotNull);
      final exif = decodeJpgExif(data);
      expect(exif, isNull);
    });
  });
}
