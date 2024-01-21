import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/tab_setting.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/time_line_repository.dart';

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

  ChangeNotifierProvider<TimelineRepository> timelineProvider(
      TabSetting setting) {
    switch (this) {
      case TabType.localTimeline:
        return localTimeLineProvider(setting);
      case TabType.homeTimeline:
        return homeTimeLineProvider(setting);
      case TabType.globalTimeline:
        return globalTimeLineProvider(setting);
      case TabType.hybridTimeline:
        return hybridTimeLineProvider(setting); //FIXME
      case TabType.roleTimeline:
        return roleTimelineProvider(setting);
      case TabType.channel:
        return channelTimelineProvider(setting);
      case TabType.userList:
        return userListTimelineProvider(setting);
      case TabType.antenna:
        return antennaTimelineProvider(setting);
    }
  }
}
