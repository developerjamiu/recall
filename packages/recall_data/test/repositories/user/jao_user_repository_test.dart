@Tags(['integration'])
library;

import 'package:common/models/user.dart';
import 'package:recall_data/recall_data.dart';
import 'package:test/test.dart';

import '../../test_helper.dart';

void main() {
  late JaoUserRepository userRepository;

  setUpAll(() async {
    await initTestDatabase();
    userRepository = const JaoUserRepository();
  });

  tearDownAll(() {
    cleanupTestDatabase();
  });

  group('JaoUserRepository', () {
    group('createUser', () {
      test('creates a user and returns it', () async {
        final user = User.fromOAuthData(
          email: 'create-${DateTime.now().millisecondsSinceEpoch}@test.com',
          firstName: 'John',
          lastName: 'Doe',
          provider: AuthProvider.google,
          providerId: 'google-123',
          avatarUrl: 'https://example.com/avatar.jpg',
        );

        final created = await userRepository.createUser(user);

        expect(created.id, equals(user.id));
        expect(created.email, equals(user.email));
        expect(created.firstName, equals('John'));
        expect(created.lastName, equals('Doe'));
        expect(created.provider, equals(AuthProvider.google));
        expect(created.providerId, equals('google-123'));
        expect(created.avatarUrl, equals('https://example.com/avatar.jpg'));
        expect(created.createdAt, isA<DateTime>());
        expect(created.updatedAt, isA<DateTime>());
      });

      test('creates a user without avatarUrl', () async {
        final user = User.fromOAuthData(
          email: 'no-avatar-${DateTime.now().millisecondsSinceEpoch}@test.com',
          firstName: 'Jane',
          lastName: 'Doe',
          provider: AuthProvider.github,
          providerId: 'github-456',
        );

        final created = await userRepository.createUser(user);

        expect(created.avatarUrl, isNull);
      });
    });

    group('getUserByEmail', () {
      test('returns the user when found', () async {
        final email =
            'findme-${DateTime.now().millisecondsSinceEpoch}@test.com';
        await createTestUser(userRepository, email: email);

        final found = await userRepository.getUserByEmail(email);

        expect(found, isNotNull);
        expect(found!.email, equals(email));
      });

      test('returns null when not found', () async {
        final found =
            await userRepository.getUserByEmail('nonexistent@test.com');

        expect(found, isNull);
      });
    });

    group('getUserById', () {
      test('returns the user when found', () async {
        final user = await createTestUser(userRepository);

        final found = await userRepository.getUserById(user.id);

        expect(found, isNotNull);
        expect(found!.id, equals(user.id));
        expect(found.email, equals(user.email));
      });

      test('returns null when not found', () async {
        final found = await userRepository.getUserById('non-existent-id');

        expect(found, isNull);
      });
    });
  });
}
