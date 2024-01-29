import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/futurable.dart';
import 'package:misskey_dart/misskey_dart.dart';

@RoutePage()
class InstanceMutePage extends ConsumerStatefulWidget {
  final Account account;

  const InstanceMutePage({super.key, required this.account});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      InstanceMutePageState();
}

class InstanceMutePageState extends ConsumerState<InstanceMutePage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future<void> save() async {
    final text = controller.text;

    final List<String> mutedInstances =
        text.split("\n").whereNot((element) => element.trim().isEmpty).toList();

    await ref
        .read(misskeyProvider(widget.account))
        .i
        .update(IUpdateRequest(mutedInstances: mutedInstances));
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).instanceMute)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CommonFuture<MeDetailed>(
            future: ref.read(misskeyProvider(widget.account)).i.i(),
            futureFinished: (data) {
              controller.text = data.mutedInstances.join("\n");
            },
            complete: (context, data) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(S.of(context).instanceMuteDescription1),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  TextField(
                    maxLines: null,
                    minLines: 5,
                    controller: controller,
                    autofocus: true,
                    textCapitalization: TextCapitalization.none,
                  ),
                  Text(
                    S.of(context).instanceMuteDescription2,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  ElevatedButton.icon(
                    onPressed: save,
                    icon: const Icon(Icons.save),
                    label: Text(S.of(context).save),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
