import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/presentation/notes/widgets/delete_confirmation_dialog.dart';
import 'package:riverpod/experimental/mutation.dart';
import 'package:frontend/src/shared/widgets/action_button.dart';
import 'package:frontend/src/shared/widgets/app_icon.dart';
import 'package:frontend/src/providers/selected_note_provider.dart';
import 'package:frontend/src/providers/note_mutations.dart';
import 'package:frontend/src/shared/utils/snackbar_utils.dart';

class ActionButtons extends ConsumerWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNote = ref.watch(selectedNoteProvider);
    final isNewNote = selectedNote.id == null;

    final deleteState = ref.watch(deleteNote);

    ref.listen<MutationState<void>>(deleteNote, (previous, next) {
      if (previous is! MutationPending) return;
      switch (next) {
        case MutationSuccess():
          SnackbarUtils.showSuccess(context, 'Note deleted successfully!');
        case MutationError():
          SnackbarUtils.showError(
            context,
            'Failed to delete note: ${next.error.toString()}',
          );
        case MutationPending():
        case MutationIdle():
          break;
      }
    });

    if (isNewNote) return const SizedBox.shrink();

    return ActionButton(
      text: 'Delete',
      icon: AppIcon.delete(),
      onPressed: () => DeleteConfirmationDialog.show(
        context,
        onDeleteClicked: switch (deleteState) {
          MutationPending() => null,
          _ => () => executeDeleteNote(ref, selectedNote.id!),
        },
      ),
      isDestructive: true,
    );
  }
}
