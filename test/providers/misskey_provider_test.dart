import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/repository/shared_preference_controller.dart";

import "../test_util/mock.mocks.dart";
import "../test_util/test_datas.dart";

// Account の == は host と userId しか見ないので、再認証でトークンだけが
// 変わっても misskeyProvider の family は同じキーと判定される。
// keepAlive がかかっているため、古いトークンの Misskey が返り続け、
// アプリを再起動するまで直らなかった。
// https://github.com/shiosyakeyakini-info/miria/issues/776
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      overrides: [
        tabSettingsRepositoryProvider.overrideWith(
          (ref) => MockTabSettingsRepository(),
        ),
        accountSettingsRepositoryProvider.overrideWith(
          (ref) => MockAccountSettingsRepository(),
        ),
        emojiRepositoryProvider.overrideWith(
          (ref, account) => MockEmojiRepository(),
        ),
        // 保存はしない。isShareExtensionContextを立てると書き込みが素通りする
        sharedPrefenceControllerProvider.overrideWithValue(
          const SharedPreferenceController(isShareExtensionContext: true),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test("再認証でトークンが変わったら、misskeyProviderが作り直されること", () async {
    final container = buildContainer();
    final repository = container.read(accountRepositoryProvider.notifier);

    final oldAccount = TestData.account.copyWith(token: "old-token");
    final newAccount = TestData.account.copyWith(token: "new-token");
    // host と userId が同じなので family のキーとしては同一
    expect(oldAccount, newAccount);

    await repository.addAccount(oldAccount);
    expect(container.read(misskeyProvider(oldAccount)).token, "old-token");

    await repository.addAccount(newAccount);

    expect(container.read(misskeyProvider(newAccount)).token, "new-token");
  });

  test("再認証してもアカウントの並び順が変わらないこと", () async {
    final container = buildContainer();
    final repository = container.read(accountRepositoryProvider.notifier);

    final other = TestData.account.copyWith(userId: "bob", token: "bob-token");
    await repository.addAccount(TestData.account.copyWith(token: "old-token"));
    await repository.addAccount(other);

    await repository.addAccount(TestData.account.copyWith(token: "new-token"));

    expect(container.read(accountRepositoryProvider).map((e) => e.userId), [
      TestData.account.userId,
      "bob",
    ]);
  });
}
