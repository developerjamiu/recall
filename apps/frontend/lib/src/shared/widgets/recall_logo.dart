import 'package:flutter/material.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';
import 'package:frontend/src/shared/widgets/app_icon.dart';

class RecallLogo extends StatelessWidget {
  const RecallLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = RecallTheme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon.recall(size: 28),
        const SizedBox(width: 4),
        Text(
          'Recall',
          style: TextStyle(
            fontFamily: 'Satoshi',
            color: colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
