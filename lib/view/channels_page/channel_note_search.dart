import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/view/search_page/note_search.dart";

class ChannelNoteSearch extends HookConsumerWidget {
  final String channelId;
  const ChannelNoteSearch({required this.channelId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState("");

    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 5)),
        TextField(
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
          textInputAction: TextInputAction.done,
          onSubmitted: (value) => searchQuery.value = value,
        ),
        Expanded(
          child: NoteSearchList(
            query: searchQuery.value,
            channelId: channelId,
            localOnly: false,
          ),
        ),
      ],
    );
  }
}
