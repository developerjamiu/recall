import 'package:common/utils/response_body.dart';
import 'package:recall_data/recall_data.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_backend/handlers/auth_handler.dart';
import 'package:shelf_backend/handlers/notes_handler.dart';
import 'package:shelf_backend/middleware/auth_middleware.dart';
import 'package:shelf_backend/middleware/rate_limiter.dart';
import 'package:shelf_backend/utils/app_response.dart';
import 'package:shelf_router/shelf_router.dart';

Router createRouter({
  required AuthHandler authHandler,
  required NotesHandler notesHandler,
  required JwtService jwtService,
}) {
  final router = Router()
    // Health check
    ..get('/', (Request request) {
      return AppResponse.ok(
        const ResponseBody(
          success: true,
          message: "You probably shouldn't be here, but...",
          data: {'service': 'recall-api'},
        ),
      );
    });

  // Auth routes with rate limiting
  final authRouter = Router()
    ..get('/google', authHandler.getGoogleAuthUrl)
    ..get('/google/callback', authHandler.handleGoogleCallback)
    ..get('/github', authHandler.getGitHubAuthUrl)
    ..get('/github/callback', authHandler.handleGitHubCallback)
    ..post('/refresh', authHandler.handleRefresh)
    ..post('/logout', authHandler.handleLogout);

  final rateLimitedAuth = const Pipeline()
      .addMiddleware(rateLimiter())
      .addHandler(authRouter.call);

  router.mount('/auth/', rateLimitedAuth);

  // Protected API routes
  final apiRouter = Router()
    ..get('/me', authHandler.getCurrentUser)
    ..get('/notes', notesHandler.getNotes)
    ..post('/notes', notesHandler.createNote)
    ..get('/notes/<id>', notesHandler.getNoteById)
    ..patch('/notes/<id>', notesHandler.updateNote)
    ..delete('/notes/<id>', notesHandler.deleteNote);

  final protectedApi = const Pipeline()
      .addMiddleware(authMiddleware(jwtService))
      .addHandler(apiRouter.call);

  router.mount('/api/', protectedApi);

  return router;
}
