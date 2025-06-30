import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/view/profile_edit_page/profile_edit_provider.dart";
import "package:misskey_dart/misskey_dart.dart";

void main() {
  test("remove field shifts values", () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(profileFieldsProvider.notifier).update(const [
      UserField(name: "a", value: "1"),
      UserField(name: "b", value: "2"),
      UserField(name: "c", value: "3"),
    ]);
    final notifier = container.read(profileFieldsProvider.notifier);
    final current = container.read(profileFieldsProvider);
    notifier.update([...current]..removeAt(1));
    final updated = container.read(profileFieldsProvider);
    expect(updated.length, 2);
    expect(updated[1].name, "c");
  });

  test("add field increases length", () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(profileFieldsProvider.notifier).update(const []);
    final notifier = container.read(profileFieldsProvider.notifier);
    final current = container.read(profileFieldsProvider);
    notifier.update([
      ...current,
      const UserField(name: "a", value: "1"),
    ]);
    final updated = container.read(profileFieldsProvider);
    expect(updated.length, 1);
    expect(updated.first.name, "a");
  });
}
