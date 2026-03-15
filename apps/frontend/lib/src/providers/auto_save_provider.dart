import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/providers/note_mutations.dart';
import 'package:frontend/src/providers/selected_note_provider.dart';

enum SaveStatus { idle, saving, saved, error }

final saveStatusProvider = NotifierProvider<SaveStatusNotifier, SaveStatus>(
  SaveStatusNotifier.new,
);

class SaveStatusNotifier extends Notifier<SaveStatus> {
  @override
  SaveStatus build() => SaveStatus.idle;

  void set(SaveStatus status) => state = status;
}

final autoSaveProvider = Provider<AutoSaveNotifier>((ref) {
  final notifier = AutoSaveNotifier(ref);
  ref.onDispose(notifier.dispose);

  ref.listen(selectedNoteProvider, (previous, next) {
    if (previous == null) return;
    if (next.title.trim().isEmpty && next.content.trim().isEmpty) return;

    if (previous.title != next.title || previous.content != next.content) {
      notifier.debounceSave();
    }
  });

  return notifier;
});

class AutoSaveNotifier {
  AutoSaveNotifier(this._ref);

  final Ref _ref;
  Timer? _debounceTimer;

  static const _debounceDelay = Duration(seconds: 2);

  void debounceSave() {
    _debounceTimer?.cancel();
    _ref.read(saveStatusProvider.notifier).set(SaveStatus.idle);

    _debounceTimer = Timer(_debounceDelay, _performSave);
  }

  Future<void> _performSave() async {
    final selectedNote = _ref.read(selectedNoteProvider);

    if (selectedNote.title.trim().isEmpty) return;

    _ref.read(saveStatusProvider.notifier).set(SaveStatus.saving);

    try {
      await executeSaveNote(_ref);
      _ref.read(saveStatusProvider.notifier).set(SaveStatus.saved);
    } catch (_) {
      _ref.read(saveStatusProvider.notifier).set(SaveStatus.error);
    }
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}
