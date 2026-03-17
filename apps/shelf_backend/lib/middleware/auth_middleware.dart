import 'dart:convert';

import 'package:recall_data/recall_data.dart';
import 'package:shelf/shelf.dart';

const _authUserIdKey = 'authUserId';

Middleware authMiddleware(JwtService jwtService) {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response(
          401,
          body: jsonEncode({
            'success': false,
            'message': 'Missing or invalid authorization header',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      final token = authHeader.substring(7);
      final userId = jwtService.authenticateFromToken(token);

      if (userId == null) {
        return Response(
          401,
          body: jsonEncode({
            'success': false,
            'message': 'Invalid or expired token',
          }),
          headers: {'content-type': 'application/json'},
        );
      }

      final updatedRequest = request.change(
        context: {
          ...request.context,
          _authUserIdKey: userId,
        },
      );

      return innerHandler(updatedRequest);
    };
  };
}

extension AuthRequest on Request {
  String get userId => context[_authUserIdKey]! as String;
}
