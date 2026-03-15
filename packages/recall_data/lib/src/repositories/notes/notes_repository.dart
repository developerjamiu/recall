import 'package:common/common.dart';

abstract class NotesRepository {
  Future<Note> addNote(String userId, CreateNoteParams noteParams);

  Future<List<Note>> getAllNotes(String userId);

  Future<Note?> getNoteById(String id, String userId);

  Future<Note> updateNote(
    String id,
    String userId,
    UpdateNoteParams noteParams,
  );

  Future<void> deleteNote(String id, String userId);
}
