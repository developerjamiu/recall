import 'package:flutter/material.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';

class NoteFooter extends StatelessWidget {
  const NoteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = RecallTheme.of(context).colorScheme;
    final textTheme = RecallTheme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          '© 2025 Developer Jamiu',
          style: textTheme.smallBody?.copyWith(
            fontSize: 11,
            color: colorScheme.onSurface.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }
}
