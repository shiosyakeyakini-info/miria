import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/general_settings.dart";
import "package:miria/providers.dart";
import "package:miria/repository/general_settings_repository.dart";
import "package:miria/view/common/misskey_notes/note_background.dart";
import "package:misskey_dart/misskey_dart.dart";

class FakeGeneralSettingsRepository extends GeneralSettingsRepository {
  FakeGeneralSettingsRepository(this._settings);

  GeneralSettings _settings;

  @override
  GeneralSettings get settings => _settings;

  @override
  Future<void> load() async {}

  @override
  Future<void> update(GeneralSettings settings) async {
    _settings = settings;
  }
}

Widget buildTestWidget({
  required GeneralSettings settings,
  required Brightness brightness,
}) {
  return ProviderScope(
    overrides: [
      generalSettingsRepositoryProvider.overrideWith(
        (ref) => FakeGeneralSettingsRepository(settings),
      ),
    ],
    child: MaterialApp(
      theme: ThemeData(brightness: brightness),
      home: NoteBackground(
        visibility: NoteVisibility.public,
        child: const SizedBox(width: 10, height: 10),
      ),
    ),
  );
}

void main() {
  testWidgets("returns child when color is null", (tester) async {
    await tester.pumpWidget(
      buildTestWidget(
        settings: const GeneralSettings(),
        brightness: Brightness.light,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ColoredBox), findsNothing);
  });

  testWidgets("apply background color", (tester) async {
    const color = Colors.red;
    await tester.pumpWidget(
      buildTestWidget(
        settings: const GeneralSettings(lightNoteBackgroundPublic: color),
        brightness: Brightness.light,
      ),
    );
    await tester.pumpAndSettle();
    final box = tester.widget<ColoredBox>(find.byType(ColoredBox));
    expect(box.color, color);
  });
}
