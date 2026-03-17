import 'package:common/dtos/create_note_params.dart';
import 'package:common/dtos/update_note_params.dart';
import 'package:common/models/note.dart' as models;
import 'package:recall_data/recall_data.dart';

class JaoNotesRepository implements NotesRepository {
  const JaoNotesRepository();

  @override
  Future<models.Note> addNote(
    String userId,
    CreateNoteParams noteParams,
  ) async {
    final appNote = await AppNotes.objects.create({
      'user_id': userId,
      'title': noteParams.title,
      'content': noteParams.content,
    });

    return _toModel(appNote);
  }

  @override
  Future<List<models.Note>> getAllNotes(String userId) async {
    final results = await AppNotes.objects
        .filter(AppNotes.$.userId.eq(userId))
        .orderBy(AppNotes.$.createdAt.desc())
        .toList();

    return results.map(_toModel).toList();
  }

  @override
  Future<models.Note?> getNoteById(String id, String userId) async {
    final result = await AppNotes.objects
        .filter(AppNotes.$.id.eq(id) & AppNotes.$.userId.eq(userId))
        .first();

    if (result == null) return null;
    return _toModel(result);
  }

  @override
  Future<models.Note> updateNote(
    String id,
    String userId,
    UpdateNoteParams noteParams,
  ) async {
    await AppNotes.objects
        .filter(AppNotes.$.id.eq(id) & AppNotes.$.userId.eq(userId))
        .update(noteParams.toMap());

    final updatedNote = await getNoteById(id, userId);

    if (updatedNote == null) throw Exception('Note not found after update');

    return updatedNote;
  }

  @override
  Future<void> deleteNote(String id, String userId) async {
    await AppNotes.objects
        .filter(AppNotes.$.id.eq(id) & AppNotes.$.userId.eq(userId))
        .delete();
  }

  models.Note _toModel(AppNote appNote) {
    return models.Note(
      id: appNote.id,
      userId: appNote.userId,
      title: appNote.title,
      content: appNote.content,
      createdAt: appNote.createdAt,
      updatedAt: appNote.updatedAt,
    );
  }
}
