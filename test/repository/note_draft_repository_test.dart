import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/repository/note_draft_repository.dart";
import "package:mockito/mockito.dart";
import "package:misskey_dart/misskey_dart.dart";

import "../test_util/mock.mocks.dart";

void main() {
  group("NoteDraftRepository", () {
    late ProviderContainer container;
    late MockMisskey mockMisskey;
    late MockMisskeyNotes mockNotes;
    late MockMisskeyNotesDrafts mockDrafts;

    setUp(() {
      mockMisskey = MockMisskey();
      mockNotes = MockMisskeyNotes();
      mockDrafts = MockMisskeyNotesDrafts();

      // Setup the mock hierarchy
      when(mockMisskey.notes).thenReturn(mockNotes);
      when(mockNotes.drafts).thenReturn(mockDrafts);

      // Mock draft data
      final testDraft = NoteDraft(
        id: "test-draft-id",
        text: "Test draft content",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        fileIds: [],
        visibility: NoteVisibility.public,
      );

      // Mock successful operations
      when(mockDrafts.list(any)).thenAnswer((_) async => [testDraft]);

      container = ProviderContainer(
        overrides: [misskeyPostContextProvider.overrideWithValue(mockMisskey)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test("should be able to read the provider without throwing UnimplementedError", () {
      // This test verifies that the provider can be instantiated
      // without throwing UnimplementedError due to missing dependencies
      expect(
        () => container.read(noteDraftRepositoryProvider.notifier),
        returnsNormally,
      );
    });

    test("should be able to call list() method", () async {
      final repository = container.read(noteDraftRepositoryProvider.notifier);
      
      // This should not throw UnimplementedError
      expect(
        () async => await repository.list(),
        returnsNormally,
      );
    });

    test("list() should return drafts from API", () async {
      final repository = container.read(noteDraftRepositoryProvider.notifier);
      
      final drafts = await repository.list();
      expect(drafts, hasLength(1));
      expect(drafts.first.id, equals("test-draft-id"));
      expect(drafts.first.text, equals("Test draft content"));
    });
  });
}