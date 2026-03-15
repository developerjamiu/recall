import 'package:flutter/material.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';
import 'package:frontend/src/shared/widgets/app_icon.dart';
import 'package:frontend/src/presentation/landing/widgets/terms_and_condition.dart';

class MobileLandingContent extends StatelessWidget {
  const MobileLandingContent({
    super.key,
    required this.onSignInWithGoogle,
    required this.onSignInWithGitHub,
  });

  final VoidCallback onSignInWithGoogle;
  final VoidCallback onSignInWithGitHub;

  @override
  Widget build(BuildContext context) {
    final colorScheme = RecallTheme.of(context).colorScheme;
    final textTheme = RecallTheme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon.recall(size: 40),
            const SizedBox(height: 32),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Your thoughts, '),
                  TextSpan(
                    text: 'recalled',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  TextSpan(text: ' instantly.'),
                ],
              ),
              style: textTheme.heading3?.copyWith(
                color: colorScheme.onSurface,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'A full-stack Dart & Flutter notes app.',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 40),
            _MobileSignInButton(
              onPressed: onSignInWithGoogle,
              label: 'Continue with Google',
              icon: AppIcon.google(size: 18),
              filled: true,
            ),
            const SizedBox(height: 12),
            _MobileSignInButton(
              onPressed: onSignInWithGitHub,
              label: 'Continue with GitHub',
              icon: AppIcon.github(size: 18),
            ),
            const SizedBox(height: 24),
            const TermsAndConditions(),
          ],
        ),
      ),
    );
  }
}

class _MobileSignInButton extends StatelessWidget {
  const _MobileSignInButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    this.filled = false,
  });

  final VoidCallback onPressed;
  final String label;
  final Widget icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = RecallTheme.of(context).colorScheme;
    final textTheme = RecallTheme.of(context).textTheme;
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: filled
              ? colorScheme.primary
              : (isDark ? colorScheme.surface : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: filled
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              label,
              style: textTheme.body?.copyWith(
                color: filled ? Colors.white : colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
