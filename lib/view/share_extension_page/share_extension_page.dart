import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';

@RoutePage()
class ShareExtensionPage extends ConsumerStatefulWidget {
  const ShareExtensionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ShareExtensionPageState();
}

class ShareExtensionPageState extends ConsumerState<ShareExtensionPage> {
  var sharedPreference = "";
  var sharedData = "";
  String? error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      try {
        await SharedPreferenceAppGroup.setAppGroup(
            "group.info.shiosyakeyakini.miria");
        sharedPreference =
            await SharedPreferenceAppGroup.get("account_settings") as String? ??
                "";
        sharedData =
            await SharedPreferenceAppGroup.get("ShareKey") as String? ?? "";
        await SharedPreferenceAppGroup.setString("ShareKey", "");
        setState(() {});
      } catch (e) {
        setState(() {
          error = e.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Extension Page Test"),
      ),
      body: Text(error ??
          "SharedPreference: $sharedPreference\n共有されたデータ: $sharedData"),
    );
  }
}
