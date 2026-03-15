import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/src/shared/extensions/responsivex.dart';
import 'package:frontend/src/shared/theme/theme_data.dart';
import 'package:frontend/src/shared/widgets/loading_indicator.dart';
import 'package:frontend/src/presentation/landing/widgets/desktop_landing_content.dart';
import 'package:frontend/src/presentation/landing/widgets/landing_footer.dart';
import 'package:frontend/src/presentation/landing/widgets/landing_header.dart';
import 'package:frontend/src/presentation/landing/widgets/mobile_landing_content.dart';
import 'package:frontend/src/providers/auth_provider.dart';
import 'package:frontend/src/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processOAuthCallback();
    });
  }

  void _processOAuthCallback() {
    if (!mounted) return;

    final uri = GoRouterState.of(context).uri;
    final params = uri.queryParameters;

    ref.read(authStateProvider.notifier).processOAuthCallback(
      token: params['token'],
      refreshToken: params['refreshToken'],
      error: params['error'],
    );
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    await ref.read(authStateProvider.notifier).signInWithGoogle();
  }

  Future<void> _signInWithGitHub() async {
    await ref.read(authStateProvider.notifier).signInWithGitHub();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = RecallTheme.of(context).colorScheme;
    final themeToggle = ref.read(themeModeNotifierProvider.notifier).toggle;

    ref.listen(authStateProvider, (_, next) {
      if (next.hasError && !next.isLoading) {
        _showErrorSnackbar(next.error.toString());
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: LoadingIndicator(
        key: ValueKey(ref.watch(authStateProvider).isLoading),
        isLoading: ref.watch(authStateProvider).isLoading,
        child: SafeArea(
          child: Column(
            children: [
              if (!context.isMobile) LandingHeader(onThemeToggle: themeToggle),
              Expanded(
                child: context.isMobile
                    ? MobileLandingContent(
                        onSignInWithGoogle: _signInWithGoogle,
                        onSignInWithGitHub: _signInWithGitHub,
                      )
                    : DesktopLandingContent(
                        onSignInWithGoogle: _signInWithGoogle,
                        onSignInWithGitHub: _signInWithGitHub,
                      ),
              ),
              const LandingFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
