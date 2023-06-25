import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/image_file.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';

class CreateFileView extends ConsumerWidget {
  final MisskeyPostFile file;

  const CreateFileView({super.key, required this.file});

  Future<void> onTap(BuildContext context, WidgetRef ref) async {
    final account = AccountScope.of(context);
    context.pushRoute<Uint8List?>(PhotoEditRoute(
        account: AccountScope.of(context),
        file: file,
        onSubmit: (result) {
          ref
              .read(noteCreateProvider(account).notifier)
              .setFileContent(file, result);
        }));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = file;

    switch (data) {
      case ImageFile():
        return SizedBox(
          height: 200,
          child: GestureDetector(
              onTap: () async => await onTap(context, ref),
              child: Image.memory(data.data)),
        );
      case ImageFileAlreadyPostedFile():
        return SizedBox(
          height: 200,
          child: GestureDetector(
              onTap: () async => await onTap(context, ref),
              child: Image.memory(data.data)),
        );
      case UnknownFile():
        return Text(data.fileName);
      case UnknownAlreadyPostedFile():
        return Text(data.fileName);
    }
  }
}
