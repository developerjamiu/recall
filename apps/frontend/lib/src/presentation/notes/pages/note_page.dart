import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/shared/extensions/responsivex.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';
import 'package:frontend/src/presentation/notes/widgets/desktop_note_content.dart';
import 'package:frontend/src/presentation/notes/pages/mobile_notes_list_page.dart';
import 'package:frontend/src/providers/notes_provider.dart';
import 'package:frontend/src/providers/selected_note_provider.dart';
import 'package:frontend/src/providers/theme_provider.dart';
import 'package:frontend/src/shared/widgets/keyboard_shortcuts.dart';

class NotePage extends ConsumerStatefulWidget {
  const NotePage({super.key, this.initialNoteId});

  final String? initialNoteId;

  @override
  ConsumerState<NotePage> createState() => _NotePageState();
}

class _NotePageState extends ConsumerState<NotePage> {
  bool _hasSelectedInitialNote = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectInitialNoteIfNeeded();
  }

  void _selectInitialNoteIfNeeded() {
    if (_hasSelectedInitialNote || widget.initialNoteId == null) return;

    final notesAsync = ref.read(notesProvider);
    notesAsync.whenData((notes) {
      final note = notes.where((n) => n.id == widget.initialNoteId).firstOrNull;
      if (note != null) {
        ref.read(selectedNoteProvider.notifier).selectNote(note);
        _hasSelectedInitialNote = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = RecallTheme.of(context).colorScheme;
    final themeToggle = ref.read(themeModeNotifierProvider.notifier).toggle;

    if (widget.initialNoteId != null && !_hasSelectedInitialNote) {
      ref.listen(notesProvider, (_, next) {
        next.whenData((_) => _selectInitialNoteIfNeeded());
      });
    }

    return KeyboardShortcuts(
      child: Title(
        title: 'Recall - Notes',
        color: colorScheme.primary,
        child: Scaffold(
          backgroundColor: colorScheme.background,
          body: SafeArea(
            child: context.isMobile
                ? const MobileNotesListPage()
                : DesktopNoteContent(onThemeToggle: themeToggle),
          ),
        ),
      ),
    );
  }
}
