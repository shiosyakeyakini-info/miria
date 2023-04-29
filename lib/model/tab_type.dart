import 'package:flutter_misskey_app/model/tab_settings.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TabType {
  localTimeline,
  homeTimeline,
  globalTimeline,
  hybridTimeline,
  channel,
  notification;

  ChangeNotifierProvider<TimeLineRepository> timelineProvider(
      TabSettings settings) {
    switch (this) {
      case TabType.localTimeline:
        return localTimeLineProvider;
      case TabType.homeTimeline:
        return homeTimeLineProvider;
      case TabType.globalTimeline:
        return globalTimeLineProvider;
      case TabType.hybridTimeline:
        return localTimeLineProvider; //FIXME
      case TabType.channel:
        return channelTimelineProvider(settings.channelId!); //FIXME
      case TabType.notification:
        return localTimeLineProvider; //FIXME
    }
  }
}
