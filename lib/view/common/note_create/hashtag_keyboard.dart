import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/text_editing_controller_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/input_completion_type.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/note_create/basic_keyboard.dart';
import 'package:miria/view/common/note_create/custom_keyboard_button.dart';
import 'package:miria/view/common/note_create/input_completation.dart';
import 'package:misskey_dart/misskey_dart.dart' hide Hashtag;

final _hashtagsSearchProvider = AsyncNotifierProviderFamily<_HashtagsSearch,
    List<String>, (String, String)>(_HashtagsSearch.new);

class _HashtagsSearch
    extends FamilyAsyncNotifier<List<String>, (String, String)> {
  @override
  Future<List<String>> build((String, String) arg) async {
    final (host, query) = arg;
    if (query.isEmpty) {
      return [];
    } else {
      final response = await ref
          .read(misskeyProvider(Account.demoAccount(host)))
          .hashtags
          .search(
            HashtagsSearchRequest(
              query: query,
              limit: 30,
            ),
          );
      return response.toList();
    }
  }
}

final _filteredHashtagsProvider = NotifierProvider.autoDispose
    .family<_FilteredHashtags, List<String>, Account>(_FilteredHashtags.new);

class _FilteredHashtags
    extends AutoDisposeFamilyNotifier<List<String>, Account> {
  @override
  List<String> build(Account arg) {
    ref.listen(
      inputCompletionTypeProvider,
      (_, type) {
        _updateHashtags(type);
      },
      fireImmediately: true,
    );
    return [];
  }

  void _updateHashtags(InputCompletionType type) async {
    if (type is Hashtag) {
      final query = type.query;
      if (query.isEmpty) {
        final response = await ref.read(misskeyProvider(arg)).hashtags.trend();
        state = response.map((hashtag) => hashtag.tag).toList();
      } else {
        state = await ref.read(
          _hashtagsSearchProvider((arg.host, query)).future,
        );
      }
    }
  }
}

class HashtagKeyboard extends ConsumerWidget {
  const HashtagKeyboard({
    super.key,
    required this.account,
    required this.controller,
    required this.focusNode,
  });

  final Account account;
  final TextEditingController controller;
  final FocusNode focusNode;

  void insertHashtag(String hashtag) {
    final textBeforeSelection = controller.textBeforeSelection;
    final lastHashIndex = textBeforeSelection!.lastIndexOf("#");
    final queryLength = textBeforeSelection.length - lastHashIndex - 1;
    controller.insert("${hashtag.substring(queryLength)} ");
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredHashtags = ref.watch(_filteredHashtagsProvider(account));

    if (filteredHashtags.isEmpty) {
      return BasicKeyboard(
        controller: controller,
        focusNode: focusNode,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final hashtag in filteredHashtags)
          CustomKeyboardButton(
            keyboard: hashtag,
            controller: controller,
            focusNode: focusNode,
            onTap: () => insertHashtag(hashtag),
          ),
      ],
    );
  }
}
