import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";

void main() {
  group('MFM Border Tests', () {
    testWidgets('basic text without border displays normally', (WidgetTester tester) async {
      const mfmText = 'ただのテキスト';
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MfmText(
                mfmText: mfmText,
              ),
            ),
          ),
        ),
      );
      
      expect(find.textContaining('ただのテキスト'), findsOneWidget);
    });

    testWidgets('MfmText widget can be created with border text', (WidgetTester tester) async {
      const mfmText = r'$[border テスト]';
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MfmText(
                mfmText: mfmText,
              ),
            ),
          ),
        ),
      );
      
      // The widget should be created without throwing
      expect(find.byType(MfmText), findsOneWidget);
    });

    testWidgets('MfmText widget can handle complex border syntax', (WidgetTester tester) async {
      const mfmText = r'$[border.color=#ff0000,width=2,radius=5 境界線テスト]';
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MfmText(
                mfmText: mfmText,
              ),
            ),
          ),
        ),
      );
      
      // The widget should be created without throwing
      expect(find.byType(MfmText), findsOneWidget);
    });
  });
}