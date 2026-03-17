import 'package:backend/handlers/notes_handler.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:recall_data/recall_data.dart';

Handler middleware(Handler handler) {
  return handler.use(
    provider<NotesHandler>(
      (context) => NotesHandler(
        notesRepository: context.read<NotesRepository>(),
      ),
    ),
  );
}
