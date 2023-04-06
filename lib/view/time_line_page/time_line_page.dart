import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_misskey_app/repository/time_line_repository.dart';
import 'package:flutter_misskey_app/view/time_line_page/misskey_time_line.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misskey_dart/misskey_dart.dart';

class TimeLinePage extends ConsumerStatefulWidget {
  const TimeLinePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TimeLinePageState();

}

class TimeLinePageState extends ConsumerState<TimeLinePage> {

  ChangeNotifierProvider<TimeLineRepository> timelineProvider = localTimeLineProvider;
  String type = "";

  final textEditingController = TextEditingController();
  
  void note() {
    ref.read(misskeyProvider).notes.create(NotesCreateRequest(
          text: textEditingController.value.text,
        ));
    textEditingController.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    ref.read(emojiRepositoryProvider).loadFromSource();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(children: [
        IconButton(onPressed: () {
          setState(() {
            timelineProvider = homeTimeLineProvider;
            type = "hometimeline";
          });

        }, icon: const Icon(Icons.house)),
        IconButton(onPressed: () {
          setState(() {
            timelineProvider = localTimeLineProvider;
            type = "localtimeline";
          });
        }, icon: const Icon(Icons.public)),
        IconButton(onPressed: () {
          setState(() {
            timelineProvider = globalTimeLineProvider;
            type = "globaltimeline";
          });
        }, icon: const Icon(Icons.rocket)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.hub)),
      ])),
      body: MisskeyTimeline(type: type, timeLineRepositoryProvider: timelineProvider),
      bottomNavigationBar: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextField(
              controller: textEditingController,
            ),
          )),
          IconButton(onPressed: note, icon: const Icon(Icons.edit)),
        ],
      ),
    );  
  }

}