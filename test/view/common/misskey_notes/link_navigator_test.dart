import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:miria/providers.dart';
import 'package:miria/view/common/misskey_notes/link_navigator.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:mockito/mockito.dart';

import '../../../test_util/mock.mocks.dart';
import '../../../test_util/test_datas.dart';

void main() {
  group('LinkNavigator.onMentionTap', () {
    late MockMisskey mockMisskey;
    late MockMisskeyUsers mockUsersService;
    
    setUp(() {
      mockMisskey = MockMisskey();
      mockUsersService = MockMisskeyUsers();
      when(mockMisskey.users).thenReturn(mockUsersService);
    });

    test('異なるホストのノートからのメンションタップ時の問題を再現', () async {
      // シナリオ:
      // - 自分のアカウント: user@local.example.com
      // - ノートの投稿者: someone@note.example.com
      // - メンション: @test (ホスト指定なし)
      // 
      // 期待される動作: @testはnote.example.comで検索されるべき
      // 実際の動作: @testはlocal.example.comで検索される（バグ）

      final localAccount = TestData.account.copyWith(
        host: 'local.example.com',
      );

      // API呼び出しをキャプチャ
      String? capturedHost;
      when(mockUsersService.showByName(any)).thenAnswer((invocation) async {
        final request = invocation.positionalArguments[0] as UsersShowByUserNameRequest;
        capturedHost = request.host;
        return TestData.usersShowResponse1.copyWith(
          id: 'test_user_id',
          username: 'test',
          host: 'note.example.com',
        );
      });

      final container = ProviderContainer(
        overrides: [
          accountContextProvider.overrideWithValue(AccountContext(
            getAccount: localAccount,
            postAccount: localAccount,
          )),
          misskeyProvider(localAccount).overrideWithValue(mockMisskey),
        ],
      );

      // LinkNavigatorのonMentionTapの処理を再現
      final accountContext = container.read(accountContextProvider);
      
      // ノートの投稿者のホスト（MFMTextのhostパラメータとして渡される）
      final noteHost = 'note.example.com';
      
      // メンションのテキスト
      final mentionText = '@test';
      
      // 正規表現でメンションを解析
      final regResult = RegExp(r"^@?(.+?)(@(.+?))?$").firstMatch(mentionText);
      final contextHost = accountContext.getAccount.host;
      final resolvedNoteHost = noteHost;  // MFMTextから渡されたhost
      final regResultHost = regResult?.group(3); // @test@host.comの場合のhost部分
      
      // ホスト解決ロジック（LinkNavigatorのコードと同じ）
      final String? finalHost;
      if (regResultHost == null && resolvedNoteHost == contextHost) {
        // @なし、かつノートが自分のインスタンスのもの
        finalHost = null;
      } else if (regResultHost == contextHost) {
        // @自分ドメイン
        finalHost = null;
      } else if (regResultHost != null) {
        // @host.comのようにホストが明示されている
        finalHost = regResultHost;
      } else {
        // @testのようにホストが明示されていない場合
        // ノートの投稿者のホストを使うべき
        finalHost = resolvedNoteHost;
      }
      
      // 期待される動作: finalHostは'note.example.com'になるべき
      expect(finalHost, 'note.example.com');
      
      // 実際のAPI呼び出し（バグのある実装）
      // 常にaccountContext.getAccount（local.example.com）のAPIを使用
      await container
          .read(misskeyProvider(accountContext.getAccount))  // ここが問題！
          .users
          .showByName(
            UsersShowByUserNameRequest(
              userName: regResult?.group(1) ?? "",
              host: finalHost,  // 'note.example.com'
            ),
          );
      
      // APIは呼び出されるが、間違ったインスタンス（local.example.com）に対して
      // showByName(userName: 'test', host: 'note.example.com')を送信している
      // 
      // 正しい動作:
      // - note.example.comのインスタンスに対してshowByName(userName: 'test', host: null)を送信
      // または
      // - local.example.comのインスタンスが適切にプロキシする
      
      verify(mockUsersService.showByName(any)).called(1);
      
      // 問題: local.example.comのAPIに対して、host='note.example.com'を指定してユーザーを検索している
      // これは、local.example.comから見たリモートユーザー@test@note.example.comを検索することになる
      // しかし、本来はnote.example.comのローカルユーザー@testを検索したい
      print('APIが呼び出されたホストパラメータ: $capturedHost');
      print('期待: note.example.comのローカルユーザーを検索');
      print('実際: local.example.comからnote.example.comのユーザーを検索');
    });

    test('正しい実装の場合の動作', () async {
      // 正しい実装では、異なるホストのノートからのメンションは
      // そのホストのAPIを使用して検索すべき
      
      final localAccount = TestData.account.copyWith(
        host: 'local.example.com',
      );
      
      // note.example.com用のモックAPI
      final mockRemoteMisskey = MockMisskey();
      final mockRemoteUsersService = MockMisskeyUsers();
      when(mockRemoteMisskey.users).thenReturn(mockRemoteUsersService);
      
      when(mockRemoteUsersService.showByName(any)).thenAnswer((_) async {
        return TestData.usersShowResponse1.copyWith(
          id: 'test_user_id',
          username: 'test',
          host: null,  // note.example.comのローカルユーザー
        );
      });
      
      final container = ProviderContainer(
        overrides: [
          accountContextProvider.overrideWithValue(AccountContext(
            getAccount: localAccount,
            postAccount: localAccount,
          )),
          // 正しい実装では、note.example.com用のAPIクライアントが必要
          misskeyWithoutAccountProvider('note.example.com').overrideWithValue(mockRemoteMisskey),
        ],
      );
      
      // 正しい実装のシミュレーション
      // note.example.comのAPIを使用してユーザーを検索
      await container
          .read(misskeyWithoutAccountProvider('note.example.com'))
          .users
          .showByName(
            UsersShowByUserNameRequest(
              userName: 'test',
              host: null,  // note.example.comのローカルユーザー
            ),
          );
      
      verify(mockRemoteUsersService.showByName(
        argThat(
          isA<UsersShowByUserNameRequest>()
              .having((r) => r.userName, 'userName', 'test')
              .having((r) => r.host, 'host', null),
        ),
      )).called(1);
    });
  });
}