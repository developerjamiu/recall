import 'package:backend/handlers/auth_handler.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart';
import 'package:recall_data/recall_data.dart';

Handler middleware(Handler handler) {
  return handler
      .use(
        provider<AuthHandler>(
          (context) => AuthHandler(
            userRepository: context.read<UserRepository>(),
            oauthService: context.read<OAuthService>(),
            jwtService: context.read<JwtService>(),
            refreshTokenRepository:
                context.read<RefreshTokenRepository>(),
          ),
        ),
      )
      .use(
        provider<UserRepository>(
          (context) => const JaoUserRepository(),
        ),
      )
      .use(
        provider<NotesRepository>(
          (context) => const JaoNotesRepository(),
        ),
      )
      .use(
        provider<RefreshTokenRepository>(
          (context) => const JaoRefreshTokenRepository(),
        ),
      )
      .use(
        provider<OAuthService>(
          (context) => OAuthService(
            httpClient: context.read<Client>(),
          ),
        ),
      )
      .use(
        provider<JwtService>((context) => const JwtService()),
      );
}
