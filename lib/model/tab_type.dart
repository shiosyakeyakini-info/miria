import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TabType {
  localTimeline,
  homeTimeline,
  globalTimeline,
  hybridTimeline,
  roleTimeline,
  channel,
  userList,
  antenna,
  ;

  String displayName(BuildContext context) {
    return switch (this) {
      TabType.localTimeline => S.of(context).localTimeline,
      TabType.homeTimeline => S.of(context).homeTimeline,
      TabType.globalTimeline => S.of(context).globalTimeline,
      TabType.hybridTimeline => S.of(context).socialTimeline,
      TabType.roleTimeline => S.of(context).roleTimeline,
      TabType.channel => S.of(context).channel,
      TabType.userList => S.of(context).list,
      TabType.antenna => S.of(context).antenna,
    };
  }
}
