import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotes extends ConsumerStatefulWidget {
  final String userId;

  const UserNotes({super.key, required this.userId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => UserNotesState();
}

class UserNotesState extends ConsumerState<UserNotes> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [],
    );
  }
}
