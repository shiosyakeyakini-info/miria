import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:miria/model/account.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/federation_page/federation_announcements.dart';

@RoutePage()
class AnnouncementPage extends StatelessWidget {
  final Account account;

  const AnnouncementPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("お知らせ")),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: AccountScope(
          account: account,
          child: FederationAnnouncements(host: account.host),
        ),
      ),
    );
  }
}
