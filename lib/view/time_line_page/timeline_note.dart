import 'package:flutter/material.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timelineNoteProvider =
    ChangeNotifierProvider.autoDispose((ref) => TextEditingController());

final timelineFocusNode =
    ChangeNotifierProvider.autoDispose((ref) => FocusNode());

class TimelineNoteField extends ConsumerStatefulWidget {
  const TimelineNoteField({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      TimelineNoteFieldState();
}

class TimelineNoteFieldState extends ConsumerState<TimelineNoteField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final noteStyle = AppTheme.of(context).noteTextStyle;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextField(
        focusNode: ref.watch(timelineFocusNode),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: ref.watch(timelineNoteProvider),
        decoration: noteStyle,
      ),
    );
  }
}
