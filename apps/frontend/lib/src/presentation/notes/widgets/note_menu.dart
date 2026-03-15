import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';
import 'package:frontend/src/presentation/landing/widgets/theme_toggle.dart';

class NoteMenu extends StatelessWidget {
  const NoteMenu({super.key, required this.onThemeToggle, this.onSignOut});

  final VoidCallback onThemeToggle;
  final VoidCallback? onSignOut;

  static Future<T?> show<T>(
    BuildContext context, {
    required VoidCallback onThemeToggle,
    required VoidCallback? onSignOut,
    required double topOffset,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => NoteMenu(
        onThemeToggle: onThemeToggle,
        onSignOut: onSignOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = RecallTheme.of(context).colorScheme;
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          _MenuItem(
            icon: Icons.dark_mode_outlined,
            title: 'Theme',
            trailing: ThemeToggle(onThemeToggle: onThemeToggle),
            onTap: onThemeToggle,
          ),
          _MenuItem(
            icon: Icons.logout_rounded,
            title: 'Sign out',
            isDestructive: true,
            onTap: () {
              context.pop();
              onSignOut?.call();
            },
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = RecallTheme.of(context).colorScheme;
    final textTheme = RecallTheme.of(context).textTheme;
    final color = isDestructive
        ? colorScheme.error
        : colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color.withValues(alpha: 0.7)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: textTheme.body?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
