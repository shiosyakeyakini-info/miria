import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:misskey_dart/misskey_dart.dart';
import '../../model/account.dart';
import '../common/account_scope.dart';
import '../note_create_page/drive_file_select_dialog.dart';
import '../../router/app_router.dart';
import 'profile_edit_provider.dart';
import 'profile_update_notifier.dart';
import '../../hooks/use_async.dart';
import '../../providers.dart';

@RoutePage()
class ProfileEditPage extends HookConsumerWidget implements AutoRouteWrapper {
  final Account account;

  const ProfileEditPage({required this.account, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialized = useState(false);
    useEffect(() {
      () async {
        final me = await ref.read(misskeyGetContextProvider).i.i();
        ref.read(profileNameProvider.notifier).state = me.name ?? '';
        ref.read(profileDescriptionProvider.notifier).state =
            me.description ?? '';
        ref.read(profileLocationProvider.notifier).state = me.location ?? '';
        ref.read(profileBirthdayProvider.notifier).state = me.birthday;
        ref.read(profileFollowedMessageProvider.notifier).state =
            me.followedMessage ?? '';
        final fields = me.fields?.toList() ?? [];
        final min = fields.length < 5 ? 5 : fields.length;
        ref.read(profileFieldsProvider.notifier).state = [
          ...fields,
          ...List.generate(
              min - fields.length, (_) => const UserField(name: '', value: '')),
        ];
        initialized.value = true;
      }();
      return null;
    }, []);

    final fields = ref.watch(profileFieldsProvider);

    final update = useAsync(() async {
      await ref.read(profileUpdateNotifierProvider.notifier).submit();
      if (context.mounted) Navigator.of(context).pop();
    });

    if (!initialized.value) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
              onPressed: update.executeOrNull, icon: const Icon(Icons.save))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: useTextEditingController(
                    text: ref.read(profileNameProvider)),
                onChanged: (v) =>
                    ref.read(profileNameProvider.notifier).state = v,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await FilePicker.platform
                          .pickFiles(withData: true, type: FileType.image);
                      if (result != null && result.files.isNotEmpty) {
                        final f = result.files.first;
                        if (f.bytes != null) {
                          ref.read(profileAvatarFileProvider.notifier).state =
                              (data: f.bytes!, name: f.name);
                          ref
                              .read(profileAvatarDriveIdProvider.notifier)
                              .state = null;
                        }
                      }
                    },
                    child: const Text('Upload'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final selected =
                          await context.pushRoute<List<DriveFile>?>(
                        DriveFileSelectRoute(
                            account: account, allowMultiple: false),
                      );
                      if (selected != null && selected.isNotEmpty) {
                        ref.read(profileAvatarDriveIdProvider.notifier).state =
                            selected.first.id;
                        ref.read(profileAvatarFileProvider.notifier).state =
                            null;
                      }
                    },
                    child: const Text('From Drive'),
                  ),
                ],
              ),
              TextField(
                controller: useTextEditingController(
                    text: ref.read(profileDescriptionProvider)),
                maxLines: null,
                onChanged: (v) =>
                    ref.read(profileDescriptionProvider.notifier).state = v,
                decoration: const InputDecoration(labelText: 'Bio'),
              ),
              TextField(
                controller: useTextEditingController(
                    text: ref.read(profileLocationProvider)),
                onChanged: (v) =>
                    ref.read(profileLocationProvider.notifier).state = v,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(ref
                            .watch(profileBirthdayProvider)
                            ?.toLocal()
                            .toString()
                            .split(' ')[0] ??
                        ''),
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: () async {
                      final now = DateTime.now();
                      final result = await showDatePicker(
                        context: context,
                        initialDate: ref.read(profileBirthdayProvider) ?? now,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(now.year + 1),
                      );
                      if (result != null) {
                        ref.read(profileBirthdayProvider.notifier).state =
                            result;
                      }
                    },
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fields.length,
                itemBuilder: (context, index) {
                  final field = fields[index];
                  final nameController =
                      useTextEditingController(text: field.name);
                  final valueController =
                      useTextEditingController(text: field.value);
                  useEffect(() {
                    nameController.text = field.name;
                    valueController.text = field.value;
                    nameController.addListener(() {
                      final list = ref.read(profileFieldsProvider);
                      if (index >= list.length) return;
                      final newList = list.toList();
                      newList[index] = UserField(
                          name: nameController.text, value: list[index].value);
                      ref.read(profileFieldsProvider.notifier).state = newList;
                    });
                    valueController.addListener(() {
                      final list = ref.read(profileFieldsProvider);
                      if (index >= list.length) return;
                      final newList = list.toList();
                      newList[index] = UserField(
                          name: list[index].name, value: valueController.text);
                      ref.read(profileFieldsProvider.notifier).state = newList;
                    });
                    return;
                  }, [index, fields.length]);
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: valueController,
                          decoration: const InputDecoration(labelText: 'Value'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          final list = ref.read(profileFieldsProvider).toList();
                          if (list.length > index) {
                            list.removeAt(index);
                            ref.read(profileFieldsProvider.notifier).state =
                                list;
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    ref.read(profileFieldsProvider.notifier).state = [
                      ...ref.read(profileFieldsProvider),
                      const UserField(name: '', value: '')
                    ];
                  },
                  child: const Text('Add'),
                ),
              ),
              TextField(
                controller: useTextEditingController(
                    text: ref.read(profileFollowedMessageProvider)),
                maxLines: null,
                onChanged: (v) =>
                    ref.read(profileFollowedMessageProvider.notifier).state = v,
                decoration:
                    const InputDecoration(labelText: 'Followed Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
