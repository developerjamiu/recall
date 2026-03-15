import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = RecallTheme.of(context).textTheme;
    final colorScheme = RecallTheme.of(context).colorScheme;

    return Text.rich(
      textAlign: TextAlign.center,
      style: textTheme.smallBody?.copyWith(
        fontSize: 12,
        color: colorScheme.onSurface.withValues(alpha: 0.45),
      ),
      TextSpan(
        children: [
          const TextSpan(text: 'By signing in, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchUrl(
                'https://github.com/developerjamiu/recall/blob/main/TERMS_OF_SERVICE.md',
              ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchUrl(
                'https://github.com/developerjamiu/recall/blob/main/PRIVACY_POLICY.md',
              ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
