import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_test/flutter_test.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/misskey_post_file.dart";
import "package:miria/view/chat_page/chat_file_preview.dart";

import "../../test_util/test_datas.dart";

void main() {
  group("ChatFilePreview", () {
    testWidgets("画像ファイルのプレビューが表示されること", (tester) async {
      var fileDeleted = false;
      var fileSettingChanged = false;

      final binaryData = await TestData.binaryImage;
      final imageFile = ImageFile(data: binaryData, fileName: "test_image.jpg");

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatFilePreview(
              file: imageFile,
              onFileDeleted: () => fileDeleted = true,
              onFileSettingChanged: (file) async => fileSettingChanged = true,
            ),
          ),
        ),
      );

      // 画像が表示されることを確認
      expect(find.byType(Image), findsOneWidget);

      // 削除ボタンが表示されることを確認
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets("NSFW画像にNSFWラベルが表示されること", (tester) async {
      var fileDeleted = false;
      var fileSettingChanged = false;

      final binaryData = await TestData.binaryImage;
      final nsfwImageFile = ImageFile(
        data: binaryData,
        fileName: "nsfw_image.jpg",
        isNsfw: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            S.delegate,
          ],
          supportedLocales: S.supportedLocales,
          home: Scaffold(
            body: ChatFilePreview(
              file: nsfwImageFile,
              onFileDeleted: () => fileDeleted = true,
              onFileSettingChanged: (file) async => fileSettingChanged = true,
            ),
          ),
        ),
      );

      // NSFWラベルが表示されることを確認
      expect(find.text("NSFW"), findsOneWidget);
    });

    testWidgets("その他ファイルのプレビューが表示されること", (tester) async {
      var fileDeleted = false;
      var fileSettingChanged = false;

      final unknownFile = UnknownFile(
        data: Uint8List.fromList([1, 2, 3, 4]),
        fileName: "document.pdf",
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatFilePreview(
              file: unknownFile,
              onFileDeleted: () => fileDeleted = true,
              onFileSettingChanged: (file) async => fileSettingChanged = true,
            ),
          ),
        ),
      );

      // ファイルアイコンが表示されることを確認
      expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);

      // ファイル名が表示されることを確認
      expect(find.text("document.pdf"), findsOneWidget);

      // 削除ボタンが表示されることを確認
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets("削除ボタンをタップすると削除コールバックが呼ばれること", (tester) async {
      var fileDeleted = false;
      var fileSettingChanged = false;

      final binaryData = await TestData.binaryImage;
      final imageFile = ImageFile(data: binaryData, fileName: "test_image.jpg");

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatFilePreview(
              file: imageFile,
              onFileDeleted: () => fileDeleted = true,
              onFileSettingChanged: (file) async => fileSettingChanged = true,
            ),
          ),
        ),
      );

      // 削除ボタンをタップ
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // 削除コールバックが呼ばれることを確認
      expect(fileDeleted, isTrue);
      expect(fileSettingChanged, isFalse);
    });

    testWidgets("既存ファイルの場合は何も表示されないこと", (tester) async {
      var fileDeleted = false;
      var fileSettingChanged = false;

      final binaryData = await TestData.binaryImage;
      final existingFile = ImageFileAlreadyPostedFile(
        data: binaryData,
        id: "existing-file-id",
        fileName: "existing_image.jpg",
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatFilePreview(
              file: existingFile,
              onFileDeleted: () => fileDeleted = true,
              onFileSettingChanged: (file) async => fileSettingChanged = true,
            ),
          ),
        ),
      );

      // 何も表示されないことを確認
      expect(find.byType(Image), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);
      expect(find.byIcon(Icons.insert_drive_file), findsNothing);
    });

    testWidgets("画像プレビューのサイズが正しいこと", (tester) async {
      var fileDeleted = false;
      var fileSettingChanged = false;

      final binaryData = await TestData.binaryImage;
      final imageFile = ImageFile(data: binaryData, fileName: "test_image.jpg");

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatFilePreview(
              file: imageFile,
              onFileDeleted: () => fileDeleted = true,
              onFileSettingChanged: (file) async => fileSettingChanged = true,
            ),
          ),
        ),
      );

      // プレビューコンテナのサイズを確認
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(ChatFilePreview),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8));
    });

    testWidgets("その他ファイルプレビューのサイズが正しいこと", (tester) async {
      var fileDeleted = false;
      var fileSettingChanged = false;

      final unknownFile = UnknownFile(
        data: Uint8List.fromList([1, 2, 3, 4]),
        fileName: "very_long_filename_that_should_be_truncated.pdf",
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatFilePreview(
              file: unknownFile,
              onFileDeleted: () => fileDeleted = true,
              onFileSettingChanged: (file) async => fileSettingChanged = true,
            ),
          ),
        ),
      );

      // プレビューコンテナが正しいサイズであることを確認
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(ChatFilePreview),
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.constraints?.maxWidth, 80.0);
      expect(container.constraints?.maxHeight, 80.0);
    });
  });
}
