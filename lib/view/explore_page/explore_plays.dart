import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/futable_list_builder.dart';
import 'package:miria/view/common/misskey_notes/mfm_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ExplorePlay extends ConsumerStatefulWidget {
  const ExplorePlay({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ExplorePagesState();
}

class ExplorePagesState extends ConsumerState<ExplorePlay> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: FutureListView(future: () async {
        final result = await ref
            .read(misskeyProvider(AccountScope.of(context)))
            .flash
            .featured();
        return result.toList();
      }(), builder: (context, item) {
        return ListTile(
          onTap: () async {
            await launchUrl(Uri(
                scheme: "https",
                host: AccountScope.of(context).host,
                pathSegments: ["play", item.id]));
          },
          title: MfmText(mfmText: item.title),
          subtitle: MfmText(mfmText: item.summary),
        );
      }),
    );
  }
}
