import 'dart:convert';

import 'package:common/dtos/create_note_params.dart';
import 'package:common/dtos/update_note_params.dart';
import 'package:common/utils/response_body.dart';
import 'package:recall_data/recall_data.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_backend/middleware/auth_middleware.dart';
import 'package:shelf_backend/utils/app_response.dart';

class NotesHandler {
  const NotesHandler({required NotesRepository notesRepository})
      : _notesRepository = notesRepository;

  final NotesRepository _notesRepository;

  Future<Response> createNote(Request request) async {
    try {
      final userId = request.userId;
      final body = await request.readAsString();
      final noteData = jsonDecode(body) as Map<String, dynamic>;

      final error = CreateNoteParams.validate(noteData);
      if (error != null) {
        return AppResponse.badRequest(
          ResponseBody(success: false, message: error),
        );
      }

      final params = CreateNoteParams.fromMap({
        ...noteData,
        'user_id': userId,
      });

      final note = await _notesRepository.addNote(userId, params);

      return AppResponse.created(
        ResponseBody(
          success: true,
          message: 'Note created successfully',
          data: note,
        ),
      );
    } catch (_) {
      return AppResponse.internalServerError(
        const ResponseBody(
          success: false,
          message: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<Response> getNotes(Request request) async {
    try {
      final userId = request.userId;
      final notes = await _notesRepository.getAllNotes(userId);

      return AppResponse.ok(
        ResponseBody(
          success: true,
          message: 'Notes fetched successfully',
          data: notes,
        ),
      );
    } catch (_) {
      return AppResponse.internalServerError(
        const ResponseBody(
          success: false,
          message: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<Response> getNoteById(Request request, String noteId) async {
    try {
      final userId = request.userId;
      final note = await _notesRepository.getNoteById(noteId, userId);

      if (note == null) {
        return AppResponse.notFound(
          const ResponseBody(success: false, message: 'Note does not exist'),
        );
      }

      return AppResponse.ok(
        ResponseBody(
          success: true,
          message: 'Note fetched successfully',
          data: note,
        ),
      );
    } catch (_) {
      return AppResponse.internalServerError(
        const ResponseBody(
          success: false,
          message: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<Response> updateNote(Request request, String noteId) async {
    try {
      final userId = request.userId;
      final existingNote = await _notesRepository.getNoteById(noteId, userId);
      if (existingNote == null) {
        return AppResponse.notFound(
          const ResponseBody(success: false, message: 'Note does not exist'),
        );
      }

      final body = await request.readAsString();
      final noteData = jsonDecode(body) as Map<String, dynamic>;

      final error = UpdateNoteParams.validate(noteData);
      if (error != null) {
        return AppResponse.badRequest(
          ResponseBody(success: false, message: error),
        );
      }

      final noteParams = UpdateNoteParams.fromMap(noteData);

      final note =
          await _notesRepository.updateNote(noteId, userId, noteParams);

      return AppResponse.ok(
        ResponseBody(
          success: true,
          message: 'Note updated successfully',
          data: note,
        ),
      );
    } catch (_) {
      return AppResponse.internalServerError(
        const ResponseBody(
          success: false,
          message: 'An unexpected error occurred',
        ),
      );
    }
  }

  Future<Response> deleteNote(Request request, String noteId) async {
    try {
      final userId = request.userId;
      await _notesRepository.deleteNote(noteId, userId);

      return AppResponse.ok(
        ResponseBody(
          success: true,
          message: 'Note deleted successfully',
          data: {'id': noteId},
        ),
      );
    } catch (_) {
      return AppResponse.internalServerError(
        const ResponseBody(
          success: false,
          message: 'An unexpected error occurred',
        ),
      );
    }
  }
}
