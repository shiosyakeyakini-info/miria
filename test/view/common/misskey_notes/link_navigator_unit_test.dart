import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/mockito.dart';

import '../../../test_util/mock.mocks.dart';
import '../../../test_util/test_datas.dart';

void main() {
  group('LinkNavigator.onMentionTap ロジックテスト', () {
    late MockMisskey mockLocalMisskey;
    late MockMisskeyUsers mockLocalUsersService;
    late MockMisskey mockRemoteMisskey;
    late MockMisskeyUsers mockRemoteUsersService;
    
    setUp(() {
      // ローカルホスト用のモック
      mockLocalMisskey = MockMisskey();
      mockLocalUsersService = MockMisskeyUsers();
      when(mockLocalMisskey.users).thenReturn(mockLocalUsersService);
      
      // リモートホスト用のモック
      mockRemoteMisskey = MockMisskey();
      mockRemoteUsersService = MockMisskeyUsers();
      when(mockRemoteMisskey.users).thenReturn(mockRemoteUsersService);
    });

    group('@aaa@example1.com 形式のメンション', () {
      test('user.hostがnullの場合でもexample1.comで検索する', () async {
        final localAccount = TestData.account.copyWith(
          host: 'myhost.com',
        );

        // API呼び出しをキャプチャ
        UsersShowByUserNameRequest? capturedRequest;
        Misskey? usedMisskey;
        
        when(mockLocalUsersService.showByName(any)).thenAnswer((invocation) async {
          capturedRequest = invocation.positionalArguments[0] as UsersShowByUserNameRequest;
          usedMisskey = mockLocalMisskey;
          return TestData.usersShowResponse1.copyWith(
            id: 'aaa_user_id',
            username: 'aaa',
            host: 'example1.com',
          );
        });

        when(mockRemoteUsersService.showByName(any)).thenAnswer((invocation) async {
          capturedRequest = invocation.positionalArguments[0] as UsersShowByUserNameRequest;
          usedMisskey = mockRemoteMisskey;
          return TestData.usersShowResponse1.copyWith(
            id: 'aaa_user_id',
            username: 'aaa',
            host: null, // example1.comのローカルユーザー
          );
        });

        final container = ProviderContainer(
          overrides: [
            accountContextProvider.overrideWithValue(AccountContext(
              getAccount: localAccount,
              postAccount: localAccount,
            )),
            misskeyProvider(localAccount).overrideWithValue(mockLocalMisskey),
            misskeyWithoutAccountProvider('example1.com').overrideWithValue(mockRemoteMisskey),
          ],
        );

        // 修正後のロジックを再現
        final regResult = RegExp(r"^@?(.+?)(@(.+?))?$").firstMatch('@aaa@example1.com');
        final accountContext = container.read(accountContextProvider);
        final contextHost = accountContext.getAccount.host;
        final noteHost = null ?? accountContext.getAccount.host; // user.hostがnull
        final regResultHost = regResult?.group(3); // 'example1.com'
        
        // 修正後のロジック
        final String targetApiHost;
        final String? searchHost;

        if (regResultHost != null) {
          // @aaa@example1.com 形式：明示的にホストが指定されている
          targetApiHost = regResultHost;
          searchHost = null; // 指定されたホストのローカルユーザーとして検索
        } else if (noteHost != contextHost) {
          // @aaa 形式かつノートが他ホストの投稿：ノートのホストで検索
          targetApiHost = noteHost;
          searchHost = null; // ノートのホストのローカルユーザーとして検索
        } else {
          // @aaa 形式かつノートが自ホストの投稿：自ホストで検索
          targetApiHost = contextHost;
          searchHost = null; // 自ホストのローカルユーザーとして検索
        }

        // 適切なAPIクライアントを選択
        final Misskey misskeyClient;
        if (targetApiHost == contextHost) {
          // 自ホストの場合は認証済みクライアントを使用
          misskeyClient = container.read(misskeyProvider(accountContext.getAccount));
        } else {
          // 他ホストの場合は認証なしクライアントを使用
          misskeyClient = container.read(misskeyWithoutAccountProvider(targetApiHost));
        }

        await misskeyClient.users.showByName(
          UsersShowByUserNameRequest(
            userName: regResult?.group(1) ?? "",
            host: searchHost,
          ),
        );

        // 期待される動作: example1.comのAPIでローカルユーザーとして検索
        expect(targetApiHost, 'example1.com');
        expect(searchHost, null);
        expect(capturedRequest?.userName, 'aaa');
        expect(capturedRequest?.host, null);
        expect(usedMisskey, mockRemoteMisskey);
      });

      test('user.hostが非nullの場合でもexample1.comで検索する', () async {
        final localAccount = TestData.account.copyWith(
          host: 'myhost.com',
        );

        // API呼び出しをキャプチャ
        UsersShowByUserNameRequest? capturedRequest;
        Misskey? usedMisskey;
        
        when(mockRemoteUsersService.showByName(any)).thenAnswer((invocation) async {
          capturedRequest = invocation.positionalArguments[0] as UsersShowByUserNameRequest;
          usedMisskey = mockRemoteMisskey;
          return TestData.usersShowResponse1.copyWith(
            id: 'aaa_user_id',
            username: 'aaa',
            host: null,
          );
        });

        final container = ProviderContainer(
          overrides: [
            accountContextProvider.overrideWithValue(AccountContext(
              getAccount: localAccount,
              postAccount: localAccount,
            )),
            misskeyProvider(localAccount).overrideWithValue(mockLocalMisskey),
            misskeyWithoutAccountProvider('example1.com').overrideWithValue(mockRemoteMisskey),
          ],
        );

        // 修正後のロジック
        final regResult = RegExp(r"^@?(.+?)(@(.+?))?$").firstMatch('@aaa@example1.com');
        final accountContext = container.read(accountContextProvider);
        final contextHost = accountContext.getAccount.host;
        final noteHost = 'remote.host.com' ?? accountContext.getAccount.host; // user.hostが非null
        final regResultHost = regResult?.group(3); // 'example1.com'
        
        final String targetApiHost;
        final String? searchHost;

        if (regResultHost != null) {
          targetApiHost = regResultHost;
          searchHost = null;
        } else if (noteHost != contextHost) {
          targetApiHost = noteHost;
          searchHost = null;
        } else {
          targetApiHost = contextHost;
          searchHost = null;
        }

        final misskeyClient = container.read(misskeyWithoutAccountProvider(targetApiHost));

        await misskeyClient.users.showByName(
          UsersShowByUserNameRequest(
            userName: regResult?.group(1) ?? "",
            host: searchHost,
          ),
        );

        // user.hostに関係なく、example1.comで検索
        expect(targetApiHost, 'example1.com');
        expect(searchHost, null);
        expect(capturedRequest?.userName, 'aaa');
        expect(capturedRequest?.host, null);
        expect(usedMisskey, mockRemoteMisskey);
      });
    });

    group('@aaa 形式のメンション', () {
      test('user.hostが入っていればそのホストで検索する', () async {
        final localAccount = TestData.account.copyWith(
          host: 'myhost.com',
        );

        UsersShowByUserNameRequest? capturedRequest;
        Misskey? usedMisskey;
        
        when(mockRemoteUsersService.showByName(any)).thenAnswer((invocation) async {
          capturedRequest = invocation.positionalArguments[0] as UsersShowByUserNameRequest;
          usedMisskey = mockRemoteMisskey;
          return TestData.usersShowResponse1.copyWith(
            id: 'aaa_user_id',
            username: 'aaa',
            host: null,
          );
        });

        final container = ProviderContainer(
          overrides: [
            accountContextProvider.overrideWithValue(AccountContext(
              getAccount: localAccount,
              postAccount: localAccount,
            )),
            misskeyProvider(localAccount).overrideWithValue(mockLocalMisskey),
            misskeyWithoutAccountProvider('note.host.com').overrideWithValue(mockRemoteMisskey),
          ],
        );

        final regResult = RegExp(r"^@?(.+?)(@(.+?))?$").firstMatch('@aaa');
        final accountContext = container.read(accountContextProvider);
        final contextHost = accountContext.getAccount.host;
        final noteHost = 'note.host.com'; // user.hostが入っている
        final regResultHost = regResult?.group(3); // null
        
        final String targetApiHost;
        final String? searchHost;

        if (regResultHost != null) {
          targetApiHost = regResultHost;
          searchHost = null;
        } else if (noteHost != contextHost) {
          targetApiHost = noteHost; // note.host.com
          searchHost = null;
        } else {
          targetApiHost = contextHost;
          searchHost = null;
        }

        final misskeyClient = container.read(misskeyWithoutAccountProvider(targetApiHost));

        await misskeyClient.users.showByName(
          UsersShowByUserNameRequest(
            userName: regResult?.group(1) ?? "",
            host: searchHost,
          ),
        );

        // note.host.comで検索
        expect(targetApiHost, 'note.host.com');
        expect(searchHost, null);
        expect(capturedRequest?.userName, 'aaa');
        expect(capturedRequest?.host, null);
        expect(usedMisskey, mockRemoteMisskey);
      });

      test('user.hostが入っていなければ自ホストで検索する', () async {
        final localAccount = TestData.account.copyWith(
          host: 'myhost.com',
        );

        UsersShowByUserNameRequest? capturedRequest;
        Misskey? usedMisskey;
        
        when(mockLocalUsersService.showByName(any)).thenAnswer((invocation) async {
          capturedRequest = invocation.positionalArguments[0] as UsersShowByUserNameRequest;
          usedMisskey = mockLocalMisskey;
          return TestData.usersShowResponse1.copyWith(
            id: 'aaa_user_id',
            username: 'aaa',
            host: null,
          );
        });

        final container = ProviderContainer(
          overrides: [
            accountContextProvider.overrideWithValue(AccountContext(
              getAccount: localAccount,
              postAccount: localAccount,
            )),
            misskeyProvider(localAccount).overrideWithValue(mockLocalMisskey),
          ],
        );

        final regResult = RegExp(r"^@?(.+?)(@(.+?))?$").firstMatch('@aaa');
        final accountContext = container.read(accountContextProvider);
        final contextHost = accountContext.getAccount.host;
        final noteHost = null ?? accountContext.getAccount.host; // user.hostが入っていない
        final regResultHost = regResult?.group(3); // null
        
        final String targetApiHost;
        final String? searchHost;

        if (regResultHost != null) {
          targetApiHost = regResultHost;
          searchHost = null;
        } else if (noteHost != contextHost) {
          targetApiHost = noteHost;
          searchHost = null;
        } else {
          targetApiHost = contextHost; // myhost.com
          searchHost = null;
        }

        final misskeyClient = container.read(misskeyProvider(accountContext.getAccount));

        await misskeyClient.users.showByName(
          UsersShowByUserNameRequest(
            userName: regResult?.group(1) ?? "",
            host: searchHost,
          ),
        );

        // 自ホストで検索
        expect(targetApiHost, 'myhost.com');
        expect(searchHost, null);
        expect(capturedRequest?.userName, 'aaa');
        expect(capturedRequest?.host, null);
        expect(usedMisskey, mockLocalMisskey);
      });
    });
  });
}