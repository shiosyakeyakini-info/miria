import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';

@RoutePage()
class ShareExtensionPage extends ConsumerWidget {
  const ShareExtensionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Extension Page Test"),
      ),
      body: FutureBuilder(
        future: Future(() async {
          await SharedPreferenceAppGroup.setAppGroup(
              "group.info.shiosyakeyakini.miria");
          return await SharedPreferenceAppGroup.get("account_settings")
              as String?;
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.requireData ?? "no data");
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}\n${snapshot.stackTrace}");
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
