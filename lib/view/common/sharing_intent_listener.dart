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
      intentDataStreamSubscription =
          ReceiveSharingIntent.instance.getMediaStream().listen((event) {
        final items = event
            .where(
              (e) =>
                  e.type == SharedMediaType.image ||
                  e.type == SharedMediaType.video ||
                  e.type == SharedMediaType.file,
            )
            .map((e) => e.path)
            .toList();

        final text = event
            .where(
              (e) =>
                  e.type == SharedMediaType.text ||
                  e.type == SharedMediaType.url,
            )
            .map((e) => e.path)
            .join("\n");

        if (account.length == 1) {
          unawaited(
            widget.router.push(
              NoteCreateRoute(
                initialMediaFiles: items,
                initialAccount: account.first,
                initialText: text,
              ),
            ),
          );
        } else {
          unawaited(
            widget.router.push(
              SharingAccountSelectRoute(
                filePath: items,
                sharingText: text,
              ),
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
