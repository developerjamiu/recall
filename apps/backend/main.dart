import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart';
import 'package:jao/jao.dart';
import 'package:recall_data/recall_data.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

Future<void> init(InternetAddress ip, int port) async {
  Environment.init();

  await Jao.configure(
    adapter: databaseAdapter,
    config: databaseConfig,
  );
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  final finalHandler = handler
      .use(provider<Client>((context) => Client()))
      .use(fromShelfMiddleware(corsHeaders()))
      .use(requestLogger());

  return serve(finalHandler, ip, port);
}
