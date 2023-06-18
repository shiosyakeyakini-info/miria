import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:misskey_dart/misskey_dart.dart';

class FederationCustomEmojis extends ConsumerStatefulWidget {
  final String host;

  const FederationCustomEmojis({super.key, required this.host});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FederationCustomEmojisState();
}

class FederationCustomEmojisState
    extends ConsumerState<FederationCustomEmojis> {
  var isLoading = false;
  Object? error;

  Map<String, List<Emoji>> emojis = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future(() async {
      final result = await ref
          .read(misskeyProvider(Account.demoAccount(widget.host)))
          .emojis();
      emojis
        ..clear()
        ..addAll(result.emojis.groupListsBy((e) => e.category ?? ""));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return ErrorDetail(error: error);
    return ListView.builder(
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        final entry = emojis.entries.toList()[index];
        return ExpansionTile(
          title: Text(entry.key),
          children: [
            for (final element in entry.value)
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            CustomEmoji(
                              emojiData: CustomEmojiData(
                                  baseName: element.name,
                                  hostedName: widget.host,
                                  url: element.url,
                                  isCurrentServer: false,
                                  isSensitive: element.isSensitive),
                              fontSizeRatio: 2,
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              ":${element.name}:",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Text(element.aliases.join(" ")),
                      ],
                    ),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
