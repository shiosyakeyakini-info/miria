import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/error_detail.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FederationCustomEmojis extends ConsumerStatefulWidget {
  final String host;
  final MetaResponse meta;

  const FederationCustomEmojis({
    super.key,
    required this.host,
    required this.meta,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FederationCustomEmojisState();
}

class FederationCustomEmojisState
    extends ConsumerState<FederationCustomEmojis> {
  var isLoading = false;
  (Object?, StackTrace)? error;

  Map<String, List<Emoji>> emojis = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future(() async {
      final result = await ref
          .read(misskeyProvider(Account.demoAccount(widget.host, widget.meta)))
          .emojis();
      emojis
        ..clear()
        ..addAll(result.emojis.groupListsBy((e) => e.category ?? ""));
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) {
      return ErrorDetail(
        error: error?.$1,
        stackTrace: error?.$2,
      );
    }
    return ListView.builder(
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        final entry = emojis.entries.toList()[index];
        return ExpansionTile(
          title: Text(entry.key),
          childrenPadding: EdgeInsets.zero,
          children: [
            for (final element in entry.value)
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(children: [
                            WidgetSpan(
                                child: CustomEmoji(
                                  emojiData: CustomEmojiData(
                                      baseName: element.name,
                                      hostedName: widget.host,
                                      url: element.url,
                                      isCurrentServer: false,
                                      isSensitive: element.isSensitive),
                                  fontSizeRatio: 2,
                                ),
                                alignment: PlaceholderAlignment.middle),
                            const WidgetSpan(
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10))),
                            TextSpan(
                              text: ":${element.name}:",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (element.isSensitive)
                              WidgetSpan(
                                  child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, right: 3),
                                  child: Text(
                                    S.of(context).sensitive,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              )),
                          ])),
                          if (element.aliases.isNotEmpty) ...[
                            const Padding(padding: EdgeInsets.only(top: 10)),
                            Text(
                              element.aliases.join(" "),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ]
                        ],
                      ),
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
