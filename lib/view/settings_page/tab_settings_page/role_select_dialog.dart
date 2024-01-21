import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:misskey_dart/misskey_dart.dart';

class RoleSelectDialog extends ConsumerStatefulWidget {
  final Account account;

  const RoleSelectDialog({super.key, required this.account});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      RoleSelectDialogState();
}

class RoleSelectDialogState extends ConsumerState<RoleSelectDialog> {
  final roles = <RolesListResponse>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() async {
      final rolesList =
          await ref.read(misskeyProvider(widget.account)).roles.list();
      roles
        ..clear()
        ..addAll(rolesList);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AccountScope(
      account: widget.account,
      child: AlertDialog(
        title: Text(S.of(context).selectRole),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).role,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: roles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            Navigator.of(context).pop(roles[index]);
                          },
                          title: Text(roles[index].name));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
