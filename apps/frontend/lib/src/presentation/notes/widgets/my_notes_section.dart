import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';
import 'package:frontend/src/shared/widgets/error_state.dart';
import 'package:frontend/src/shared/widgets/skeleton_loader.dart';
import 'package:frontend/src/presentation/notes/widgets/note_item.dart';
import 'package:frontend/src/providers/notes_provider.dart';
import 'package:frontend/src/providers/selected_note_provider.dart';
import 'package:go_router/go_router.dart';

class MyNotesSection extends ConsumerWidget {
  const MyNotesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = RecallTheme.of(context).textTheme;
    final colorScheme = RecallTheme.of(context).colorScheme;
    final notesAsync = ref.watch(notesProvider);
    final selectedNote = ref.watch(selectedNoteProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 12),
          child: Text(
            'MY NOTES',
            style: textTheme.smallBody?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ),
        Expanded(
          child: notesAsync.when(
            data: (notes) => notes.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      'No notes yet',
                      style: textTheme.body?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: notes.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 2),
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final isSelected = selectedNote.id == note.id;

                      return NoteItem(
                        title: note.title,
                        isSelected: isSelected,
                        onTap: () {
                          ref
                              .read(selectedNoteProvider.notifier)
                              .selectNote(note);
                          context.go('/notes/${note.id}');
                        },
                      );
                    },
                  ),
            loading: () => const NotesListSkeleton(),
            error: (error, stack) => ErrorState(
              message: 'Failed to load notes',
              onRetry: () => ref.invalidate(notesProvider),
            ),
          ),
        ),
      ],
    );
  }
}
