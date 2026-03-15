import 'package:common/models/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:recall_data/src/config/environment.dart';
import 'package:recall_data/src/services/jwt_service.dart';
import 'package:test/test.dart';

void main() {
  late JwtService jwtService;
  late User testUser;

  setUpAll(() {
    Environment.init();
  });

  setUp(() {
    jwtService = const JwtService();
    testUser = User(
      id: 'user-123',
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      provider: AuthProvider.google,
      providerId: 'google-456',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );
  });

  group('createAccessToken', () {
    test('embeds correct claims in the token', () {
      final token = jwtService.createAccessToken(testUser);
      final jwt = JWT.verify(token, SecretKey(Environment.jwtSecret));

      expect(jwt.subject, equals('user-123'));
      expect(jwt.issuer, equals('recall-app'));
      expect(jwt.audience?.contains('recall.app'), isTrue);

      final payload = jwt.payload as Map<String, dynamic>;
      expect(payload['id'], equals('user-123'));
      expect(payload['email'], equals('test@example.com'));
      expect(payload['type'], equals('access'));
    });

    test('rejects verification with wrong secret', () {
      final token = jwtService.createAccessToken(testUser);

      expect(
        () => JWT.verify(token, SecretKey('wrong-secret')),
        throwsA(isA<JWTException>()),
      );
    });
  });

  group('authenticateFromToken', () {
    test('extracts userId from a valid token', () {
      final token = jwtService.createAccessToken(testUser);
      final userId = jwtService.authenticateFromToken(token);

      expect(userId, equals('user-123'));
    });

    test('returns null for an invalid token', () {
      expect(jwtService.authenticateFromToken('not.a.jwt'), isNull);
    });

    test('returns null for a token signed with wrong secret', () {
      final jwt = JWT({'id': 'user-123', 'type': 'access'});
      final token = jwt.sign(SecretKey('wrong-secret'));

      expect(jwtService.authenticateFromToken(token), isNull);
    });

    test('returns null for an expired token', () {
      final jwt = JWT(
        subject: testUser.id,
        {'id': testUser.id, 'email': testUser.email, 'type': 'access'},
      );
      final token = jwt.sign(
        SecretKey(Environment.jwtSecret),
        expiresIn: const Duration(seconds: -1),
      );

      expect(jwtService.authenticateFromToken(token), isNull);
    });

    test('returns null for a tampered token', () {
      final token = jwtService.createAccessToken(testUser);
      final parts = token.split('.');
      final tampered = '${parts[0]}.${parts[1]}x.${parts[2]}';

      expect(jwtService.authenticateFromToken(tampered), isNull);
    });
  });
}
