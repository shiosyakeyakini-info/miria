import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:misskey_dart/misskey_dart.dart';

class ChannelSelectDialog extends ConsumerStatefulWidget {
  final Account account;

  const ChannelSelectDialog({super.key, required this.account});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ChannelSelectDialogState();
}

class ChannelSelectDialogState extends ConsumerState<ChannelSelectDialog> {
  final favoritedChannels = <CommunityChannel>[];
  final followedChannels = <CommunityChannel>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      final myFavorites = await ref
          .read(misskeyProvider(widget.account))
          .channels
          .myFavorite(const ChannelsMyFavoriteRequest(limit: 100));
      favoritedChannels
        ..clear()
        ..addAll(myFavorites);

      final followed = await ref
          .read(misskeyProvider(widget.account))
          .channels
          .followed(const ChannelsFollowedRequest(limit: 100));
      followedChannels
        ..clear()
        ..addAll(followed);
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AccountScope(
      account: widget.account,
      child: AlertDialog(
        title: Text(S.of(context).selectChannel),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).following,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: followedChannels.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            Navigator.of(context).pop(followedChannels[index]);
                          },
                          title: Text(followedChannels[index].name));
                    }),
                const Padding(padding: EdgeInsets.only(top: 30)),
                Text(
                  S.of(context).favorite,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favoritedChannels.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            Navigator.of(context).pop(favoritedChannels[index]);
                          },
                          title: Text(favoritedChannels[index].name));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
