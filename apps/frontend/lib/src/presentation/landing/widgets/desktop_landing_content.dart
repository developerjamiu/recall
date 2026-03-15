import 'package:flutter/material.dart';
import 'package:frontend/src/presentation/landing/widgets/landing_hero.dart';
import 'package:frontend/src/presentation/landing/widgets/sign_in_card.dart';

class DesktopLandingContent extends StatelessWidget {
  const DesktopLandingContent({
    super.key,
    required this.onSignInWithGoogle,
    required this.onSignInWithGitHub,
  });

  final VoidCallback onSignInWithGoogle;
  final VoidCallback onSignInWithGitHub;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Flexible(child: LandingHero()),
            const SizedBox(width: 80),
            SignInCard(
              onSignInWithGoogle: onSignInWithGoogle,
              onSignInWithGitHub: onSignInWithGitHub,
            ),
          ],
        ),
      ),
    );
  }
}
