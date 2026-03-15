import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/providers/note_mutations.dart';
import 'package:frontend/src/providers/selected_note_provider.dart';
import 'package:go_router/go_router.dart';

class KeyboardShortcuts extends ConsumerWidget {
  const KeyboardShortcuts({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyN, control: true): () {
          ref.read(selectedNoteProvider.notifier).selectNote(null);
          context.go('/notes');
        },
        const SingleActivator(LogicalKeyboardKey.keyN, meta: true): () {
          ref.read(selectedNoteProvider.notifier).selectNote(null);
          context.go('/notes');
        },
        const SingleActivator(LogicalKeyboardKey.keyS, control: true): () {
          executeSaveNote(ref);
        },
        const SingleActivator(LogicalKeyboardKey.keyS, meta: true): () {
          executeSaveNote(ref);
        },
        const SingleActivator(LogicalKeyboardKey.escape): () {
          ref.read(selectedNoteProvider.notifier).clearSelection();
          context.go('/notes');
        },
        const SingleActivator(LogicalKeyboardKey.delete, control: true): () {
          final noteId = ref.read(selectedNoteProvider).id;
          if (noteId != null) {
            executeDeleteNote(ref, noteId);
          }
        },
        const SingleActivator(LogicalKeyboardKey.backspace, meta: true): () {
          final noteId = ref.read(selectedNoteProvider).id;
          if (noteId != null) {
            executeDeleteNote(ref, noteId);
          }
        },
      },
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}
