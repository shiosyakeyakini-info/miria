import "dart:typed_data";

import "package:auto_route/auto_route.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/hooks/use_async.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/model/account.dart";
import "package:miria/model/image_file.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/note_create_page/drive_modal_sheet.dart";
import "package:miria/view/profile_edit_page/edit_profile_state_notifier.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class ProfileEditPage extends HookConsumerWidget implements AutoRouteWrapper {
  final Account account;

  const ProfileEditPage({required this.account, super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editProfileStateNotifierProvider);
    final notifier = ref.read(editProfileStateNotifierProvider.notifier);
    final s = S.of(context);

    final update = useAsync(() async {
      await notifier.submit();
      if (context.mounted) Navigator.of(context).pop();
    });

    return switch (state) {
      AsyncData(value: final data) => _ProfileEditForm(
        data: data,
        notifier: notifier,
        s: s,
        update: update,
        account: account,
      ),
      AsyncLoading() => Scaffold(
        appBar: AppBar(title: Text(s.edit)),
        body: const SafeArea(
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
      AsyncError(error: final error) => Scaffold(
        appBar: AppBar(title: Text(s.edit)),
        body: SafeArea(child: Center(child: Text(error.toString()))),
      ),
    };
  }
}

class _ProfileEditForm extends HookConsumerWidget {
  final EditProfileState data;
  final EditProfileStateNotifier notifier;
  final S s;
  final dynamic update;
  final Account account;

  const _ProfileEditForm({
    required this.data,
    required this.notifier,
    required this.s,
    required this.update,
    required this.account,
  });

  User _createTempUser(EditProfileState data, Account account) {
    Uri? avatarUrl;
    if (data.avatarFile != null) {
      // ファイルが選択されている場合は一時的な空のURLを使う
      avatarUrl = Uri.parse("temp://avatar");
    } else if (data.avatarDriveId != null &&
        data.selectedDriveFileUrl != null) {
      // ドライブから選択された場合は選択したファイルのURLを使用
      avatarUrl = data.selectedDriveFileUrl;
    } else {
      // それ以外は現在のURLを使用
      avatarUrl = data.currentAvatarUrl;
    }

    return account.i.copyWith(
      name: data.name.isNotEmpty ? data.name : account.i.name,
      avatarUrl: avatarUrl ?? account.i.avatarUrl,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(s.edit),
        actions: [
          IconButton(
            onPressed: data.isSubmitting ? null : update.executeOrNull,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              spacing: 16,
              children: [
                Row(
                  spacing: 16,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result =
                            await showModalBottomSheet<
                              DriveModalSheetReturnValue
                            >(
                              context: context,
                              builder: (context) => const DriveModalSheet(),
                            );
                        if (result == null) return;

                        if (result == DriveModalSheetReturnValue.upload) {
                          final pickedFile = await FilePicker.platform
                              .pickFiles(withData: true, type: FileType.image);
                          if (pickedFile != null &&
                              pickedFile.files.isNotEmpty) {
                            final f = pickedFile.files.first;
                            if (f.bytes != null) {
                              if (context.mounted) {
                                final editedBytes = await context
                                    .pushRoute<Uint8List>(
                                      PhotoEditRoute(
                                        accountContext: ref.read(
                                          accountContextProvider,
                                        ),
                                        file: ImageFile(
                                          data: f.bytes!,
                                          fileName: f.name,
                                        ),
                                        onSubmit: (editedData) {
                                          Navigator.of(context).pop(editedData);
                                        },
                                      ),
                                    );
                                if (editedBytes != null) {
                                  notifier.updateAvatarFile((
                                    data: editedBytes,
                                    name: f.name,
                                  ));
                                }
                              }
                            }
                          }
                        } else if (result == DriveModalSheetReturnValue.drive) {
                          final selected = await context
                              .pushRoute<List<DriveFile>?>(
                                DriveFileSelectRoute(
                                  accountContext: AccountContext.as(account),
                                  children: [DriveRoute(selectFile: true)],
                                ),
                              );
                          if (selected != null && selected.isNotEmpty) {
                            notifier.updateAvatarDriveId(
                              selected.first.id,
                              Uri.parse(selected.first.url),
                            );
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          if (data.avatarFile != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(64),
                              child: SizedBox(
                                width: 64,
                                height: 64,
                                child: Image.memory(
                                  data.avatarFile!.data,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else
                            AvatarIcon(
                              user: _createTempUser(data, account),
                              onTap: null,
                              height: 64,
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: useTextEditingController(text: data.name),
                        onChanged: notifier.updateName,
                        decoration: InputDecoration(labelText: s.profileName),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: useTextEditingController(text: data.description),
                  maxLines: null,
                  minLines: 5,
                  onChanged: notifier.updateDescription,
                  decoration: InputDecoration(labelText: s.profileBio),
                ),
                TextField(
                  controller: useTextEditingController(text: data.location),
                  onChanged: notifier.updateLocation,
                  decoration: InputDecoration(labelText: s.location),
                ),
                Row(
                  children: [
                    Text(
                      data.birthday?.toLocal().toString().split(" ")[0] ?? "",
                    ),
                    if (data.birthday != null)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          notifier.updateBirthday(null);
                        },
                      ),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Text(s.profileSetBirthday),
                      onPressed: () async {
                        final now = DateTime.now();
                        final result = await showDatePicker(
                          context: context,
                          initialDate: data.birthday ?? now,
                          firstDate: DateTime(0, 1, 1),
                          lastDate: DateTime(9999, 12, 31),
                        );
                        if (result != null) {
                          notifier.updateBirthday(result);
                        }
                      },
                    ),
                  ],
                ),
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  buildDefaultDragHandles: false,
                  itemCount: data.fields.length,
                  onReorder: notifier.reorderFields,
                  itemBuilder: (context, index) {
                    final field = data.fields[index];
                    return _FieldListItem(
                      key: ValueKey(field.id),
                      field: field,
                      index: index,
                      notifier: notifier,
                      s: s,
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(s.profileAddField),
                    onPressed: notifier.addField,
                  ),
                ),

                TextField(
                  controller: useTextEditingController(
                    text: data.followedMessage,
                  ),
                  maxLines: null,
                  onChanged: notifier.updateFollowedMessage,
                  decoration: InputDecoration(
                    labelText: s.profileFollowedMessage,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldListItem extends HookWidget {
  const _FieldListItem({
    required this.field,
    required this.index,
    required this.notifier,
    required this.s,
    super.key,
  });

  final EditUserField field;
  final int index;
  final EditProfileStateNotifier notifier;
  final S s;

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(text: field.name);
    final valueController = useTextEditingController(text: field.value);

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15, right: 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => notifier.removeField(index),
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        onChanged: (value) =>
                            notifier.updateField(index, name: value),
                        decoration: InputDecoration(
                          labelText: s.profileFieldName,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: valueController,
                        onChanged: (value) =>
                            notifier.updateField(index, value: value),
                        decoration: InputDecoration(
                          labelText: s.profileFieldValue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
