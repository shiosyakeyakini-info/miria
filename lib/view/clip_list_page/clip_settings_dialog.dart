import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/clip_settings.dart';

final _formKeyProvider = Provider.autoDispose((ref) => GlobalKey<FormState>());

final _initialSettingsProvider = Provider.autoDispose<ClipSettings>(
  (ref) => throw UnimplementedError(),
);

final _clipSettingsNotifierProvider =
    NotifierProvider.autoDispose<_ClipSettingsNotifier, ClipSettings>(
  _ClipSettingsNotifier.new,
  dependencies: [_initialSettingsProvider],
);

class _ClipSettingsNotifier extends AutoDisposeNotifier<ClipSettings> {
  @override
  ClipSettings build() {
    return ref.watch(_initialSettingsProvider);
  }

  void updateName(String? name) {
    if (name != null) {
      state = state.copyWith(name: name);
    }
  }

  void updateDescription(String? description) {
    if (description != null) {
      state = state.copyWith(
        description: description.isEmpty ? null : description,
      );
    }
  }

  void updateIsPublic(bool? isPublic) {
    if (isPublic != null) {
      state = state.copyWith(isPublic: isPublic);
    }
  }
}

class ClipSettingsDialog extends StatelessWidget {
  const ClipSettingsDialog({
    super.key,
    this.title,
    this.initialSettings = const ClipSettings(),
  });

  final Widget? title;
  final ClipSettings initialSettings;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      scrollable: true,
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
    final settings = ref.watch(_clipSettingsNotifierProvider);

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: initialSettings.name,
            maxLength: 100,
            decoration: const InputDecoration(
              labelText: "クリップ名",
              contentPadding: EdgeInsets.fromLTRB(12, 24, 12, 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "入力してください";
              }
              return null;
            },
            onSaved:
                ref.read(_clipSettingsNotifierProvider.notifier).updateName,
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: initialSettings.description,
            minLines: 2,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: "説明（省略可）",
              contentPadding: EdgeInsets.fromLTRB(12, 24, 12, 16),
            ),
            onSaved: ref
                .read(_clipSettingsNotifierProvider.notifier)
                .updateDescription,
          ),
          CheckboxListTile(
            title: const Text("パブリック"),
            value: settings.isPublic,
            onChanged:
                ref.read(_clipSettingsNotifierProvider.notifier).updateIsPublic,
          ),
          ElevatedButton(
            child: const Text("決定"),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                final settings = ref.read(_clipSettingsNotifierProvider);
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
