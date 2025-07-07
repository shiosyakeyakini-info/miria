import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";

void main() {
  group('MFM Border Tests', () {
    testWidgets('basic border function displays border', (WidgetTester tester) async {
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
      
      expect(find.text('テスト'), findsOneWidget);
      
      // Look for a Container with border decoration
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);
      
      final container = tester.widget<Container>(containerFinder.first);
      expect(container.decoration, isA<BoxDecoration>());
    });

    testWidgets('border with color parameter', (WidgetTester tester) async {
      const mfmText = r'$[border.color=#ff0000 赤い境界線]';
      
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
      
      expect(find.text('赤い境界線'), findsOneWidget);
    });

    testWidgets('border with width parameter', (WidgetTester tester) async {
      const mfmText = r'$[border.width=3 太い境界線]';
      
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
      
      expect(find.text('太い境界線'), findsOneWidget);
    });

    testWidgets('border with radius parameter', (WidgetTester tester) async {
      const mfmText = r'$[border.radius=10 角丸境界線]';
      
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
      
      expect(find.text('角丸境界線'), findsOneWidget);
    });

    testWidgets('border with multiple parameters', (WidgetTester tester) async {
      const mfmText = r'$[border.color=#00ff00,width=2,radius=5 緑の角丸境界線]';
      
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
      
      expect(find.text('緑の角丸境界線'), findsOneWidget);
    });

    testWidgets('text without border function displays normally', (WidgetTester tester) async {
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
      
      expect(find.text('ただのテキスト'), findsOneWidget);
    });
  });
}