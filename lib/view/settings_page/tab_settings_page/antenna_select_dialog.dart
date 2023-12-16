import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:misskey_dart/misskey_dart.dart';

class AntennaSelectDialog extends ConsumerStatefulWidget {
  final Account account;

  const AntennaSelectDialog({super.key, required this.account});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      AntennaSelectDialogState();
}

class AntennaSelectDialogState extends ConsumerState<AntennaSelectDialog> {
  final antennas = <Antenna>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      final myAntennas =
          await ref.read(misskeyProvider(widget.account)).antennas.list();
      antennas
        ..clear()
        ..addAll(myAntennas);
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AccountScope(
      account: widget.account,
      child: AlertDialog(
        title: Text(S.of(context).selectAntenna),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).antenna,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: antennas.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            Navigator.of(context).pop(antennas[index]);
                          },
                          title: Text(antennas[index].name));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
