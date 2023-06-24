import 'package:flutter/material.dart';

enum DriveModalSheetReturnValue { upload, drive }

class DriveModalSheet extends StatelessWidget {
  const DriveModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text("アップロード"),
          leading: const Icon(Icons.upload),
          onTap: () {
            Navigator.of(context).pop(DriveModalSheetReturnValue.upload);
          },
        ),
        ListTile(
          title: const Text("ドライブから"),
          leading: const Icon(Icons.cloud_outlined),
          onTap: () {
            Navigator.of(context).pop(DriveModalSheetReturnValue.drive);
          },
        ),
      ],
    );
  }
}
