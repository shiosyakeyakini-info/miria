import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:miria/view/profile_edit_page/profile_edit_provider.dart';

void main() {
  test('remove field shifts values', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(profileFieldsProvider.notifier).state = const [
      UserField(name: 'a', value: '1'),
      UserField(name: 'b', value: '2'),
      UserField(name: 'c', value: '3'),
    ];
    final notifier = container.read(profileFieldsProvider.notifier);
    notifier.state = [...notifier.state]..removeAt(1);
    expect(notifier.state.length, 2);
    expect(notifier.state[1].name, 'c');
  });

  test('add field increases length', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(profileFieldsProvider.notifier).state = const [];
    final notifier = container.read(profileFieldsProvider.notifier);
    notifier.state = [
      ...notifier.state,
      const UserField(name: 'a', value: '1')
    ];
    expect(notifier.state.length, 1);
    expect(notifier.state.first.name, 'a');
  });
}
