import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:receive_sharing_intent/receive_sharing_intent.dart";

class SharingIntentListener extends ConsumerStatefulWidget {
  final AppRouter router;
  final Widget child;

  const SharingIntentListener({
    required this.router,
    required this.child,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      SharingIntentListenerState();
}

class SharingIntentListenerState extends ConsumerState<SharingIntentListener> {
  late final StreamSubscription<List<SharedMediaFile>>
  intentDataStreamSubscription;
  late Iterable<Account> account = [];

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      intentDataStreamSubscription = ReceiveSharingIntent.instance
          .getMediaStream()
          .listen((event) {
            final mediaFiles = <String>[];
            String? textContent;

            for (final file in event) {
              if (file.type == SharedMediaType.text) {
                textContent = file.path;
              } else {
                mediaFiles.add(file.path);
              }
            }

            if (account.length == 1) {
              widget.router.push(
                NoteCreateRoute(
                  initialMediaFiles: mediaFiles.isNotEmpty ? mediaFiles : null,
                  initialText: textContent,
                  initialAccount: account.first,
                ),
              );
            } else {
              widget.router.push(
                SharingAccountSelectRoute(
                  filePath: mediaFiles.isNotEmpty ? mediaFiles : null,
                  sharingText: textContent,
                ),
              );
            }
          });
    }
  }

  @override
  void dispose() {
    intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    account = ref.watch(accountsProvider);
    return widget.child;
  }
}
