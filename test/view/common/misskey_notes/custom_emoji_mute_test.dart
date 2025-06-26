import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/account_settings.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/repository/account_settings_repository.dart';

import '../../../test_util/default_root_widget.dart';
import '../../../test_util/test_datas.dart';

class FakeAccountSettingsRepository extends AccountSettingsRepository {
  FakeAccountSettingsRepository(this.settings);

  AccountSettings settings;

  @override
  AccountSettings fromAccount(Account account) => settings;

  @override
  Future<void> save(AccountSettings settings) async {
    this.settings = settings;
  }

  @override
  Future<void> load() async {}
}

Widget buildTestWidget({required MisskeyEmojiData emoji, required List<String> muted}) {
  final repoSettings = AccountSettings(
    userId: TestData.account.userId,
    host: TestData.account.host,
    mutedReactions: muted,
  );
  return ProviderScope(
    overrides: [
      accountSettingsRepositoryProvider.overrideWith(
        (ref) => FakeAccountSettingsRepository(repoSettings),
      ),
    ],
    child: DefaultRootNoRouterWidget(
      child: AccountContextScope.as(
        account: TestData.account,
        child: CustomEmoji(emojiData: emoji),
      ),
    ),
  );
}

void main() {
  final localEmoji = CustomEmojiData(
    baseName: 'yay',
    hostedName: ':yay@.:',
    url: Uri.parse('https://example.com/yay.png'),
    isCurrentServer: true,
    isSensitive: false,
  );
  final remoteEmoji = CustomEmojiData(
    baseName: 'igyo',
    hostedName: ':igyo@remote.host:',
    url: Uri.parse('https://remote.host/igyo.png'),
    isCurrentServer: false,
    isSensitive: false,
  );

  testWidgets('not muted emoji appears normally', (tester) async {
    await tester.pumpWidget(buildTestWidget(emoji: localEmoji, muted: []));
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsNothing);
  });

  testWidgets('muted same host emoji shows error', (tester) async {
    await tester.pumpWidget(buildTestWidget(emoji: localEmoji, muted: [':yay:']));
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('muted different host emoji shows error', (tester) async {
    await tester.pumpWidget(buildTestWidget(emoji: remoteEmoji, muted: [':igyo@remote.host:']));
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('host wide mute shows error', (tester) async {
    await tester.pumpWidget(buildTestWidget(emoji: remoteEmoji, muted: ['@remote.host']));
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsOneWidget);
  });
}
