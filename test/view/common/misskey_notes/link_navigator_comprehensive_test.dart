import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/misskey_notes/link_navigator.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/mockito.dart';

import '../../../test_util/mock.mocks.dart';
import '../../../test_util/test_datas.dart';

void main() {
  group('LinkNavigator.onMentionTap 包括的テスト', () {
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
      testWidgets('user.hostがnullの場合でもexample1.comで検索する', (tester) async {
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

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              accountContextProvider.overrideWithValue(AccountContext(
                getAccount: localAccount,
                postAccount: localAccount,
              )),
              misskeyProvider(localAccount).overrideWithValue(mockLocalMisskey),
              misskeyWithoutAccountProvider('example1.com').overrideWithValue(mockRemoteMisskey),
            ],
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      await const LinkNavigator().onMentionTap(
                        context,
                        ref,
                        '@aaa@example1.com',
                        null, // user.hostがnull（自分のインスタンスのノート）
                      );
                    },
                    child: const Text('Test'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // 期待される動作: example1.comで検索
        expect(capturedRequest?.userName, 'aaa');
        expect(capturedRequest?.host, null); // example1.comのローカルユーザーとして検索
        expect(usedMisskey, mockRemoteMisskey); // example1.comのAPIを使用
      });

      testWidgets('user.hostが非nullの場合でもexample1.comで検索する', (tester) async {
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

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              accountContextProvider.overrideWithValue(AccountContext(
                getAccount: localAccount,
                postAccount: localAccount,
              )),
              misskeyProvider(localAccount).overrideWithValue(mockLocalMisskey),
              misskeyWithoutAccountProvider('example1.com').overrideWithValue(mockRemoteMisskey),
            ],
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      await const LinkNavigator().onMentionTap(
                        context,
                        ref,
                        '@aaa@example1.com',
                        'remote.host.com', // user.hostが非null（リモートインスタンスのノート）
                      );
                    },
                    child: const Text('Test'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // 期待される動作: example1.comで検索（user.hostに関係なく）
        expect(capturedRequest?.userName, 'aaa');
        expect(capturedRequest?.host, null); // example1.comのローカルユーザーとして検索
        expect(usedMisskey, mockRemoteMisskey); // example1.comのAPIを使用
      });
    });

    group('@aaa 形式のメンション', () {
      testWidgets('user.hostが入っていればそのホストで検索する', (tester) async {
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
            host: 'note.host.com',
          );
        });

        when(mockRemoteUsersService.showByName(any)).thenAnswer((invocation) async {
          capturedRequest = invocation.positionalArguments[0] as UsersShowByUserNameRequest;
          usedMisskey = mockRemoteMisskey;
          return TestData.usersShowResponse1.copyWith(
            id: 'aaa_user_id',
            username: 'aaa',
            host: null, // note.host.comのローカルユーザー
          );
        });

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              accountContextProvider.overrideWithValue(AccountContext(
                getAccount: localAccount,
                postAccount: localAccount,
              )),
              misskeyProvider(localAccount).overrideWithValue(mockLocalMisskey),
              misskeyWithoutAccountProvider('note.host.com').overrideWithValue(mockRemoteMisskey),
            ],
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      await const LinkNavigator().onMentionTap(
                        context,
                        ref,
                        '@aaa',
                        'note.host.com', // user.hostが入っている
                      );
                    },
                    child: const Text('Test'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // 期待される動作: note.host.comで検索
        expect(capturedRequest?.userName, 'aaa');
        expect(capturedRequest?.host, null); // note.host.comのローカルユーザーとして検索
        expect(usedMisskey, mockRemoteMisskey); // note.host.comのAPIを使用
      });

      testWidgets('user.hostが入っていなければ自ホストで検索する', (tester) async {
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
            host: null, // myhostのローカルユーザー
          );
        });

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              accountContextProvider.overrideWithValue(AccountContext(
                getAccount: localAccount,
                postAccount: localAccount,
              )),
              misskeyProvider(localAccount).overrideWithValue(mockLocalMisskey),
            ],
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      await const LinkNavigator().onMentionTap(
                        context,
                        ref,
                        '@aaa',
                        null, // user.hostが入っていない
                      );
                    },
                    child: const Text('Test'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // 期待される動作: 自ホストで検索
        expect(capturedRequest?.userName, 'aaa');
        expect(capturedRequest?.host, null); // 自ホストのローカルユーザーとして検索
        expect(usedMisskey, mockLocalMisskey); // 自ホストのAPIを使用
      });
    });

    group('現在の実装での問題を再現', () {
      testWidgets('@aaa (user.host有り) で現在の問題を確認', (tester) async {
        final localAccount = TestData.account.copyWith(
          host: 'myhost.com',
        );

        // 現在の実装では常にローカルAPIが使われる
        UsersShowByUserNameRequest? capturedRequest;
        when(mockLocalUsersService.showByName(any)).thenAnswer((invocation) async {
          capturedRequest = invocation.positionalArguments[0] as UsersShowByUserNameRequest;
          return TestData.usersShowResponse1.copyWith(
            id: 'aaa_user_id',
            username: 'aaa',
            host: 'note.host.com', // myhostから見たリモートユーザー
          );
        });

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              accountContextProvider.overrideWithValue(AccountContext(
                getAccount: localAccount,
                postAccount: localAccount,
              )),
              misskeyProvider(localAccount).overrideWithValue(mockLocalMisskey),
            ],
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      await const LinkNavigator().onMentionTap(
                        context,
                        ref,
                        '@aaa',
                        'note.host.com',
                      );
                    },
                    child: const Text('Test'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // 現在の実装での動作: 自ホストで note.host.com のユーザーを検索
        expect(capturedRequest?.userName, 'aaa');
        expect(capturedRequest?.host, 'note.host.com'); // 問題: リモートユーザーとして検索
        
        // 正しくは note.host.com のローカルユーザーとして検索すべき
        print('現在の実装: myhost.com API で users/show-by-name(userName: aaa, host: note.host.com)');
        print('正しい実装: note.host.com API で users/show-by-name(userName: aaa, host: null)');
      });
    });
  });
}