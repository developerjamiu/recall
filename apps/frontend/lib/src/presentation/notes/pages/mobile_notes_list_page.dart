import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/presentation/notes/widgets/mobile_empty_notes.dart';
import 'package:frontend/src/presentation/notes/widgets/mobile_note_item.dart';
import 'package:frontend/src/presentation/notes/widgets/notes_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';
import 'package:frontend/src/shared/widgets/error_state.dart';
import 'package:frontend/src/shared/widgets/skeleton_loader.dart';
import 'package:frontend/src/providers/notes_provider.dart';
import 'package:frontend/src/providers/selected_note_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class MobileNotesListPage extends ConsumerWidget {
  const MobileNotesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = RecallTheme.of(context).colorScheme;
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: const NotesAppBar(),
      backgroundColor: colorScheme.background,
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) return const MobileEmptyNote();

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: notes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final note = notes[index];
              return MobileNoteItem(
                title: note.title,
                content: note.content,
                date: timeago.format(note.updatedAt),
                onTap: () {
                  ref.read(selectedNoteProvider.notifier).selectNote(note);
                  context.push('/notes/edit');
                },
              );
            },
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: NotesListSkeleton(itemCount: 8),
        ),
        error: (error, stack) => ErrorState(
          message: 'Failed to load notes',
          onRetry: () => ref.invalidate(notesProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(selectedNoteProvider.notifier).clearSelection();
          context.push('/notes/edit');
        },
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
