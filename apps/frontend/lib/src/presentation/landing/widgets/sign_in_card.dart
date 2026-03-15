import 'package:flutter/material.dart';
import 'package:frontend/src/shared/theme/app_colors.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';
import 'package:frontend/src/shared/widgets/app_icon.dart';
import 'package:frontend/src/presentation/landing/widgets/terms_and_condition.dart';

class SignInCard extends StatelessWidget {
  const SignInCard({
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
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    return Container(
      width: 360,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? colorScheme.outline.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            offset: const Offset(0, 8),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Get started',
            style: textTheme.heading4?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Sign in to start taking notes',
            style: textTheme.body?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 28),
          _SignInButton(
            onPressed: onSignInWithGoogle,
            label: 'Continue with Google',
            icon: AppIcon.google(size: 18),
            filled: true,
          ),
          const SizedBox(height: 12),
          _SignInButton(
            onPressed: onSignInWithGitHub,
            label: 'Continue with GitHub',
            icon: AppIcon.github(size: 18),
          ),
          const SizedBox(height: 20),
          const TermsAndConditions(),
        ],
      ),
    );
  }
}

class _SignInButton extends StatefulWidget {
  const _SignInButton({
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
  State<_SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<_SignInButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = RecallTheme.of(context).colorScheme;
    final textTheme = RecallTheme.of(context).textTheme;
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    final bgColor = widget.filled
        ? (_hovering
            ? colorScheme.primary.withValues(alpha: 0.9)
            : colorScheme.primary)
        : (_hovering
            ? (isDark
                ? AppColors.secondary.shade800
                : AppColors.primary.shade50)
            : (isDark ? colorScheme.surface : Colors.white));

    final textColor = widget.filled
        ? Colors.white
        : colorScheme.onSurface;

    final borderColor = widget.filled
        ? colorScheme.primary
        : (_hovering
            ? colorScheme.primary
            : colorScheme.outline.withValues(alpha: 0.4));

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon,
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: textTheme.body?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
