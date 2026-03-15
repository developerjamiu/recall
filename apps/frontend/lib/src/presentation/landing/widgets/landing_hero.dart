import 'package:flutter/material.dart';
import 'package:frontend/src/shared/theme/app_colors.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';

class LandingHero extends StatelessWidget {
  const LandingHero({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = RecallTheme.of(context).textTheme;
    final colorScheme = RecallTheme.of(context).colorScheme;

    return SizedBox(
      width: 480,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Built with Dart & Flutter',
              style: textTheme.body?.copyWith(
                color: AppColors.accent.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Your thoughts,\n'),
                TextSpan(
                  text: 'recalled ',
                  style: TextStyle(color: colorScheme.primary),
                ),
                TextSpan(text: 'instantly.'),
              ],
            ),
            style: textTheme.heading1,
          ),
          const SizedBox(height: 20),
          Text(
            'A full-stack showcase of modern Dart backend development. '
            'Authentication, database, and rich text editing, all in one app.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.65),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
