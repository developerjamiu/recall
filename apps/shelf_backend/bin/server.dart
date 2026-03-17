import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jao/jao.dart';
import 'package:recall_data/recall_data.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_backend/handlers/auth_handler.dart';
import 'package:shelf_backend/handlers/notes_handler.dart';
import 'package:shelf_backend/router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<void> main() async {
  Environment.init();

  await Jao.configure(adapter: databaseAdapter, config: databaseConfig);

  const jwtService = JwtService();
  final httpClient = http.Client();

  final oauthService = OAuthService(httpClient: httpClient);
  const userRepository = JaoUserRepository();
  const notesRepository = JaoNotesRepository();
  const refreshTokenRepository = JaoRefreshTokenRepository();

  final authHandler = AuthHandler(
    userRepository: userRepository,
    oauthService: oauthService,
    jwtService: jwtService,
    refreshTokenRepository: refreshTokenRepository,
  );

  const notesHandler = NotesHandler(notesRepository: notesRepository);

  final router = createRouter(
    authHandler: authHandler,
    notesHandler: notesHandler,
    jwtService: jwtService,
  );

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router.call);

  final port = int.parse(Environment.get('PORT', fallback: '8080'));
  final server = await io.serve(handler, InternetAddress.anyIPv4, port);

  stdout.writeln('Shelf backend running on http://localhost:${server.port}');
}
