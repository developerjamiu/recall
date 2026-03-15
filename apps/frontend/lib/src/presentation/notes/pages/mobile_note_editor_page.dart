import 'package:flutter/material.dart';
import 'package:frontend/src/presentation/notes/widgets/delete_confirmation_dialog.dart';
import 'package:frontend/src/presentation/notes/widgets/mobile_note_text_editor.dart';
import 'package:frontend/src/presentation/notes/widgets/save_status_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';
import 'package:frontend/src/providers/selected_note_provider.dart';
import 'package:frontend/src/providers/note_mutations.dart';
import 'package:frontend/src/shared/utils/snackbar_utils.dart';
import 'package:riverpod/experimental/mutation.dart';

class MobileNoteEditorPage extends ConsumerStatefulWidget {
  const MobileNoteEditorPage({super.key});

  @override
  ConsumerState<MobileNoteEditorPage> createState() =>
      _MobileNoteEditorPageState();
}

class _MobileNoteEditorPageState extends ConsumerState<MobileNoteEditorPage> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    final selectedNote = ref.read(selectedNoteProvider);
    _titleController = TextEditingController(text: selectedNote.title);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedNote.id == null) {
        ref.read(selectedNoteProvider.notifier).clearSelection();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = RecallTheme.of(context).colorScheme;
    final textTheme = RecallTheme.of(context).textTheme;
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

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          ScaffoldMessenger.of(context).clearSnackBars();
        }
      },
      child: Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            context.pop();
          },
        ),
        title: const SaveStatusIndicator(),
        centerTitle: true,
        actions: [
          if (!isNewNote)
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: colorScheme.error,
              ),
              onPressed: deleteState is MutationPending
                  ? null
                  : () => DeleteConfirmationDialog.show(
                        context,
                        onDeleteClicked: switch (deleteState) {
                          MutationPending() => null,
                          _ => () => executeDeleteNote(ref, selectedNote.id!),
                        },
                      ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: TextField(
              controller: _titleController,
              style: textTheme.heading4?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (title) {
                ref.read(selectedNoteProvider.notifier).updateTitle(title);
              },
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: textTheme.heading4?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: null,
            ),
          ),
          Divider(
            color: colorScheme.outline.withValues(alpha: 0.3),
            indent: 20,
            endIndent: 20,
          ),
          Expanded(
            child: MobileNoteTextEditor(
              key: ValueKey(selectedNote.id),
              currentContent: selectedNote.content,
              onContentChanged: (content) {
                ref.read(selectedNoteProvider.notifier).updateContent(content);
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}
