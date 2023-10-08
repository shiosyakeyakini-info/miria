import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/users_list_settings.dart';

final _formKeyProvider = Provider.autoDispose((ref) => GlobalKey<FormState>());

final _initialSettingsProvider = Provider.autoDispose<UsersListSettings>(
  (ref) => throw UnimplementedError(),
);

final _usersListSettingsNotifierProvider =
    NotifierProvider.autoDispose<_UsersListSettingsNotifier, UsersListSettings>(
  _UsersListSettingsNotifier.new,
  dependencies: [_initialSettingsProvider],
);

class _UsersListSettingsNotifier
    extends AutoDisposeNotifier<UsersListSettings> {
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

class UsersListSettingsDialog extends StatelessWidget {
  const UsersListSettingsDialog({
    super.key,
    this.title,
    this.initialSettings = const UsersListSettings(),
  });

  final Widget? title;
  final UsersListSettings initialSettings;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: ProviderScope(
        overrides: [
          _initialSettingsProvider.overrideWithValue(initialSettings),
        ],
        child: const UsersListSettingsForm(),
      ),
    );
  }
}

class UsersListSettingsForm extends ConsumerWidget {
  const UsersListSettingsForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = ref.watch(_formKeyProvider);
    final initialSettings = ref.watch(_initialSettingsProvider);
    final settings = ref.watch(_usersListSettingsNotifierProvider);

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: initialSettings.name,
            maxLength: 100,
            decoration: const InputDecoration(
              labelText: "リスト名",
              contentPadding: EdgeInsets.fromLTRB(12, 24, 12, 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "入力してください";
              }
              return null;
            },
            onSaved: ref
                .read(_usersListSettingsNotifierProvider.notifier)
                .updateName,
          ),
          CheckboxListTile(
            title: const Text("パブリック"),
            value: settings.isPublic,
            onChanged: ref
                .read(_usersListSettingsNotifierProvider.notifier)
                .updateIsPublic,
          ),
          ElevatedButton(
            child: const Text("決定"),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
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
    );
  }
}
