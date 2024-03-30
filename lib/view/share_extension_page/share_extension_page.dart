import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:shared_preference_app_group/shared_preference_app_group.dart';

part 'share_extension_page.freezed.dart';
part 'share_extension_page.g.dart';

@freezed
class ShareExtensionData with _$ShareExtensionData {
  factory ShareExtensionData({
    required List<String> text,
    required List<SharedFiles> files,
  }) = _ShareExtensionData;

  factory ShareExtensionData.fromJson(Map<String, dynamic> json) =>
      _$ShareExtensionDataFromJson(json);
}

@freezed
class SharedFiles with _$SharedFiles {
  factory SharedFiles({
    required String path,
    required int type,
  }) = _SharedFiles;

  factory SharedFiles.fromJson(Map<String, dynamic> json) =>
      _$SharedFilesFromJson(json);
}

@RoutePage()
class ShareExtensionPage extends ConsumerStatefulWidget {
  const ShareExtensionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ShareExtensionPageState();
}

final isShareExtensionProvider = StateProvider(
  (ref) => false,
);

class ShareExtensionPageState extends ConsumerState<ShareExtensionPage> {
  var sharedPreference = "";
  String? error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      ref.read(isShareExtensionProvider.notifier).state = true;
      try {
        await ref.read(accountRepositoryProvider.notifier).load();
        final json = jsonDecode(
            await SharedPreferenceAppGroup.get("ShareKey") as String? ?? "");
        await SharedPreferenceAppGroup.setString("ShareKey", "");
        final sharedData =
            ShareExtensionData.fromJson(json as Map<String, dynamic>);

        if (ref.read(accountsProvider).length >= 2) {
          if (!mounted) return;
          context.replaceRoute(SharingAccountSelectRoute(
              sharingText: sharedData.text.join("\n"),
              filePath: sharedData.files.map((e) => e.path).toList()));
        } else {
          if (!mounted) return;
          context.replaceRoute(
            NoteCreateRoute(
              initialAccount: ref.read(accountsProvider)[0],
              initialText: sharedData.text.join("\n"),
              initialMediaFiles: sharedData.files.map((e) => e.path).toList(),
              exitOnNoted: true,
            ),
          );
        }
      } catch (e, s) {
        setState(() {
          error = "$e\n$s";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: error != null
          ? Text(error.toString())
          : const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
