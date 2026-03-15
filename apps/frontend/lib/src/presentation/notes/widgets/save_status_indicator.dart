import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/providers/auto_save_provider.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';

class SaveStatusIndicator extends ConsumerWidget {
  const SaveStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(autoSaveProvider);

    final status = ref.watch(saveStatusProvider);
    final textTheme = RecallTheme.of(context).textTheme;
    final colorScheme = RecallTheme.of(context).colorScheme;

    final (text, color) = switch (status) {
      SaveStatus.idle => (null, null),
      SaveStatus.saving => ('Saving...', colorScheme.onSurface.withValues(alpha: 0.5)),
      SaveStatus.saved => ('Saved', colorScheme.primary),
      SaveStatus.error => ('Save failed', colorScheme.error),
    };

    if (text == null) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 200),
      child: Text(
        text,
        style: textTheme.smallBody?.copyWith(color: color),
      ),
    );
  }
}
