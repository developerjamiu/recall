import 'dart:convert';

import 'package:common/models/user.dart' show AuthProvider;
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recall_data/src/config/environment.dart';
import 'package:recall_data/src/services/oauth_service.dart';
import 'package:test/test.dart';

class MockClient extends Mock implements Client {}

void main() {
  late MockClient mockClient;
  late OAuthService oAuthService;

  setUpAll(() {
    Environment.init();
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  setUp(() {
    mockClient = MockClient();
    oAuthService = OAuthService(httpClient: mockClient);
  });

  group('authenticateWithGoogle', () {
    test('returns OAuthData with correct fields on success', () async {
      _mockGoogleTokenExchange(mockClient);
      _mockGoogleUserInfo(mockClient);

      final result = await oAuthService.authenticateWithGoogle('valid_code');

      expect(result.email, equals('user@gmail.com'));
      expect(result.firstName, equals('John'));
      expect(result.lastName, equals('Doe'));
      expect(result.provider, equals(AuthProvider.google.name));
      expect(result.providerId, equals('google-id-123'));
    });

    test('handles missing family_name from Google profile', () async {
      _mockGoogleTokenExchange(mockClient);
      _mockGoogleUserInfo(
        mockClient,
        userData: {
          'id': 'google-id-123',
          'email': 'user@gmail.com',
          'name': 'Mononymous',
          'given_name': 'Mononymous',
          'picture': null,
        },
      );

      final result = await oAuthService.authenticateWithGoogle('valid_code');

      expect(result.firstName, equals('Mononymous'));
      expect(result.lastName, equals(''));
    });

    test('falls back to name splitting when given_name and family_name missing',
        () async {
      _mockGoogleTokenExchange(mockClient);
      _mockGoogleUserInfo(
        mockClient,
        userData: {
          'id': 'google-id-123',
          'email': 'user@gmail.com',
          'name': 'Full Name',
        },
      );

      final result = await oAuthService.authenticateWithGoogle('valid_code');

      expect(result.firstName, equals('Full'));
      expect(result.lastName, equals('Name'));
    });

    test('falls back to email when all name fields are missing', () async {
      _mockGoogleTokenExchange(mockClient);
      _mockGoogleUserInfo(
        mockClient,
        userData: {
          'id': 'google-id-123',
          'email': 'user@gmail.com',
        },
      );

      final result = await oAuthService.authenticateWithGoogle('valid_code');

      expect(result.firstName, equals('user@gmail.com'));
    });

    test('throws on token exchange failure', () async {
      when(() => mockClient.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
            encoding: any(named: 'encoding'),
          )).thenAnswer((_) async => Response('error', 401));

      expect(
        () => oAuthService.authenticateWithGoogle('bad_code'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('authenticateWithGitHub', () {
    test('returns OAuthData with correct fields on success', () async {
      _mockGitHubTokenExchange(mockClient);
      _mockGitHubUserInfo(mockClient);

      final result = await oAuthService.authenticateWithGitHub('valid_code');

      expect(result.email, equals('user@github.com'));
      expect(result.firstName, equals('Jane'));
      expect(result.lastName, equals('Smith'));
      expect(result.provider, equals(AuthProvider.github.name));
      expect(result.providerId, equals('12345'));
    });

    test('detects error in GitHub 200 response body', () async {
      when(() => mockClient.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
            encoding: any(named: 'encoding'),
          )).thenAnswer(
        (_) async => Response(
          jsonEncode({
            'error': 'bad_verification_code',
            'error_description': 'The code passed is incorrect or expired.',
          }),
          200,
        ),
      );

      expect(
        () => oAuthService.authenticateWithGitHub('expired_code'),
        throwsA(isA<Exception>()),
      );
    });

    test('falls back to /user/emails when profile email is null', () async {
      _mockGitHubTokenExchange(mockClient);
      _mockGitHubUserInfo(mockClient, email: null);
      _mockGitHubEmailsApi(mockClient);

      final result = await oAuthService.authenticateWithGitHub('valid_code');

      expect(result.email, equals('primary@github.com'));
    });

    test('uses login as name when name is null', () async {
      _mockGitHubTokenExchange(mockClient);
      _mockGitHubUserInfo(mockClient, name: null, login: 'devjamiu');

      final result = await oAuthService.authenticateWithGitHub('valid_code');

      expect(result.firstName, equals('devjamiu'));
      expect(result.lastName, equals(''));
    });

    test('throws when no verified primary email exists', () async {
      _mockGitHubTokenExchange(mockClient);
      _mockGitHubUserInfo(mockClient, email: null);

      when(() => mockClient.get(
            Uri.parse('https://api.github.com/user/emails'),
            headers: any(named: 'headers'),
          )).thenAnswer(
        (_) async => Response(
          jsonEncode([
            {
              'email': 'unverified@test.com',
              'primary': true,
              'verified': false,
            },
          ]),
          200,
        ),
      );

      expect(
        () => oAuthService.authenticateWithGitHub('valid_code'),
        throwsA(isA<Exception>()),
      );
    });
  });
}

// -- Helpers --

void _mockGoogleTokenExchange(MockClient client) {
  when(() => client.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        body: any(named: 'body'),
        headers: any(named: 'headers'),
        encoding: any(named: 'encoding'),
      )).thenAnswer(
    (_) async => Response(
      jsonEncode({'access_token': 'google_access_token'}),
      200,
    ),
  );
}

void _mockGoogleUserInfo(
  MockClient client, {
  Map<String, dynamic>? userData,
}) {
  when(() => client.get(
        Uri.parse('https://www.googleapis.com/oauth2/v2/userinfo'),
        headers: any(named: 'headers'),
      )).thenAnswer(
    (_) async => Response(
      jsonEncode(userData ??
          {
            'id': 'google-id-123',
            'email': 'user@gmail.com',
            'name': 'John Doe',
            'given_name': 'John',
            'family_name': 'Doe',
            'picture': 'https://example.com/photo.jpg',
          }),
      200,
    ),
  );
}

void _mockGitHubTokenExchange(MockClient client) {
  when(() => client.post(
        Uri.parse('https://github.com/login/oauth/access_token'),
        body: any(named: 'body'),
        headers: any(named: 'headers'),
        encoding: any(named: 'encoding'),
      )).thenAnswer(
    (_) async => Response(
      jsonEncode({'access_token': 'github_access_token'}),
      200,
    ),
  );
}

void _mockGitHubUserInfo(
  MockClient client, {
  String? email = 'user@github.com',
  String? name = 'Jane Smith',
  String? login = 'janesmith',
}) {
  when(() => client.get(
        Uri.parse('https://api.github.com/user'),
        headers: any(named: 'headers'),
      )).thenAnswer(
    (_) async => Response(
      jsonEncode({
        'id': 12345,
        'email': email,
        'name': name,
        'login': login,
        'avatar_url': 'https://avatars.githubusercontent.com/12345',
      }),
      200,
    ),
  );
}

void _mockGitHubEmailsApi(MockClient client) {
  when(() => client.get(
        Uri.parse('https://api.github.com/user/emails'),
        headers: any(named: 'headers'),
      )).thenAnswer(
    (_) async => Response(
      jsonEncode([
        {'email': 'primary@github.com', 'primary': true, 'verified': true},
        {'email': 'secondary@github.com', 'primary': false, 'verified': true},
      ]),
      200,
    ),
  );
}
