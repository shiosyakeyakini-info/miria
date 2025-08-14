import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/clip_settings.dart";
import "package:miria/view/clip_list_page/clip_settings_dialog.dart";

void main() {
  group("ClipSettingsDialog dependencies テスト", () {
    testWidgets("dependenciesパラメーター追加後のProviderScopeが正しく動作すること", (tester) async {
      const testSettings = ClipSettings(
        name: "テストクリップ",
        description: "テスト説明",
        isPublic: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: S.localizationsDelegates,
            supportedLocales: S.supportedLocales,
            home: ClipSettingsDialog(
              title: const Text("テスト"),
              initialSettings: testSettings,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // ダイアログが表示されることを確認
      expect(find.byType(AlertDialog), findsOneWidget);
      
      // 初期値が正しく表示されることを確認
      expect(find.text("テストクリップ"), findsOneWidget);
      
      // パブリックチェックボックスが正しく設定されていることを確認
      final checkbox = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(checkbox.value, true);
    });
  });
}