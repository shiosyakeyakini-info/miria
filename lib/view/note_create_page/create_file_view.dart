import 'package:flutter/material.dart';
import 'package:miria/model/image_file.dart';

class CreateFileView extends StatelessWidget {
  final MisskeyPostFile file;

  const CreateFileView({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final data = file;

    switch (data) {
      case ImageFile():
        return SizedBox(
          height: 200,
          child: Image.memory(data.data),
        );
      case ImageFileAlreadyPostedFile():
        return SizedBox(
          height: 200,
          child: Image.memory(data.data),
        );
      case UnknownFile():
        return Text(data.fileName);
      case UnknownAlreadyPostedFile():
        return Text(data.fileName);
    }
  }
}
