import 'package:flutter/material.dart';
import 'package:frontend/src/shared/extensions/responsivex.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';
import 'package:frontend/src/shared/widgets/social_icons.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = RecallTheme.of(context).textTheme;
    final colorScheme = RecallTheme.of(context).colorScheme;
    final muted = colorScheme.onSurface.withValues(alpha: 0.45);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          if (!context.isMobile) ...[
            const SocialIcons(),
            const SizedBox(height: 16),
          ],
          Text(
            '© 2025 Developer Jamiu. All rights reserved.',
            style: textTheme.smallBody?.copyWith(color: muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
