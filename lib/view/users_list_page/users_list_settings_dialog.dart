import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/users_list_settings.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "users_list_settings_dialog.g.dart";

@riverpod
UsersListSettings _initialSettings(_InitialSettingsRef ref) =>
    throw UnimplementedError();

@riverpod
class _UsersListSettingsNotifier extends _$UsersListSettingsNotifier {
  @override
  UsersListSettings build() {
    return ref.watch(_initialSettingsProvider);
  }

  void updateName(String? name) {
    if (name != null) {
      state = state.copyWith(name: name);
    }
  }

  void updateIsPublic(bool? isPublic) {
    if (isPublic != null) {
      state = state.copyWith(isPublic: isPublic);
    }
  }
}

@RoutePage<UsersListSettings>()
class UsersListSettingsDialog extends HookConsumerWidget
    implements AutoRouteWrapper {
  const UsersListSettingsDialog({
    super.key,
    this.title,
    this.initialSettings = const UsersListSettings(),
  });

  final Widget? title;
  final UsersListSettings initialSettings;

  @override
  Widget wrappedRoute(BuildContext context) => ProviderScope(
        overrides: [
          _initialSettingsProvider.overrideWithValue(initialSettings),
        ],
        child: this,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useState(GlobalKey<FormState>());
    final initialSettings = ref.watch(_initialSettingsProvider);
    final settings = ref.watch(_usersListSettingsNotifierProvider);

    return AlertDialog(
      title: title,
      content: Form(
        key: formKey.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: initialSettings.name,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: S.of(context).listName,
                contentPadding: const EdgeInsets.fromLTRB(12, 24, 12, 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).pleaseInput;
                }
                return null;
              },
              onSaved: ref
                  .read(_usersListSettingsNotifierProvider.notifier)
                  .updateName,
            ),
            CheckboxListTile(
              title: Text(S.of(context).public),
              value: settings.isPublic,
              onChanged: ref
                  .read(_usersListSettingsNotifierProvider.notifier)
                  .updateIsPublic,
            ),
            ElevatedButton(
              child: Text(S.of(context).done),
              onPressed: () {
                if (formKey.value.currentState!.validate()) {
                  formKey.value.currentState!.save();
                  final settings = ref.read(_usersListSettingsNotifierProvider);
                  if (settings == initialSettings) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop(settings);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
