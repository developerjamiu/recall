import 'package:flutter/material.dart';
import 'package:frontend/src/presentation/landing/pages/landing_page.dart';
import 'package:frontend/src/presentation/notes/pages/mobile_note_editor_page.dart';
import 'package:frontend/src/presentation/notes/pages/note_page.dart';
import 'package:frontend/src/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppRouter {
  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: _AuthNotifier(ref),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LandingPage()),
        ),
        GoRoute(
          path: '/notes',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: NotePage()),
          routes: [
            GoRoute(
              path: 'edit',
              pageBuilder: (context, state) => const MaterialPage(
                child: MobileNoteEditorPage(),
              ),
            ),
            GoRoute(
              path: ':id',
              pageBuilder: (context, state) {
                final noteId = state.pathParameters['id']!;
                return NoTransitionPage(
                  child: NotePage(initialNoteId: noteId),
                );
              },
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final authState = ref.watch(authStateProvider);

        if (authState.isLoading) return null;

        final isAuthenticated = authState.value != null;
        final isOnLanding = state.uri.path == '/';

        if (isAuthenticated && isOnLanding) return '/notes';

        if (!isAuthenticated && !isOnLanding) return '/';

        return null;
      },
    );
  }
}

class _AuthNotifier extends ChangeNotifier {
  final WidgetRef _ref;

  _AuthNotifier(this._ref) {
    _ref.listen(authStateProvider, (previous, next) {
      notifyListeners();
    });
  }
}
