import "package:file/file.dart";
import "package:file/local.dart";
import "package:flutter_test/flutter_test.dart";
import "package:image/image.dart";
import "package:miria/state_notifier/note_create_page/note_create_state_notifier.dart";

void main() {
  const FileSystem fs = LocalFileSystem();
  group("画像読込", () {
    test("PNG画像が読み込めること", () async {
      final file = fs.file("test/assets/images/test.png");
      final d = await NoteCreateNotifier().loadImage(file);
      expect(decodePng(d.data), isNotNull);
    });

    test("GIF画像が読み込めること", () async {
      final file = fs.file("test/assets/images/test.gif");
      final d = await NoteCreateNotifier().loadImage(file);
      expect(decodeGif(d.data), isNotNull);
    });

    test("JPEG画像が読み込めること", () async {
      final file = fs.file("test/assets/images/exif_test.jpg");
      final d = await NoteCreateNotifier().loadImage(file);
      expect(decodeJpg(d.data), isNotNull);
    });

    test("TIFFはJPEGに変換されること", () async {
      final file = fs.file("test/assets/images/test.tiff");
      final d = await NoteCreateNotifier().loadImage(file);
      expect(decodeTiff(d.data), isNull);
      expect(decodeJpg(d.data), isNotNull);
    });

    test("入力JPEG画像にgpsIfdのキーがあること", () async {
      final file = fs.file("test/assets/images/exif_test.jpg");
      final exif = decodeJpgExif(await file.readAsBytes());
      expect(exif?.gpsIfd.values.length, 5);
    });

    test("出力JPEG画像にgpsIfdのキーが存在しないこと", () async {
      final file = fs.file("test/assets/images/exif_test.jpg");
      final d = await NoteCreateNotifier().loadImage(file);
      final exif = decodeJpgExif(d.data);
      expect(exif, isNotNull);
      expect(exif?.gpsIfd.keys.length, 0);
    });

    test("出力JPEG画像のEXIFに向き以外存在しないこと", () async {
      final file = fs.file("test/assets/images/exif_test.jpg");
      final d = await NoteCreateNotifier().loadImage(file);
      final exif = decodeJpgExif(d.data);
      expect(exif, isNotNull);
      expect(exif?.imageIfd.keys.length, 1);
      expect(exif?.imageIfd.keys.first, 0x112);
    });

    test("出力JPEG画像のEXIFのOrientation値が6であること", () async {
      final file = fs.file("test/assets/images/exif_test.jpg");
      final d = await NoteCreateNotifier().loadImage(file);
      final exif = decodeJpgExif(d.data);
      expect(exif, isNotNull);
      expect(exif?.imageIfd.keys.length, 1);
      expect(exif?.imageIfd.orientation, 6);
    });

    test("EXIFがIFDだけのJPEG画像が読み込めること", () async {
      final file = fs.file("test/assets/images/exif_ifd_only.jpg");
      final d = await NoteCreateNotifier().loadImage(file);
      final img = decodeJpg(d.data);
      expect(img, isNotNull);
    });

    test("EXIFがIFDだけのJPEG画像はOrientation値が1になること", () async {
      final file = fs.file("test/assets/images/exif_ifd_only.jpg");
      final d = await NoteCreateNotifier().loadImage(file);
      final exif = decodeJpgExif(d.data);
      expect(exif, isNotNull);
      expect(exif?.imageIfd.keys.length, 1);
      expect(exif?.imageIfd.orientation, 1);
    });

    test("EXIFがないJPEG画像の場合はEXIFをつけないこと", () async {
      final file = fs.file("test/assets/images/exif_no_data.jpg");
      final d = await NoteCreateNotifier().loadImage(file);
      expect(decodeJpg(d.data), isNotNull);
      final exif = decodeJpgExif(d.data);
      expect(exif, isNull);
    });
  });
}
