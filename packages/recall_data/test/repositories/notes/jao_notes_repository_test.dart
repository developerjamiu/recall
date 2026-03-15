@Tags(['integration'])
library;

import 'package:common/dtos/create_note_params.dart';
import 'package:common/dtos/update_note_params.dart';
import 'package:recall_data/recall_data.dart';
import 'package:test/test.dart';

import '../../test_helper.dart';

void main() {
  late JaoNotesRepository notesRepository;
  late JaoUserRepository userRepository;
  late String testUserId;

  setUpAll(() async {
    await initTestDatabase();

    notesRepository = const JaoNotesRepository();
    userRepository = const JaoUserRepository();

    final user = await createTestUser(userRepository);
    testUserId = user.id;
  });

  tearDownAll(() {
    cleanupTestDatabase();
  });

  group('JaoNotesRepository', () {
    group('addNote', () {
      test('creates a note and returns it with generated fields', () async {
        final params = CreateNoteParams(
          title: 'Test Note',
          content: 'Test content',
        );

        final note = await notesRepository.addNote(testUserId, params);

        expect(note.id, isNotEmpty);
        expect(note.userId, equals(testUserId));
        expect(note.title, equals('Test Note'));
        expect(note.content, equals('Test content'));
        expect(note.createdAt, isA<DateTime>());
        expect(note.updatedAt, isA<DateTime>());
      });
    });

    group('getAllNotes', () {
      test('returns notes for the given user ordered by createdAt desc',
          () async {
        final note1 = await notesRepository.addNote(
          testUserId,
          CreateNoteParams(title: 'First', content: 'First content'),
        );
        final note2 = await notesRepository.addNote(
          testUserId,
          CreateNoteParams(title: 'Second', content: 'Second content'),
        );

        final notes = await notesRepository.getAllNotes(testUserId);

        expect(notes.length, greaterThanOrEqualTo(2));
        // Most recent first
        final titles = notes.map((n) => n.title).toList();
        final firstIdx = titles.indexOf(note1.title);
        final secondIdx = titles.indexOf(note2.title);
        expect(secondIdx, lessThan(firstIdx));
      });

      test('returns empty list for user with no notes', () async {
        final notes = await notesRepository.getAllNotes('non-existent-user');
        expect(notes, isEmpty);
      });
    });

    group('getNoteById', () {
      test('returns the note when it exists and belongs to the user',
          () async {
        final created = await notesRepository.addNote(
          testUserId,
          CreateNoteParams(title: 'Find Me', content: 'Content'),
        );

        final found = await notesRepository.getNoteById(
          created.id,
          testUserId,
        );

        expect(found, isNotNull);
        expect(found!.id, equals(created.id));
        expect(found.title, equals('Find Me'));
      });

      test('returns null for non-existent note', () async {
        final found = await notesRepository.getNoteById(
          'non-existent-id',
          testUserId,
        );
        expect(found, isNull);
      });

      test('returns null when note belongs to a different user', () async {
        final created = await notesRepository.addNote(
          testUserId,
          CreateNoteParams(title: 'Private', content: 'Content'),
        );

        final found = await notesRepository.getNoteById(
          created.id,
          'different-user-id',
        );
        expect(found, isNull);
      });
    });

    group('updateNote', () {
      test('updates the note title', () async {
        final created = await notesRepository.addNote(
          testUserId,
          CreateNoteParams(title: 'Original', content: 'Content'),
        );

        final updated = await notesRepository.updateNote(
          created.id,
          testUserId,
          const UpdateNoteParams(title: 'Updated'),
        );

        expect(updated.title, equals('Updated'));
        expect(updated.content, equals('Content'));
      });

      test('updates the note content', () async {
        final created = await notesRepository.addNote(
          testUserId,
          CreateNoteParams(title: 'Title', content: 'Original'),
        );

        final updated = await notesRepository.updateNote(
          created.id,
          testUserId,
          const UpdateNoteParams(content: 'Updated content'),
        );

        expect(updated.title, equals('Title'));
        expect(updated.content, equals('Updated content'));
      });

      test('throws when note does not exist', () async {
        expect(
          () => notesRepository.updateNote(
            'non-existent-id',
            testUserId,
            const UpdateNoteParams(title: 'Nope'),
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('deleteNote', () {
      test('deletes the note', () async {
        final created = await notesRepository.addNote(
          testUserId,
          CreateNoteParams(title: 'Delete Me', content: 'Content'),
        );

        await notesRepository.deleteNote(created.id, testUserId);

        final found = await notesRepository.getNoteById(
          created.id,
          testUserId,
        );
        expect(found, isNull);
      });

      test('does not throw when deleting non-existent note', () async {
        await expectLater(
          notesRepository.deleteNote('non-existent-id', testUserId),
          completes,
        );
      });
    });
  });
}
