import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:miria/router/app_router.dart';

class SharingIntentListener extends ConsumerStatefulWidget {
  final AppRouter router;
  final Widget child;

  const SharingIntentListener({
    super.key,
    required this.router,
    required this.child,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      SharingIntentListenerState();
}

class SharingIntentListenerState extends ConsumerState<SharingIntentListener> {
  late final StreamSubscription<List<SharedMediaFile>>
      intentDataStreamSubscription;
  late final StreamSubscription<String> intentDataTextStreamSubscription;
  late Iterable<Account> account = [];

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      intentDataStreamSubscription =
          ReceiveSharingIntent.getMediaStream().listen((event) {
        final items = event.map((e) => e.path).toList();
        if (account.length == 1) {
          widget.router.push(NoteCreateRoute(
            initialMediaFiles: items,
            initialAccount: account.first,
          ));
        } else {
          widget.router.push(SharingAccountSelectRoute(
            filePath: items,
          ));
        }
      });
      intentDataTextStreamSubscription =
          ReceiveSharingIntent.getTextStream().listen((event) {
        if (account.length == 1) {
          widget.router.push(NoteCreateRoute(
            initialText: event,
            initialAccount: account.first,
          ));
        } else {
          widget.router.push(SharingAccountSelectRoute(
            sharingText: event,
          ));
        }
      });
    }
  }

  @override
  void dispose() {
    intentDataStreamSubscription.cancel();
    intentDataTextStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    account = ref.watch(accountsProvider);
    return widget.child;
  }
}
