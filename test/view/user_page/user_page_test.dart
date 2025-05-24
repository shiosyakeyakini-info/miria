import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";
import "../../test_util/widget_tester_extension.dart";

void main() {
  group("ユーザー情報", () {
    group("全般", () {
      testWidgets("ユーザー情報が表示できること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockUser = MockMisskeyUsers();
        when(mockMisskey.users).thenReturn(mockUser);
        when(
          mockUser.show(any),
        ).thenAnswer((_) async => TestData.usersShowResponse1);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
            ],
            child: DefaultRootWidget(
              initialRoute: UserRoute(
                userId: TestData.usersShowResponse1.id,
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.textContaining(
            TestData.usersShowResponse1.name!,
            findRichText: true,
          ),
          findsAtLeastNWidgets(1),
        );
      });

      testWidgets("リモートユーザーの場合、リモートユーザー用のタブが表示されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockUser = MockMisskeyUsers();
        when(mockMisskey.users).thenReturn(mockUser);
        when(
          mockUser.show(any),
        ).thenAnswer((_) async => TestData.usersShowResponse3AsRemoteUser);
        when(
          mockUser.showByName(any),
        ).thenAnswer((_) async => TestData.usersShowResponse3AsLocalUser);

        final emojiRepository = MockEmojiRepository();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
              misskeyWithoutAccountProvider.overrideWith(
                (ref, account) => mockMisskey,
              ),
              emojiRepositoryProvider.overrideWith(
                (ref, account) => emojiRepository,
              ),
            ],
            child: DefaultRootWidget(
              initialRoute: UserRoute(
                userId: TestData.usersShowResponse1.id,
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text("アカウント情報（リモート）"), findsOneWidget);
        expect(find.text("ノート（リモート）"), findsOneWidget);
      });
    });

    group("アカウント情報", () {
      group("他人のアカウント", () {
        testWidgets("フォローされている場合、フォローされていることが表示されること", (tester) async {
          final mockMisskey = MockMisskey();
          final mockUser = MockMisskeyUsers();
          when(mockMisskey.users).thenReturn(mockUser);
          when(mockUser.show(any)).thenAnswer(
            (_) async => TestData.usersShowResponse2.copyWith(isFollowed: true),
          );

          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                misskeyProvider.overrideWith((ref, account) => mockMisskey),
              ],
              child: DefaultRootWidget(
                initialRoute: UserRoute(
                  userId: TestData.usersShowResponse2.id,
                  accountContext: TestData.accountContext,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text("フォローされています"), findsOneWidget);
        });
        testWidgets("フォローされていない場合、フォローされている表示がされないこと", (tester) async {
          final mockMisskey = MockMisskey();
          final mockUser = MockMisskeyUsers();
          when(mockMisskey.users).thenReturn(mockUser);
          when(mockUser.show(any)).thenAnswer(
            (_) async =>
                TestData.usersShowResponse2.copyWith(isFollowed: false),
          );

          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                misskeyProvider.overrideWith((ref, account) => mockMisskey),
              ],
              child: DefaultRootWidget(
                initialRoute: UserRoute(
                  userId: TestData.usersShowResponse2.id,
                  accountContext: TestData.accountContext,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text("フォローされています"), findsNothing);
        });
        testWidgets("フォローしている場合、フォロー解除のボタンが表示されること", (tester) async {
          final mockMisskey = MockMisskey();
          final mockUser = MockMisskeyUsers();
          when(mockMisskey.users).thenReturn(mockUser);
          when(mockUser.show(any)).thenAnswer(
            (_) async =>
                TestData.usersShowResponse2.copyWith(isFollowing: true),
          );

          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                misskeyProvider.overrideWith((ref, account) => mockMisskey),
              ],
              child: DefaultRootWidget(
                initialRoute: UserRoute(
                  userId: TestData.usersShowResponse2.id,
                  accountContext: TestData.accountContext,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text("フォロー解除"), findsOneWidget);
        });
        testWidgets("フォローしていない場合でフォロー申請が必要ない場合、フォローするのボタンが表示されること", (
          tester,
        ) async {
          final mockMisskey = MockMisskey();
          final mockUser = MockMisskeyUsers();
          when(mockMisskey.users).thenReturn(mockUser);
          when(mockUser.show(any)).thenAnswer(
            (_) async => TestData.usersShowResponse2.copyWith(
              isFollowing: false,
              isLocked: false,
            ),
          );

          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                misskeyProvider.overrideWith((ref, account) => mockMisskey),
              ],
              child: DefaultRootWidget(
                initialRoute: UserRoute(
                  userId: TestData.usersShowResponse2.id,
                  accountContext: TestData.accountContext,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text("フォローする"), findsOneWidget);
        });
        testWidgets("フォローしていない場合でフォロー申請が必要な場合、フォロー申請のボタンが表示されること", (
          tester,
        ) async {
          final mockMisskey = MockMisskey();
          final mockUser = MockMisskeyUsers();
          when(mockMisskey.users).thenReturn(mockUser);
          when(mockUser.show(any)).thenAnswer(
            (_) async => TestData.usersShowResponse2.copyWith(
              isFollowing: false,
              hasPendingFollowRequestFromYou: false,
              isLocked: true,
              isFollowed: false,
            ),
          );

          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                misskeyProvider.overrideWith((ref, account) => mockMisskey),
              ],
              child: DefaultRootWidget(
                initialRoute: UserRoute(
                  userId: TestData.usersShowResponse2.id,
                  accountContext: TestData.accountContext,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text("フォロー申請"), findsOneWidget);
        });
        testWidgets("フォロー申請中の場合、フォロー申請中の表示がされること", (tester) async {
          final mockMisskey = MockMisskey();
          final mockUser = MockMisskeyUsers();
          when(mockMisskey.users).thenReturn(mockUser);
          when(mockUser.show(any)).thenAnswer(
            (_) async => TestData.usersShowResponse2.copyWith(
              isFollowing: false,
              hasPendingFollowRequestFromYou: true,
            ),
          );

          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                misskeyProvider.overrideWith((ref, account) => mockMisskey),
              ],
              child: DefaultRootWidget(
                initialRoute: UserRoute(
                  userId: TestData.usersShowResponse2.id,
                  accountContext: TestData.accountContext,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text("フォロー許可待ち"), findsOneWidget);
        });
        testWidgets("ミュートしている場合、ミュート中が表示されること", (tester) async {
          final mockMisskey = MockMisskey();
          final mockUser = MockMisskeyUsers();
          when(mockMisskey.users).thenReturn(mockUser);
          when(mockUser.show(any)).thenAnswer(
            (_) async => TestData.usersShowResponse2.copyWith(isMuted: true),
          );

          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                misskeyProvider.overrideWith((ref, account) => mockMisskey),
              ],
              child: DefaultRootWidget(
                initialRoute: UserRoute(
                  userId: TestData.usersShowResponse2.id,
                  accountContext: TestData.accountContext,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text("ミュート中"), findsOneWidget);
        });
        testWidgets("ミュートしていない場合、ミュート中が表示されること", (tester) async {
          final mockMisskey = MockMisskey();
          final mockUser = MockMisskeyUsers();
          when(mockMisskey.users).thenReturn(mockUser);
          when(mockUser.show(any)).thenAnswer(
            (_) async => TestData.usersShowResponse2.copyWith(isMuted: false),
          );

          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                misskeyProvider.overrideWith((ref, account) => mockMisskey),
              ],
              child: DefaultRootWidget(
                initialRoute: UserRoute(
                  userId: TestData.usersShowResponse2.id,
                  accountContext: TestData.accountContext,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text("ミュート中"), findsNothing);
        });

        //TODO: ブロック
      });

      group("自分のアカウント", () {});
    });

    group("メモの更新", () {
      testWidgets("メモの更新ができること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockUser = MockMisskeyUsers();
        when(mockMisskey.users).thenReturn(mockUser);
        when(mockUser.show(any)).thenAnswer(
          (_) async => TestData.usersShowResponse2.copyWith(isFollowed: true),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
            ],
            child: DefaultRootWidget(
              initialRoute: UserRoute(
                userId: TestData.usersShowResponse1.id,
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byIcon(Icons.edit));
        await tester.tap(find.byIcon(Icons.edit));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).hitTestable(), "藍ちゃん吸う");
        await tester.tap(find.text("保存"));
        await tester.pumpAndSettle();

        verify(
          mockUser.updateMemo(
            argThat(
              equals(
                UsersUpdateMemoRequest(
                  userId: TestData.usersShowResponse2.id,
                  memo: "藍ちゃん吸う",
                ),
              ),
            ),
          ),
        );
      });
    });

    group("ノート（ローカル）", () {
      testWidgets("ローカルのノートが表示されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockUser = MockMisskeyUsers();
        when(mockMisskey.users).thenReturn(mockUser);
        when(
          mockUser.show(any),
        ).thenAnswer((_) async => TestData.usersShowResponse2);
        when(mockUser.notes(any)).thenAnswer((_) async => [TestData.note1]);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
            ],
            child: DefaultRootWidget(
              initialRoute: UserRoute(
                userId: TestData.usersShowResponse2.id,
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(of: find.byType(Tab), matching: find.text("ノート")),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining(TestData.note1.text!), findsOneWidget);

        verify(
          mockUser.notes(
            argThat(
              predicate<UsersNotesRequest>(
                (request) =>
                    request.withReplies == false &&
                    request.withFiles == false &&
                    request.includeMyRenotes == true,
              ),
            ),
          ),
        ).called(1);

        await tester.pageNation();

        verify(
          mockUser.notes(
            argThat(
              predicate<UsersNotesRequest>(
                (request) =>
                    request.withReplies == false &&
                    request.withFiles == false &&
                    request.includeMyRenotes == true &&
                    request.untilId == TestData.note1.id,
              ),
            ),
          ),
        ).called(1);
      });
      testWidgets("「返信つき」をタップすると、返信つきのノートが表示されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockUser = MockMisskeyUsers();
        when(mockMisskey.users).thenReturn(mockUser);
        when(
          mockUser.show(any),
        ).thenAnswer((_) async => TestData.usersShowResponse2);
        when(mockUser.notes(any)).thenAnswer((_) async => [TestData.note1]);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
            ],
            child: DefaultRootWidget(
              initialRoute: UserRoute(
                userId: TestData.usersShowResponse2.id,
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(of: find.byType(Tab), matching: find.text("ノート")),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text("返信つき"));
        await tester.pumpAndSettle();

        verify(
          mockUser.notes(
            argThat(
              predicate<UsersNotesRequest>(
                (request) => request.withReplies == true,
              ),
            ),
          ),
        ).called(1);
      });
      testWidgets("「ファイルつき」をタップすると、ファイルつきのノートが表示されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockUser = MockMisskeyUsers();
        when(mockMisskey.users).thenReturn(mockUser);
        when(
          mockUser.show(any),
        ).thenAnswer((_) async => TestData.usersShowResponse2);
        when(mockUser.notes(any)).thenAnswer((_) async => [TestData.note1]);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
            ],
            child: DefaultRootWidget(
              initialRoute: UserRoute(
                userId: TestData.usersShowResponse2.id,
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(of: find.byType(Tab), matching: find.text("ノート")),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text("ファイルつき"));
        await tester.pumpAndSettle();

        verify(
          mockUser.notes(
            argThat(
              predicate<UsersNotesRequest>(
                (request) => request.withFiles == true,
              ),
            ),
          ),
        ).called(1);
      });
      testWidgets("「リノートも」を外すと、リノートを除外したノートが表示されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockUser = MockMisskeyUsers();
        when(mockMisskey.users).thenReturn(mockUser);
        when(
          mockUser.show(any),
        ).thenAnswer((_) async => TestData.usersShowResponse2);
        when(mockUser.notes(any)).thenAnswer((_) async => [TestData.note1]);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
            ],
            child: DefaultRootWidget(
              initialRoute: UserRoute(
                userId: TestData.usersShowResponse2.id,
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(of: find.byType(Tab), matching: find.text("ノート")),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text("リノートも"));
        await tester.pumpAndSettle();

        verify(
          mockUser.notes(
            argThat(
              predicate<UsersNotesRequest>(
                (request) => request.includeMyRenotes == false,
              ),
            ),
          ),
        ).called(1);
      });
      testWidgets("「ハイライト」をタップすると、ハイライトのノートのみが表示されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockUser = MockMisskeyUsers();
        when(mockMisskey.users).thenReturn(mockUser);
        when(
          mockUser.show(any),
        ).thenAnswer((_) async => TestData.usersShowResponse2);
        when(mockUser.notes(any)).thenAnswer((_) async => [TestData.note1]);
        when(
          mockUser.featuredNotes(any),
        ).thenAnswer((_) async => [TestData.note2]);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
            ],
            child: DefaultRootWidget(
              initialRoute: UserRoute(
                userId: TestData.usersShowResponse2.id,
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(of: find.byType(Tab), matching: find.text("ノート")),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text("ハイライト"));
        await tester.pumpAndSettle();

        expect(find.textContaining(TestData.note2.text!), findsOneWidget);
      });
    });

    group("クリップ", () {
      testWidgets("クリップのタブでクリップが表示されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockUser = MockMisskeyUsers();
        when(mockMisskey.users).thenReturn(mockUser);
        when(
          mockUser.show(any),
        ).thenAnswer((_) async => TestData.usersShowResponse2);
        when(mockUser.clips(any)).thenAnswer((_) async => [TestData.clip]);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
            ],
            child: DefaultRootWidget(
              initialRoute: UserRoute(
                userId: TestData.usersShowResponse2.id,
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(of: find.byType(Tab), matching: find.text("クリップ")),
        );
        await tester.pumpAndSettle();

        expect(find.text(TestData.clip.name!), findsOneWidget);
        await tester.pageNation();
        verify(
          mockUser.clips(
            argThat(
              equals(
                UsersClipsRequest(
                  userId: TestData.usersShowResponse2.id,
                  untilId: TestData.clip.id,
                ),
              ),
            ),
          ),
        );
      });
    });

    group("ページ", () {
      testWidgets("ページのタブでページが表示されること", (tester) async {
        //TODO
      });
    });

    group("リアクション", () {
      // TODO: なぜか失敗する
      // testWidgets("リアクションを公開している場合、リアクション一覧が表示されること", (tester) async {
      //   final mockMisskey = MockMisskey();
      //   final mockUser = MockMisskeyUsers();
      //   when(mockMisskey.users).thenReturn(mockUser);
      //   when(mockUser.show(any)).thenAnswer((_) async =>
      //       TestData.usersShowResponse2.copyWith(publicReactions: true));
      //   when(mockUser.reactions(any)).thenAnswer((_) async => [
      //         UsersReactionsResponse(
      //             id: "id",
      //             createdAt: DateTime.now(),
      //             user: TestData.user1,
      //             type: "🤯",
      //             note: TestData.note3AsAnotherUser)
      //       ]);

      //   await tester.pumpWidget(ProviderScope(
      //     overrides: [misskeyProvider.overrideWith((ref, account) => mockMisskey)],
      //     child: DefaultRootWidget(
      //       initialRoute: UserRoute(
      //           userId: TestData.usersShowResponse2.id,
      //           account: TestData.account),
      //     ),
      //   ));
      //   await tester.pumpAndSettle();
      //   await tester.ensureVisible(find.text("リアクション"));
      //   await tester.pump();
      //   await tester.tap(find.text("リアクション"));
      //   await tester.pumpAndSettle();

      //   expect(find.text(TestData.note3AsAnotherUser.text!), findsOneWidget);
      //   await tester.pageNation();
      //   verify(mockUser.reactions(argThat(equals(UsersReactionsRequest(
      //       userId: TestData.usersShowResponse2.id, untilId: "id")))));
      // });
    });

    group("フォロー", () {
      testWidgets("フォローが表示されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockUser = MockMisskeyUsers();
        when(mockMisskey.users).thenReturn(mockUser);
        when(mockUser.show(any)).thenAnswer(
          (_) async => TestData.usersShowResponse2.copyWith(isFollowed: true),
        );
        when(mockUser.following(any)).thenAnswer(
          (_) async => [
            Following(
              id: "id",
              createdAt: DateTime.now(),
              followeeId: TestData.usersShowResponse2.id,
              followerId: TestData.account.i.id,
              followee: TestData.detailedUser2,
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
            ],
            child: DefaultRootWidget(
              initialRoute: UserRoute(
                userId: TestData.usersShowResponse1.id,
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.dragUntilVisible(
          find.text("フォロー"),
          find.byType(CustomScrollView),
          const Offset(0, -50),
        );
        await tester.pump();
        await tester.tap(find.text("フォロー"));
        await tester.pumpAndSettle();

        expect(
          find.textContaining(TestData.detailedUser2.name!),
          findsOneWidget,
        );
        await tester.pageNation();
        verify(
          mockUser.following(
            argThat(
              equals(
                UsersFollowingRequest(
                  userId: TestData.usersShowResponse2.id,
                  untilId: "id",
                ),
              ),
            ),
          ),
        );
      });
    });

    group("被フォロー", () {
      testWidgets("被フォローが表示されること", (tester) async {
        final mockMisskey = MockMisskey();
        final mockUser = MockMisskeyUsers();
        when(mockMisskey.users).thenReturn(mockUser);
        when(mockUser.show(any)).thenAnswer(
          (_) async => TestData.usersShowResponse2.copyWith(isFollowed: true),
        );
        when(mockUser.followers(any)).thenAnswer(
          (_) async => [
            Following(
              id: "id",
              createdAt: DateTime.now(),
              followeeId: TestData.account.i.id,
              followerId: TestData.usersShowResponse2.id,
              follower: TestData.detailedUser2,
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              misskeyProvider.overrideWith((ref, account) => mockMisskey),
            ],
            child: DefaultRootWidget(
              initialRoute: UserRoute(
                userId: TestData.usersShowResponse1.id,
                accountContext: TestData.accountContext,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.dragUntilVisible(
          find.text("フォロワー"),
          find.byType(CustomScrollView),
          const Offset(0, -50),
        );
        await tester.pump();
        await tester.tap(find.text("フォロワー"));
        await tester.pumpAndSettle();

        expect(
          find.textContaining(TestData.detailedUser2.name!),
          findsOneWidget,
        );
        await tester.pageNation();
        verify(
          mockUser.followers(
            argThat(
              equals(
                UsersFollowersRequest(
                  userId: TestData.usersShowResponse2.id,
                  untilId: "id",
                ),
              ),
            ),
          ),
        );
      });
    });
    group("Play", () {
      testWidgets("PlayのタブでPlayが表示されること", (tester) async {
        //TODO
      });
    });
  });
}
