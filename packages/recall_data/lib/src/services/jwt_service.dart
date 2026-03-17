import 'dart:convert';
import 'dart:math';

import 'package:common/models/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:recall_data/src/config/environment.dart';
import 'package:uuid/uuid.dart';

class JwtService {
  const JwtService();

  static String get _jwtSecret => Environment.jwtSecret;
  static final _secureRandom = Random.secure();

  static const Duration accessTokenExpiry = Duration(minutes: 15);
  static const Duration refreshTokenExpiry = Duration(days: 7);

  String createAccessToken(User user) {
    final now = DateTime.now().toUtc();

    final jwt = JWT(
      subject: user.id,
      issuer: 'recall-app',
      audience: Audience(['recall.app']),
      jwtId: const Uuid().v4(),
      {
        'iat': now.millisecondsSinceEpoch ~/ 1000,
        'id': user.id,
        'email': user.email,
        'type': 'access',
      },
    );

    return jwt.sign(SecretKey(_jwtSecret), expiresIn: accessTokenExpiry);
  }

  String generateRefreshToken() {
    final bytes = List<int>.generate(32, (_) => _secureRandom.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  String? authenticateFromToken(String token) {
    final jwt = JWT.tryVerify(token, SecretKey(_jwtSecret));

    if (jwt == null) return null;

    final payload = jwt.payload;
    if (payload is! Map<String, dynamic>) return null;

    return payload['id'] as String?;
  }
}
