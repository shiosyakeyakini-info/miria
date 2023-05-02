import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misskey_app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ClipListPage extends ConsumerStatefulWidget {
  const ClipListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ClipListPageState();
}

class ClipListPageState extends ConsumerState<ClipListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("クリップ一覧"),
        ),
        body: FutureBuilder(
            future: ref.read(misskeyProvider).clips.list(),
            builder: (context, snapshot) {
              final list = snapshot.data?.toList();

              if (list != null) {
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final element = list[index];
                      return ListTile(
                        title: Text(element.name ?? ""),
                        subtitle: Text(element.description ?? ""),
                      );
                    });
              }

              if (snapshot.hasError) {
                print(snapshot.error);
                print(snapshot.stackTrace);
                return const Center(child: Text("えらー"));
              }

              return const Center(child: CircularProgressIndicator());
            }));
  }
}
